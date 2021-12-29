#include "sim.h"
#include "interface.h"
#include <assert.h>
namespace CloudDesign{
	void CWriteController::Init()
	{
		storages.push_back(&isWriteA);
		storages.push_back(&isWriteB);
		//storages.push_back(&outLen);
		storages.push_back(&dataWidth);
		storages.push_back(&dataWidth2);
		storages.push_back(&idx);
		for (int i = 0; i < BANK_NUM; i++)
			storages.push_back(nextInst + i);
		storages.push_back(&mode);
		storages.push_back(&Oaddr);
		storages.push_back(&finishedSeq);
		storages.push_back(&isUpsample);

		storages.push_back(&maxpool_stride);
		storages.push_back(&maxpool_size);
		storages.push_back(&H1_last);
		storages.push_back(&curH01);
		storages.push_back(&curH23);
		storages.push_back(&pool_width_01);
		storages.push_back(&pool_width_23);
		storages.push_back(&pool_flush_01);
		storages.push_back(&pool_flush_23);
		storages.push_back(&addr_pool_01);
		storages.push_back(&addr_pool_23);
		for (int i = 0; i < COMPUTING_GROUP_SIZE * 2; i++){
			storages.push_back(pool_max_01 + i);
			storages.push_back(pool_max_23 + i);
		}

		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->Init();
		debugLevel = DEFAULT_DEBUG_LEVEL;
		for (int i = 0; i < BANK_NUM; i++)
			outValid[i] = false;
		valid = false;

		idx.SetSkipCheck();
		for (int i = 0; i < BANK_NUM; i++)
			nextInst[i] = true;

		if (DUMP_VERIFICATION_CTRLWRITE){
			char filename[100];
			sprintf(filename, "%s/ctrlwrite_input.txt", OUTPUT_DIR);
			fvi = fopen(filename, "wt");
			assert(fvi);
			sprintf(filename, "%s/ctrlwrite_output.txt", OUTPUT_DIR);
			fvo = fopen(filename, "wt");
			assert(fvo);
		}
		else
			fvi = fvo = NULL;
	}

	void CWriteController::reset()
	{
		for (int i = 0; i < BANK_NUM; i++)
			outValid[i] = false;
		valid = false;
		cbInsts.clear();
		for (int i = 0; i < BANK_NUM; i++)
			nextInst[i] = true;
	}


	void CWriteController::latch(int num)
	{
		for (int i = 0; i < BANK_NUM; i++)
			if (outValid[i]){
				dataFifo[i].push(outBus[i]);
				dataAddr[i].push(outAddr[i]);
				outValid[i] = false;
			}
		if (valid){
			valid = false;
			fifo.push(inst);
		}
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->latch(num);
		
	}

	void CWriteController::WriteData(DTYPE *buf, int idx, unsigned addr)
	{
		assert(!outValid[idx]);
		outValid[idx] = true;
		outBus[idx] = (DTYPE*)palloc->Alloc();// new DTYPE[dataWidth.GetValue()];
		memcpy(outBus[idx], buf, dataWidth.GetValue() * sizeof(DTYPE));;
		outAddr[idx] = addr;

		//memcpy(outBus + idx * COMPUTING_GROUP_SIZE, buf, sizeof(buf[0]) * len);
	}

	void CWriteController::StartDumpVerify(int num)
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump){
			return;
		}
		fprintf(fvi, "%d %d %d %d\n", num + 1, cbInsts[0]->GetFinishedSeq(), valid, pddr->writeReady());
		if (valid)
			fprintf(fvi, " %d %d %d %d %d %d %d %d %d %d\n", inst.mode
			, inst.dataWidth, inst.dataWidth2, inst.Oaddr
			, inst.outH1, inst.isUpsample, inst.isMaddr_a
			, inst.isMaddr_b, inst.maxpool_stride, inst.maxpool_size);


		
		for (int i = 0; i < BANK_NUM; i++){
			fprintf(fvi, " %d %d %d\n", cbInsts[i]->IsFetchNextInst()
				, nextInst[i].GetNextValue() && !nextInst[i].GetValue()
				, outValid[i]);
			if (outValid[i]){
				fprintf(fvi, " %d %d", outAddr[i], dataWidth.GetValue());
				for (unsigned j = 0; j < dataWidth.GetValue(); j++)
					fprintf(fvi, " %d", outBus[i][j]);
				fprintf(fvi, "\n");
			}
		}

		ddr_write_enable = false;
		rama_write_enable = false;
		ramb_write_enable = false;
		fprintf(fvo, "%d %d %d %d %d %d %d %d\n", num, finishedSeq.GetValue()
			, IsFetchNextInst(), IsWritable(0), IsWritable(1)
			, IsWritable(2), IsWritable(3), this->IsStopable());
		for (int i = 0; i < BANK_NUM; i++){
			fprintf(fvo, " %d %d", dataFifo[i].size() == 0, dataFifo[i].size() >= WRITE_FIFO_SIZE);
			data_ren[i] = false;
		}
		fprintf(fvo, "\n");
	}
	void CWriteController::FinishDumpVerify()
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump)
			return;

		if (!(ddr_write_enable || rama_write_enable || ramb_write_enable))
			fprintf(fvo, " 0");
		fprintf(fvo, "\n %d %d %d %d %d %d %d\n", ddr_write_enable
			, ddr_write_addr, ddr_write_len, rama_write_enable
			, ramb_write_enable, ram_write_addr, ram_write_len);

		fprintf(fvo, " %d %d %d %d %d %d %d\n", idx.GetValue()
			, curH01.GetValue(), curH23.GetValue(), pool_flush_01.GetValue()
			, pool_flush_23.GetValue(), addr_pool_01.GetValue(), addr_pool_23.GetValue());

		for (int i = 0; i < BANK_NUM; i++){
			fprintf(fvo, " %d", data_ren[i]);
		}

		fprintf(fvo, "\n");
	}

	void CWriteController::progress(int num)
	{
		for (int i = 0; i < BANK_NUM; i++)
			fifo_empty[i] = dataFifo[i].size() == 0;
		StartDumpVerify(num);
		processInstruction(num);
		ProduceOutputs(num);
		FinishDumpVerify();
	}

	void CWriteController::processInstruction(int num)
	{
		for (int i = 0; i < BANK_NUM; i++)
			if (!nextInst[i].GetValue())
				return;
		for (int i = 0; i < BANK_NUM; i++)
			if (dataFifo[i].size() != 0)
				return;
		if (pool_flush_01.GetValue() || pool_flush_23.GetValue())
			return;
		if (fifo.size() == 0)
			return;
		InstructionWrite inst = fifo.front();
		fifo.pop();
		mode = inst.mode;
		isWriteA = inst.isMaddr_a;
		isWriteB = inst.isMaddr_b;
		//outLen = inst.outLen;
		dataWidth = inst.dataWidth;
		dataWidth2 = inst.dataWidth2;
		//assert(dataWidth.GetNextValue() == COMPUTING_GROUP_SIZE);
		Oaddr = inst.Oaddr;
		isUpsample = inst.isUpsample;
		maxpool_size = inst.maxpool_size;
		maxpool_stride = inst.maxpool_stride;
		H1_last = inst.outH1;
		curH01 = 0;
		curH23 = 0;
		if (inst.mode == MODE_ONE){
			pool_width_01 = inst.dataWidth * 2 / inst.maxpool_stride;
			pool_width_23 = (inst.dataWidth + inst.dataWidth2) / inst.maxpool_stride;
		}
		else if (inst.mode == MODE_TWO){
			pool_width_01 = (inst.dataWidth + inst.dataWidth2) / inst.maxpool_stride;
			pool_width_23 = (inst.dataWidth + inst.dataWidth2) / inst.maxpool_stride;
		}
		else{
			pool_width_01 = inst.dataWidth / inst.maxpool_stride;
			pool_width_23 = inst.dataWidth / inst.maxpool_stride;
		}
		//idx = 0;
		for (int i = 0; i < BANK_NUM; i++)
			nextInst[i] = false;
		if (fp && debugLevel <=3)
			fprintf(fp, "%d : wctrl width %d, width2 %d, oa %d, H1Last %d, maxsize %d, maxstride %d\n"
			, num, inst.dataWidth, inst.dataWidth2, inst.Oaddr, H1_last.GetNextValue(), inst.maxpool_size, inst.maxpool_stride);
	}

	bool CWriteController::IsWritable(int idx)
	{
		if (nextInst[idx].GetValue())
			return false;
		if (dataFifo[idx].size() >= WRITE_FIFO_SIZE)
			return false;
		return true;
	}

	void CWriteController::DumpState()
	{
		if (!fp)
			return;
		fprintf(fp, "Dump %s mode %s fifo %d,finished %d, UPS?(%s), write %s Oaddr %d\n", name.c_str()
			, mode == MODE_FOUR ? "FOUR" : (mode == MODE_TWO ? "TWO" : "ONE"), fifo.size()
			, finishedSeq.GetValue(), isUpsample.GetValue() ? "Y" : "N"
			, isWriteA.GetValue() ? "A" : (isWriteB.GetValue() ? "B" : "M"), Oaddr.GetValue());
		fprintf(fp, "\tdataWidth %d, idx %d, maxsize %d, maxstride %d, nextInst?(%s %s %s %s)\n\t"
			, dataWidth.GetValue(), idx.GetValue(), maxpool_size.GetValue(), maxpool_stride.GetValue()
			, nextInst[0].GetValue() ? "Y" : "N", nextInst[1].GetValue() ? "Y" : "N", nextInst[2].GetValue() ? "Y" : "N", nextInst[3].GetValue() ? "Y" : "N");
		for (int i = 0; i < BANK_NUM; i++){
			fprintf(fp, " %d", dataFifo[i].size());
			if (dataFifo[i].size() > 0)
				fprintf(fp, "("DFMT" @ %d)", *dataFifo[i].front(), dataAddr[i].front());
		}
		fprintf(fp, "\n");
	}



	bool CWriteController::IsFetchNextInst()
	{
		std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin();
		for (; p != cbInsts.end(); p++)
			if (!(*p)->IsFetchNextInst())
				return false;
		return true;
	}
	void CWriteController::ProduceOutputs(int num)
	{
		bool finished = true;
		for (int i = 0; i < BANK_NUM; i++)
			if (outValid[i] || !fifo_empty[i])
				finished = false;
		if (finished){
			if (fp && debugLevel <= 3 && finishedSeq.GetValue() != cbInsts[0]->GetFinishedSeq())
				fprintf(fp, "%d : wctrl change finished %d -> %d\n", num, finishedSeq.GetValue(), cbInsts[0]->GetFinishedSeq());

			finishedSeq = cbInsts[0]->GetFinishedSeq();
		}

		if (!isWriteA.GetValue() && !isWriteB.GetValue() && !pddr->writeReady())
			return;
		DTYPE outbuf[COMPUTING_GROUP_SIZE * BANK_NUM];
		unsigned addr;
		int len = 0;
		if (maxpool_size.GetValue() == 2){
			if (pool_flush_01.GetValue()){
				pool_flush_01 = false;
				for (unsigned i = 0; i < pool_width_01.GetValue(); i++)
					outbuf[i] = pool_max_01[i].GetValue();
				len = pool_width_01.GetValue();
				addr = addr_pool_01.GetValue();
			}
			else if (pool_flush_23.GetValue()){
				pool_flush_23 = false;
				for (unsigned i = 0; i < pool_width_23.GetValue(); i++)
					outbuf[i] = pool_max_23[i].GetValue();
				len = pool_width_23.GetValue();
				addr = addr_pool_23.GetValue();
			}
			else{
				if (dataFifo[0].size() > 0 || dataFifo[1].size() > 0 || dataFifo[2].size() > 0 || dataFifo[3].size() > 0)
					idx = ((idx.GetValue() & 2) + 2) % BANK_NUM;
				else
					idx = 0;
				if (dataFifo[idx.GetValue()].size() > 0 && dataFifo[idx.GetValue() + 1].size() > 0){
					DTYPE *p0 = dataFifo[idx.GetValue()].front();
					DTYPE *p1 = dataFifo[idx.GetValue() + 1].front();
					ADDR_TYPE addr_fifo = dataAddr[idx.GetValue()].front();
					dataFifo[idx.GetValue()].pop();
					dataAddr[idx.GetValue()].pop();
					dataFifo[idx.GetValue() + 1].pop();
					dataAddr[idx.GetValue() + 1].pop();
					data_ren[idx.GetValue()] = true;
					data_ren[idx.GetValue() + 1] = true;

					if (idx == 0){
						if (curH01 == H1_last.GetValue())
							curH01 = 0;
						else
							curH01 = curH01.GetValue() + 1;
					}
					else{
						if (curH23 == H1_last.GetValue())
							curH23 = 0;
						else
							curH23 = curH23.GetValue() + 1;
					}
					unsigned wid = (idx == 0) ? pool_width_01.GetValue() : pool_width_23.GetValue();
					if (maxpool_stride.GetValue() == 2){
						bool isFirst = (((idx == 0)?curH01.GetValue() : curH23.GetValue()) & 1) == 0;
						for (unsigned i = 0; i < wid; i++){
							unsigned k = i * 2;
							DTYPE val1 = k < dataWidth.GetValue() ? p0[k] : p1[k - dataWidth.GetValue()];
							k = i * 2 + 1;
							DTYPE val2 = k < dataWidth.GetValue() ? p0[k] : p1[k - dataWidth.GetValue()];
							DTYPE val = val1 > val2 ? val1 : val2;
							if (isFirst){
								if (idx == 0)
									pool_max_01[i] = val;
								else
									pool_max_23[i] = val;
							}
							else{
								DTYPE pval = (idx == 0) ? pool_max_01[i].GetValue() : pool_max_23[i].GetValue();
								outbuf[i] = pval > val ? pval : val;
							}
						}

						if (isFirst){
							if (idx == 0)
								addr_pool_01 = addr_fifo;
							else
								addr_pool_23 = addr_fifo;
							palloc->Free((char *)p0);
							palloc->Free((char *)p1);
							return;
						}
						else{
							if (idx == 0){
								addr = addr_pool_01.GetValue();
								len = pool_width_01.GetValue();
							}
							else{
								addr = addr_pool_23.GetValue();
								len = pool_width_23.GetValue();
							}
						}
					}
					else{ //maxpool_stride.GetValue() == 2
						for (unsigned i = 0; i < wid; i++){
							unsigned k = i;
							DTYPE val1 = k < dataWidth.GetValue() ? p0[k] : p1[k - dataWidth.GetValue()];
							k = i + 1;
							DTYPE val2;
							if (i == wid - 1)
								val2 = val1;
							else
								val2 = k < dataWidth.GetValue() ? p0[k] : p1[k - dataWidth.GetValue()];
							DTYPE val = val1 > val2 ? val1 : val2;
							if (idx == 0){
								pool_max_01[i] = val;
								if (curH01.GetValue() != 0){
									DTYPE pval = pool_max_01[i].GetValue();
									outbuf[i] = pval > val ? pval : val;
								}
							}else{
								pool_max_23[i] = val;
								if (curH23.GetValue() != 0){
									DTYPE pval = pool_max_23[i].GetValue();
									outbuf[i] = pval > val ? pval : val;
								}
							}
						}
						if (idx == 0){
							addr_pool_01 = addr_fifo;
							if (curH01.GetValue() != 0){
								addr = addr_pool_01.GetValue();
								len = pool_width_01.GetValue();
							}
							if (curH01.GetValue() == H1_last.GetValue())
								pool_flush_01 = true;
						}
						else{
							addr_pool_23 = addr_fifo;
							if (curH23.GetValue() != 0){
								addr = addr_pool_23.GetValue();
								len = pool_width_23.GetValue();
							}
							if (curH23.GetValue() == H1_last.GetValue())
								pool_flush_23 = true;
						}
						if (idx == 0 && curH01.GetValue() == 0 || idx.GetValue() != 0 && curH23.GetValue() == 0){
							palloc->Free((char *)p0);
							palloc->Free((char *)p1);
							return;
						}
					}
					palloc->Free((char *)p0);
					palloc->Free((char *)p1);

				} else {
					return;
				}
			}
		}
		else if (isUpsample.GetValue() || mode.GetValue() == MODE_FOUR){
			if (mode.GetValue() == MODE_ONE && idx.GetValue() == 3
				|| mode.GetValue() == MODE_TWO && ((idx.GetValue() & 1) == 1))
				len = dataWidth2.GetValue();
			else
				len = dataWidth.GetValue();

			if (dataFifo[idx.GetValue()].size() > 0){
				addr = dataAddr[idx.GetValue()].front();
				DTYPE *p = dataFifo[idx.GetValue()].front();
				dataFifo[idx.GetValue()].pop();
				dataAddr[idx.GetValue()].pop();
				data_ren[idx.GetValue()] = true;
				memcpy(outbuf, p, sizeof(p[0]) * dataWidth.GetValue());
				palloc->Free((char *)p);
				idx = (idx.GetValue() + 1) % BANK_NUM;
				if (fp && debugLevel <=1)
					fprintf(fp, "wctrl output %d data to %d ("DFMT", "DFMT", "DFMT", "DFMT")\n", len, addr, outbuf[0], outbuf[1], outbuf[2], outbuf[3]);
			}
			else {
				idx = (idx.GetValue() + 1) % BANK_NUM;
				return;
			}
		}
		else if (mode == MODE_ONE){
			len = dataWidth.GetValue() * 3 + dataWidth2.GetValue();
			int i;
			for (i = 0; i < BANK_NUM; i++)
				if (dataFifo[i].size() == 0)
					return;
			int len0 = 0;
			addr = dataAddr[0].front();
			unsigned nextaddr = addr;
			for (i = 0; i < BANK_NUM; i++){
				DTYPE *p = dataFifo[i].front();
				dataFifo[i].pop();
				data_ren[i] = true;
				if (nextaddr != dataAddr[i].front()){
					if (fp)
						fprintf(fp, "wctrl error i: %d, nextaddr expected %u, real %u\n", i, nextaddr, dataAddr[i].front());
					assert(0);
				}
				nextaddr += dataWidth.GetValue();
				dataAddr[i].pop();
				memcpy(outbuf + len0, p, sizeof(p[0]) * dataWidth.GetValue());
				len0 += dataWidth.GetValue();
				palloc->Free((char *)p); //delete[]p;
			}
		}
		else /*if (mode == MODE_TWO)*/{
			len = dataWidth.GetValue() + dataWidth2.GetValue();
			if (dataFifo[idx.GetValue()].size() > 0 && dataFifo[idx.GetValue() + 1].size() > 0){
				assert((idx.GetValue() & 1) == 0);
				int len0 = 0;
				addr = dataAddr[idx.GetValue()].front();
				unsigned nextaddr = addr;
				for (int i = 0; i < BANK_NUM / 2; i++){
					DTYPE *p = dataFifo[i + idx.GetValue()].front();
					dataFifo[i + idx.GetValue()].pop();
					data_ren[idx.GetValue() + i] = true;
					nextaddr += dataWidth.GetValue();
					dataAddr[i + idx.GetValue()].pop();
					memcpy(outbuf + len0, p, sizeof(p[0]) * dataWidth.GetValue());
					len0 += dataWidth.GetValue();
					palloc->Free((char *)p); //delete[]p;
				}
				idx = (idx.GetValue() + 2) % BANK_NUM;
			}
			else{
				//assert((idx.GetValue() & 1) == 0);
				//if(!nextInst.GetValue())
				idx = ((idx.GetValue()&2) + 2) % BANK_NUM;
				return;
			}

		}

		if (isWriteA.GetValue()){
			assert(false);
			rama->Write(Oaddr.GetValue() + addr, len, outbuf);

			rama_write_enable = true;
			ram_write_addr = Oaddr.GetValue() + addr;
			ram_write_len = len;
			if (fp && debugLevel <=1)
				fprintf(fp, "wctrl write to A %d (%d)\n", Oaddr.GetValue() + addr, len);
		}
		else if (isWriteB.GetValue()){
			assert(false);
			ramb->Write(Oaddr.GetValue() + addr, len, outbuf);

			ramb_write_enable = true;
			ram_write_addr = Oaddr.GetValue() + addr;
			ram_write_len = len;
			if (fp && debugLevel <=1)
				fprintf(fp, "wctrl write to B %d (%d)\n", Oaddr.GetValue() + addr, len);

		}
		else{
#ifdef YOLO
			FEATURE_TYPE bufs[MAX_LOAD_WIDTH];
			for (int j = 0; j < len; j++){
				FEATURE_TYPE v1 = outbuf[j];
				if (v1 < -(1 << (FEATURE_BIT_SIZE-1)))
					v1 = -(1 << (FEATURE_BIT_SIZE - 1));
				if (v1 >((1 << (FEATURE_BIT_SIZE - 1)) - 1))
					v1 = ((1 << (FEATURE_BIT_SIZE - 1)) - 1);
				bufs[j] = v1;
			}
			pddr->DelayWrite(Oaddr.GetValue() + SZ_DTYPE * addr, len * SZ_DTYPE, (unsigned char *)bufs);

			ddr_write_enable = true;
			ddr_write_addr = Oaddr.GetValue() + SZ_DTYPE * addr;
			ddr_write_len = len * SZ_DTYPE;
			if (fp && debugLevel <=1)
				fprintf(fp, "wctrl write to M %d (%d), idx %d (%d %d)\n", Oaddr.GetValue() + SZ_DTYPE * addr, len * SZ_DTYPE, idx.GetValue(), bufs[0], bufs[1]);
			
#else
			//memcpy((unsigned *)(Oaddr.GetValue() + sizeof(DTYPE) * addr), outbuf, len * sizeof(DTYPE));
			pddr->DelayWrite(Oaddr.GetValue() + sizeof(DTYPE) * addr, len * sizeof(DTYPE), (unsigned char *)outbuf);
			if (fp && debugLevel <= 1)
				fprintf(fp, "wctrl write to M %d (%d), idx %d\n", Oaddr.GetValue() + sizeof(DTYPE) * addr, len * sizeof(DTYPE), idx.GetValue());
#endif
			

		}
		if (fvo){
			fprintf(fvo, " %d", len);
			for (int k = 0; k < len; k++)
				fprintf(fvo, " %d", outbuf[k]);
		}
		if (fp && debugLevel <=1) {
			fprintf(fp, "(");
			for (int i = 0; i < len; i++)
				fprintf(fp, ", "DFMT, outbuf[i]);
			fprintf(fp, ")\n");
			for (int i = 0; i < BANK_NUM; i++)
				fprintf(fp, " %d (%s)", dataFifo[i].size(), outValid[i]?"*":"");
			fprintf(fp, "\n");
		}
		/*for (int i = 0; i < BANK_NUM; i++)
			if (outValid[i] || !fifo_empty[i])
				return;
		if (fp && debugLevel <= 3 && finishedSeq.GetValue() != cbInsts[0]->GetFinishedSeq())
			fprintf(fp, "%d : wctrl change finished %d -> %d\n", num, finishedSeq.GetValue(), cbInsts[0]->GetFinishedSeq());

		finishedSeq = cbInsts[0]->GetFinishedSeq();*/
	}

	unsigned CWriteController::GetFinishedSeq() 
	{
		return finishedSeq.GetValue(); 
		//return cbInsts[0]->GetFinishedSeq();
	}

	void CWriteController::ProduceOutputsx4(int num)
	{
		DTYPE outbuf[COMPUTING_GROUP_SIZE * BANK_NUM];
		unsigned addr;
		int len = 0;
		if (isUpsample.GetValue() && mode.GetValue() != MODE_FOUR){
			if (dataFifo[idx.GetValue()].size() >= 2 && dataFifo[idx.GetValue() + 1].size() >= 2){
				addr = dataAddr[idx.GetValue()].front();
				unsigned nextaddr = addr;
				for (int i = 0; i < BANK_NUM / 2; i++)
					for (int k = 0; k < 2; k++){
						DTYPE *p = dataFifo[i + idx.GetValue()].front();
						dataFifo[i + idx.GetValue()].pop();
						assert(nextaddr == dataAddr[i + idx.GetValue()].front());
						nextaddr += dataWidth.GetValue();
						dataAddr[i + idx.GetValue()].pop();
						memcpy(outbuf + len, p, sizeof(p[0]) * dataWidth.GetValue());
						len += dataWidth.GetValue();
						//delete[]p;
						palloc->Free((char *)p);
					}
				idx = (idx.GetValue() + 2) % BANK_NUM;
				if (fp && debugLevel <= 1)
					fprintf(fp, "wctrl output %d data to %d ("DFMT", "DFMT", "DFMT", "DFMT")\n", len, addr, outbuf[0], outbuf[1], outbuf[2], outbuf[3]);

			}
			else {
				//if(!nextInst.GetValue())
				idx = (idx.GetValue() + 2) % BANK_NUM;
				return;
			}
		}
		else if (mode == MODE_ONE){
			int i;
			for (i = 0; i < BANK_NUM; i++)
				if (dataFifo[i].size() == 0)
					return;
			addr = dataAddr[0].front();
			unsigned nextaddr = addr;
			for (i = 0; i < BANK_NUM; i++){
				DTYPE *p = dataFifo[i].front();
				dataFifo[i].pop();
				assert(nextaddr == dataAddr[i].front());
				nextaddr += dataWidth.GetValue();
				dataAddr[i].pop();
				memcpy(outbuf + len, p, sizeof(p[0]) * dataWidth.GetValue());
				len += dataWidth.GetValue();
				palloc->Free((char *)p); //delete[]p;
			}
		}
		else if (mode == MODE_TWO){

			if (dataFifo[idx.GetValue()].size() >= 2 && dataFifo[idx.GetValue() + 1].size() >= 2){

				addr = dataAddr[idx.GetValue()].front();
				unsigned nextaddr = addr;
				for (int k = 0; k < 2; k++)
					for (int i = 0; i < BANK_NUM / 2; i++){
						DTYPE *p = dataFifo[i + idx.GetValue()].front();
						dataFifo[i + idx.GetValue()].pop();
						if (nextaddr != dataAddr[i + idx.GetValue()].front()){ // frame end for S = 2, output 5 x 5
							assert(k == 1 && i == 0);
							if (isWriteA.GetValue()){
								assert(false);
								rama->Write(Oaddr.GetValue() + addr, len, outbuf, true);

							}
							else if (isWriteB.GetValue()){
								assert(false);
								ramb->Write(Oaddr.GetValue() + addr, len, outbuf, true);
							}
							else{
								memcpy((unsigned *)(Oaddr.GetValue() + sizeof(DTYPE) * addr), outbuf, len * sizeof(DTYPE));
							}
							addr = dataAddr[idx.GetValue()].front();
							nextaddr = addr;
							len = 0;
						}
						nextaddr += dataWidth.GetValue();
						dataAddr[i + idx.GetValue()].pop();
						memcpy(outbuf + len, p, sizeof(p[0]) * dataWidth.GetValue());
						len += dataWidth.GetValue();
						palloc->Free((char *)p); //delete[]p;
					}
				idx = (idx.GetValue() + 2) % BANK_NUM;
			}
			else if (nextInst[idx.GetValue()].GetValue() && dataFifo[idx.GetValue()].size() == 1 && dataFifo[idx.GetValue() + 1].size() == 1){

				addr = dataAddr[idx.GetValue()].front();
				unsigned nextaddr = addr;
				for (int i = 0; i < BANK_NUM / 2; i++){
					DTYPE *p = dataFifo[i + idx.GetValue()].front();
					dataFifo[i + idx.GetValue()].pop();
					nextaddr += dataWidth.GetValue();
					dataAddr[i + idx.GetValue()].pop();
					memcpy(outbuf + len, p, sizeof(p[0]) * dataWidth.GetValue());
					len += dataWidth.GetValue();
					palloc->Free((char *)p); //delete[]p;
				}
				idx = (idx.GetValue() + 2) % BANK_NUM;
			}
			else{
				//assert((idx.GetValue() & 1) == 0);
				//if(!nextInst.GetValue())
				idx = ((idx.GetValue() & 2) + 2) % BANK_NUM;
				return;
			}

		}
		else{
			if (dataFifo[idx.GetValue()].size() >= 4){
				addr = dataAddr[idx.GetValue()].front();
				unsigned nextaddr = addr;
				for (int k = 0; k < 4; k++){
					DTYPE *p = dataFifo[idx.GetValue()].front();
					dataFifo[idx.GetValue()].pop();
					assert(nextaddr == dataAddr[idx.GetValue()].front());
					nextaddr += dataWidth.GetValue();

					dataAddr[idx.GetValue()].pop();
					memcpy(outbuf + len, p, sizeof(p[0]) * dataWidth.GetValue());
					len += dataWidth.GetValue();
					palloc->Free((char *)p); //delete[]p;
				}
				if (fp && debugLevel <= 1)
					fprintf(fp, "wctrl output %d data to %d ("DFMT", "DFMT", "DFMT", "DFMT")\n", len, addr, outbuf[0], outbuf[1], outbuf[2], outbuf[3]);
				idx = (idx.GetValue() + 1) % BANK_NUM;
			}
			else if (nextInst[idx.GetValue()].GetValue() && dataFifo[idx.GetValue()].size() > 0){
				addr = dataAddr[idx.GetValue()].front();
				unsigned nextaddr = addr;
				for (unsigned k = 0; k < dataFifo[idx.GetValue()].size(); k++){
					DTYPE *p = dataFifo[idx.GetValue()].front();
					dataFifo[idx.GetValue()].pop();
					assert(nextaddr == dataAddr[idx.GetValue()].front());
					nextaddr += dataWidth.GetValue();

					dataAddr[idx.GetValue()].pop();
					memcpy(outbuf + len, p, sizeof(p[0]) * dataWidth.GetValue());
					len += dataWidth.GetValue();
					palloc->Free((char *)p); //delete[]p;
				}
				if (fp && debugLevel <= 1)
					fprintf(fp, "wctrl output %d data to %d ("DFMT", "DFMT", "DFMT", "DFMT")\n", len, addr, outbuf[0], outbuf[1], outbuf[2], outbuf[3]);
				idx = (idx.GetValue() + 1) % BANK_NUM;
			}
			else{
				//if (!nextInst.GetValue())
				idx = (idx.GetValue() + 1) % BANK_NUM;
				return;
			}

		}

		/*if (!(nextInst[idx.GetValue()].GetValue())) {
			if (mode == MODE_FOUR || mode == MODE_ONE)
				assert(outLen == len);
			else{
				if (fp && !(outLen == len || outLen == len * 2))
					fprintf(fp, "wctrl ERROR outlen %d, len %d\n", outLen, len);
			}
		}*/
		//assert(outLen == len || outLen == len * 2);
		if (isWriteA.GetValue()){
			assert(false);
			rama->Write(Oaddr.GetValue() + addr, len, outbuf);
			
			rama_write_enable = true;
			ram_write_addr = Oaddr.GetValue() + addr;
			ram_write_len = len;
			if (fp && debugLevel <= 1)
				fprintf(fp, "wctrl write to A %d (%d)\n", Oaddr.GetValue() + addr, len);
		}
		else if (isWriteB.GetValue()){
			assert(false);
			ramb->Write(Oaddr.GetValue() + addr, len, outbuf);
			
			ramb_write_enable = true;
			ram_write_addr = Oaddr.GetValue() + addr;
			ram_write_len = len;
			if (fp && debugLevel <= 1)
				fprintf(fp, "wctrl write to B %d (%d)\n", Oaddr.GetValue() + addr, len);

		}
		else{
			//memcpy((unsigned *)(Oaddr.GetValue() + sizeof(DTYPE) * addr), outbuf, len * sizeof(DTYPE));
			pddr->DelayWrite(Oaddr.GetValue() + sizeof(DTYPE) * addr, len * sizeof(DTYPE), (unsigned char *)outbuf);

			ddr_write_enable = true;
			ddr_write_addr = Oaddr.GetValue() + sizeof(DTYPE) * addr;
			ddr_write_len = len * sizeof(DTYPE);
			if (fp && debugLevel <= 1)
				fprintf(fp, "wctrl write to M %d (%d) (%d %d)\n", Oaddr.GetValue() + sizeof(DTYPE) * addr, len * sizeof(DTYPE), outbuf[0], outbuf[1]);

		}
		if (fvo){
			fprintf(fvo, " %d", len);
			for (int k = 0; k < len; k++)
				fprintf(fvo, " %d", outbuf[k]);
		}
		if (fp && debugLevel <= 1) {
			for (int i = 0; i < BANK_NUM; i++)
				fprintf(fp, " %d (%s)", dataFifo[i].size(), outValid[i] ? "*" : "");
			fprintf(fp, "\n");
		}
		for (int i = 0; i < BANK_NUM; i++)
			if (outValid[i] || dataFifo[i].size() > 0)
				return;
		if (fp && debugLevel <= 3 && finishedSeq.GetValue() != cbInsts[0]->GetFinishedSeq())
			fprintf(fp, "%d : wctrl change finished %d -> %d\n", num, finishedSeq.GetValue(), cbInsts[0]->GetFinishedSeq());

		finishedSeq = cbInsts[0]->GetFinishedSeq();
	}

}
#include "sim.h"
#include "interface.h"
#include <assert.h>
namespace CloudDesign{
	void CReadController::Init()
	{
		storages.push_back(&isReadA);
		storages.push_back(&isReadB);
		//storages.push_back(&isResA);
		storages.push_back(&hasMoreData);
		storages.push_back(&readMoreData);
		storages.push_back(&liveCount);
		storages.push_back(&mode);
		storages.push_back(&reqSeq);
		storages.push_back(&reqProgress);
		storages.push_back(&readWidth);
		storages.push_back(&dataWidth);
		storages.push_back(&nextReadPos);
		storages.push_back(&lastPos);
		storages.push_back(&nextReadY);
		storages.push_back(&readYLast);
		storages.push_back(&w);
		storages.push_back(&nextReadC);
		storages.push_back(&readCLast);
		storages.push_back(&frameReadStart);
		storages.push_back(&frameSize);
		storages.push_back(&readYStart);
		storages.push_back(&reqq);
		storages.push_back(&reqq_ddr);
		storages.push_back(&retq);
		storages.push_back(&Oaddr);
#ifdef S2_OPTIMIZE
		storages.push_back(&isStride2);
#endif
		storages.push_back(&dataRead);
		storages.push_back(&dataAsk);
		storages.push_back(&newReqSeq);
		storages.push_back(&seqNum);
		storages.push_back(&seqNumNew);
		storages.push_back(&reqGIBValid);
		storages.push_back(&req_ram_valid);
		storages.push_back(&data_ram_valid);
		
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->Init();

		busValid = false;
		valid = false;
		for (int i = 0; i < BANK_NUM; i++)
			reqValid[i] = false;
		reqGIBValid = false;
		dataIdx = 0;
		debugLevel = DEFAULT_DEBUG_LEVEL;
		start_dump = false;

		if (DUMP_VERIFICATION_CTRLREAD){
			char filename[100];
			sprintf(filename, "%s/ctrlread_input.txt", OUTPUT_DIR);
			fvi = fopen(filename, "wt");
			assert(fvi);
			sprintf(filename, "%s/ctrlread_output.txt", OUTPUT_DIR);
			fvo = fopen(filename, "wt");
			assert(fvo);
		}
		else
			fvi = fvo = NULL;
		resetVerify();
		req_ram_request = false;
		data_ram_request = false;
	}

	void CReadController::reset()
	{
		if (busValid){
			delete[]dataBus;
			busValid = false;
		}
		for (int i = 0; i < BANK_NUM; i++)
			reqValid[i] = false;
		dataIdx = 0;
		valid = false;
		reqGIBValid = false;
		cbInsts.clear();
		resetVerify();
	}


	void CReadController::latch(int num)
	{
		req_ram_valid = req_ram_request;
		data_ram_valid = data_ram_request;
		req_ram_request = false;
		data_ram_request = false;
		FinishDumpVerify2(); 
		if (busValid){
			palloc->Free((char *)dataBus);
			/*if (isFeature)
				delete[]dataBus;
			else
				delete (ReturnData *)dataBus;*/
			busValid = false;
		}
		if (valid){
			valid = false;
			fifo.push(inst);
		}
		int cnt = 0;
		for (int i = 0; i < BANK_NUM; i++)
			if (reqValid[i]){
				cnt++;
				reqValid[i] = false;
				reqq.Push(ritem[i]);
			}
		assert(cnt < 2);
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->latch(num);
		resetVerify();
		//if (fp && debugLevel <= 1)
		//	fprintf(fp, "ctrlread reqsize %d, retsize %d\n", reqq.size(), retq.size());
	}
	void CReadController::resetVerify()
	{
		ddr_enable = false;
		rama_ren = false;
		ramb_ren = false;
	}
	void CReadController::DumpState()
	{
		if (!fp)
			return;
		fprintf(fp, "Dump %s mode %s fifo %d, newseq?(%s), seq %d (%d), req %d(%d)\n", name.c_str()
			, mode == MODE_FOUR ? "FOUR" : (mode == MODE_TWO ? "TWO" : "ONE"), fifo.size()
			, newReqSeq.GetValue() ? "Y" : "N", seqNum.GetValue(), seqNumNew.GetValue()
			, reqSeq.GetValue(), reqProgress.GetValue());
		fprintf(fp, "\tReading %s, dataIdx %d, w %d, more?(%s), Oaddr %d, data queue %d\n"
			, isReadA.GetValue() ? "A" : (isReadB.GetValue() ? "B" : "M"), dataIdx
			, w.GetValue(), hasMoreData.GetValue() ? "Y" : "N", Oaddr.GetValue(), data_fifo.size());
		fprintf(fp, "\tReadWidth %d, datawidth %d, dataRead %d, nreadPos %d, lastPos %d\n"
			, readWidth.GetValue(), dataWidth.GetValue(), dataRead.GetValue(), nextReadPos.GetValue(), lastPos.GetValue());
		fprintf(fp, "\tnreadyC %d, lreadC %d, nreadY %d, lreadY %d, sreadY %d, fstart %d, fsize %d\n"
			, nextReadC.GetValue(), readCLast.GetValue(), nextReadY.GetValue(), readYLast.GetValue()
			, readYStart.GetName(), frameReadStart.GetValue(), frameSize.GetValue());
		fprintf(fp, "\treqQ %d, retQ %d\n", reqq.size(), retq.size());
	}

	void CReadController::RequestGIB(RequestItem &rq) {
		
		assert(!reqGIBValid.GetValue());
		reqGIB = rq; reqGIBValid = true;
		if (!start_dump && fvi){
			start_dump = true;
			fprintf(fvi, "0 0 0 0 0 0 0 0 0 0\n \
				0 0 0 0 0 0 0\n\
				0 0 0 0 0 0 0\n\
				0 0 0 0 0 0 0\n\
				0 0\n\
				0");

			fprintf(fvo, "0 1 0 0 0 0\n 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0\n");
		}
	}

	void CReadController::FinishDumpVerify2()
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump){
			return;
		}
		if (valid){
			fprintf(fvi, " 1  %d %d %d %d %d %d"
				,inst.mode, inst.reqSeqNum, inst.reqProgress
				, inst.seqNum, inst.W, inst.H);
			fprintf(fvi, " %d %d %d %d %d %d"
				, inst.C, inst.Maddr, inst.W1
				, inst.W2, inst.H1, inst.X);
			fprintf(fvi, " %d %d %d %d %d %d %d\n", inst.Y
				, inst.S, inst.lPad, inst.rPad
				, inst.isMaddr_a, inst.isMaddr_b, inst.isRes_a);
		}
		else
			fprintf(fvi, " 0\n");
		
		int hasValid = false;
		for (int i = 0; i < BANK_NUM; i++)
			if (reqValid[i]){
				fprintf(fvi, " %d %d %d %d %d %d %d %d\n", i, ritem[i].addr
					, ritem[i].seq, ritem[i].len, ritem[i].token
					, ritem[i].type, ritem[i].isRamA, ritem[i].isRamB);
				hasValid = true;
			}
		
		if (!hasValid)
			fprintf(fvi, " -1\n");

		if (!reqGIBValid.GetValue() && reqGIBValid.GetNextValue()){
			fprintf(fvi, " 1 %d %d %d %d %d %d %d\n", reqGIB.addr
				, reqGIB.seq, reqGIB.len, reqGIB.token
				, reqGIB.type, reqGIB.isRamA, reqGIB.isRamB);
		}
		else
			fprintf(fvi, " 0\n");

		//input logic         requestValid,
		//	input RequestItem_t ritem,
		//	input logic         reqGIBValid,
		//	input RequestItem_t reqGIB,
	}
	void CReadController::StartDumpVerify(int num)
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump){
			return;
		}
		fprintf(fvi, "%d %d %d", num + 1, pddr->GetDDRID(), pddr->readReady());
		for (int i = 0; i < BANK_NUM; i++)
			fprintf(fvi, " %d %d %d %d %d %d %d\n", cbInsts[i]->IsRunning()
			, cbInsts[i]->IsReadingFeatures(), cbInsts[i]->IsLoadingFroze(), cbInsts[i]->GetReqFeature()
			, cbInsts[i]->GetFinishedSeq(), cbInsts[i]->GetWorkingSeq(), cbInsts[i]->GetWorkingProgress());
		fprintf(fvi, " 0 0\n"); //rama, ramb
		
		
		//	input s_feature_t[MAX_LOAD_WIDTH - 1:0]ddr_data,
		

		fprintf(fvo, "%d %d %d %d\n", num, data_fifo_empty, data_fifo_progfull, dataIdx);
	}
	void CReadController::FinishDumpVerify()
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump)
			return;
		if (!pddr->DataValid(DDR_DATA_ID) && !pddr->DataValid(DDR_EXT_ID))
			fprintf(fvi, " 0\n");

		if (!busValid)
			fprintf(fvo, " 0 0\n");
		fprintf(fvo, " %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n"
			, input_data_wen, input_data_ren
			, ddr_id, reqGIBValid.GetValue()
			, ddr_enable, ddr_addr, ddr_len, rama_ren
			, ramb_ren, ram_addr, ram_len, waitForSeq()
			, RequestFull(), seqNum.GetValue());
		fprintf(fvo, " %d %d %d %d %d %d\n", this->IsStopable(), liveCount.GetValue()
			, readMoreData.GetValue(), newReqSeq.GetValue()
			, data_fifo_wen, data_fifo_ren);
		
	}

	void CReadController::progress(int num)
	{
		cnt_inc = 0;
		ddr_id = 0;
		//fprintf(fp, "livecount %d, datasize %d, reqsize %d, retsize %d, input %d, dly %d, idx %d\n"
		//	, liveCount.GetValue(), data_fifo.size(), reqq.size()
		//	, retq.size(), input_data.size(), dly_info.size(), dataIdx);
		//fflush(fp);
		data_fifo_empty = data_fifo.size() == 0;
		data_fifo_progfull = Full(1);
		StartDumpVerify(num);
		ProduceInputs();
		ReadData(num);
		ReceiveData(num);
		AskData(num);
		ReadExtData(num); // Read before Ask, so that last_ri not overwriten
		AskExtData(num); // move this after productInputs so we use data next cycle
		processInstruction(num);
		
		int cnt1 = (busValid && isFeature) ? 1 : 0;
		if (!liveCount.IsSetted()){
			liveCount = liveCount.GetValue() + cnt_inc - cnt1;
			//totalAdd += cnt;
			//totalDec += cnt1;
		}
		FinishDumpVerify();
		//fprintf(fp, "cr done\n");
		//fflush(fp);
	}

	void CReadController::processInstruction(int num)
	{
		if (hasMoreData.GetValue())
			return;
		if (mode.GetValue() != MODE_ONE && dataIdx != 0)
			return;
		if (fifo.size() == 0)
			return;
		InstructionRead inst = fifo.front();
		fifo.pop();
		reqSeq = inst.reqSeqNum;
		seqNumNew = inst.seqNum;
		newReqSeq = true;
		//seqCounts = data.size();
		reqProgress = inst.reqProgress;
		w = inst.W;
		mode = inst.mode;
		int rw;
		if (inst.mode == MODE_FOUR)
			rw = inst.W1;
		else if (inst.mode == MODE_TWO)
			rw = (inst.W1 + inst.W2);
		else
			rw = (inst.W1 * 3 + inst.W2);
#if defined(S2_OPTIMIZE)
		if (inst.S == 2)
			rw *= 2;
		isStride2 = (inst.S == 2);
#endif
		int nextx = inst.X;
		
		//if (inst.lPad > 0){
			if (inst.X > 0){
				rw += inst.lPad;
				nextx -= inst.lPad;
			}
		//}
		//if (inst.rPad > 0){
			if (inst.X + rw < inst.W)
				rw += inst.rPad;
		//}
		dataWidth = rw;
#if defined(S2_OPTIMIZE)
		if (inst.S == 2){
			if(inst.mode == MODE_FOUR)
				readWidth = rw * 2;
			else
				readWidth = rw;
		}else
#endif
		if (inst.mode == MODE_TWO) // assert( W == 20) for yolo
			readWidth = rw << 1;
		else if (inst.mode == MODE_FOUR) // assert( W == 10)
			readWidth = rw << 2;
		else
			readWidth = rw;
		
		int ys = inst.Y;
		//readYStart = inst.Y;
		int yl = inst.Y + inst.H1;
		readCLast = inst.C - 1;

		//if (inst.lPad > 0){
			if (inst.Y > 0){
				ys -= inst.lPad;
			}
		//}
		//if (inst.rPad > 0){
			if (inst.Y + inst.H1 != inst.H - 1)
				yl += inst.rPad;
		//}
		readYStart = ys;

		readYLast = yl;
		frameSize = inst.W * inst.H;
		Oaddr = inst.Maddr;
		frameReadStart = inst.W * ys + nextx;// +inst.Maddr;
		nextReadPos = inst.W * ys + nextx;// +inst.Maddr;  //frameReadStart;
		nextReadY = ys;
		nextReadC = 0;
		isReadA = inst.isMaddr_a;
		isReadB = inst.isMaddr_b;
		//isResA = inst.isRes_a;
		//if (inst.isMaddr_a || inst.isMaddr_b)
		lastPos = inst.W * inst.H * inst.C;// +inst.Maddr;
		//else
		//	lastPos = inst.W * inst.H * inst.C *sizeof(DTYPE) + inst.Maddr;
		hasMoreData = true;
		readMoreData = true;
		dataRead = 0;
		dataAsk = 0;
		if (fp && debugLevel <=3)
			fprintf(fp, "%d : readctrl newinst req %d, seq %d, rpos %d, rw %d, oaddr %u, queue %d %s%s\n", num, inst.reqSeqNum
			, seqNumNew.GetNextValue(), nextReadPos.GetNextValue()
			, readWidth.GetNextValue(), Oaddr.GetNextValue(), data_fifo.size(), inst.isMaddr_a ? "A" : "", inst.isMaddr_b ? "B" : "");
	}

	void CReadController::dumpGIBData(DTYPE *data, int clen)
	{
		fprintf(fvi, " %d", clen);
		unsigned char *pdata = (unsigned char*)data;
		for (int i = 0; i < clen; i++)
			fprintf(fvi, " %d", pdata[i]);
		/*int len = (clen + 3) / 4;
		for (int i = 0; i < len; i++){
			fprintf(fvi, " %d", data[i] & 0xffff);
			if (i * 2 + 1 < slen)
				fprintf(fvi, " %d", data[i] >> 16);
		}*/
		fprintf(fvi, "\n");
	}

	void CReadController::DumpVerifyReturnData(ReturnData *rd)
	{
		if (!fvo)
			return;
		if (rd->type != TYPE_GIB)
		{
			fprintf(fvo, " 1 0 %d %d %d %d", rd->seq, rd->len, rd->token, rd->type);
			for (unsigned i = 0; i < rd->len; i++)
				fprintf(fvo, " %d", rd->data[i]);
			fprintf(fvo, "\n");
		}
		else{
			fprintf(fvo, " 1 0 %d %d %d %d", rd->seq, rd->len, rd->token, rd->type);
			unsigned char *pdata = (unsigned char *)rd->data;
			for (int i = 0; i < rd->len; i++)
				fprintf(fvo, " %d", pdata[i]);
			fprintf(fvo, "\n");
			
		}

	}
	void CReadController::ReadExtData(int num)
	{
		if (req_ram_valid.GetValue()){
			ReturnData *ret = (ReturnData *)palloc->Alloc();
			ret->len = last_ri.len;
			ret->token = last_ri.token;
			ret->type = last_ri.type;
			ret->seq = last_ri.seq; 
				//ret->isLast = ri.isLast;
			if (last_ri.isRamA){
				assert(false);
				rama->Load(ret->data, last_ri.addr, last_ri.len);
			}
			else if (last_ri.isRamB){
				assert(false);
				ramb->Load(ret->data, last_ri.addr, last_ri.len);
			}
			if (fp && debugLevel <= 1)
				fprintf(fp, "readctrl read ext data len %d from RAM\n", last_ri.len);
			retq.Push(ret);
		}
		else if (pddr->DataValid(DDR_EXT_ID)){
			ReturnData *ret = (ReturnData *)palloc->Alloc();
			last_ri = reqq_ddr.Pop();
			ret->len = last_ri.len;
			ret->token = last_ri.token;
			ret->type = last_ri.type;
			ret->seq = last_ri.seq;


			if (last_ri.type == TYPE_GIB){
				memcpy(ret->data, pddr->DelayData(), last_ri.len);
				if (fvi){
					dumpGIBData(ret->data, last_ri.len);
				}
				if (fp && debugLevel <= 1)
					fprintf(fp, "readctrl read GIB data len %d (%d, %d) \n", last_ri.len, pddr->DelayData()[0], pddr->DelayData()[1]);
				/*if (fp){
					fprintf(fp, "# readcExtdata %d %d %d", ret->type, ret->len, ret->seq);
					int slen = (last_ri.len + 1) / 2;
					unsigned short *pdata = (unsigned short *)ret->data;
					for (int i = 0; i < slen; i++)
						fprintf(fp, " %d", pdata[i]);
					fprintf(fp, "\n");
				}*/
			}
			else{
#ifdef YOLO
				FEATURE_TYPE bufs[MAX_LOAD_WIDTH];
				memcpy((unsigned char *)bufs, pddr->DelayData(), last_ri.len * (FEATURE_BIT_SIZE / 8));
				for (unsigned j = 0; j < last_ri.len; j++)
					ret->data[j] = bufs[j];
				if (fvi){
					fprintf(fvi, " %d", last_ri.len);
					for (unsigned i = 0; i < last_ri.len; i++)
						fprintf(fvi, " %u", bufs[i]);
					fprintf(fvi, "\n");
				}
				/*if (fp){
					fprintf(fp, "# readcExtdata %d %d %d", ret->type, ret->len, ret->seq);
					for(int i = 0; i < ret->len; i++)
						fprintf(fp, " %d",ret->data[i]);
					fprintf(fp, "\n");
				}*/
#else
				memcpy(ret->data, pddr->DelayData(), last_ri.len * sizeof(DTYPE));
				//pddr->Load((unsigned char *)ret->data, ri.addr, ri.len * sizeof(DTYPE));
#endif

				if (fp && debugLevel <= 1)
					fprintf(fp, "readctrl read ext data len %d from ddr %d, %d)\n", last_ri.len, pddr->DelayData()[0], pddr->DelayData()[1]);
			}
			retq.Push(ret);
		}
	}

	void CReadController::AskExtData(int num)
	{
		if (ddr_enable)
			return;
		/*std::vector<CHomoGeneousComputingBank*>::const_iterator p;
		for (p = cbInsts.begin(); p != cbInsts.end(); p++)
			if ((*p)->IsRunning() && ((*p)->GetReqFeature() == seqNum.GetValue() &&
				(*p)->IsReadingFeatures())){
				return;
			}*/
		if (reqq.size() == 0){
			if (reqGIBValid.GetValue() && pddr->readReady() && !reqq_ddr.IsFull()){
				reqGIBValid = false;
				pddr->DelayLoad(DDR_EXT_ID, reqGIB.addr, reqGIB.len);
				reqq_ddr.Push(reqGIB);
				ddr_enable = true;
				ddr_addr = reqGIB.addr;
				ddr_len = reqGIB.len;
				ddr_id = DDR_EXT_ID;
				if (fp && debugLevel <= 1)
					fprintf(fp, "readctrl ask GIB data len %d, addr %d \n", reqGIB.len, reqGIB.addr);
			}
			return;
		}
		 
		last_ri = reqq.front();
		if (!last_ri.isRamA && !last_ri.isRamB && (!pddr->readReady() || reqq_ddr.IsFull()))
			return;
		reqq.Pop();
		if (last_ri.isRamA || last_ri.isRamB){
			req_ram_request = true;
			rama_ren = true;
			ram_addr = last_ri.addr;
			ram_len = last_ri.len;
		}
		else{
			reqq_ddr.Push(last_ri);
			ddr_id = DDR_EXT_ID;
#ifdef YOLO
			pddr->DelayLoad(DDR_EXT_ID, last_ri.addr, last_ri.len * (FEATURE_BIT_SIZE/8));
			ddr_enable = true;
			ddr_addr = last_ri.addr;
			ddr_len = last_ri.len * (FEATURE_BIT_SIZE / 8);
			if (fp && debugLevel <= 1)
				fprintf(fp, "readctrl ask ext data len %d (%d) \n", last_ri.len * (FEATURE_BIT_SIZE / 8), last_ri.addr);

#else
			//memcpy(ret->data, (void *)ri.addr, ri.len * sizeof(DTYPE));
			pddr->DelayLoad(DDR_EXT_ID, last_ri.addr, last_ri.len * sizeof(DTYPE));
#endif
		}

	}
	bool CReadController::waitForSeq()
	{
		std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin();
		for (; p != cbInsts.end(); p++)
			if ((*p)->GetFinishedSeq() < reqSeq.GetValue()){
				if ((*p)->GetWorkingSeq() < reqSeq.GetValue()
					|| (*p)->GetWorkingProgress() < reqProgress.GetValue()){
					return true;
				}
			}
		return false;
	}
	bool CReadController::waitingFeature()
	{
		for (std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin(); p != cbInsts.end(); p++)
			if ((*p)->IsRunning() && ((*p)->GetReqFeature() == seqNum.GetValue() &&
				(!(*p)->IsReadingFeatures() || (*p)->IsLoadingFroze()))){
				if (fp && debugLevel <= 1)
					fprintf(fp, "readctrl ReadData return\n");
				return true;
			}
		return false;
	}

	void CReadController::ReadData(int num)
	{
		input_data_ren = false;
		data_fifo_wen = false;
		if (mode.GetValue() != MODE_ONE && dataIdx != 0){
			DTYPE *buf0 = (DTYPE*)palloc->Alloc(); //new DTYPE[dataWidth.GetValue()];
			memcpy(buf0, saveData + dataIdx * dataWidth.GetValue(), sizeof(buf0[0]) * dataWidth.GetValue());
			data_fifo.push(buf0);
			data_fifo_wen = true;
			len_mp[buf0] =  dataWidth.GetValue();
#ifdef S2_OPTIMIZE
			if (mode.GetValue() == MODE_TWO || isStride2.GetValue() || dataIdx == 3){
#else
			if (mode.GetValue() == MODE_TWO || dataIdx == 3){
#endif
				dataIdx = 0;
				palloc->Free((char *)saveData);
				//delete[]saveData;
			}
			else
				dataIdx++;
		}
		//else if (!data_fifo_progfull && hasMoreData.GetValue() && (isReadA.GetValue() || isReadB.GetValue() || !ddr_enable)){
		else if (!input_data.empty()){
			input_data_ren = true;
			data_fifo_wen = true;
			DTYPE *buf = input_data.front(); //new DTYPE[MAX_LOAD_WIDTH];
			SDelayReadInfo ri = dly_info.front();
			dly_info.pop();
			input_data.pop();
			dataRead += ri.len;
			if (fp && debugLevel <=1)
				fprintf(fp, "readctrl read %d (%d) data", ri.len, dataRead.GetNextValue());
			len_mp[buf] = ri.len;
			if (fp && debugLevel <=1)
				fprintf(fp, ", "DFMT", "DFMT"\n", buf[24], buf[25]);
			data_fifo.push(buf);
			hasMoreData = ri.hasMoreData;
			
			if(ri.setup_saved){
				dataIdx = 1;
				DTYPE *buf0 = (DTYPE*)palloc->Alloc(); //new DTYPE[dataWidth.GetValue()];
				memcpy(buf0, buf, sizeof(buf0[0]) * MAX_LOAD_WIDTH);
				saveData = buf0;
			}
			if (!hasMoreData.GetNextValue() && fp)
				fprintf(fp, "%d : readctrl done\n", num);
		}
	}

	void CReadController::ReceiveData(int num)
	{
		input_data_wen = false;
		if (data_ram_valid.GetValue()){
			DTYPE *buf = (DTYPE*)palloc->Alloc();
			if (isReadA.GetValue()){
				assert(false);
				rama->Load(buf, ram_addr, ram_len);
			}
			else {
				assert(isReadB.GetValue());
				assert(false);
				ramb->Load(buf, ram_addr, ram_len);
			}
			input_data.push(buf);
			input_data_wen = true;
		}
		else if (pddr->DataValid(DDR_DATA_ID)){
			DTYPE *buf = (DTYPE*)palloc->Alloc();
#ifdef YOLO
			FEATURE_TYPE bufs[MAX_LOAD_WIDTH];
			memcpy((unsigned char *)bufs, pddr->DelayData(), MAX_LOAD_WIDTH * sizeof(bufs[0]));
			for (int j = 0; j < MAX_LOAD_WIDTH; j++)
				buf[j] = bufs[j];
			if (fvi){
				fprintf(fvi, " %d", MAX_LOAD_WIDTH);
				for (int i = 0; i < MAX_LOAD_WIDTH; i++)
					fprintf(fvi, " %d", bufs[i]);
				fprintf(fvi, "\n");
			}
			if (fp && debugLevel <= 1){
				fprintf(fp, "readctrl received data %d %d\n", bufs[0], bufs[1]);
			}
			/*if(fp){
				fprintf(fp, "# readcdata ");	
				for (int i = 0; i < MAX_LOAD_WIDTH; i++)
					fprintf(fp, " %d", bufs[i]);
				fprintf(fp, "\n");
		}*/
#else
			memcpy((unsigned char *)buf, pddr->DelayData(), MAX_LOAD_WIDTH * sizeof(DTYPE));
#endif
			input_data.push(buf);
			input_data_wen = true;
		}
	}

	void CReadController::AskData(int num)
	{
		int cnt;
		if (mode == MODE_FOUR){
			cnt = 3;
		}
		else if (mode == MODE_TWO){
			cnt = 1;
		}
		else{
			cnt = 0;
		}
		if (waitForSeq())
			return;
		if (waitingFeature())
			return;
		if (!isReadA.GetValue() && !isReadB.GetValue() && !pddr->readReady())
			return;
		if (liveCount.GetValue() + cnt < MAX_INPUT_BUF_SIZE && readMoreData.GetValue()){
			if (newReqSeq.GetValue() && liveCount.GetValue() > 0){
				if (fp && debugLevel <= 2)
					fprintf(fp, "readctrl wait for %d data use\n", data_fifo.size());
				return;
			}//else{
			newReqSeq = false;
			seqNum = seqNumNew.GetValue();
			//reqSeq = reqSeqNew.GetValue();
			if (fp && debugLevel <= 1 && seqNum.GetValue() != seqNumNew.GetValue())
				fprintf(fp, "readctrl start new seq %d \n", seqNumNew.GetValue());
			int len = readWidth.GetValue();
			if (mode.GetValue() == MODE_FOUR){
				if (nextReadPos.GetValue() + len > lastPos.GetValue()){
					len = lastPos.GetValue() - nextReadPos.GetNextValue();
					if(fp)
						fprintf(fp, "readctrl len reduced from %d to %d \n", readWidth.GetValue(), len);
				}
			}
			else if (mode.GetValue() == MODE_TWO){
				if (nextReadY.GetValue() == readYLast.GetValue()){
					//assert(nextReadY.GetValue() + 1 == readYLast.GetValue());
					len = dataWidth.GetValue();
				}
			}
			dataAsk += len;
			if (fp && debugLevel <= 1)
				fprintf(fp, "readctrl asked %d (%d) data, Yaddr %d\n", len, dataAsk.GetNextValue(),
				(Oaddr.GetValue() + nextReadPos.GetValue() *(FEATURE_BIT_SIZE / 8)));

			//if (!isReadA.GetValue() && !isReadB.GetValue())
			//	len *= sizeof(DTYPE);
			if (isReadA.GetValue() || isReadB.GetValue()){
				data_ram_request = true;
				assert(false);
				//rama->Load(buf, Oaddr.GetValue() + nextReadPos.GetValue(), len);
				rama_ren = true;
				ram_addr = Oaddr.GetValue() + nextReadPos.GetValue();
				ram_len = len;
			}
			else{
				ddr_enable = true;
				ddr_id = DDR_DATA_ID;
#ifdef YOLO
				pddr->DelayLoad(DDR_DATA_ID, (Oaddr.GetValue() + nextReadPos.GetValue() *(FEATURE_BIT_SIZE / 8))
					, len * (FEATURE_BIT_SIZE / 8));
				ddr_addr = (Oaddr.GetValue() + nextReadPos.GetValue() *(FEATURE_BIT_SIZE / 8));
				ddr_len = len * (FEATURE_BIT_SIZE / 8);
#else
				pddr->DelayLoad(DDR_DATA_ID, (Oaddr.GetValue() + nextReadPos.GetValue() *sizeof(DTYPE))
					, len * sizeof(DTYPE));
#endif
			}
			if (len == 0)
				printf("Add 0 len\n");
			bool setup_saved = false;

			if (mode.GetValue() == MODE_ONE
#ifdef S2_OPTIMIZE
				|| mode.GetValue() == MODE_TWO && isStride2.GetValue()
#endif				
				){
				if (nextReadY.GetValue() < readYLast.GetValue()){
					nextReadY++;
					nextReadPos += w.GetValue();
				}
				else if (nextReadC.GetValue() < readCLast.GetValue()){
					frameReadStart += frameSize.GetValue();
					nextReadPos = frameReadStart.GetNextValue();
					nextReadC++;
					nextReadY = readYStart.GetValue();
				}
				else{
					readMoreData = false;
				}
				cnt_inc = 1;
			}
			else if (mode.GetValue() == MODE_TWO){
				if (nextReadY.GetValue() == readYLast.GetValue()){
					//assert(dataIdx == 0);
					if (nextReadC.GetValue() < readCLast.GetValue()){
						frameReadStart += frameSize.GetValue();
						nextReadPos = frameReadStart.GetNextValue();
						nextReadC++;
						nextReadY = readYStart.GetValue();
					}
					else{
						readMoreData = false;
					}
					cnt_inc = 1;
				}
				else{
					if (nextReadY.GetValue() < readYLast.GetValue() - 1){
						nextReadY = nextReadY.GetValue() + 2;
						nextReadPos += w.GetValue() * 2;
					}
					else if (nextReadC.GetValue() < readCLast.GetValue()){
						frameReadStart += frameSize.GetValue();
						nextReadPos = frameReadStart.GetNextValue();
						nextReadC++;
						nextReadY = readYStart.GetValue();
					}
					else{
						readMoreData = false;
					}
					cnt_inc = 2;
					//dataIdx++;
					setup_saved = true;
				}

			}
			else{
				cnt_inc = 4;
				//dataIdx++;
				setup_saved = true;
				nextReadPos += len;
				if (nextReadPos.GetNextValue() >= lastPos.GetValue())
					readMoreData = false;
			}
			if (!readMoreData.GetNextValue() && fp)
				fprintf(fp, "%d : readctrl Ask done\n", num);
			//ramDelay.dataIdx = dataIdx;
			ramDelay.hasMoreData = readMoreData.GetNextValue();
			ramDelay.setup_saved = setup_saved;
			ramDelay.len = len;
			if (!(isReadA.GetValue() || isReadB.GetValue()))
				dly_info.push(ramDelay);
		}
	}

	void CReadController::ProduceInputs()
	{
		data_fifo_ren = false;
		std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin();
		bool skip = false;
		for (; p != cbInsts.end(); p++){
			if (!((*p)->IsRunning() && ((*p)->GetReqFeature() == seqNum.GetValue())))
				skip = true;
		}
		if (skip || waitingFeature() || data_fifo_empty){
			if (retq.size() > 0){
				ReturnData *rd = retq.Pop();
				dataBus = (DTYPE *)rd;
				busValid = true;
				isFeature = false;

				DumpVerifyReturnData(rd);

				return;
			}
		}
		else{
			dataBus = data_fifo.front();
			data_fifo.pop();
			data_fifo_ren = true;
			busValid = true;
			isFeature = true;
			/*if (fp && debugLevel <= 1){
				fprintf(fp, "readctrl data_bus");
				for (unsigned i = 0; i < len_mp[dataBus]; i++)
					fprintf(fp, " %d", dataBus[i]);
				fprintf(fp, "\n");
			}*/
			if (fvo){
				unsigned len = len_mp[dataBus];
				if (len == 0){
					printf("zero len %p", dataBus);
					assert(len > 0);
				}
				len_mp.erase(dataBus);
				fprintf(fvo, " 1 1 %d", len);
				for (unsigned i = 0; i < len; i++)
					fprintf(fvo, " %d", dataBus[i]);
				fprintf(fvo, "\n");
			}

		}
	}
}

#include "sim.h"
#include "interface.h"
#include <assert.h>
namespace CloudDesign{
	void CWeightController::Init()
	{
		storages.push_back(&isReadRam);
		storages.push_back(&isWriteRam);
		storages.push_back(&hasMoreData);
		storages.push_back(&readMoreData);
		storages.push_back(&mode);
		//storages.push_back(&dataWidth);
		storages.push_back(&Oaddr);
		storages.push_back(&seqNum);
		storages.push_back(&dropSize);
		storages.push_back(&nextReadAddr);
		storages.push_back(&nextReceiveAddr);
		storages.push_back(&lastAddr);
		storages.push_back(&liveCount);
		storages.push_back(&weight_ram_valid);
		
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->Init();

		busValid = false;
		valid = false;
		dataIdx = 0;
		debugLevel = DEFAULT_DEBUG_LEVEL;
		ResetVerify();
		start_dump = false;

		if (DUMP_VERIFICATION_CTRLWEIGHT){
			char filename[100];
			sprintf(filename, "%s/ctrlweight_input.txt", OUTPUT_DIR);
			fvi = fopen(filename, "wt");
			assert(fvi);
			sprintf(filename, "%s/ctrlweight_output.txt", OUTPUT_DIR);
			fvo = fopen(filename, "wt");
			assert(fvo);
		}
		else
			fvi = fvo = NULL;
	}

	void CWeightController::reset()
	{
		if (busValid){
			delete[]dataBus;
			busValid = false;
		}
		dataIdx = 0;
		weight_ram_request = 0;
		valid = false;
		ResetVerify();
		cbInsts.clear();
	}


	void CWeightController::latch(int num)
	{
		weight_ram_valid = weight_ram_request;
		weight_ram_request = false;
		ResetVerify();
		if (busValid){
			palloc->Free((char *)dataBus);
			//delete[]dataBus;
			busValid = false;
		}
		if (valid){
			valid = false;
			fifo.push(inst);
		}
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->latch(num);
	}

	void CWeightController::DumpState()
	{
		if (!fp)
			return;
		fprintf(fp, "Dump %s seq %d mode %s fifo %d\n", name.c_str(), seqNum.GetValue()
			, mode == MODE_FOUR ? "FOUR" : (mode == MODE_TWO ? "TWO" : "ONE"), fifo.size());
		fprintf(fp, "\tReading %s, writeRam?(%s) , more?(%s), Oaddr %d, data queue %d\n"
			, isReadRam.GetValue() ? "Wram" : "M", isWriteRam.GetValue() ? "Y" : "N"
			, hasMoreData.GetValue()?"Y":"N", Oaddr.GetValue(), data.size());
		fprintf(fp, "\tidx %d, drop %d, nextRA %d, lastA %d\n"
			,dataIdx, dropSize.GetValue(), nextReadAddr.GetValue(), lastAddr.GetValue());
		
	}
	void CWeightController::processInstruction()
	{
		if (hasMoreData.GetValue())
			return;
		if (liveCount.GetValue() > dropSize.GetValue())
			return;
		if (mode.GetValue() != MODE_FOUR && dataIdx != 0)
			return;
		if (fifo.size() == 0)
			return;
		if (data.size() > 0 || busValid)
			return;
		InstructionWeight inst = fifo.front();
		fifo.pop();

		isReadRam = inst.isReadRam;
		isWriteRam = inst.isWriteRam;
		mode = inst.mode;
		Oaddr = inst.Oaddr;
		seqNum = inst.seqNum;
		dropSize = inst.dropSize;
		//if (inst.isReadRam){
			nextReadAddr = 0;
			nextReceiveAddr = 0;
			lastAddr = inst.size;
		//}
		/*else{
			nextReadAddr = inst.Oaddr;
			lastAddr = inst.Oaddr + inst.size;
		}*/
		/*if (inst.mode == MODE_FOUR)
			dataWidth = WEIGHT_DATA_WIDTH * 4;
		else if (inst.mode == MODE_TWO)
			dataWidth = WEIGHT_DATA_WIDTH * 2;
		else
			dataWidth = WEIGHT_DATA_WIDTH;*/
			liveCount = 0;
		hasMoreData = true;
		readMoreData = true;
		totalAdd = totalDec = 0;
		if (fp && debugLevel <=3)
			fprintf(fp, "weightctrl newinst %s %s seq %d, drop %d, Oaddr %d, size %d\n"
			, inst.isReadRam ? "ReadRam" : "", inst.isWriteRam ? "WriteRam" : ""
			, inst.seqNum, inst.dropSize
			, inst.Oaddr, inst.size);
	}

	void CWeightController::convertYoloWeights(DTYPE *buf, char *bufs, int len)
	{
		for (int i = 0; i < len; i ++){
			buf[i] = bufs[i];
		}
	}
	void CWeightController::ResetVerify()
	{
		cwinst_enable		= false;
		weight_ram_enable = false;
		saved_enable = false;
		read_mem = false;
		data_fifo_ren = false;
		data_fifo_wen = false;
		weight_mem_ren = false;
		weight_mem_wen = false;
	}
	void CWeightController::StartDumpVerify(int num)
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump){
			return;
		}
		fprintf(fvi, "%d %d", num + 1, pddr->readReady());
		for (int i = 0; i < BANK_NUM; i++)
			fprintf(fvi, " %d %d %d", cbInsts[i]->IsReadingWeights()
				, cbInsts[i]->GetReqWeight(), cbInsts[i]->IsWeightFull());
		fprintf(fvi, "\n");
		if (valid)
			fprintf(fvi, " 1 %d %d %d %d %d %d %d\n", inst.isReadRam
			, inst.isWriteRam, inst.mode, inst.Oaddr
			, inst.seqNum, inst.dropSize, inst.size);
		else
			fprintf(fvi, " 0\n");
		
#ifdef YOLO
			if (fvi){
				fprintf(fvi, " %d", pddr->GetDDRID());
				if (pddr->DataValid(DDR_DATA_ID)){
					int buf[MAX_LOAD_WIDTH];
					int len = WEIGHT_READ_WIDTH;
					 char bufs[MAX_LOAD_WIDTH * 2];
					 memcpy((char *)bufs, pddr->DelayData(), WEIGHT_READ_WIDTH);
					//convertYoloWeights(buf, bufs, len);

					fprintf(fvi, " %d", WEIGHT_READ_WIDTH);
					for (int i = 0; i < WEIGHT_READ_WIDTH; i++)
						fprintf(fvi, " %d", bufs[i]);
					fprintf(fvi, "\n");
				}
				else
					fprintf(fvi, " 0\n");
			}
#endif

		fprintf(fvo, "%d %d %d %d %d", num, data.size() == 0, data_fifo_full, dataIdx, this->IsStopable());
	}
	void CWeightController::FinishDumpVerify()
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump)
			return;

		fprintf(fvo, " %d %d %d %d %d %d %d\n", weight_ram_enable
			, DDR_DATA_ID, Oaddr.GetValue() + nextReadAddr.GetValue()
			, busValid, seqNum.GetValue(), hasMoreData.GetValue()
			, nextReadAddr.GetValue());
		fprintf(fvo, " %d %d %d %d %d %d\n", saved_enable, read_mem
			, busValid, data_fifo_wen, weight_mem_ren, weight_mem_wen);
		
		if (busValid){
			if (mode == MODE_FOUR){
				dataWidth = WEIGHT_DATA_WIDTH * 4;
			}
			else if (mode == MODE_TWO){
				dataWidth = WEIGHT_DATA_WIDTH * 2;
			}
			else{
				dataWidth = WEIGHT_DATA_WIDTH;
			}
			fprintf(fvo, " %d", dataWidth);
			for (unsigned i = 0; i < dataWidth; i++)
				fprintf(fvo, " %d", dataBus[i]);
			fprintf(fvo, "\n");
		}
	}
	
	void CWeightController::progress(int num)
	{
		data_fifo_full = Full(3);
		StartDumpVerify(num);
		ProduceWeights();
		ReadWeights(num);
		ReceiveWeights(num);
		AskWeights(num);
		processInstruction();

		int cnt;
		if (!read_mem)
			cnt = 0;
		else if (mode == MODE_FOUR)
			cnt = 1;
		else if (mode == MODE_TWO)
			cnt = 2;
		else
			cnt = 4;
		int cnt1 = busValid ? 1 : 0;
		if (!liveCount.IsSetted()){
			liveCount = liveCount.GetValue() + cnt - cnt1;
			totalAdd += cnt;
			totalDec += cnt1;
		}
		//if (fp && debugLevel <= 1)
		//	fprintf(fp, "weightctrl next ivecount %d ( %d , %d )\n", liveCount.GetNextValue(), totalAdd, totalDec);

		FinishDumpVerify();
	}

	void CWeightController::ReadWeights(int num)
	{
		int pos;
		bool data_valid = false;
		if (mode == MODE_FOUR){
			dataWidth = WEIGHT_DATA_WIDTH * 4;
			pos = 0;
		}
		else if (mode == MODE_TWO){
			dataWidth = WEIGHT_DATA_WIDTH * 2;
			pos = WEIGHT_DATA_WIDTH * 2;
		}
		else{
			dataWidth = WEIGHT_DATA_WIDTH;
			pos = WEIGHT_DATA_WIDTH * dataIdx;
		}
		if (mode.GetValue() != MODE_FOUR && dataIdx != 0){
			saved_enable = true;
			data_fifo_wen = true;
			DTYPE *buf0 = (DTYPE*)palloc->Alloc(); //new DTYPE[dataWidth.GetValue()];
			memcpy(buf0, saveData + pos, sizeof(buf0[0]) * dataWidth);
			assert(!Full());
			data.push(buf0);
			if (mode.GetValue() == MODE_TWO || dataIdx == 3 || !hasMoreData.GetValue() && dataIdx + 1 == dropSize.GetValue()){
				dataIdx = 0;
				palloc->Free((char *)saveData);
				//delete[]saveData;
			}
			else
				dataIdx++;
		}
		else if (!inputs_data.empty()){
			data_fifo_wen = true;
			DTYPE *buf = inputs_data.front();
			int len = WEIGHT_READ_WIDTH;
			inputs_data.pop();
			if (isWriteRam.GetValue()){
				weight_mem_wen = true;
				ramw->Write(nextReceiveAddr.GetValue(), len, buf);
			}
			if (fp && debugLevel <= 1)
				fprintf(fp, "weightctrl pop %d, %d (%d) data, livecount %d, (%d, %d, %d, %d)"
				, len, Oaddr.GetValue(), nextReceiveAddr.GetValue(), liveCount.GetValue(), buf[0], buf[1], buf[2], buf[3]);
			nextReceiveAddr += WEIGHT_READ_WIDTH;
			if (nextReceiveAddr.GetNextValue() >= lastAddr.GetValue())
				hasMoreData = false;

			if (!hasMoreData.GetNextValue() && fp)
				fprintf(fp, "%d : weightctrl done\n", num);
			if (fp && debugLevel <=1)
				fprintf(fp, ", "DFMT", "DFMT"\n", buf[0], buf[1]);
			data.push(buf);
			if (mode.GetValue() == MODE_FOUR || !hasMoreData.GetNextValue() && dropSize == 1) {
				//data.push(buf);
			}
			else{
				dataIdx = 1;
				DTYPE *buf0 = (DTYPE*)palloc->Alloc(); //new DTYPE[dataWidth.GetValue()];
				memcpy(buf0, buf, sizeof(buf0[0]) * WEIGHT_READ_WIDTH);
				//data.push(buf);
				saveData = buf0;
			}
		}
	}

	void CWeightController::ReceiveWeights(int num)
	{
		int len = WEIGHT_READ_WIDTH;
		if (weight_ram_valid.GetValue()){
			DTYPE *buf = (DTYPE*)palloc->Alloc();
			ramw->Load(buf, ram_addr, ram_len);
			inputs_data.push(buf);
			//input_data_wen = true;
		}
		else if (pddr->DataValid(DDR_DATA_ID)){
			DTYPE *buf = (DTYPE*)palloc->Alloc();
#ifdef YOLO
			char bufs[MAX_LOAD_WIDTH];
			memcpy(bufs, pddr->DelayData(), MAX_LOAD_WIDTH);
			convertYoloWeights(buf, bufs, len);
			if (fp && debugLevel <= 1){
				fprintf(fp, "weightctrl received data %d %d %d %d\n", bufs[0], bufs[1], bufs[21], bufs[22]);
				//for(int i = 0; i < len * 3 /2 ; i++)
				//	fprintf(fp, " %d", bufs[i]);
				fprintf(fp, "\nweightctrl received data(w) ");
				for (int i = 0; i < len; i++)
					fprintf(fp, " %d", buf[i]);
				fprintf(fp, "\n");
			}

#else
			memcpy((unsigned char *)buf, pddr->DelayData(), MAX_LOAD_WIDTH * sizeof(DTYPE));
			if (fp && debugLevel <= 1)
				fprintf(fp, "weightctrl receive data\n");
#endif
			inputs_data.push(buf);
		}
	}
	void CWeightController::AskWeights(int num)
	{
		int cnt;
		if (mode == MODE_FOUR){
			cnt = 1;
		}
		else if (mode == MODE_TWO){
			cnt = 2;
		}
		else{
			cnt = 4;
		}
		if (!isReadRam.GetValue() && !pddr->readReady())
			return;
		if (liveCount.GetValue() + cnt <= MAX_CTRL_BUF_SIZE && readMoreData.GetValue()){
			read_mem = true;
			//DTYPE *buf = (DTYPE*)palloc->Alloc(); //new DTYPE[WEIGHT_READ_WIDTH];
			int len = WEIGHT_READ_WIDTH;
			if (fp && debugLevel <= 1)
				fprintf(fp, "weightctrl read %d, %d (%d) data, livecount %d\n", len, Oaddr.GetValue(), nextReadAddr.GetValue(), liveCount.GetValue());
			if (isReadRam.GetValue()){
				weight_mem_ren = true;
				//ramw->Load(buf, nextReadAddr.GetValue(), len);
				//dlyNumber = num + 2;

				weight_ram_request = true;
				ram_addr = nextReadAddr.GetValue();
				ram_len = len;
			}
			else{
				
#ifdef YOLO
				//unsigned char bufs[MAX_LOAD_WIDTH * 2];
				assert((len & 1) == 0);
				pddr->DelayLoad(DDR_DATA_ID, (Oaddr.GetValue() + nextReadAddr.GetValue()), len );
				//convertYoloWeights(buf, bufs, len);
				weight_ram_enable = true;
				//if (fvi){
				//	dly_num_v.push(dlyNumber-1);
				//	dly_data_v.push(buf);
				//}
	
#else
				pddr->DelayLoad(DDR_DATA_ID, (Oaddr.GetValue() + nextReadAddr.GetValue() *sizeof(DTYPE))
					, len * sizeof(DTYPE));
#endif
			}
			nextReadAddr += WEIGHT_READ_WIDTH;
			if (nextReadAddr.GetNextValue() >= lastAddr.GetValue())
				readMoreData = false;
			
			if (!readMoreData.GetNextValue() && fp)
				fprintf(fp, "%d : weightctrl read done\n", num);
		}
		
	}


	void CWeightController::ProduceWeights()
	{
		std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin();
		bool skip = true;
		for (; p != cbInsts.end(); p++){
			if ((*p)->IsReadingWeights() && ((*p)->GetReqWeight() == seqNum.GetValue()))
				if ((*p)->IsWeightFull()){
					skip = true;
					break;
				}
				else{
					skip = false;
				}
		}
		if (skip)
			return;
		/*for (p = cbInsts.begin(); p != cbInsts.end(); p++)
			if ((*p)->IsRunning() && ((*p)->GetWorkingSeq() == seqNum.GetValue() &&
				(!(*p)->IsReadingWeights()))){
				if (fp && debugLevel <=1)
					fprintf(fp, "weightctrl return\n");
				return;
			}*/
		if (data.size() > 0){
			dataBus = data.front();
			data.pop();
			busValid = true;
		}
	}
}

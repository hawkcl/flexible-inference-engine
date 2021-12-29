#include "sim.h"
#include "interface.h"
#include <assert.h>
namespace CloudDesign{
	void CGlobalInstructionBuffer::Init(){
		debugLevel = DEFAULT_DEBUG_LEVEL;
		storages.push_back(&fetchMore);
		//storages.push_back(&outValid);
		storages.push_back(&addressValid);
		storages.push_back(&address);
		storages.push_back(&endValid);
		/*storages.push_back(&gstate);
		storages.push_back(&inst);
		storages.push_back(&curX);
		storages.push_back(&curY);
		storages.push_back(&curH);
		storages.push_back(&newWctrl);
		storages.push_back(&curSeq);
		storages.push_back(&curW);*/
#ifdef BATCH1_OPTIMIZE
		storages.push_back(&b15);
		storages.push_back(&b12);
		storages.push_back(&H1);
#endif
		storages.push_back(&readLen);
		storages.push_back(&requestLen);
		storages.push_back(&maxLen);
		storages.push_back(&type);
		storages.push_back(&processEnd);
		storages.push_back(&pendingRequest);
		storages.push_back(&stopRequest);

		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->Init();

		addressValid = false;
		endValid = false;
		fetchMore = false;
		start_dump = false;

		if (DUMP_VERIFICATION_GIB){
			char filename[100];
			sprintf(filename, "%s/gib_input.txt", OUTPUT_DIR);
			fvi = fopen(filename, "wt");
			assert(fvi);
			sprintf(filename, "%s/gib_output.txt", OUTPUT_DIR);
			fvo = fopen(filename, "wt");
			assert(fvo);
		}
		else
			fvi = fvo = NULL;
		//outValid = false;
		//newWctrl.SetSkipCheck();
		//gstate = GIB_IDLE;

	}
	void CGlobalInstructionBuffer::reset() 
	{
		while (!fifo.empty()) fifo.pop();
		addressValid = false;
		endValid = false;
		fetchMore = false;
		//outValid = false;
	}
	void CGlobalInstructionBuffer::latch(int num)
	{
		std::vector<CSimNode *>::const_iterator p = storages.begin();
		for (; p != storages.end(); p++)
			(*p)->latch(num);
	}
	void CGlobalInstructionBuffer::DumpState()
	{
		if (!fp)
			return;
		fprintf(fp, "Dump %s, address %d(%s), fetch?(%s), processEnd?(%s), endValid?(%s) %d\n"
			, name.c_str(), address.GetValue(), addressValid.GetValue() ? "Y" : "N"
			, fetchMore.GetValue() ? "Y" : "N"
			, processEnd.GetValue() ? "Y" : "N", endValid.GetValue() ? "Y" : "N", endInst.reqSeqNum);
		fprintf(fp, "\tend fifo %d, pendingrequest %s\n"
			, fifo.size(), pendingRequest.GetValue() ? "Y" : "N");
		fprintf(fp, "\treadLen %d, maxLen %d\n"
			, readLen.GetValue(), maxLen.GetValue());
	}
#ifdef BATCH1_OPTIMIZE
	void CGlobalInstructionBuffer::GetBatchSize(int h, int &b1)
	{
		b1 = h / 3;
		if (h > b1 * 3)
			b1++;
	}
#endif
	
	void CGlobalInstructionBuffer::StartDumpVerify(int num)
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump){
			if (adrBuf->Size() == 0)
				return;
			start_dump = true;
		}
		fprintf(fvi, "%d %d %d %d %d %d %d %d %d", num + 1
			, rama->GetFinishedSeq(), ramb->GetFinishedSeq(), pcwrite->GetFinishedSeq()
			, adrBuf->Size() == 0, adrBuf->Size()? adrBuf->Top():0
			, pcread->busValid, pcread->isFeature, pcread->RequestGIBValid());
		for (int i = 0; i < BANK_NUM; i++)
			fprintf(fvi, " %d", cbInsts[i]->IBFull());
		fprintf(fvi, " %d %d\n", pcread->InstFull(), pcweight->InstFull());
		for (int i = 0; i < BANK_NUM; i++)
			fprintf(fvi, " %d", cbInsts[i]->IsStopable());
		fprintf(fvi, " %d %d %d\n", pcread->IsStopable(), pcweight->IsStopable(), pcwrite->IsStopable());
		if (pcread->busValid && !pcread->isFeature){
			ReturnData * data = (ReturnData *)pcread->dataBus;
			fprintf(fvi, " %d %d %d %d", data->seq, data->len, data->token, data->type);
			if (data->type != TYPE_GIB){
				fprintf(fvi, " %d", data->len);
				for (unsigned i = 0; i < data->len; i++)
					fprintf(fvi, " %d", data->data[i]);
			}
			else {
				int clen = data->len;
				fprintf(fvi, " %d", clen);
				unsigned char *pdata = (unsigned char *)data->data;
				for (int i = 0; i < clen; i++)
					fprintf(fvi, " %d", pdata[i]);
				
			}
			fprintf(fvi, "\n");
		}
		addressBuffer_ren = false;
		pif_AddOutput = false;
		reqGIBValid = false;
		send_inst = false;
		fprintf(fvo, "%d", num);
	}
	void CGlobalInstructionBuffer::FinishDumpVerify()
	{
		if (!fvi || !fvo)
			return;
		if (!start_dump)
			return;
		if (!reqGIBValid && !send_inst)
			fprintf(fvo, " 0 none\n");

		fprintf(fvo, " %d %d %d %d %d %d %d %d %d %d %d\n", addressBuffer_ren
			, address.GetValue(), addressValid.GetValue(), fetchMore.GetValue()
			, endValid.GetValue(), readLen.GetValue()/4, maxLen.GetValue()
			, type.GetValue(), pendingRequest.GetValue(), send_inst
			, endInst.reqSeqNum);
	}

	void CGlobalInstructionBuffer::dumpReqGIB(RequestItem &ri)
	{
		reqGIBValid = true;
		if (!fvo)
			return;
		fprintf(fvo, " 1 %d %d %d %d %d %d %d none\n"
			, ri.addr
			, ri.seq
			, ri.len
			, ri.token
			, ri.type
			, ri.isRamA
			, ri.isRamB);
	}
	
	void CGlobalInstructionBuffer::dumpWeight(InstructionWeight &inst)
	{
		if (fvo)
			fprintf(fvo, " weight %d %d %d %d %d %d %d\n", inst.isReadRam
			, inst.isWriteRam, inst.mode, inst.Oaddr
			, inst.seqNum, inst.dropSize, inst.size);
	}
	void CGlobalInstructionBuffer::dumpRead(InstructionRead &inst)
	{
		if (fvo){
			fprintf(fvo, " read  %d %d %d %d %d %d"
				, inst.mode, inst.reqSeqNum, inst.reqProgress
				, inst.seqNum, inst.W, inst.H);
			fprintf(fvo, " %d %d %d %d %d %d"
				, inst.C, inst.Maddr, inst.W1
				, inst.W2, inst.H1, inst.X);
			fprintf(fvo, " %d %d %d %d %d %d %d\n", inst.Y
				, inst.S, inst.lPad, inst.rPad
				, inst.isMaddr_a, inst.isMaddr_b, inst.isRes_a);
		}
	}

	void CGlobalInstructionBuffer::dumpWrite(InstructionWrite &inst)
	{
		if (fvo)
			fprintf(fvo, "  write %d %d %d %d %d %d %d %d %d %d\n", inst.mode
			, inst.dataWidth, inst.dataWidth2, inst.Oaddr
			, inst.outH1, inst.isUpsample, inst.isMaddr_a
			, inst.isMaddr_b, inst.maxpool_stride, inst.maxpool_size);
	}
	void CGlobalInstructionBuffer::dumpHCB(InstructionHCB &inst)
	{
		if (fvo){
			fprintf(fvo, " hcb" );
			fprintf(fvo, " %d %d %d %d %d %d %d %d\n", inst.Id, inst.type
				, inst.reqSeqNum, inst.reqProgress, inst.reqSeqNumW
				, inst.reqProgressW, inst.seqNum, inst.W);

			fprintf(fvo, " %d %d %d %d %d %d %d %d\n", inst.H, inst.C
				, inst.Waddr, inst.WEnd, inst.weightPos
				, inst.ReadPos, inst.ResPos, inst.W1);
			fprintf(fvo, " %d %d %d %d %d %d %d %d\n", inst.H1, inst.X
				, inst.Y, inst.S, inst.lPad
				, inst.rPad, inst.K, inst.M);
			fprintf(fvo, " %d %d %d %d %d %d %d\n", inst.Kh, inst.Ks
				, inst.Kt, inst.Res_addr, inst.wScale
				, inst.fScale, inst.wLRelu);
			fprintf(fvo, " %d %d %d %d %d %d %d\n", inst.weightToken, inst.maxpool_size
				, inst.maxpool_stride, inst.mode, inst.isResMaster
				, inst.isProgressMaster, inst.isRaddr_a);
			fprintf(fvo, " %d %d %d %d %d %d %d %d\n", inst.doRes, inst.doRelu
				, inst.doLRelu, inst.doBM, inst.doUpSample
				, inst.newWriteInst, inst.outbufsize, inst.ofsize);
			fprintf(fvo, " %d %d %d %d %d %d %d %d\n", inst.outyx, inst.outputAddrGap
				, inst.outkh, inst.ng, inst.gu
				, inst.resSize, inst.resSizeLast, inst.resLen);
			fprintf(fvo, " %d %d %d %d %d %d %d %d", inst.resLenLast, inst.pfs
				, inst.volumeSize, inst.kCurLast, inst.wtotal_n
				, inst.wtotalLast, inst.wlenk_regular, inst.wlenk_nLast);
			fprintf(fvo, " %d %d\n", inst.wlenk_nLast2, inst.totalRes);
		}
	}

	void CGlobalInstructionBuffer::processEndInst()
	{
		if (endValid == false){
			//if (outValid.GetValue())
			//	return; // need to reset outValid for us to process next end
			if (fifo.size() == 0)
				return;
			endInst = fifo.front();
			fifo.pop();
			endValid = true;


			if (fp && debugLevel <= 3)
				fprintf(fp, "\tGIB pop end instruction %u\n", endInst.reqSeqNum);
			return;
		}

		unsigned seq;
		if (endInst.isRamA)
			seq = this->rama->GetFinishedSeq();
		else if ((endInst.isRamB))
			seq = this->ramb->GetFinishedSeq();
		else
			seq = pcwrite->GetFinishedSeq();
		if (seq >= endInst.reqSeqNum){
			endValid = false;
			//outValid = true;
			pif->AddOutput(endInst.oAddr, endInst.oSize);
			pif_AddOutput = true;
			if (fvo)
				fprintf(fvo, " 1 %d %d", endInst.oAddr, endInst.oSize);
			if (!endInst.hasMore)
				processEnd = true; // not used
			if (fp && debugLevel <= 3)
				fprintf(fp, "\tGIB end instruction %u done!", endInst.reqSeqNum);
		}
	}

	void CGlobalInstructionBuffer::processStopRequest()
	{
		if (stopRequest.GetValue()){
			std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin();
			for (; p != cbInsts.end(); p++)
				if (!(*p)->IsStopable()){
					if (fp && debugLevel <= 3)
						fprintf(fp, "\tGIB stop by %s\n", (*p)->GetName().c_str());
					return;
				}
			if (!pcread->IsStopable()){
				if (fp && debugLevel <= 3)
					fprintf(fp, "\tGIB stop readctrl\n");
				return;
			}
			if (!pcweight->IsStopable()){
				if (fp && debugLevel <= 3)
					fprintf(fp, "\tGIB stop weightctrl\n");
				return;
			}
			if (!pcwrite->IsStopable()){
				if (fp && debugLevel <= 3)
					fprintf(fp, "\tGIB stop writectrl\n");
				return;
			}
			for (int i = 0; i < BANK_NUM; i++)
					(cbInsts[i])->SetStop();

			stopRequest = false;
			if (fp && debugLevel <= 3)
				fprintf(fp, "\tGIB stop end\n");
		}
	}
	void CGlobalInstructionBuffer::progress(int num)
	{
		//processInst();
		//processConvInst();
		//processPoolInst();
		StartDumpVerify(num);
		processEndInst();
		if (fvo && start_dump){
			if (!pif_AddOutput)
				fprintf(fvo, " 0");
			
		}
		ReadInstruction(num);
		processStopRequest();
		FinishDumpVerify();
	}


	void CGlobalInstructionBuffer::DecodeInstruction(int num)
	{
		if (fvo){
			fprintf(fvo, " 0");
			send_inst = true;
		}
	
		switch (type.GetValue()) {
		case OPTIONS:
		{
			InstructionOption pi;
			UnPackInstructionOption(instBuf + 4, &pi);
			if (pi.start){
				for (int i = 0; i < BANK_NUM; i++)
					(cbInsts[i])->SetStart();
				if (fvo)
					fprintf(fvo, " start\n");
				if (fp && debugLevel <= 3)
					fprintf(fp, "\tGIB Start\n");
			}
			if (pi.stop){
				stopRequest = true;
				//for (int i = 0; i < BANK_NUM; i++)
				//	(cbInsts[i])->SetStop();
				if (fvo)
					fprintf(fvo, " stop\n");
				if (fp && debugLevel <= 3)
					fprintf(fp, "\tGIB stop\n");
			}
			//ptoken->SetMaxVal(pi->weight_token_max);
			break;
		}
		case MEM:
		{
			assert(0);
			InstructionMem *pi = (InstructionMem *)(instBuf + 4);
			if (pi->isRamA)
				this->rama->PushInst(*pi);
			else
				this->ramb->PushInst(*pi);
			if (fp && debugLevel <= 3)
				fprintf(fp, "\tGIB push MEM\n");
			break;
		}
		case LOADWEIGHT:
		{
			InstructionWeight pi;
			UnPackInstructionWeight(instBuf + 4, &pi);
			this->pcweight->PushInst(pi);
			dumpWeight(pi);
			if (fp && debugLevel <= 3)
				fprintf(fp, "\tGIB push LOADWEIGHT\n");
			break;
		}
		case HCB:
		{
			InstructionHCB pi;
			UnPackInstructionHCB(instBuf + 4, &pi);
			dumpHCB(pi);
			(cbInsts[pi.Id])->PushInst(num, pi);
			
			if (fp && debugLevel <= 3)
				fprintf(fp, "\tGIB push HCB%d\n", pi.Id);
			break;
		}
		case CREAD:
		{
			InstructionRead pi;
			UnPackInstructionRead(instBuf + 4, &pi);
			pcread->PushInst(pi);
			dumpRead(pi);
			break;
		}
		case CWRITE:
		{
			InstructionWrite pi;
			UnPackInstructionWrite(instBuf + 4, &pi);
			pcwrite->PushInst(pi);
			dumpWrite(pi);
			break;
		}
		case POOL:
		case CONV:
		{
			assert(false);
			/*Instruction *pi = (Instruction *)(instBuf + 1);
			instFifo.push(*pi);
			if (fp && debugLevel <= 3)
				fprintf(fp, "\tGIB push CONV/POOL\n");*/
			break;
		}
		case END:
		{
			InstructionEnd pi;
			UnPackInstructionEnd(instBuf + 4, &pi);
			fifo.push(pi);
			if (fvo)
				fprintf(fvo, " end\n");
			if (!pi.hasMore)
				addressValid = false;
			if (fp && debugLevel <= 3)
				fprintf(fp, "\tGIB push END\n");
			break;
		}

		}
	}
	void CGlobalInstructionBuffer::ReadInstruction(int num)
	{
		if (!addressValid.GetValue()){
			ADDR_TYPE adr;
			if (adrBuf->Pop(adr)){
				addressValid = true;
				addressBuffer_ren = true;
				address = adr;
				if (fp && debugLevel <= 3)
					fprintf(fp, "\tGIB instruction address %d\n", adr);
			}
			return;
		}//else 
		if (pendingRequest.GetValue()){
			bool data_received = true;
			if (!pcread->busValid || pcread->isFeature)
				data_received = false;
			ReturnData * data = (ReturnData *)pcread->dataBus;
			if (data_received && data->type != TYPE_GIB)
				data_received = false;
			if (data_received){
                if (fp && debugLevel <= 1)
					fprintf(fp, "\tGIB receive %d data (%d %d %d %d)\n"
					, data->len, data->data[0] & 0xff, (data->data[0] >> 8) & 0xff
					, (data->data[0] >> 16) & 0xff, (data->data[0] >> 24) & 0xff);
				if (readLen == 0){
					type = InstructionType(*((char *)data->data));
					int len;
					switch (type.GetNextValue()) {
					case OPTIONS: len = InstructionOptionLength; break;
					case MEM: len = sizeof(InstructionMem); break;
					case LOADWEIGHT: len = InstructionWeightLength; break;
					case HCB: len = InstructionHCBLength; break;
					case CREAD: len = InstructionReadLength; break;
					case CWRITE: len = InstructionWriteLength; break;
					case POOL:
					case CONV: len = sizeof(Instruction); break;
					case END: len = InstructionEndLength; break;
					default:
							printf("type %d not recognized\n", type.GetNextValue());
							assert(0);
					}
					if (len % 4)
						len += (4 - len % 4);
					maxLen = len + 4;
					assert(data->len == 4);
				}
				memcpy(instBuf + readLen.GetValue(), data->data, data->len);
				readLen += data->len;
				if (readLen.GetNextValue() == maxLen.GetValue()){
					DecodeInstruction(num);
					pendingRequest = false;
					fetchMore = false;
				}
			}
			if (data_received || readLen.GetValue() != 0)
				if (requestLen.GetValue() < maxLen.GetNextValue() && !pcread->RequestGIBValid())
			{
				int len = BRAM_BUS_WIDTH;// *SZ_DTYPE;
				if (requestLen.GetValue() + len > maxLen.GetNextValue()){
					len = maxLen.GetNextValue() - requestLen.GetValue();
				}
				RequestItem ri;
				ri.addr = address.GetValue();
				ri.isRamA = false;
				ri.isRamB = false;
				ri.seq = 0;
				ri.len = len;
				ri.token = 0;
				ri.type = TYPE_GIB;
				pcread->RequestGIB(ri);
				address += len;
				requestLen = requestLen.GetValue() + len;
				dumpReqGIB(ri);
				

			}
		}
		else{ //make sure addressValid 
			if (fetchMore.GetValue()){
				RequestItem ri;
				ri.addr = address.GetValue();
				ri.isRamA = false;
				ri.isRamB = false;
				ri.seq = 0;
				ri.len = 4;
				ri.token = 0;
				ri.type = TYPE_GIB;
				pcread->RequestGIB(ri);
				pendingRequest = true;
				address += 4;
				readLen = 0;
				requestLen = 4;
				dumpReqGIB(ri);
				if (fp && debugLevel <= 1)
					fprintf(fp, "\tGIB new instruction request addr %d \n", ri.addr);
			} else {
				if (stopRequest.GetValue())
					return;
				std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin();
				for (; p != cbInsts.end(); p++)
					if ((*p)->IBFull())
						return;
				//if (pcread->InstFull() || pcweight->InstFull())
				//	return;
				fetchMore = true;
				if (fp && debugLevel <= 1)
					fprintf(fp, "\tGIB IB size %d %d %d %d\n", cbInsts[0]->GetIBSize()
					, cbInsts[1]->GetIBSize(), cbInsts[2]->GetIBSize(), cbInsts[3]->GetIBSize());
			}
			
		}
	}

	
}
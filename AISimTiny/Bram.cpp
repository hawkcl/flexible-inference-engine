#include "sim.h"
#include <assert.h>

namespace CloudDesign{

	void CBRAM::Write(int adr, int len, DTYPE *data, bool rightnow)
	{
		if (rightnow){
			assert(len + adr <= size);
			memcpy(buf + adr, data, len * sizeof(DTYPE));
		}
		else{
			assert(len + adr <= size);
			assert(!wrValid);
			wrValid = true;
			wrAddr = adr;
			wrLen = len;
			memcpy(wrtmp, data, len * sizeof(DTYPE));
		}
		//memcpy(buf + adr, data, len * sizeof(DTYPE));
	}

	void CBRAM::reset()
	{
		while (fifo.size() > 0)
			fifo.pop();
		valid = false;
		ioValid = false;
		isReading = false;
		isWriting = false;
		progressNum = 0;
		wrValid = false;
		size = 0;
		delete[]buf;
		cbInsts.clear();
	}

	bool CBRAM::IsReadingFeatures()
	{
		std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin();
		for (; p != cbInsts.end(); p++)
			if ((*p)->IsReadingFeatures())
				return true;
		return false;
	}
	void CBRAM::DumpState()
	{
		if (!fp)
			return;
		fprintf(fp, "Dump for %s\n", name.c_str());
		fprintf(fp, "\tdataLen %d, finish %d, working %d, progress %d\n", dataLen, finishSeq, workingSeq, progressNum);
		fprintf(fp, "\tinstQueue %d, IO?(%s)\n", fifo.size(), ioValid?"Y":"N");
		if (isReading){
			fprintf(fp, "\tread idx %d", idx);
			for (int i = 0; i < BANK_NUM; i++)
				fprintf(fp, " %d(%s)", segPos[i], ioDone[i]?"Done":"");
			fprintf(fp, "\n");
		}
		else if (isWriting)
			fprintf(fp, "\twrite len %d\n", ioLen);


		
	}

	void CBRAM::latch(int num)
	{
		if (wrValid){
			wrValid = false;
			assert(!isReading);
			memcpy(buf + wrAddr, wrtmp, wrLen * sizeof(DTYPE));
			std::vector<CHomoGeneousComputingBank*>::const_iterator p = cbInsts.begin();
			for (; p != cbInsts.end(); p++)
				if ((*p)->IsProgressMaster()){
					finishSeq = (*p)->GetFinishedSeq();
					workingSeq = (*p)->GetWorkingSeq();
					progressNum = (*p)->GetWorkingProgress();
				}
		}
		dataLen = 0;
		if (valid){
			//assert(fifo.size() < ADDRESS_FIFOSIZE);
			fifo.push(inst);
			valid = false;
		}
		if (isReading){
			int len = BRAM_LOAD_SIZE;

			if (segPos[idx] + len / sizeof(DTYPE) >= ioInst.segments[idx + 1]){
				len = sizeof(DTYPE) * (ioInst.segments[idx + 1] - segPos[idx]);
				ioDone[idx] = true;
			}

			memcpy(buf + ioInst.Maddr + segPos[idx],
				(void *)(ioInst.Oaddr + segPos[idx] * sizeof(DTYPE)), len);
			segPos[idx] += len / sizeof(DTYPE);
			progressNum += len / sizeof(DTYPE);
			idx++;
			if (idx >= idxSize)
				idx = 0;

			int i;
			for (i = 0; i < BANK_NUM; i++){
				if (!ioDone[i])
					break;
			}
			if (i == BANK_NUM){
				isReading = false;
				finishSeq = ioInst.seqNum;
			}

			if (fp && debugLevel <=1)
				fprintf(fp, "\t%s read %d %s\n", name.c_str(), len / sizeof(DTYPE), isReading ? "" : "END");

			return;
		}
		if (isWriting){
			int len = BRAM_LOAD_SIZE;
			if (ioLen + len / sizeof(DTYPE) >= ioInst.len){
				len = sizeof(DTYPE) * (ioInst.len - ioLen);
				isWriting = false;
				finishSeq = ioInst.seqNum;
			}

			memcpy((void *)(ioInst.Oaddr + ioLen * sizeof(DTYPE)),
				buf + ioInst.Maddr + ioLen, len);
			ioLen += len / sizeof(DTYPE);
			if (fp && debugLevel <=1)
				fprintf(fp, "\t%s write %d %s\n", name.c_str(), ioLen, isWriting ? "" : "END");
			return;
		}

		if (!ioValid){
			if (fifo.size() == 0)
				return;
			ioInst = fifo.front();
			fifo.pop();
			ioValid = true;
		}

		if ((*cbInsts.begin())->GetFinishedSeq() < ioInst.reqSeqNum)
			return;
		if (ioInst.isRead){
			if (ioInst.isFast == 1){
				int len = sizeof(DTYPE) * (ioInst.len);
				finishSeq = ioInst.seqNum;
				memcpy(buf + ioInst.Maddr, (void *)(ioInst.Oaddr), len);
				ioLen = ioInst.len;
				progressNum = ioLen;
			}
			else{
				isReading = true;
				for (int i = 0; i < BANK_NUM; i++){
					segPos[i] = ioInst.segments[i];
					if (ioInst.segments[i + 1] == 0)
						ioDone[i] = true;
					else
						ioDone[i] = false;
				}
				ioValid = false;
				idx = 0;
				workingSeq = ioInst.seqNum;
				progressNum = 0;
				for (idxSize = 1; idxSize < BANK_NUM; idxSize++) // sum of reduced or
					if (ioInst.segments[idxSize + 1] == 0)
						break;
				if (fp && debugLevel <=3)
					fprintf(fp, "\t%s start read req %d, seq %d, Ma %d, Oa %d, seg (%d, %d, %d, %d), done?(%s %s %s %s)\n"
					, name.c_str(), ioInst.reqSeqNum, ioInst.seqNum, ioInst.Maddr, ioInst.Oaddr
					, ioInst.segments[0], ioInst.segments[1], ioInst.segments[2], ioInst.segments[3]
					, ioDone[0] ? "Y" : "N", ioDone[1] ? "Y" : "N", ioDone[2] ? "Y" : "N", ioDone[3] ? "Y" : "N");
				//memcpy(buf + ioInst.Maddr, (void *)ioInst.Oaddr, sizeof(DTYPE) * ioInst.H);
			}
		}
		else if (!ioInst.isRead){
			isWriting = true;
			ioLen = 0;
			ioValid = false;
			workingSeq = ioInst.seqNum;
			//memcpy((void *)ioInst.Oaddr, buf + ioInst.Maddr, sizeof(DTYPE) * ioInst.H);
		}

	}
}

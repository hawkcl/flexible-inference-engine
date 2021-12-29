#include "model.h"
#include <stdio.h>
#include <stdlib.h> 
using namespace CloudDesign;
static DTYPE rn = -100;
DTYPE GetRand() 
{
	/*if (rn < 100)
		rn++;
	else
		rn = -100;
	return rn;*/
	//return rand() % 20 - 10;
	//return rand() % 2;
	//return 1;
	return DTYPE((rand() % 20000 - 10000)/100.0); 
}

void GetBatchNum(int h, int & b15, int &b12, int &b0)
{
	if (h % 16 == 0){
		b0 = 16;
		b12 = b15 = 0;
		return;
	}
	b12 = 0;
	b15 = h / 15;
	b0 = h - 15 * b15;
	while (b0 < 7 && b15 > 0){
		b15--;
		b12++;
		b0 += 3;
	}
}
// order weights interleave across banks in width of WEIGHT_DATA_WIDTH
// the result will be w_bank0[0:7],w_bank1[0:7],w_bank2[0:7],w_bank3[0:7],w_bank0[8:15], ...
DTYPE* transformWeights2(DTYPE *src, CloudDesign::DATA_MODE mode, int *start, int *dropSize, int *wSize)
{
	int i;
	DTYPE *ret = NULL;
	*dropSize = 0;
	if (mode == CloudDesign::MODE_FOUR){
		int size = start[1] - start[0];
		for (i = 1; i < 4; i++)
			if (start[i + 1] - start[i] > size)
				size = start[i + 1] - start[i];
		if (size % WEIGHT_DATA_WIDTH != 0)
			size = (size / WEIGHT_DATA_WIDTH + 1) * WEIGHT_DATA_WIDTH;
		*wSize = 4 * size;
		ret = new DTYPE[*wSize];
		int pos = 0;
		for (int k = 0; k < size; k += WEIGHT_DATA_WIDTH){
			for (int i = 0; i < 4; i++){
				if (k < start[i + 1] - start[i]){
					memcpy(ret + pos, src + start[i] + k, sizeof(src[0]) * WEIGHT_DATA_WIDTH);
				}
				pos += WEIGHT_DATA_WIDTH;
			}
		}

	}
	else if (mode == CloudDesign::MODE_TWO){
		int size = start[1] - start[0];
		if (start[2] - start[1] > size)
			size = start[2] - start[1];
		if (size % WEIGHT_DATA_WIDTH != 0)
			size = (size / WEIGHT_DATA_WIDTH + 1) * WEIGHT_DATA_WIDTH;
		if (((size / WEIGHT_DATA_WIDTH) % 2) == 1)
			*dropSize = 1;
		*wSize = 2 * (size + *dropSize);
		ret = new DTYPE[*wSize];
		int pos = 0;
		for (int k = 0; k < size; k += WEIGHT_DATA_WIDTH){
			for (int i = 0; i < 2; i++){
				if (k < start[i + 1] - start[i]){
					memcpy(ret + pos, src + start[i] + k, sizeof(src[0]) * WEIGHT_DATA_WIDTH);
				}
				pos += WEIGHT_DATA_WIDTH;
			}
		}

	}else{
		int size = start[1] - start[0];
		if (size % WEIGHT_DATA_WIDTH != 0)
			size = (size / WEIGHT_DATA_WIDTH + 1) * WEIGHT_DATA_WIDTH;
		*dropSize = (size / WEIGHT_DATA_WIDTH) % 4;
		if (*dropSize == 0)
			*wSize = size;
		else
			*wSize = size + (4 - *dropSize) * WEIGHT_DATA_WIDTH;
		ret = new DTYPE[*wSize];
		int pos = 0;
		for (int k = 0; k < size; k += WEIGHT_DATA_WIDTH){
			memcpy(ret + pos, src + start[0] + k, sizeof(src[0]) * WEIGHT_DATA_WIDTH);
			pos += WEIGHT_DATA_WIDTH;
		}
	}
	return ret;
}

void transformWeights(DTYPE *dst, int *start, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankSize)
{
	int tmp[2];
	tmp[0] = bankSize;
	int Kh[2];
	int Ks[2];
	int Kt[2];
	transformWeights(dst, start, Kh, Ks, Kt, src, ext, ext_len, M, C, K, 1, tmp);
}
void transformWeights(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankSize1, int bankSize2)
{
	int tmp[2];
	tmp[0] = bankSize1;
	tmp[1] = bankSize2;
	transformWeights(dst, start, Kh, Ks, Kt, src, ext, ext_len, M, C, K, 2, tmp);
}
void transformWeights(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankSize1, int bankSize2, int bankSize3)
{
	int tmp[3];
	tmp[0] = bankSize1;
	tmp[1] = bankSize2;
	tmp[2] = bankSize3;
	transformWeights(dst, start, Kh, Ks, Kt, src, ext, ext_len, M, C, K, 3, tmp);
}
void transformWeights(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankSize1, int bankSize2, int bankSize3, int bankSize4)
{
	int tmp[4];
	tmp[0] = bankSize1;
	tmp[1] = bankSize2;
	tmp[2] = bankSize3;
	tmp[3] = bankSize4;
	transformWeights(dst, start, Kh, Ks, Kt, src, ext, ext_len, M, C, K, 4, tmp);
}
//compute start Kh, Ks, Kt, and move weights belonging to the same bank together in order they are needed
//inside a bank, the weights are ordered first by skip groups (m), then by layers(c), then by computing groups(n)  
void transformWeights(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, DTYPE *src, DTYPE *ext, int ext_len, int M, int C, int K, int bankNum, int *bankSize)
{
	int i, j, m, n;
	int pos = 0;
	for (int k = 0; k < bankNum; k++){
		start[k] = pos;
		Kh[k] = 0;
		for (i = 0; i < k; i++){
			Kh[k] += bankSize[i] / K;
		}
		Ks[k] = 0;
		for (i = 0; i < bankNum; i++)
			if (i != k)
				Ks[k] += bankSize[i] / K;

		int G = bankSize[k] / K;

		for (m = Kh[k];;){
			for (int c = 0; c < C; c++)
				for (n = 0; n < G; n++)
					for (i = 0; i < K; i++)
						for (j = 0; j < K; j++)
							dst[pos++] = src[(m + n)*C*K*K+ c*K*K+ i*K + j];
			if (ext_len > 0){
				for (n = 0; n < G; n++){
					for (i = 0; i < ext_len; i++)
						dst[pos++] = ext[(m+n) * ext_len + i];
				}
			}
			if (m + G + Ks[k] >= M){
				Kt[k] = m + G - 1;
				break;
			}
			m += G + Ks[k];
			if (m + G > M)
				G = M - m;
		}
	}
	start[bankNum] = pos;
}

void transformWeightsBatch(DTYPE *dst, int *start, int *Kh, int *Ks, int *Kt, int *Kbh, int *Kbe, DTYPE *src, int M, int C, int K, int bankNum, int bankSize)
{
	assert(K == 1);
	int G1 = bankSize / K;
	int G2 = bankSize / K / 3;
	int ng1 = M / bankNum / G1;
	int M1 = ng1 * bankNum * G1;
	int M2 = M - M1;
	int ng2 =  M2/ bankNum / G2;
	if (M2 != ng2 * bankNum * G2)
		ng2++;

	if (ng2 == 0)
		Kbh[0] = 0;

	int i, j, m, n;
	int pos = 0;
	for (int k = 0; k < bankNum; k++){
		start[k] = pos;
		Kh[k] = k * G1;
		Ks[k] = (bankNum -1) *G1;
		Kt[k] = Kh[k] + bankNum * G1 * (ng1 -1) + G1 - 1;
		m = Kh[k];
		for (int gg = 0; gg < ng1; gg++){
			for (int c = 0; c < C; c++)
				for (n = 0; n < G1; n++)
					for (i = 0; i < K; i++)
						for (j = 0; j < K; j++)
							dst[pos++] = src[(m + n)*C*K*K + c*K*K + i*K + j];
			if (gg == ng1 - 1)
				break;
			assert(m + G1 + Ks[k] <= M);
			m += G1 + Ks[k];
			assert(m + G1 <= M);
		}
		if (ng2 > 0){
			Kbh[k] = M1 + k * (ng2 * G2);
			Kbe[k] = M1 + (k + 1) * (ng2 * G2) - 1;
			if (Kbe[k] >= M)
				Kbe[k] = M - 1;

			m = Kbh[k];
			for (int gg = 0; gg < ng2; gg++){
				int Gs;
				if (Kbe[k] + 1 - m >= G2)
					Gs = G2;
				else
					Gs = Kbe[k] + 1 - m;
				for (int c = 0; c < C; c++)
					for (n = 0; n < Gs; n++)
						for (i = 0; i < K; i++)
							for (j = 0; j < K; j++)
								dst[pos++] = src[(m + n)*C*K*K + c*K*K + i*K + j];
				m += G2;
			}
		}
	}

}

void CModel::BuildModel(int numBanks, int numCGs)
{
	numBanks = BANK_NUM;
	numCGs = CG_NUM;
	paddrBuf = new CAddrBuffer;
	prama = new CBRAM;
	pramb = new CBRAM;
	pramw = new CBRAM;
	pgib = new CGlobalInstructionBuffer;
	ptkn = new CTokenGen;
	ptknw = new CTokenGen;
	pcwrite = new CWriteController;
	pcread = new CReadController;
	pcweight = new CWeightController;
	palloc = new CAllocAssist<MAX_LOAD_WIDTH * sizeof(DTYPE)>;

	prama->SetName("rama");
	pramb->SetName("ramb");
	pramw->SetName("ramw");
	pgib->SetName("GIB");
	ptkn->SetName("token");
	ptknw->SetName("wtoken");
	pcread->SetName("cread");
	pcweight->SetName("cweight");
	pcwrite->SetName("cwrite");

	pcread->SetAlloc(palloc);
	pcweight->SetAlloc(palloc);
	pcwrite->SetAlloc(palloc);
	paddrBuf->Init();
	prama->Init(BRAM_SIZE, 100);
	pramb->Init(BRAM_SIZE, 100);
	pramw->Init(WEIGHT_SIZE, 100);
	pcwrite->Init();
	pcread->Init();
	pcweight->Init();
	pgib->Init();
	ptkn->Init();
	ptknw->Init();
	operations.push_back(pcweight);
	operations.push_back(pcread);
	operations.push_back(paddrBuf);
	operations.push_back(pgib);
	operations.push_back(ptkn);
	operations.push_back(ptknw);
	
	

	//pread->SetMaxVal(1);
	//pwrite->SetMaxVal(2);
	//pweight->SetMaxVal(2);
	//pext->SetMaxVal(1);
	pgib->SetAddrBuf(paddrBuf);
	pgib->SetRam(prama, pramb, pramw);
	pgib->SetCtrl(pcread, pcwrite, pcweight);
	pgib->SetTokenGen(ptkn);
	pcweight->SetRam(pramw);
	pcread->SetRam(prama, pramb);
	pcwrite->SetRam(prama, pramb);
	for (int i = 0; i < numBanks; i++){
		//banks[i].SetRam(pramw);
		banks[i].SetCtrl(pcread, pcwrite, pcweight);
		banks[i].SetTokenGen(ptkn, ptknw);
		banks[i].SetAlloc(palloc);
		pgib->AddCBIB(banks + i);
		prama->AddCBIB(banks + i);
		pramb->AddCBIB(banks + i);
		pramw->AddCBIB(banks + i);
		pcread->AddCBIB(banks + i);
		pcweight->AddCBIB(banks + i);
		pcwrite->AddCBIB(banks + i);
		if (i % 3 == 2 && numCGs == 15 && numBanks == 12) //full chip
			banks[i].Init(numCGs + 3);
		else
			banks[i].Init(numCGs);
		banks[i].Init();
		operations.push_back(banks + i);
		char tmp[100];
		sprintf(tmp, "bank%d", i);
		banks[i].SetID(i);
		banks[i].SetName(tmp);
	}
	operations.push_back(pcwrite);
	operations.push_back(prama); // latch after pcwrite
	operations.push_back(pramb);
	operations.push_back(pramw);

}

CModel::~CModel()
{
	delete paddrBuf;
	delete prama;
	delete pramb;
	delete pramw;
	delete pgib;
	delete ptkn;

	delete ptknw;
	delete pcread;
	delete pcweight;
	delete pcwrite;
	delete palloc;
}

void CModel::GetWLenKs(unsigned &wlenkInit, unsigned &wlenkLast, unsigned wtotal, unsigned k)
{
	unsigned len;
	if (k == 1)
		len = 8;
	else if (k <= 4)
		len = 2;
	else
		len = 1;
	if (wtotal < len){
		wlenkInit = wtotal * k;
		wlenkLast = 0;
	}
	else{
		wlenkInit = len * k;
		unsigned x = wtotal / len;
		wlenkLast = (wtotal - x * len) *k;
	}
}

int CModel::getTotalFrames(int kh, int ks, int kt, int ng)
{
	int num = 0;
	for (;;){
		int end = kh + ng - 1;
		if (end >= kt){
			return num + kt - kh + 1;
		}
		num += ng;
		kh = end + 1 + ks;
		assert(kh <= kt);
	}
}


void CModel::processInstExt(InstructionHCB &inst)
{
	int outwidth;
	int outheight;
	int outy;
	int outx;

	outwidth = (inst.W - inst.K + inst.lPad + inst.rPad) / inst.S + 1;
	outheight = (inst.H - inst.K + inst.lPad + inst.rPad) / inst.S + 1;
	outx = inst.X / inst.S;
	outy = inst.Y / inst.S;
	if (inst.maxpool_stride == 2){
		outwidth /= 2;
		outheight /= 2;
		outx /= 2;
		outy /= 2;
	}
	if (inst.doUpSample){
		outwidth *= 2;
		outheight *= 2;
		outx *= 2;
		outy *= 2;
	}

	int outbufh1 = ((inst.H1 - inst.K + 1 + inst.lPad + inst.rPad) / inst.S + 1);
	int outbufw1 = ((inst.W1 - inst.K + inst.lPad + inst.rPad) / inst.S + 1);
	inst.outbufsize = outbufh1 * outbufw1;//

	inst.ofsize = outwidth * outheight;//
	inst.outyx = outwidth * outy + outx;//

	inst.outputAddrGap = inst.ofsize * inst.Ks;//
	inst.outkh = inst.ofsize * inst.Kh + inst.outyx;//

	inst.ng = CG_NUM / inst.K;//
	if ((inst.Kt + 1 - inst.Kh) * inst.K < CG_NUM){
		inst.gu = inst.Kt + 1 - inst.Kh;
	}
	else{
		inst.gu = inst.ng;
	}

	int rw = inst.W1;
	if (inst.lPad > 0){
		if (inst.X > 0){
			rw += inst.lPad;
		}
	}
	if (inst.rPad > 0){
		if (inst.X + inst.W1 != inst.W)
			rw += inst.rPad;
	}
	int ys = inst.Y;
	int yl = inst.Y + inst.H1;
	if (inst.lPad > 0){
		if (inst.Y > 0){
			ys -= inst.lPad;
		}
	}
	if (inst.rPad > 0){
		if (inst.Y + inst.H1 + 1 != inst.H)
			yl += inst.rPad;
	}
	inst.pfs = rw * (yl - ys + 1);

	inst.volumeSize = inst.pfs * inst.C;//
	int kn = (inst.Kt - inst.Kh) / (inst.ng + inst.Ks);
	inst.kCurLast = inst.Kh + kn * (inst.ng + inst.Ks);
	unsigned sz = inst.outbufsize * inst.gu;
	unsigned k = sz / (4 * outbufw1);
	inst.resSize = k * 4 * outbufw1;
	if (inst.resSize == sz){
		inst.resSize -= 4 * outbufw1;
		inst.resLen = 4 * outbufw1;
	}
	else{
		inst.resLen = sz - inst.resSize;
		if (inst.doRes)
			assert(inst.resLen == outbufw1 || inst.resLen == outbufw1 * 2 || inst.resLen == outbufw1 * 3);
	}
	sz = inst.outbufsize * (inst.Kt + 1 - inst.kCurLast);
	k = sz / (4 * outbufw1);
	inst.resSizeLast = k * 4 * outbufw1;
	if (inst.resSizeLast == sz){
		inst.resSizeLast -= 4 * outbufw1;
		inst.resLenLast = 4 * outbufw1;
	}
	else{
		inst.resLenLast = sz - inst.resSize;
		if (inst.doRes)
			assert(inst.resLenLast == outbufw1 || inst.resLenLast == outbufw1 * 2 || inst.resLenLast == outbufw1 * 3);
	}

	unsigned wlenk1, wlenk2;
	inst.wtotal_n = inst.ng * inst.K;
	GetWLenKs(wlenk1, wlenk2, inst.wtotal_n, inst.K);
	inst.wlenk_regular = wlenk1;
	inst.wlenk_nLast = wlenk2;
	if (inst.gu == inst.ng){
		unsigned usedGroupsLast = inst.Kt + 1 - inst.kCurLast;
		inst.wtotalLast = usedGroupsLast * inst.K;
		GetWLenKs(wlenk1, wlenk2, inst.wtotalLast, inst.K);
		if (wlenk1 < inst.wlenk_regular){
			inst.wlenk_nLast2 = wlenk1;
			assert(wlenk2 == 0);
		}
		else
			inst.wlenk_nLast2 = wlenk2;
	}
	else{
		inst.wtotalLast = inst.gu * inst.K;
		GetWLenKs(wlenk1, wlenk2, inst.wtotalLast, inst.K);
		inst.wlenk_regular = wlenk1;
		inst.wlenk_nLast2 = wlenk2;
	}
	
	if (inst.doRes)
		inst.totalRes = inst.outbufsize * getTotalFrames(inst.Kh, inst.Ks, inst.Kt, inst.ng);
	else
		inst.totalRes = 0;

	//wtotal_bn = inst.ug_batch;
	//wtotalbLast = inst.ug_batchLast;
#ifdef BATCH1_OPTIMIZE
	inst.outkhb = inst.ofsize * inst.Kbh + inst.outyx;//
	inst.readRowCount3 = (yl - ys + 1) / 3;
	if (inst.readRowCount3 * 3 == yl - ys + 1){
		inst.readRowCount3--;
		inst.lastRowLen3 = rw * 3;
	}
	else
		inst.lastRowLen3 = (yl - ys + 1 - 3 * inst.readRowCount3) * rw;

	sz = inst.outbufsize * (inst.Kbe + 1 - inst.Kbh);
	k = sz / (4 * outbufw1);
	inst.resSizeBatch = k * 4 * outbufw1;
	if (inst.resSizeBatch == sz){
		inst.resSizeBatch -= 4 * outbufw1;
		inst.resLenBatch = 4 * outbufw1;
	}
	else{
		inst.resLenBatch = sz - inst.resSizeBatch;
		if (inst.doRes && inst.doBatch3)
			assert(inst.resLenBatch == outbufw1 || inst.resLenBatch == outbufw1 * 2 || inst.resLenBatch == outbufw1 * 3);
	}

	inst.ug_batch = inst.ng / 3;
	GetWLenKs(wlenk1, wlenk2, inst.ug_batch, inst.K);
	if (wlenk1 != inst.wlenk_regular)
		inst.wlenk_bLast = wlenk1;
	else
		inst.wlenk_bLast = wlenk2;
	//inst.wlenk_bLast = wlenk2;
	int numbatches = inst.Kbe + 1 - inst.Kbh;
	if (!inst.doBatch3 || numbatches <= inst.ug_batch){
		inst.batch_1group = 1;
		inst.kbe_1 = inst.Kbh;
		inst.ug_batchLast = numbatches;
	}
	else{
		inst.batch_1group = 0;
		int k = numbatches / inst.ug_batch;
		if (k * inst.ug_batch == numbatches){
			assert(k >= 2);
			inst.kbe_1 = inst.Kbh + (k - 2) * inst.ug_batch;
			inst.ug_batchLast = inst.ug_batch;
		}
		else{
			inst.kbe_1 = inst.Kbh + (k - 1) * inst.ug_batch;
			inst.ug_batchLast = inst.Kbe + 1 - inst.kbe_1 - inst.ug_batch;
		}
	}
	GetWLenKs(wlenk1, wlenk2, inst.ug_batchLast, inst.K);
	if (wlenk1 != inst.wlenk_regular)
		inst.wlenk_bLast2 = wlenk1;
	else
		inst.wlenk_bLast2 = wlenk2;
#endif
}

GlobalInstruction * CModel::ExpandInstructions(GlobalInstruction *p)
{
	int s;
	int maxIdx;
	for (s = 0; s < 10000; s++)
		if (p[s].type == END && !p[s].i.end.hasMore){
			maxIdx = 7 * p[s].i.end.reqSeqNum + 10;
			break;
		}
	
	GlobalInstruction *pp = new GlobalInstruction[maxIdx];
	int idx = 0;
	pp[idx].type = OPTIONS;
	pp[idx].i.co.start = 0;
	pp[idx].i.co.stop = 1;
	idx++;
	bool isFirst = true;
	for (int i = 0;;i++){
		if (p[i].type != CONV){
			pp[idx++] = p[i];
			if (p[i].type == END && !p[i].i.end.hasMore)
				break;
			continue;
		}
		Instruction inst = p[i].i.inst;
		CFlop<unsigned, 0> curX;
		CFlop<unsigned, 0> curY;
		CFlop<unsigned, 0> curSeq;	
		CFlop<unsigned, 0> curW;
		CFlop<unsigned, 0> curH;

		curX = 0;
		curY = 0;
		curSeq = inst.seqNum;
		curW = inst.W1;
		curH = inst.H1;

		bool done = false;
		bool newWctrl = true;

		while (!done){
			curX.latch(0);
			curY.latch(0);
			curSeq.latch(0);
			curW.latch(0);
			curH.latch(0);

			if (newWctrl){
				newWctrl = false;
				InstructionWrite iw;
				iw.mode = inst.mode;
				if (inst.W2){
					iw.dataWidth = ((inst.W1 - inst.K + inst.lPad + inst.rPad) / inst.S + 1);
					iw.dataWidth2 = ((inst.W2 - inst.K + inst.lPad + inst.rPad) / inst.S + 1);
				}
				else{
					iw.dataWidth = ((curW.GetValue() - inst.K + inst.lPad + inst.rPad) / inst.S + 1);
					iw.dataWidth2 = ((curW.GetValue() - inst.K + inst.lPad + inst.rPad) / inst.S + 1);
				}
				//iw.outLen = BANK_NUM * iw.dataWidth;
				iw.isUpsample = inst.doUpSample;
				iw.isMaddr_a = inst.isOaddr_a;
				iw.isMaddr_b = inst.isOaddr_b;
				iw.Oaddr = inst.Oaddr;
				unsigned h1 = inst.H1;
				if (h1 > inst.H)
					h1 = inst.H;
				iw.outH1 = ((h1 - inst.K + inst.lPad + inst.rPad) / inst.S);
				iw.maxpool_size = inst.maxpool_size;
				iw.maxpool_stride = inst.maxpool_stride;
				pp[idx].type = CWRITE;
				pp[idx++].i.wr = iw;
			}
			InstructionWeight iwt;
			if (curX == 0 && curY == 0){
				
				iwt.mode = inst.mode;
				iwt.isReadRam = false;
				iwt.isWriteRam = inst.isUseWRam;
				iwt.dropSize = inst.wDropSize;
				iwt.seqNum = curSeq.GetValue();
				iwt.Oaddr = inst.Waddr;
				iwt.size = inst.WSize;
			}
			else{
				iwt.mode = inst.mode;
				iwt.isReadRam = inst.isUseWRam;
				iwt.isWriteRam = false;
				iwt.dropSize = inst.wDropSize;
				iwt.seqNum = curSeq.GetValue();
				iwt.Oaddr = inst.Waddr;
				iwt.size = inst.WSize;
			}
			

			InstructionRead ir;
			ir.mode = inst.mode;
			ir.reqSeqNum = inst.reqSeqNum;
			ir.reqProgress = inst.reqProgress;
			ir.seqNum = curSeq.GetValue();
			ir.W = inst.W;
			ir.H = inst.H;
			ir.C = inst.C;
			ir.Maddr = inst.Maddr;
			if (inst.W2){
				ir.W1 = inst.W1;
				ir.W2 = inst.W2;
			}
			else{
				ir.W1 = curW.GetValue();
				ir.W2 = curW.GetValue();
			}
			ir.H1 = (((curY.GetValue() + curH.GetValue()) > inst.H) ?
				(inst.H - curY.GetValue()) : curH.GetValue()) - 1;
			ir.X = curX.GetValue();
			ir.Y = curY.GetValue();
			ir.S = inst.S;
			ir.lPad = inst.lPad;
			ir.rPad = inst.rPad;
			ir.isMaddr_a = inst.isMaddr_a;
			ir.isMaddr_b = inst.isMaddr_b;
			ir.isRes_a = inst.isRaddr_a;
			pp[idx].type = CREAD;
			pp[idx++].i.rd = ir;

			if (inst.mode == MODE_FOUR){
				assert(inst.W == inst.W1);
				assert(inst.H == inst.H1);

				for (int i = 0; i < BANK_NUM; i++){
					if (inst.WEnd[i] <= 0)
						continue;
					InstructionHCB hcb;

					hcb.Id = i;
					hcb.type = CONV;
					hcb.reqSeqNum = inst.reqSeqNum;
					hcb.reqProgress = inst.reqProgress;
					//hcb.reqSeqNumW = inst.reqSeqNumW;
					//hcb.reqProgressW = inst.reqProgressW;
					hcb.seqNum = inst.seqNum;
					hcb.fScale = inst.fScale;
					hcb.wScale = inst.wScale;
					hcb.maxpool_size = inst.maxpool_size;
					hcb.maxpool_stride = inst.maxpool_stride;
					hcb.W = inst.W;
					hcb.H = inst.H;
					hcb.C = inst.C;
					//hcb.Maddr = 0;// inst.Maddr;
					//hcb.Oaddr = 0;// inst.Oaddr;
					hcb.Waddr = (i == 0) ? 0 : inst.WEnd[i - 1];
					hcb.WEnd = inst.WEnd[i];
					hcb.weightPos = i * WEIGHT_DATA_WIDTH;
					hcb.ReadPos = 0;
					hcb.ResPos = 0;
					hcb.W1 = inst.W1;
					hcb.H1 = inst.H1 - 1;
					hcb.X = 0;
					hcb.Y = 0;
					hcb.S = inst.S;
					hcb.lPad = inst.lPad;
					hcb.rPad = inst.rPad;
					hcb.K = inst.K;
					hcb.M = inst.M;
					hcb.Kh = inst.Kh[i];
					hcb.Ks = inst.Ks[i];
					hcb.Kt = inst.Kt[i];
					hcb.Res_addr = inst.Res_addr;
					//hcb.BM_addr = inst.BM_addr;
					hcb.wLRelu = inst.wLRelu;
					hcb.weightToken = i;
					//hcb.resToken = i;
					hcb.mode = inst.mode;
					hcb.isResMaster = 1;
					//hcb.isWeightMaster = 1;
					hcb.isProgressMaster = ((i == 0) ? 1 : 0);
					hcb.isRaddr_a = inst.isRaddr_a; //for Res
					hcb.doRes = inst.doRes;
					hcb.doRelu = inst.doRelu;
					hcb.doLRelu = inst.doLRelu;
					hcb.doBM = inst.doBM;
					hcb.doUpSample = inst.doUpSample;
					hcb.newWriteInst = 1;
					processInstExt(hcb);
					pp[idx].type = HCB;
					pp[idx++].i.hcb = hcb;
				}
				done = true;
			}
			else if (inst.mode == MODE_TWO){
				
				unsigned nextx = curX.GetValue() + inst.W1 * 2;
				if (nextx >= inst.W){
					if (curY.GetValue() + curH.GetValue() >= inst.H){
						done = true;
					}
					curY += curH.GetValue();
					nextx = 0;
					if (inst.W2 == 0)
						curW = inst.W1;
					curH = inst.H1;
				}
				else if (nextx + inst.W1 * 2 >= inst.W){
					if (inst.W2 == 0)
						curW = (inst.W - nextx) / 2;
				}
				curX = nextx;
				curSeq++;

				for (int i = 0; i < BANK_NUM; i++){
					InstructionHCB hcb;
					hcb.Id = i;
					hcb.type = CONV;
					hcb.reqSeqNum = inst.reqSeqNum;
					hcb.reqProgress = inst.reqProgress;
					//hcb.reqSeqNumW = inst.reqSeqNumW;
					//hcb.reqProgressW = inst.reqProgressW;
					hcb.seqNum = curSeq.GetValue();// inst.seqNum;
					hcb.fScale = inst.fScale;
					hcb.wScale = inst.wScale;
					hcb.maxpool_size = inst.maxpool_size;
					hcb.maxpool_stride = inst.maxpool_stride;
					hcb.W = inst.W;
					hcb.H = inst.H;
					hcb.C = inst.C;
					//hcb.Maddr = inst.Maddr;
					//hcb.Oaddr = 0;// inst.Oaddr;
					hcb.Waddr = (i < 2) ? 0 : inst.WEnd[0];
					hcb.WEnd = (i < 2) ? inst.WEnd[0] : inst.WEnd[1];
					hcb.weightPos = (i / 2) * WEIGHT_DATA_WIDTH;
					int gap = curX == 0 ? inst.lPad : 0;
					if (inst.W2 != 0){
						hcb.ReadPos = (i % 2 == 0) ? 0 : (inst.W1 - gap);
						hcb.ResPos = (i % 2 == 0) ? 0 : (inst.W1 / inst.S);
						hcb.W1 = ((i & 1) == 0) ? inst.W1 : inst.W2;
						hcb.X = (i % 2 == 0) ? curX.GetValue() : curX.GetValue() + inst.W1;
					}
					else{
						hcb.ReadPos = (i % 2 == 0) ? 0 : (curW.GetValue() - gap);
						hcb.ResPos = (i % 2 == 0) ? 0 : (curW.GetValue() / inst.S);
						hcb.W1 = curW.GetValue();
						hcb.X = (i % 2 == 0) ? curX.GetValue() : curX.GetValue() + curW.GetValue();
					}
					hcb.H1 = (((curY.GetValue() + curH.GetValue()) > hcb.H) ? (hcb.H - curY.GetValue()) : curH.GetValue()) - 1;
					hcb.Y = curY.GetValue();
					hcb.S = inst.S;
					hcb.lPad = inst.lPad;
					hcb.rPad = inst.rPad;
					hcb.K = inst.K;
					hcb.M = inst.M;
					hcb.Kh = inst.Kh[i / 2];
					hcb.Ks = inst.Ks[i / 2];
					hcb.Kt = inst.Kt[i / 2];
					hcb.Res_addr = inst.Res_addr;
					//hcb.BM_addr = inst.BM_addr;
					hcb.wLRelu = inst.wLRelu;
					hcb.weightToken = i / 2;
					//hcb.resToken = i/2;
					hcb.mode = inst.mode;
					hcb.isResMaster = i % 2 == 0 ? 1 : 0;
					//hcb.isWeightMaster = i % 2 == 0 ? 1 : 0; // 0 processed first 
					hcb.isProgressMaster = ((i == 0) ? 1 : 0);
					hcb.isRaddr_a = inst.isRaddr_a; //for Res
					hcb.doRes = inst.doRes;
					hcb.doRelu = inst.doRelu;
					hcb.doLRelu = inst.doLRelu;
					hcb.doBM = inst.doBM;
					hcb.doUpSample = inst.doUpSample;
					hcb.newWriteInst = done ? 1 : 0;
					processInstExt(hcb);
					pp[idx].type = HCB;
					pp[idx++].i.hcb = hcb;
				}
			}
			else{
				unsigned nextx = curX.GetValue() + inst.W1 * 4;
				if (nextx >= inst.W){
					if (curY.GetValue() + curH.GetValue() >= inst.H){
						done = true;
					}
					curY += curH.GetValue();
					nextx = 0;
					if (inst.W2 == 0)
						curW = inst.W1;
					curH = inst.H1;
				}
				else if (nextx + inst.W1 * 4 >= inst.W){
					if (inst.W2 == 0)
						curW = (inst.W - nextx) / 4;
				}
				curX = nextx;
				curSeq++;

				for (int i = 0; i < BANK_NUM; i++){
					InstructionHCB hcb;
					hcb.Id = i;
					hcb.type = CONV;
					hcb.fScale = inst.fScale;
					hcb.wScale = inst.wScale;
					hcb.reqSeqNum = inst.reqSeqNum;
					hcb.reqProgress = inst.reqProgress;
					hcb.maxpool_size = inst.maxpool_size;
					hcb.maxpool_stride = inst.maxpool_stride;
					//hcb.reqSeqNumW = inst.reqSeqNumW;
					//hcb.reqProgressW = inst.reqProgressW;
					hcb.seqNum = curSeq.GetValue();// inst.seqNum;
					hcb.W = inst.W;
					hcb.H = inst.H;
					hcb.C = inst.C;
					//hcb.Maddr = inst.Maddr;
					//hcb.Oaddr = 0;// inst.Oaddr;
					hcb.Waddr = 0;// inst.Waddr;
					hcb.WEnd = inst.WEnd[0];
					hcb.weightPos = 0;
					int gap = curX == 0 ? inst.lPad : 0;
					if (inst.W2 != 0){
						hcb.ReadPos = (i == 0) ? 0 : (i * inst.W1 - gap);
						hcb.ResPos = i * (inst.W1 / inst.S);
						hcb.W1 = ((i & 3) != 3) ? inst.W1 : inst.W2;
						hcb.X = curX.GetValue() + i * inst.W1;
					}
					else{
						hcb.ReadPos = (i == 0) ? 0 : (i * curW.GetValue() - gap);
						hcb.ResPos = i * (curW.GetValue() / inst.S);
						hcb.W1 = curW.GetValue();
						hcb.X = curX.GetValue() + i * curW.GetValue();
					}

					hcb.H1 = (((curY.GetValue() + curH.GetValue()) > hcb.H) ? (hcb.H - curY.GetValue()) : curH.GetValue()) - 1;
					hcb.Y = curY.GetValue();
					hcb.S = inst.S;
					hcb.lPad = inst.lPad;
					hcb.rPad = inst.rPad;
					hcb.K = inst.K;
					hcb.M = inst.M;
					hcb.Kh = inst.Kh[0];
					hcb.Ks = inst.Ks[0];
					hcb.Kt = inst.Kt[0];
					hcb.Res_addr = inst.Res_addr;
					//hcb.BM_addr = inst.BM_addr;
					hcb.wLRelu = inst.wLRelu;
					hcb.weightToken = 0;
					//hcb.resToken = 0;
					hcb.mode = inst.mode;
					hcb.isResMaster = ((i == 0) ? 1 : 0);
					//hcb.isWeightMaster = ((i == 0) ? 1 : 0); // any of them can be 1, 3 here for simulation
					hcb.isProgressMaster = ((i == 3) ? 1 : 0);
					hcb.isRaddr_a = inst.isRaddr_a; //for Res
					hcb.doRes = inst.doRes;
					hcb.doRelu = inst.doRelu;
					hcb.doLRelu = inst.doLRelu;
					hcb.doBM = inst.doBM;
					hcb.doUpSample = inst.doUpSample;
					if (done || curW.GetValue() != curW.GetNextValue())
						hcb.newWriteInst = 1;
					else
						hcb.newWriteInst = 0;
					processInstExt(hcb);
					pp[idx].type = HCB;
					pp[idx++].i.hcb = hcb;
				}

			}
			if (isFirst){
				isFirst = false;
				pp[idx].type = OPTIONS;
				pp[idx].i.co.start = 1;
				pp[idx].i.co.stop = 0;
				idx++;
			}
			pp[idx].type = LOADWEIGHT;
			pp[idx++].i.wt = iwt;
			if (curW.GetValue() != curW.GetNextValue())
				newWctrl = true;
		}
	}
	PrintGInsts(pp, "expand_ginsts.txt");
	return pp;
}

std::string GetMode(DATA_MODE mode)
{
	if (mode == MODE_ONE)
		return "MODE_ONE";
	return mode == MODE_TWO ? "MODE_TWO" : "MODE_FOUR";
}
void CModel::PrintGInsts(GlobalInstruction *pp, char *filename)
{
	FILE *fp = fopen(filename, "wt");
	bool done = false;
	for (int i = 0;!done; i++){
		switch (pp[i].type){
			case OPTIONS:
			{
				fprintf(fp, "%d : Option %s %s\n", i, pp[i].i.co.start ? "Start" : "", pp[i].i.co.stop ? "Stop" : "");
				break;
			}
			case LOADWEIGHT:
			{
				InstructionWeight *pi = &(pp[i].i.wt);
				fprintf(fp, "%d : Weight %s , seq %d, size %d\n"
					, i, GetMode(pi->mode).c_str(), pi->seqNum, pi->size);
				break;
			}
			case HCB:
			{
				InstructionHCB *pi = &(pp[i].i.hcb);
				fprintf(fp, "%d : HCB %d %s , seq %d, W %d, H %d, C %d, W1 %d, H1 %d, X %d, Y %d, S %d , Pad %d %d, K %d, M %d, K(%d,%d,%d), mpool  %d %d\n"
					, i, pi->Id, GetMode(pi->mode).c_str(), pi->seqNum, pi->W, pi->H, pi->C
					, pi->W1, pi->H1, pi->X, pi->Y, pi->S, pi->lPad, pi->rPad
					, pi->K, pi->M, pi->Kh, pi->Kt, pi->Ks, pi->maxpool_stride, pi->maxpool_size);
				break;
			}
			case CREAD:
			{
				InstructionRead *pi = &(pp[i].i.rd);
				fprintf(fp, "%d : Read %s , seq %d, W %d, H %d, C %d, W1 %d, W2 %d, H1 %d, X %d, Y %d, S %d, Pad %d %d\n"
					, i, GetMode(pi->mode).c_str(), pi->seqNum, pi->W, pi->H, pi->C
					, pi->W1, pi->W2, pi->H1, pi->X, pi->Y, pi->S, pi->lPad, pi->rPad);
				break;
			}
			case CWRITE:
			{
				InstructionWrite *pi = &(pp[i].i.wr);;
				fprintf(fp, "%d : Write %s , dw %d, dw2 %d, outH1 %d, mpstride %d, mpsize %d\n"
					, i, GetMode(pi->mode).c_str(), pi->dataWidth, pi->dataWidth2
					, pi->outH1, pi->maxpool_stride, pi->maxpool_size);
				break;
			}
			case POOL:
			case CONV:
			{
				assert(false);
				break;
			}
			case END:
			{
				InstructionEnd *pi = &(pp[i].i.end);
				fprintf(fp, "%d : End, reqseq %d, more?(%s)\n"
					, i, pi->reqSeqNum, pi->hasMore ? "Y" : "N");
				if (!pp[i].i.end.hasMore)
					done = true;
				break;
			}
		}
	}
	fclose(fp);
}

unsigned char * EncodeInstructions(GlobalInstruction *p)
{
	int s;
	for (s = 0; s < 10000; s++)
		if (p[s].type == END && !p[s].i.end.hasMore)
			break;
	assert(s < 10000);
	s++;
	unsigned char *ret = new unsigned char[s * sizeof(p[0])];
	unsigned char *buf = ret;
	for (s = 0;; s ++){
		memcpy(buf, &(p[s].type), 1);
		buf++;
		int len;
		if (p[s].type == HCB){
			unsigned char* tmp = DoPackInstructionHCB(&p[s].i.hcb);
			len = InstructionHCBLength;
			memcpy(buf, tmp, len);
			buf += len;
			continue;
		}
		else if (p[s].type == OPTIONS){
			unsigned char* tmp = DoPackInstructionOption(&p[s].i.co);
			len = InstructionOptionLength;
			memcpy(buf, tmp, len);
			buf += len;
			continue;
		}
		else if (p[s].type == LOADWEIGHT){
			unsigned char* tmp = DoPackInstructionWeight(&p[s].i.wt);
			len = InstructionWeightLength;
			memcpy(buf, tmp, len);
			buf += len;
			continue;
		}
		else if (p[s].type == CREAD){
			unsigned char* tmp = DoPackInstructionRead(&p[s].i.rd);
			len = InstructionReadLength;
			memcpy(buf, tmp, len);
			buf += len;
			continue;
		}
		else if (p[s].type == CWRITE){
			unsigned char* tmp = DoPackInstructionWrite(&p[s].i.wr);
			len = InstructionWriteLength;
			memcpy(buf, tmp, len);
			buf += len;
			continue;
		}
		else if (p[s].type == END){
			unsigned char* tmp = DoPackInstructionEnd(&p[s].i.end);
			len = InstructionEndLength;
			memcpy(buf, tmp, len);
			buf += len;
			if (p[s].type == END && !p[s].i.end.hasMore)
				break;
			continue;
		}
		switch (p[s].type) {
		case OPTIONS: len = sizeof(InstructionOption); break;
		case MEM: len = sizeof(InstructionMem); break;
		case LOADWEIGHT: len = sizeof(InstructionWeight); break;
		case HCB: len = sizeof(InstructionHCB); break;
		case CREAD: len = sizeof(InstructionRead); break;
		case CWRITE: len = sizeof(InstructionWrite); break;
		case POOL:
		case CONV: len = sizeof(Instruction); break;
		case END: len = sizeof(InstructionEnd); break;
		}
		memcpy(buf, &(p[s].i), len);
		buf += len;
		if (p[s].type == END && !p[s].i.end.hasMore)
			break;
	}
	int len = buf - ret;
	printf("Instruction total length : %d bytes\n", len);
	return ret;
}

void CModel::Run(GlobalInstruction *p, bool isDebug, DumpInfo * head, int debugLevel)
{
	//debugLevel = 3;
	//isDebug = false;
	FILE *fp = NULL;
	bool fullDebug = false;
	if (isDebug){
		fp = fopen("Debug.txt", "wt");
		assert(fp);
		std::vector<CSimNode *>::const_iterator pp = operations.begin();
		for (; pp != operations.end(); pp++){
			(*pp)->SetDebug(fp);
			(*pp)->SetDebugLevel(debugLevel);
			//fullDebug = true;
		}
	}
	if (debugLevel == 1)
		fullDebug = true;
	GlobalInstruction *pp = ExpandInstructions(p);
	unsigned char *buf = EncodeInstructions(pp);
	delete[]pp;
	paddrBuf->Push((ADDR_TYPE)buf);
	int countd = -1;
	for (int i = 0;; i++){
		std::vector<CSimNode *>::const_iterator p;
		if (fp && fullDebug)
			fprintf(fp, "iter %d\n", i);
		/*if (i >= 635500){
			for (p = operations.begin(); p != operations.end(); p++)
				(*p)->DumpState();
			fflush(fp);
		}*/
		/*if (i == 9629491){
			fullDebug = true;
			std::vector<CSimNode *>::const_iterator pp = operations.begin();
			for (; pp != operations.end(); pp++){
				(*pp)->SetDebugLevel(1);
			}
		}*/
		
		for (p = operations.begin(); p != operations.end(); p++)
			(*p)->progress(i);
		if (fp )
			fflush(fp);
		for (p = operations.begin(); p != operations.end(); p++)
			(*p)->latch(i);
		if (pgib->IsProcessEnd()){
			printf("took %d iterations\n", i);
			break;
		}
		if (fp )
			fflush(fp);
		if (head){
			if (countd == 0){
				Dump(head, i);
				head = head->next;
			}
			if (countd >= 0)
				countd--;
			else{
				int seq;
				if (head->isA)
					seq = this->prama->GetFinishedSeq();
				else if (head->isB)
					seq = this->pramb->GetFinishedSeq();
				else
					seq = pcwrite->GetFinishedSeq();
				if (seq >= head->reqSeq)
					countd = 5;
			}
		}
	}
	delete []buf;
	if (fp)
		fclose(fp);
	return;
}
void CModel::Dump(DumpInfo *pdi, int i)
{
	static int lastI = 0;
	printf("dump file %s i = %d (%d)\n", pdi->name.c_str(), i, i - lastI);
	lastI = i;
	FILE *fp = fopen(pdi->name.c_str(), "wt");
	fprintf(fp, "%d", pdi->len);
	DTYPE *ptr = (DTYPE *)pdi->start;
	if (pdi->isA){
		ptr = prama->GetAddress(pdi->start);
	}
	else if (pdi->isB){
		ptr = pramb->GetAddress(pdi->start);
	}
	for (int i = 0; i < pdi->len; i++)
		fprintf(fp, " "DFMT, ptr[i]);
	fclose(fp);
}

void testConv()
{
	DTYPE features[10][10][10]; //channel, height, width
	DTYPE weights[10][10][3][3];// M = 10, output channels, 3x3x10
	DTYPE bms[10][BM_NUM];
	DTYPE res[10][10][10];
	DTYPE wrelu = 2;
	int i, j, k;
	for (i = 0; i < 10; i++){
		bms[i][0] = DTYPE(-i - 1);
		bms[i][1] = DTYPE(i + 2);
		bms[i][2] = 0;
	}
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				features[i][j][k] = DTYPE(i + 1);
	for (i = 0; i < 10; i++)
		for (int j = 0; j < 10; j++)
			for (k = 0; k < 3; k++)
				for (int l = 0; l < 3; l++){
					if (i % 4 == 0)
						weights[i][j][k][l] = DTYPE(1); // output 55
					else if (i % 4 == 2)
						weights[i][j][k][l] = DTYPE(-1); // output -55
					else if (i % 4 == 1)
						weights[i][j][k][l] = DTYPE(10 - j); // output 220
					else
						weights[i][j][k][l] = DTYPE(j - 10); // output -220
				}
	for (i = 0; i < 10; i++)
		for (j = 0; j < 10; j++)
			for (k = 0; k < 10; k++)
				res[i][j][k] = DTYPE(10 * i);
	DTYPE expected[10][10][10];
	GetConv<10, 10, 10, 10, 3, 1, 1>(expected, features, weights, bms, res, wrelu, true, false, true, true);

	for (k = 0; k < 10; k++)
		for (i = 0; i < 10; i++)
			for (j = 0; j < 10; j++){
				DTYPE val;
				if (k % 2 == 0){
					if (k % 4 == 2){
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = -220;
							else
								val = -330;
						}
						else{
							if (j == 0 || j == 9)
								val = -330;
							else
								val = -495;
						}
					}
					else{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = 220;
							else
								val = 330;
						}
						else{
							if (j == 0 || j == 9)
								val = 330;
							else
								val = 495;
						}
					}
				}
				//* 220 330 220
				//330 495 330
				//220 330 220
				else{
					if (k % 4 == 3)
					{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = -880;
							else
								val = -1320;
						}
						else{
							if (j == 0 || j == 9)
								val = -1320;
							else
								val = -1980;
						}
					}
					else{
						if (i == 0 || i == 9){
							if (j == 0 || j == 9)
								val = 880;
							else
								val = 1320;
						}
						else{
							if (j == 0 || j == 9)
								val = 1320;
							else
								val = 1980;
						}
					}
				}
				//*880  1320 880
				//1320 1980 1320
				//880  1320 880
				val = k + 2 - val * (k + 1);
				val = val < 0 ? 2 * val : val;
				val = val + 10 * k;
				assert(expected[k][i][j] == val);
			}

}

#include "model.h"
#include <stdio.h>
#include <stdlib.h> 
#include <io.h>
#include <fcntl.h>
#include <errno.h>
#include <sys\stat.h>
#pragma warning(disable : 4996)
using namespace CloudDesign;
int CloudDesign::max_add1;
int CloudDesign::max_add2;
void CModelIF::BuildModel(int numBanks, int numCGs)
{
	numBanks = BANK_NUM;
	numCGs = CG_NUM;
	paddrBuf = new CAddrBuffer;
	prama = new CBRAM;
	pramb = new CBRAM;
	pramw = new CBRAM;
	pddrw = new CDDR<PS_DDR_DATAWIDTH>;
	pddrd = new CDDR<DDR_DATAWIDTH>;
	pddrd_read = new CDDRReadAssist<DDR_DATAWIDTH>;
	pddrw_read = new CDDRReadAssist<PS_DDR_DATAWIDTH>;
	pddr_write = new CDDRWriteAssist;
	pif = new CInterface;
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
	pddrw->SetName("DDRWeight");
	pddrd->SetName("DDRData");
	pddr_write->SetName("DDRWrite");
	pif->SetName("Interface");
	pgib->SetName("GIB");
	ptkn->SetName("token");
	ptknw->SetName("wtoken");
	pcread->SetName("cread");
	pcweight->SetName("cweight");
	pcwrite->SetName("cwrite");
	pddrd_read->SetName("ddrd_read");
	pddrw_read->SetName("ddrw_read");

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
	pddrd->Init(40000000);
	pddrw->Init(40000000);
	pif->Init();
	pddrd_read->Init();
	pddrd_read->SetCid(DDR_FEATURE_ID);
	pddrd_read->SetDDR(pddrd);
	pddrw_read->Init();
	pddrw_read->SetCid(DDR_WEIGHT_ID);
	pddrw_read->SetDDR(pddrw);
	pddr_write->Init();
	pddr_write->SetCid(DDR_FEATURE_ID);
	pddr_write->SetDDR(pddrd);
	
	operations.push_back(pddrd_read);
	operations.push_back(pddrw_read);
	operations.push_back(pddr_write);
	operations.push_back(pcread);
	operations.push_back(pgib);
	operations.push_back(pcweight);
	operations.push_back(paddrBuf);
	
	operations.push_back(ptkn);
	operations.push_back(ptknw);
	
	

	//pread->SetMaxVal(1);
	//pwrite->SetMaxVal(2);
	//pweight->SetMaxVal(2);
	//pext->SetMaxVal(1);
	pif->SetAddrBuf(paddrBuf);
	pif->SetDDRs(pddrw, pddrd, pddr_write);
	pif->SetCtrlRead(pcread);
	pgib->SetAddrBuf(paddrBuf);
	pgib->SetInterface(pif);
	pgib->SetRam(prama, pramb, pramw);
	pgib->SetCtrl(pcread, pcwrite, pcweight);
	pgib->SetTokenGen(ptkn);
	pcweight->SetRam(pramw);
	pcweight->SetDDRRead(pddrw_read);
	pcread->SetRam(prama, pramb);
	pcread->SetDDRRead(pddrd_read);
	pcwrite->SetRam(prama, pramb);
	pcwrite->SetDDRWrite(pddr_write);
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
		banks[i].SetID(i);// for verification
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
	operations.push_back(pddrw);
	operations.push_back(pddrd);
	operations.push_back(pif);
	if (DUMP_VERIFICATION_AXI){
		char filename[100];
		sprintf(filename, "%s/axi_output.txt", OUTPUT_DIR);
		fio = fopen(filename, "wt");
		assert(fio);
	}
	else
		fio = 0;
	if (0 && DUMP_VERIFICATION_AXI){
		char filename[100];
		sprintf(filename, "%s/axi_feature_input.txt", OUTPUT_DIR);
		ffi = fopen(filename, "wt");
		assert(ffi);
		sprintf(filename, "%s/axi_weight_input.txt", OUTPUT_DIR);
		fwi = fopen(filename, "wt");
		assert(fwi);
		sprintf(filename, "%s/axi_inst_input.txt", OUTPUT_DIR);
		fii = fopen(filename, "wt");
		assert(fii);

		sprintf(filename, "%s/axi_feature_read_output.txt", OUTPUT_DIR);
		ffro = fopen(filename, "wt");
		assert(ffro);
		sprintf(filename, "%s/axi_feature_write_output.txt", OUTPUT_DIR);
		ffwo = fopen(filename, "wt");
		assert(ffwo);
		sprintf(filename, "%s/axi_weight_read_output.txt", OUTPUT_DIR);
		fwro = fopen(filename, "wt");
		sprintf(filename, "%s/axi_inst_read_output.txt", OUTPUT_DIR);
		fio = fopen(filename, "wt");
		assert(fwro);
		assert(fio);
	}
	else
		ffi = fwi = fii = ffro = ffwo = fwro = NULL;
}

CModelIF::~CModelIF()
{
	delete paddrBuf;
	delete prama;
	delete pramb;
	delete pramw;
	delete pgib;
	delete ptkn;
	delete pddrd;
	delete pddrw;
	delete pif;

	delete ptknw;
	delete pcread;
	delete pcweight;
	delete pcwrite;
	delete palloc;
}

void CModelIF::GetWLenKs(unsigned &wlenkInit, unsigned &wlenkLast, unsigned wtotal, unsigned k)
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

int CModelIF::getTotalFrames(int kh, int ks, int kt, int ng)
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


void CModelIF::processInstExt(InstructionHCB &inst)
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
		inst.resLenLast = sz - inst.resSizeLast;
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
	/*if (inst.doBM)
		inst.totalBM = BM_NUM * getTotalFrames(inst.Kh, inst.Ks, inst.Kt, inst.ng);
	else
		inst.totalBM = 0;*/
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

GlobalInstruction * CModelIF::ExpandInstructions(GlobalInstruction *p)
{
	int s;
	int maxIdx;
	for (s = 0; s < 10000; s++)
		if (p[s].type == END && !p[s].i.end.hasMore){
			maxIdx = 7 * p[s].i.end.reqSeqNum + 10;
			break;
		}
	
	GlobalInstruction *pp = new GlobalInstruction[maxIdx];
	memset(pp, 0, sizeof(pp[0]) * maxIdx);
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
			if (!isFirst){
				pp[idx].type = CREAD;
				pp[idx++].i.rd = ir;
			}

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
			pp[idx].type = LOADWEIGHT;
			pp[idx++].i.wt = iwt;
			if (isFirst){
				isFirst = false;
				
				pp[idx].type = OPTIONS;
				pp[idx].i.co.start = 1;
				pp[idx].i.co.stop = 0;
				idx++;

				pp[idx].type = CREAD;
				pp[idx++].i.rd = ir;

			}
			
			if (curW.GetValue() != curW.GetNextValue())
				newWctrl = true;
			
		}
		/*
		if (i == 2){
			pp[idx].type = END;
			pp[idx].i.end.hasMore = 1;
			pp[idx].i.end.isRamA = 0;
			pp[idx].i.end.isRamB = 0;
			pp[idx].i.end.reqSeqNum = curSeq.GetValue();
			pp[idx].i.end.oAddr = p[i].i.inst.Oaddr;
			pp[idx++].i.end.oSize = SZ_DTYPE * p[i].i.inst.W * p[i].i.inst.H * p[i].i.inst.M
				/ p[i].i.inst.maxpool_stride / p[i].i.inst.maxpool_stride;
		}*/
	}
	PrintGInsts(pp, "expand_ginsts.txt");
	return pp;
}

std::string CModelIF::GetMode(DATA_MODE mode)
{
	if (mode == MODE_ONE)
		return "MODE_ONE";
	return mode == MODE_TWO ? "MODE_TWO" : "MODE_FOUR";
}
void CModelIF::PrintGInsts(GlobalInstruction *pp, char *filename)
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
				fprintf(fp, "%d : HCB %d %s , seq %d, req %d, W %d, H %d, C %d, W1 %d, H1 %d, X %d, Y %d, S %d , Pad %d %d, K %d, M %d, K(%d,%d,%d), mpool  %d %d\n"
					, i, pi->Id, GetMode(pi->mode).c_str(), pi->seqNum, pi->reqSeqNum, pi->W, pi->H, pi->C
					, pi->W1, pi->H1, pi->X, pi->Y, pi->S, pi->lPad, pi->rPad
					, pi->K, pi->M, pi->Kh, pi->Kt, pi->Ks, pi->maxpool_stride, pi->maxpool_size);
				break;
			}
			case CREAD:
			{
				InstructionRead *pi = &(pp[i].i.rd);
				fprintf(fp, "%d : Read %s, addr %d , seq %d, W %d, H %d, C %d, W1 %d, W2 %d, H1 %d, X %d, Y %d, S %d, Pad %d %d\n"
					, i, GetMode(pi->mode).c_str(), pi->Maddr, pi->seqNum, pi->W, pi->H, pi->C
					, pi->W1, pi->W2, pi->H1, pi->X, pi->Y, pi->S, pi->lPad, pi->rPad);
				break;
			}
			case CWRITE:
			{
				InstructionWrite *pi = &(pp[i].i.wr);;
				fprintf(fp, "%d : Write %s, oaddr %d , dw %d, dw2 %d, outH1 %d, mpstride %d, mpsize %d\n"
					, i, GetMode(pi->mode).c_str(), pi->Oaddr, pi->dataWidth, pi->dataWidth2
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
				fprintf(fp, "%d : End, reqseq %d, addr %d, size %d, more?(%s)\n"
					, i, pi->reqSeqNum, pi->oAddr, pi->oSize, pi->hasMore ? "Y" : "N");
				if (!pp[i].i.end.hasMore)
					done = true;
				break;
			}
		}
	}
	fclose(fp);
}

unsigned char * CModelIF::EncodeInstructions(GlobalInstruction *p, int &len)
{
	int s;
	for (s = 0; s < 10000; s++)
		if (p[s].type == END && !p[s].i.end.hasMore)
			break;
	assert(s < 10000);
	s++;
	unsigned char *ret = new unsigned char[s * sizeof(p[0])];
	memset(ret, 0, s * sizeof(p[0]));
	unsigned char *buf = ret;
	for (s = 0;; s ++){
		memcpy(buf, &(p[s].type), 1);
		buf+=4;
		int len;
		if (p[s].type == HCB){
			unsigned char* tmp = DoPackInstructionHCB(&p[s].i.hcb);
			len = InstructionHCBLength;
			memcpy(buf, tmp, len);
			if (len % 4)
				len += (4 - len % 4);
			buf += len;

			continue;
		}
		else if (p[s].type == OPTIONS){
			unsigned char* tmp = DoPackInstructionOption(&p[s].i.co);
			len = InstructionOptionLength;
			memcpy(buf, tmp, len);
			if (len % 4)
				len += (4 - len % 4);
			buf += len;
			continue;
		}
		else if (p[s].type == LOADWEIGHT){
			unsigned char* tmp = DoPackInstructionWeight(&p[s].i.wt);
			len = InstructionWeightLength;
			memcpy(buf, tmp, len);
			if (len % 4)
				len += (4 - len % 4);
			buf += len;
			continue;
		}
		else if (p[s].type == CREAD){
			unsigned char* tmp = DoPackInstructionRead(&p[s].i.rd);
			len = InstructionReadLength;
			memcpy(buf, tmp, len);
			if (len % 4)
				len += (4 - len % 4);
			buf += len;
			continue;
		}
		else if (p[s].type == CWRITE){
			unsigned char* tmp = DoPackInstructionWrite(&p[s].i.wr);
			len = InstructionWriteLength;
			memcpy(buf, tmp, len);
			if (len % 4)
				len += (4 - len % 4);
			buf += len;
			continue;
		}
		else if (p[s].type == END){
			unsigned char* tmp = DoPackInstructionEnd(&p[s].i.end);
			len = InstructionEndLength;
			memcpy(buf, tmp, len);
			if (len % 4)
				len += (4 - len % 4);
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
	len = buf - ret;
	printf("Instruction total length : %d bytes\n", len);
	return ret;
}
void CModelIF::ReRun(int iter, std::map<unsigned, void *> &out_mp, int osize
	, unsigned char *data, int dsize, bool isDebug, int debugLevel)
{
	FILE *fp = NULL;
	bool fullDebug = false;
	if (isDebug){
        char filename[200];
        sprintf(filename, "d:\\aidata\\Debug%d.txt", iter);
		fp = fopen(filename, "wt");
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
	SEND_STATE state = SEND_FEATURE;
	unsigned char state_buf[INTERFACE_LEN + 8];
	unsigned outlen = 0;
	unsigned char *outPos = NULL;
	int outSize = 0;
	int outcount = 0;
    char netname[100];
    sprintf(netname, "C:\\AI\\udpsend\\udp\\net_in%d.txt", iter);
	FILE *fnet1 = fopen(netname, "wt");
    assert(fnet1);
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
		if (state == SEND_FEATURE){
			unsigned len = INTERFACE_LEN;
			if (outlen + len >= dsize){
				len = dsize - outlen;
				assert(len == INTERFACE_LEN);
				state = SEND_ADDRESS;
				if (fp)
					fprintf(fp, "send address\n");
			}
			state_buf[0] = SEND_FEATURE;
			state_buf[1] = len & 0xff;
			state_buf[2] = len >> 16;
			unsigned addr = osize + outlen;
			memcpy(state_buf + 3, &addr, 4);
			memcpy(state_buf + 7, data + outlen, len);
			pif->SendData(state_buf);
			if (state == SEND_ADDRESS)
				outlen = 0;
			else
				outlen += len;
		}
		else if (state == SEND_ADDRESS){
			state = SEND_DONE;
			state_buf[0] = SEND_ADDRESS;
			state_buf[1] = 0;
			state_buf[2] = 0;
			unsigned addr = osize + dsize;
			memcpy(state_buf + 3, &addr, 4);
			pif->SendData(state_buf);
			outlen = 0;
		}
		
		
		for (p = operations.begin(); p != operations.end(); p++)
			(*p)->progress(i);
		if (fp )
			fflush(fp);
		for (p = operations.begin(); p != operations.end(); p++)
			(*p)->latch(i);
		if (pif->HasOutput()){
			if (outlen == 0){
				assert(outPos == NULL);
				outPos = (unsigned char *)out_mp[pif->GetOutputAddr()];
				//assert(outPos);
				outlen = 0;
				outSize = pif->GetOutputSize();
				if (fp)
					fprintf(fp, "new output at %p, addr %d(%d)\n", outPos, pif->GetOutputAddr(), outSize);
				fprintf(fnet1, "%d\n", outSize);
			}
			for (int k = 0; k < pif->GetOutLen(); k++)
				fprintf(fnet1, " %d", pif->GetOutBuf()[k]);
			fprintf(fnet1, "\n");
			if (outPos){
				memcpy(outPos, pif->GetOutBuf(), pif->GetOutLen());
				outPos += pif->GetOutLen();
			}
			outlen += pif->GetOutLen();

			if (fp)
				fprintf(fp, "\t output at addr %d(%d)\n", outlen, pif->GetOutLen());
			if (outlen >= outSize){
				outlen = 0;
				outSize = 0;
				if (outPos)
					outcount++;
				outPos = NULL;

				if (fp)
					fprintf(fp, "\t output done\n");
				if (outcount == out_mp.size()){
					printf("took %d iterations\n", i);
					fflush(stdout);
					break;
				}
				//fclose(fnet1);
				//return;
			}
		}
		/*if (pgib->IsProcessEnd() && pif->IsIdle()){
			printf("took %d iterations\n", i);
			fflush(stdout);
			break;
		}*/
		if (fp )
			fflush(fp);
	}
	fclose(fnet1);
	if (fp)
		fclose(fp);
	return;
}

void CModelIF::dump_axi(int i)
{
	//input
	if (pif->IsAddressEnable()){
		inst_addr = pif->GetInstAddress();
		fprintf(ffi, " %d\n", inst_addr);
	}
	
	if (pddrd->DataValid(DDR_FEATURE_ID)){
		if (pddrd->GetReqAddr() >= inst_addr){
			fprintf(fii, "%d %d %d", i, pddrd->GetReqAddr(), pddrd->IsLast());
			unsigned char *data = pddrd->DelayData();
			for (int i = 0; i < DDR_DATAWIDTH; i++)
				fprintf(fii, " %d", data[i]);

			fprintf(fii, "\n");
		}
		else{
			fprintf(ffi, "%d %d %d", i, pddrd->GetReqAddr(), pddrd->IsLast());
			unsigned char *data = pddrd->DelayData();
			for (int i = 0; i < DDR_DATAWIDTH; i++)
				fprintf(ffi, " %d", data[i]);

			fprintf(ffi, "\n");
		}
	}

	if (pddrw->DataValid(DDR_WEIGHT_ID)){
		fprintf(fwi, "%d %d %d", i, pddrw->GetReqAddr(), pddrw->IsLast());

		unsigned char *data = pddrw->DelayData();
		for (int i = 0; i < PS_DDR_DATAWIDTH; i++)
			fprintf(fwi, " %d", data[i]);

		fprintf(fwi, "\n");
	}

	//output
	pddrd->dump_axi(i, ffro, ffwo, fio, inst_addr);
	pddrw->dump_axi(i, fwro, NULL, NULL, 0);
}

void CModelIF::Run(GlobalInstruction *p, std::map<unsigned, void *> &out_mp, int osize, unsigned char * wt, int wsize
	, unsigned char *data, int dsize, bool isDebug, DumpInfo * head, int debugLevel, unsigned baseWAddr)
{
	//debugLevel = 3;
	//isDebug = false;
    int iter = 0;
    int totalIter = 1;
	FILE *fp = NULL;
	bool fullDebug = false;
	//printf("out mp size %d\n", out_mp.size());
	if (isDebug){
		char outname[200];
		sprintf(outname, "%s/Debug.txt", OUTPUT_DIR);
		fp = fopen(outname, "wt");
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
	int ilen;
	unsigned char *buf = EncodeInstructions(pp, ilen);
	ilen = (ilen & (~(ALIGN_LEN - 1))) + ALIGN_LEN;

	//paddrBuf->Push((ADDR_TYPE)buf);

	//pif->SetWeights(wt, 0, wsize);
	//pif->SetInstructions(buf, osize+dsize, ilen);
	//pif->SetFeatures(data, osize, dsize);
	//pif->SetStartInstruction(osize + dsize);

	//weight and feature/instruction different memories, instructions can use a seperate memory too
	//feature memory layout : internal features -> input feauture -> instructions (increasing addr)
	{
		int fd = open("test.rv", O_WRONLY | O_CREAT, _S_IREAD | _S_IWRITE);
		const int wt_sz = 32;
		int iter = 10;
		int pass = 100;
		char flag;
		unsigned addr, sz;

		unsigned char tmp[wt_sz];
		for (int i = 0; i < wt_sz; i++)
			tmp[i] = -1;
		assert(fd);
		for (int i = 0; i < iter; i++){
			flag = 3; //weight
			addr = 0x12345678;
			sz = pass * wt_sz;
			write(fd, &flag, sizeof(flag));
			write(fd, &addr, sizeof(addr));
			write(fd, &sz, sizeof(sz));
			assert(sz % wt_sz == 0);
			for (int i = 0; i < sz; i += wt_sz)
			write(fd, tmp, wt_sz);
		}
		flag = 1; //weight
		addr = 0xdeadbeaf;
		sz = 0;
		write(fd, &flag, sizeof(flag));
		write(fd, &addr, sizeof(addr));
		write(fd, &sz, sizeof(sz));
		close(fd);
	}
	{
		int fd = open("deep.rv", O_WRONLY | O_BINARY  | O_CREAT, _S_IREAD | _S_IWRITE);
		int wt_sz = 32;
		assert(fd);
		char flag;
		unsigned addr, sz;
		

		flag = 1; //instruction
		addr = osize + dsize;
		sz = ilen;
		write(fd, &flag, sizeof(flag));
		write(fd, &addr, sizeof(addr));
		write(fd, &sz, sizeof(sz));
		assert(sz % wt_sz == 0);
		for (int i = 0; i < sz; i += wt_sz){
			_write(fd, buf + i, wt_sz);
			if (i % (100 * wt_sz) == 0)
				printf("%d : %x\n", i, buf[i]);
		}

		
		flag = 2; //input feature
		addr = osize;
		sz = dsize;
		write(fd, &flag, sizeof(flag));
		write(fd, &addr, sizeof(addr));
		write(fd, &sz, sizeof(sz));
		assert(sz % wt_sz == 0);
		for (int i = 0; i < sz; i += wt_sz)
			write(fd, data + i, wt_sz);

		flag = 0; //weight
		addr = baseWAddr;
		sz = wsize;
		write(fd, &flag, sizeof(flag));
		write(fd, &addr, sizeof(addr));
		write(fd, &sz, sizeof(sz));
		assert(sz % wt_sz == 0);
		for (int i = 0; i < sz; i += wt_sz)
			write(fd, wt + i, wt_sz);
			
		for (int s = 0;; s++){
			if (pp[s].type == END){
				flag = 3; //output
				addr = pp[s].i.end.oAddr;
				sz = pp[s].i.end.oSize;
				write(fd, &flag, sizeof(flag));
				write(fd, &addr, sizeof(addr));
				write(fd, &sz, sizeof(sz));
				if (pp[s].type == END && !pp[s].i.end.hasMore)
					break;
			}
		}

		flag = 4; //instruction start
		addr = osize + dsize;
		sz = 0;
		write(fd, &flag, sizeof(flag));
		write(fd, &addr, sizeof(addr));
		write(fd, &sz, sizeof(sz));
		close(fd);
	}
	if (DUMP_VERIFICATION_AXI){
		int wt_sz = 32;
		char filename[100];
		sprintf(filename, "%s/axi_input.txt", OUTPUT_DIR);
		FILE *fd = fopen(filename, "wt");
		assert(fd);
		fprintf(fd, "%d\n", osize + dsize);

		char flag;
		unsigned addr, sz;


		flag = 1; //instruction
		addr = osize + dsize;
		sz = ilen;
		fprintf(fd, "%d %d %d\n", flag, addr, sz);
		for (int i = 0; i < sz; i += wt_sz){
			for (int j = 0; j < wt_sz; j++)
				fprintf(fd, " %d", buf[i + j]);
			fprintf(fd, "\n");
		}


		flag = 2; //input feature
		addr = osize;
		sz = dsize;
		fprintf(fd, "%d %d %d\n", flag, addr, sz);
		for (int i = 0; i < sz; i += wt_sz){
			for (int j = 0; j < wt_sz; j++)
				fprintf(fd, " %d", data[i + j]);
			fprintf(fd, "\n");
		}

		flag = 0; //weight
		addr = baseWAddr;
		sz = wsize;
		fprintf(fd, "%d %d %d\n", flag, addr, sz);
		for (int i = 0; i < sz; i += wt_sz){
			for (int j = 0; j < wt_sz; j++)
				fprintf(fd, " %d", wt[i + j]);
			fprintf(fd, "\n");
		}
		fclose(fd);
	}
	/*{
		int fd = open("deep.rv", O_RDONLY | O_BINARY, _S_IREAD);
		const int wt_sz = 32;
		assert(fd);
		char flag;
		unsigned addr, sz;
		unsigned char tmp[wt_sz];
		int num; 
		for (;;){
			read(fd, &flag, sizeof(flag));
			read(fd, &addr, sizeof(addr));
			read(fd, &sz, sizeof(sz));

			if (flag == 1){
				for (int i = 0; i < sz; i += num){
					num = read(fd, tmp, wt_sz);
					if (num == 0)
						printf("errno %d \n", errno);
					for (int j = 0; j < num; j++)
						if (tmp[j] != buf[i + j])
							printf("%d  %d : %d %d %d\n", i, j, num, tmp[j], buf[i + j]);
				}
			}
			else if (flag == 4)
				break;
		}
		close(fd);
	}*/
	delete[]pp;
	SEND_STATE state = SEND_WEIGHT;
	unsigned char state_buf[INTERFACE_LEN + 8];
	int countd = -1;
	unsigned outlen = 0;
    unsigned reclen = 0;
	unsigned char *outPos = NULL;
	int outSize = 0;
	int outcount = 0;
	FILE *fnet = fopen("C:\\AI\\udpsend\\udp\\net_out.txt", "wt");
	FILE *fnet1 = fopen("C:\\AI\\udpsend\\udp\\net_in.txt", "wt");
	assert(fnet);
	assert(fnet1);
	for (int i = 0;; i++){
		std::vector<CSimNode *>::const_iterator p;
		if (fp && fullDebug)
			fprintf(fp, "iter %d\n", i);
		/*if (i >= 13898488){
			for (p = operations.begin(); p != operations.end(); p++)
				(*p)->DumpState();
			fflush(fp);
			printf("\7");
		}
		if (i == 13898482){
			fullDebug = true;
			std::vector<CSimNode *>::const_iterator pp = operations.begin();
			for (; pp != operations.end(); pp++){
				(*pp)->SetDebugLevel(1);
			}
		}*/
		if (state == SEND_WEIGHT){
			unsigned len = INTERFACE_LEN;
			if (outlen + len >= wsize){
				len = wsize - outlen;
#ifdef YOLO
				assert(len == INTERFACE_LEN);
#endif
				state = SEND_INSTRUCTION;
				if(fp)
					fprintf(fp, "send instructions %d\n", osize + dsize);
			}
			state_buf[0] = SEND_WEIGHT;
			state_buf[1] = len & 0xff;
			state_buf[2] = len >> 8;
			//memcpy(state_buf + 3, &outlen, 4);
			unsigned addr = baseWAddr  + outlen;
			memcpy(state_buf + 3, &addr, 4);
			memcpy(state_buf + 7, wt + outlen, len);
			pif->SendData(state_buf);
			fprintf(fnet, "%d %d %d", SEND_WEIGHT, len, baseWAddr + outlen);
			for (int k = 0; k < len; k++)
				fprintf(fnet, " %d", wt[outlen + k]);
			fprintf(fnet, "\n");
			
			if (state == SEND_INSTRUCTION)
				outlen = 0;
			else
				outlen += len;

		}
		else if (state == SEND_INSTRUCTION){
			unsigned len = INTERFACE_LEN;
			if (outlen + len >= ilen){
				len = ilen - outlen;
#ifdef YOLO
				assert(len == INTERFACE_LEN);
#endif
				state = SEND_FEATURE;
				if (fp)
					fprintf(fp, "send features %d\n", osize);
			}
			state_buf[0] = SEND_INSTRUCTION;
			state_buf[1] = len & 0xff;
			state_buf[2] = len >> 8;
			unsigned addr = osize + dsize + outlen;
			memcpy(state_buf + 3, &addr, 4);
			memcpy(state_buf + 7, buf + outlen, len);
			pif->SendData(state_buf);
			fprintf(fnet, "%d %d %d", SEND_INSTRUCTION, len, osize + dsize + outlen);
			for (int k = 0; k < len; k++)
				fprintf(fnet, " %d", buf[outlen + k]);
			fprintf(fnet, "\n");
			if (state == SEND_FEATURE)
				outlen = 0;
			else
				outlen += len;
		}		
		else if (state == SEND_FEATURE){
			unsigned len = INTERFACE_LEN;
			if (outlen + len >= dsize){
				len = dsize - outlen;
#ifdef YOLO
				assert(len == INTERFACE_LEN);
#endif
				state = SEND_ADDRESS;
				if (fp)
					fprintf(fp, "send address\n");
			}
			state_buf[0] = SEND_FEATURE;
			state_buf[1] = len & 0xff;
			state_buf[2] = len >> 8;
			unsigned addr = osize + outlen;
			memcpy(state_buf + 3, &addr, 4);
			memcpy(state_buf + 7, data + outlen, len);
			pif->SendData(state_buf);
            if(iter == 0){
                fprintf(fnet, "%d %d %d", SEND_FEATURE, len, osize + outlen);
                for (int k = 0; k < len; k++)
                    fprintf(fnet, " %d", data[outlen + k]);
                fprintf(fnet, "\n");
            }
			if (state == SEND_ADDRESS)
				outlen = 0;
			else
				outlen += len;
		}
		else if (state == SEND_ADDRESS){
			state = SEND_DONE;
			state_buf[0] = SEND_ADDRESS;
			state_buf[1] = 0;
			state_buf[2] = 0;
			unsigned addr = osize + dsize;
			memcpy(state_buf + 3, &addr, 4);
			pif->SendData(state_buf);
            if(iter == 0){
                fprintf(fnet, "%d %d\n", SEND_ADDRESS, osize + dsize);
                fflush(fnet);
            }
			outlen = 0;
		}
		
		
		for (p = operations.begin(); p != operations.end(); p++)
			(*p)->progress(i);
		if (0 && DUMP_VERIFICATION_AXI && (state == SEND_ADDRESS || state == SEND_DONE))
			dump_axi(i);
		if (fp )
			fflush(fp);
		for (p = operations.begin(); p != operations.end(); p++)
			(*p)->latch(i);
		if (pif->HasOutput()){
			if (reclen == 0){
				assert(outPos == NULL);
				if (out_mp.find(pif->GetOutputAddr()) != out_mp.end())
					outPos = (unsigned char *)out_mp[pif->GetOutputAddr()];
				//assert(outPos);
				outSize = pif->GetOutputSize();
				if (fp)
					fprintf(fp, "new output at %p, addr %d(%d)\n", outPos, pif->GetOutputAddr(), outSize);
				fprintf(fnet1, "%d\n", outSize);
			}
			for (int k = 0; k < pif->GetOutLen(); k++){
				fprintf(fnet1, " %d", pif->GetOutBuf()[k]);
				if (DUMP_VERIFICATION_AXI)
					fprintf(fio, " %d", pif->GetOutBuf()[k]);
			}
			fprintf(fnet1, "\n");
			if (outPos){
				memcpy(outPos, pif->GetOutBuf(), pif->GetOutLen());
				outPos += pif->GetOutLen();
			}
			reclen += pif->GetOutLen();

			if (fp)
				fprintf(fp, "\t output at addr %d(%d)\n", reclen, pif->GetOutLen());
			if (reclen >= outSize){
				reclen = 0;
				outSize = 0;
				if (outPos)
					outcount++;
				outPos = NULL;
				//printf("output done %d (%d)\n", outcount, out_mp.size());
				fflush(fnet1);
				fflush(fio);
				if (fp)
					fprintf(fp, "\t output done\n");
                if (outcount == out_mp.size()){
					printf("took %d iterations\n", i);
					fflush(stdout);
					iter++;
					if (iter >= totalIter)
                        break;
                    outcount = 0;
                    fclose(fnet1);
                    char netname[100];
                    sprintf(netname, "C:\\AI\\udpsend\\udp\\net_in%d.txt", iter);
                    fnet1 = fopen(netname, "wt");
                    assert(fnet1);
                    if(fp){
                        fclose(fp);
                        char filename[200];
                        sprintf(filename, "d:\\aidata\\Debug%d.txt", iter);
                        fp = fopen(filename, "wt");
                        assert(fp);
                        std::vector<CSimNode *>::const_iterator pp = operations.begin();
                        for (; pp != operations.end(); pp++){
                            (*pp)->SetDebug(fp);
                        }
                    }
				}
				else if (outcount == 1){
					if (iter < totalIter - 1){
						state = SEND_FEATURE;
						outlen = 0;
					}
				}
				//fclose(fnet1);
				//return;
			}
		}
		/*if (pgib->IsProcessEnd() && pif->IsIdle()){
			printf("took %d iterations\n", i);
			fflush(stdout);
			break;
		}*/
		if (fp )
			fflush(fp);
		if (head && iter == 0){
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
	fclose(fnet);
	fclose(fnet1);
	delete []buf;
	if (fp)
		fclose(fp);
    //for(int i = 0; i < 10; i++)
    //    ReRun(i, out_mp, osize, data, dsize, isDebug, debugLevel);
	return;
}
void CModelIF::Dump(DumpInfo *pdi, int i)
{
	static int lastI = 0;
	printf("dump file %s i = %d (%d), len %d, addr %p\n", pdi->name.c_str(), i, i - lastI, pdi->len, pdi->start);
	lastI = i;
	//return;
	FILE *fp = fopen(pdi->name.c_str(), "wt");
	fprintf(fp, "%d\n", pdi->len);
	char *ptr = (char *)pdi->start;
	ptr = (char *)pddrd->GetAddress(pdi->start);
	/*if (pdi->isA){
		ptr = prama->GetAddress(pdi->start);
	}
	else if (pdi->isB){
		ptr = pramb->GetAddress(pdi->start);
	}*/
	for (int i = 0; i < pdi->len; i++)
		fprintf(fp, DFMT"\n", ptr[i]);
	fclose(fp);
}

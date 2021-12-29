#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"


FILE *fin;
FILE *fout;
//token set ignore for bank not 0
void init_files() 
{
	fin = fopen("D:/aidata/bank3_processinstruction_input.txt", "rt");
	fout = fopen("D:/aidata/bank3_processinstruction_output.txt", "rt");
	assert(fin);
	assert(fout);
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(processInstruction_inputs* in_data)
{
	int num;
	int enable;
	int pwrite_isFetchNextInst;
	int pib_empty;
	int hasNextFeatureParams;
	int new_params_prefetch;
	int new_readPos;
	int new_writeWidth;
	int new_volumeSize;
	int new_reqSeqF;

	int Id;
	int itype;
	int reqSeqNum;
	int reqProgress;
	int reqSeqNumW;
	int reqProgressW;
	int seqNum;
	int W;
	int H;
	int C;
	int Waddr;
	int WEnd;
	int weightPos;
	int ReadPos;
	int ResPos;
	int W1;
	int H1;
	int X;
	int Y;
	int S;
	int lPad;
	int rPad;
	int K;
	int M;
	int Kh;
	int Ks;
	int Kt;
	int Res_addr;
	int wScale;
	int fScale;
	int wLRelu;
	int weightToken;
	int maxpool_size;
	int maxpool_stride;
	int mode;
	int isResMaster;
	int isProgressMaster;
	int isRaddr_a;
	int doRes;
	int doRelu;
	int doLRelu;
	int doBM;
	int doUpSample;
	int newWriteInst;
	int outbufsize;
	int ofsize;
	int outyx;
	int outputAddrGap;
	int outkh;
	int ng;
	int gu;
	int resSize;
	int resSizeLast;
	int resLen;
	int resLenLast;
	int pfs;
	int volumeSize;
	int kCurLast;
	int wtotal_n;
	int wtotalLast;
	int wlenk_regular;
	int wlenk_nLast;
	int wlenk_nLast2;
	int totalRes;
	int new_conv_inst;

	if(EOF == fscanf(fin, "%d", &num))
		exit(0);
	printf("read %d\n", num);

	fscanf(fin, " %d %d %d", &enable, &pwrite_isFetchNextInst, &pib_empty);
	fscanf(fin, " %d %d %d %d %d %d %d", &hasNextFeatureParams, &new_params_prefetch
			, &new_readPos, &new_writeWidth
			, &new_volumeSize, &new_reqSeqF, &new_conv_inst);

	in_data->enable = enable;
	in_data->pwrite_isFetchNextInst = pwrite_isFetchNextInst;
	in_data->pib_empty = pib_empty;
	in_data->hasNextFeatureParams = hasNextFeatureParams;
	in_data->new_params_prefetch = new_params_prefetch;
	in_data->new_readPos->aval = new_readPos;
	in_data->new_readPos->bval = 0;
	in_data->new_writeWidth->aval = new_writeWidth;
	in_data->new_writeWidth->bval = 0;
	in_data->new_volumeSize->aval = new_volumeSize;
	in_data->new_volumeSize->bval = 0;
	in_data->new_reqSeqF->aval = new_reqSeqF;
	in_data->new_reqSeqF->bval = 0;

	if(new_conv_inst){
		fscanf(fin, " %d %d %d %d %d %d %d %d\n", &Id, &itype
				, &reqSeqNum, &reqProgress, &reqSeqNumW
				, &reqProgressW, &seqNum, &W);

		fscanf(fin, " %d %d %d %d %d %d %d %d\n", &H, &C
				, &Waddr, &WEnd, &weightPos
				, &ReadPos, &ResPos, &W1);
		fscanf(fin, " %d %d %d %d %d %d %d %d\n", &H1, &X
				, &Y, &S, &lPad
				, &rPad, &K, &M);
		fscanf(fin, " %d %d %d %d %d %d %d\n", &Kh, &Ks
				, &Kt, &Res_addr, &wScale
				, &fScale, &wLRelu);
		fscanf(fin, " %d %d %d %d %d %d %d\n", &weightToken, &maxpool_size
				, &maxpool_stride, &mode, &isResMaster
				, &isProgressMaster, &isRaddr_a);
		fscanf(fin, " %d %d %d %d %d %d %d %d\n", &doRes, &doRelu
				, &doLRelu, &doBM, &doUpSample
				, &newWriteInst, &outbufsize, &ofsize);
		fscanf(fin, " %d %d %d %d %d %d %d %d\n", &outyx, &outputAddrGap
				, &outkh, &ng, &gu
				, &resSize, &resSizeLast, &resLen);
		fscanf(fin, " %d %d %d %d %d %d %d %d\n", &resLenLast, &pfs
				, &volumeSize, &kCurLast, &wtotal_n
				, &wtotalLast, &wlenk_regular, &wlenk_nLast);
		fscanf(fin, " %d %d", &wlenk_nLast2, &totalRes);

		in_data->inst.isResMaster = isResMaster;
		in_data->inst.isProgressMaster = isProgressMaster;
		in_data->inst.isRaddr_a = isRaddr_a;
		in_data->inst.doRes = doRes;
		in_data->inst.doRelu = doRelu;
		in_data->inst.doLRelu = doLRelu;
		in_data->inst.doBM = doBM;
		in_data->inst.doUpSample = doUpSample;
		in_data->inst.newWriteInst = newWriteInst;

		in_data->inst.Id->aval = Id;
		in_data->inst.Id->bval = 0;
		in_data->inst.itype->aval = itype;
		in_data->inst.itype->bval = 0;
		in_data->inst.reqSeqNum->aval = reqSeqNum;
		in_data->inst.reqSeqNum->bval = 0;
		in_data->inst.reqProgress->aval = reqProgress;
		in_data->inst.reqProgress->bval = 0;
		in_data->inst.reqSeqNumW->aval = reqSeqNumW;
		in_data->inst.reqSeqNumW->bval = 0;
		in_data->inst.reqProgressW->aval = reqProgressW;
		in_data->inst.reqProgressW->bval = 0;
		in_data->inst.seqNum->aval = seqNum;
		in_data->inst.seqNum->bval = 0;
		in_data->inst.W->aval = W;
		in_data->inst.W->bval = 0;
		in_data->inst.H->aval = H;
		in_data->inst.H->bval = 0;
		in_data->inst.C->aval = C;
		in_data->inst.C->bval = 0;
		in_data->inst.Waddr->aval = Waddr;
		in_data->inst.Waddr->bval = 0;
		in_data->inst.WEnd->aval = WEnd;
		in_data->inst.WEnd->bval = 0;
		in_data->inst.weightPos->aval = weightPos;
		in_data->inst.weightPos->bval = 0;
		in_data->inst.ReadPos->aval = ReadPos;
		in_data->inst.ReadPos->bval = 0;
		in_data->inst.ResPos->aval = ResPos;
		in_data->inst.ResPos->bval = 0;
		in_data->inst.W1->aval = W1;
		in_data->inst.W1->bval = 0;
		in_data->inst.H1->aval = H1;
		in_data->inst.H1->bval = 0;
		in_data->inst.X->aval = X;
		in_data->inst.X->bval = 0;
		in_data->inst.Y->aval = Y;
		in_data->inst.Y->bval = 0;
		in_data->inst.S->aval = S;
		in_data->inst.S->bval = 0;
		in_data->inst.lPad->aval = lPad;
		in_data->inst.lPad->bval = 0;
		in_data->inst.rPad->aval = rPad;
		in_data->inst.rPad->bval = 0;
		in_data->inst.K->aval = K;
		in_data->inst.K->bval = 0;
		in_data->inst.M->aval = M;
		in_data->inst.M->bval = 0;
		in_data->inst.Kh->aval = Kh;
		in_data->inst.Kh->bval = 0;
		in_data->inst.Ks->aval = Ks;
		in_data->inst.Ks->bval = 0;
		in_data->inst.Kt->aval = Kt;
		in_data->inst.Kt->bval = 0;
		in_data->inst.Res_addr->aval = Res_addr;
		in_data->inst.Res_addr->bval = 0;
		in_data->inst.wScale->aval = wScale;
		in_data->inst.wScale->bval = 0;
		in_data->inst.fScale->aval = fScale;
		in_data->inst.fScale->bval = 0;
		in_data->inst.wLRelu->aval = wLRelu;
		in_data->inst.wLRelu->bval = 0;
		in_data->inst.weightToken->aval = weightToken;
		in_data->inst.weightToken->bval = 0;
		in_data->inst.maxpool_size->aval = maxpool_size;
		in_data->inst.maxpool_size->bval = 0;
		in_data->inst.maxpool_stride->aval = maxpool_stride;
		in_data->inst.maxpool_stride->bval = 0;
		in_data->inst.mode->aval = mode;
		in_data->inst.mode->bval = 0;
		in_data->inst.outbufsize->aval = outbufsize;
		in_data->inst.outbufsize->bval = 0;
		in_data->inst.ofsize->aval = ofsize;
		in_data->inst.ofsize->bval = 0;
		in_data->inst.outyx->aval = outyx;
		in_data->inst.outyx->bval = 0;
		in_data->inst.outputAddrGap->aval = outputAddrGap;
		in_data->inst.outputAddrGap->bval = 0;
		in_data->inst.outkh->aval = outkh;
		in_data->inst.outkh->bval = 0;
		in_data->inst.ng->aval = ng;
		in_data->inst.ng->bval = 0;
		in_data->inst.gu->aval = gu;
		in_data->inst.gu->bval = 0;
		in_data->inst.resSize->aval = resSize;
		in_data->inst.resSize->bval = 0;
		in_data->inst.resSizeLast->aval = resSizeLast;
		in_data->inst.resSizeLast->bval = 0;
		in_data->inst.resLen->aval = resLen;
		in_data->inst.resLen->bval = 0;
		in_data->inst.resLenLast->aval = resLenLast;
		in_data->inst.resLenLast->bval = 0;
		in_data->inst.pfs->aval = pfs;
		in_data->inst.pfs->bval = 0;
		in_data->inst.volumeSize->aval = volumeSize;
		in_data->inst.volumeSize->bval = 0;
		in_data->inst.kCurLast->aval = kCurLast;
		in_data->inst.kCurLast->bval = 0;
		in_data->inst.wtotal_n->aval = wtotal_n;
		in_data->inst.wtotal_n->bval = 0;
		in_data->inst.wtotalLast->aval = wtotalLast;
		in_data->inst.wtotalLast->bval = 0;
		in_data->inst.wlenk_regular->aval = wlenk_regular;
		in_data->inst.wlenk_regular->bval = 0;
		in_data->inst.wlenk_nLast->aval = wlenk_nLast;
		in_data->inst.wlenk_nLast->bval = 0;
		in_data->inst.wlenk_nLast2->aval = wlenk_nLast2;
		in_data->inst.wlenk_nLast2->bval = 0;
		in_data->inst.totalRes->aval = totalRes;
		in_data->inst.totalRes->bval = 0;
		
		
	}


}



void compare_outputs(const processInstruction_outputs* out_data)
{
	int num;
	int pib_en;
    int new_conv_inst;
    int inst_k;
    int curSeq;
    int reqSeq;
    int reqProgress;
    int isProgressMaster;
    int token_set;
    int k;
    int stride;
    int outW;
    int new_outputBufH1;
    int outputBufH1Orig;
    int outputBufW1;
    int outBufFrameSize;
    int outFrameSize;
    int outputAddrGap;
    int outFrameGapSize;
    int maxpool_stride;
    int new_outputAddr;
    int new_outputFrameStart;
    int numGroups;
    int token;
    int isResMaster;
    int readPos;
    int resPos;
    int leftPad;
    int new_readWidth;
    int writeWidth;
    int readCLast;
    int topPad;
    int downPad;
    int new_rowAddr;
    int new_rowNum;
    int reqSeqF;
    int new_kCur;
    int new_kOut;
    int Ks;
    int kt;
    int new_usedGroups;
    int new_resSize;
    int new_resReadSize;
    int new_resFrameMax;
    int doRes;
    int doRelu;
    int doLRelu;
    int doBM;
    int doUpSample;
    int newWriteInst;
    int wLRelu;
    int new_wtotal;
    int new_resFrameCount;
    int new_resRowCount;
    int new_isReadResA;
    int new_nextResAddr;
    int new_frameResAddr;
    int new_resLen;
    int new_outResGapSize;
    int new_kRes;
    int prefetchFrameSize;
    int volumeSize;
    int curVolumeSize;
    int mode;
    int fScale;
    int wScale;
    int new_addrNextFrame;
    int totalRes;
    int usedGroupsLast;
    int usedCGLast;
    int usedCG0;
    int kCurLast;
    int resSize0;
    int resSizeLast;
    int resLen0;
    int resLenLast;
    int wtotal_n;
    int wlenk_nLast;
    int wtotalLast;
    int wlenk_nLast2;
    int wlenk_regular;
    int wlen_regular;
    int new_wlenk;
    int new_wlenk_last;
    int kCurLast_1;
    int new_maxRowCount;
    int new_lastLen;
    int val;

	if(EOF ==fscanf(fout, "%d", &num))
		exit(0);
	printf("output %d\n", num);

	
	fscanf(fout, " %d %d %d %d %d %d %d %d\n", &pib_en, &new_conv_inst
		, &inst_k, &curSeq, &reqSeq
		, &reqProgress, &isProgressMaster, &token_set);
	fscanf(fout, " %d %d %d %d %d %d %d %d\n", &k, &stride
		, &outW, &outputBufH1Orig, &outputBufW1
		, &outBufFrameSize, &outFrameSize, &outputAddrGap);
	
	fscanf(fout, " %d %d %d %d %d %d %d %d\n", &outFrameGapSize, &maxpool_stride
		, &numGroups, &token, &isResMaster
		, &readPos, &resPos, &leftPad);
	fscanf(fout, " %d %d %d %d %d %d %d %d\n", &writeWidth, &readCLast
		, &topPad, &downPad, &reqSeqF
		, &Ks, &kt, &doRes);
	fscanf(fout, " %d %d %d %d %d %d %d %d\n", &doRelu, &doLRelu
		, &doBM, &doUpSample, &newWriteInst
		, &wLRelu, &prefetchFrameSize, &volumeSize);
	fscanf(fout, " %d %d %d %d %d %d %d\n", &curVolumeSize, &mode
		, &fScale, &wScale
		, &totalRes, &usedGroupsLast, &usedCGLast);
	fscanf(fout, " %d %d %d %d %d %d %d %d\n", &usedCG0, &kCurLast
		, &resSize0, &resSizeLast, &resLen0
		, &resLenLast, &wtotal_n, &wlenk_nLast);
	fscanf(fout, " %d %d %d %d %d", &wtotalLast, &wlenk_nLast2
		, &wlenk_regular, &wlen_regular, &kCurLast_1);
#ifdef S2_OPTIMIZE
	fscanf(fout, " %d", &isStride2);
	if(new_conv_inst)
		fscanf(fout, " %d %d", &new_nextRowStart, &new_kIter);
#endif
	if(new_conv_inst){
		fscanf(fout, " %d %d %d %d %d %d %d %d\n", &new_wlenk, &new_wlenk_last
			, &new_maxRowCount, &new_lastLen, &new_outputBufH1
			, &new_outputAddr, &new_outputFrameStart, &new_readWidth);
		fscanf(fout, " %d %d %d %d %d %d %d %d\n", &new_rowAddr, &new_rowNum
			, &new_kCur, &new_kOut, &new_usedGroups
			, &new_resSize, &new_resReadSize, &new_resFrameMax);
		fscanf(fout, " %d %d %d\n"
			, &new_wtotal, &new_resFrameCount, &new_resRowCount);
		fscanf(fout, " %d %d %d %d %d %d %d\n", &new_isReadResA, &new_nextResAddr
			, &new_frameResAddr, &new_resLen, &new_outResGapSize
			, &new_kRes, &new_addrNextFrame);
		
	
	}

	if (out_data->pib_en != pib_en)
		printf("\t pib_en %d vs %d\n", out_data->pib_en, pib_en);
	if (out_data->new_conv_inst != new_conv_inst)
		printf("\t new_conv_inst %d vs %d\n", out_data->new_conv_inst, new_conv_inst);
	if (out_data->isProgressMaster != isProgressMaster)
		printf("\t isProgressMaster %d vs %d\n", out_data->isProgressMaster, isProgressMaster);
	if (out_data->token_set != token_set)
		printf("\t token_set %d vs %d\n", out_data->token_set, token_set);
	if (out_data->isResMaster != isResMaster)
		printf("\t isResMaster %d vs %d\n", out_data->isResMaster, isResMaster);
	if (out_data->doRes != doRes)
		printf("\t doRes %d vs %d\n", out_data->doRes, doRes);
	if (out_data->doRelu != doRelu)
		printf("\t doRelu %d vs %d\n", out_data->doRelu, doRelu);
	if (out_data->doLRelu != doLRelu)
		printf("\t doLRelu %d vs %d\n", out_data->doLRelu, doLRelu);
	if (out_data->doBM != doBM)
		printf("\t doBM %d vs %d\n", out_data->doBM, doBM);
	if (out_data->doUpSample != doUpSample)
		printf("\t doUpSample %d vs %d\n", out_data->doUpSample, doUpSample);
	if (out_data->newWriteInst != newWriteInst)
		printf("\t newWriteInst %d vs %d\n", out_data->newWriteInst, newWriteInst);

	if (out_data->curSeq->aval != curSeq)
		printf("\t curSeq %d vs %d\n", out_data->curSeq->aval, curSeq);
	if (out_data->reqSeq->aval != reqSeq)
		printf("\t reqSeq %d vs %d\n", out_data->reqSeq->aval, reqSeq);
	if (out_data->reqProgress->aval != reqProgress)
		printf("\t reqProgress %d vs %d\n", out_data->reqProgress->aval, reqProgress);
	if (out_data->k->aval != k)
		printf("\t k %d vs %d\n", out_data->k->aval, k);
	if (out_data->stride->aval != stride)
		printf("\t stride %d vs %d\n", out_data->stride->aval, stride);
	if (out_data->outW->aval != outW)
		printf("\t outW %d vs %d\n", out_data->outW->aval, outW);
	if (out_data->outputBufH1Orig->aval != outputBufH1Orig)
		printf("\t outputBufH1Orig %d vs %d\n", out_data->outputBufH1Orig->aval, outputBufH1Orig);
	if (out_data->outputBufW1->aval != outputBufW1)
		printf("\t outputBufW1 %d vs %d\n", out_data->outputBufW1->aval, outputBufW1);
	if (out_data->outBufFrameSize->aval != outBufFrameSize)
		printf("\t outBufFrameSize %d vs %d\n", out_data->outBufFrameSize->aval, outBufFrameSize);
	if (out_data->outFrameSize->aval != outFrameSize)
		printf("\t outFrameSize %d vs %d\n", out_data->outFrameSize->aval, outFrameSize);
	if (out_data->outputAddrGap->aval != outputAddrGap)
		printf("\t outputAddrGap %d vs %d\n", out_data->outputAddrGap->aval, outputAddrGap);
	if (out_data->outFrameGapSize->aval != outFrameGapSize)
		printf("\t outFrameGapSize %d vs %d\n", out_data->outFrameGapSize->aval, outFrameGapSize);
	if (out_data->maxpool_stride->aval != maxpool_stride)
		printf("\t maxpool_stride %d vs %d\n", out_data->maxpool_stride->aval, maxpool_stride);
	if (out_data->numGroups->aval != numGroups)
		printf("\t numGroups %d vs %d\n", out_data->numGroups->aval, numGroups);
	if (out_data->token->aval != token)
		printf("\t token %d vs %d\n", out_data->token->aval, token);
	if (out_data->readPos->aval != readPos)
		printf("\t readPos %d vs %d\n", out_data->readPos->aval, readPos);
	if (out_data->resPos->aval != resPos)
		printf("\t resPos %d vs %d\n", out_data->resPos->aval, resPos);
	if (out_data->leftPad->aval != leftPad)
		printf("\t leftPad %d vs %d\n", out_data->leftPad->aval, leftPad);
	if (out_data->writeWidth->aval != writeWidth)
		printf("\t writeWidth %d vs %d\n", out_data->writeWidth->aval, writeWidth);
	if (out_data->readCLast->aval != readCLast)
		printf("\t readCLast %d vs %d\n", out_data->readCLast->aval, readCLast);
	if (out_data->topPad->aval != topPad)
		printf("\t topPad %d vs %d\n", out_data->topPad->aval, topPad);
	if (out_data->downPad->aval != downPad)
		printf("\t downPad %d vs %d\n", out_data->downPad->aval, downPad);
	if (out_data->reqSeqF->aval != reqSeqF)
		printf("\t reqSeqF %d vs %d\n", out_data->reqSeqF->aval, reqSeqF);
	if (out_data->Ks->aval != Ks)
		printf("\t Ks %d vs %d\n", out_data->Ks->aval, Ks);
	if (out_data->kt->aval != kt)
		printf("\t kt %d vs %d\n", out_data->kt->aval, kt);
	val = SV_GET_SIGNED_BITS(out_data->wLRelu->aval, 15);
	if (val != wLRelu)
		printf("\t wLRelu %d vs %d\n", val, wLRelu);
	if (out_data->prefetchFrameSize->aval != prefetchFrameSize)
		printf("\t prefetchFrameSize %d vs %d\n", out_data->prefetchFrameSize->aval, prefetchFrameSize);
	if (out_data->volumeSize->aval != volumeSize)
		printf("\t volumeSize %d vs %d\n", out_data->volumeSize->aval, volumeSize);
	if (out_data->curVolumeSize->aval != curVolumeSize)
		printf("\t curVolumeSize %d vs %d\n", out_data->curVolumeSize->aval, curVolumeSize);
	if (out_data->mode->aval != mode)
		printf("\t mode %d vs %d\n", out_data->mode->aval, mode);
	if (out_data->fScale->aval != fScale)
		printf("\t fScale %d vs %d\n", out_data->fScale->aval, fScale);
	if (out_data->wScale->aval != wScale)
		printf("\t wScale %d vs %d\n", out_data->wScale->aval, wScale);
	if (out_data->totalRes->aval != totalRes)
		printf("\t totalRes %d vs %d\n", out_data->totalRes->aval, totalRes);
	if (out_data->usedGroupsLast->aval != usedGroupsLast)
		printf("\t usedGroupsLast %d vs %d\n", out_data->usedGroupsLast->aval, usedGroupsLast);
	if (out_data->usedCGLast->aval != usedCGLast)
		printf("\t usedCGLast %d vs %d\n", out_data->usedCGLast->aval, usedCGLast);
	if (out_data->usedCG0->aval != usedCG0)
		printf("\t usedCG0 %d vs %d\n", out_data->usedCG0->aval, usedCG0);
	if (out_data->kCurLast->aval != kCurLast)
		printf("\t kCurLast %d vs %d\n", out_data->kCurLast->aval, kCurLast);
	if (out_data->resSize0->aval != resSize0)
		printf("\t resSize0 %d vs %d\n", out_data->resSize0->aval, resSize0);
	if (out_data->resSizeLast->aval != resSizeLast)
		printf("\t resSizeLast %d vs %d\n", out_data->resSizeLast->aval, resSizeLast);
	if (out_data->resLen0->aval != resLen0)
		printf("\t resLen0 %d vs %d\n", out_data->resLen0->aval, resLen0);
	if (out_data->resLenLast->aval != resLenLast)
		printf("\t resLenLast %d vs %d\n", out_data->resLenLast->aval, resLenLast);
	if (out_data->wtotal_n->aval != wtotal_n)
		printf("\t wtotal_n %d vs %d\n", out_data->wtotal_n->aval, wtotal_n);
	if (out_data->wlenk_nLast->aval != wlenk_nLast)
		printf("\t wlenk_nLast %d vs %d\n", out_data->wlenk_nLast->aval, wlenk_nLast);
	if (out_data->wtotalLast->aval != wtotalLast)
		printf("\t wtotalLast %d vs %d\n", out_data->wtotalLast->aval, wtotalLast);
	if (out_data->wlenk_nLast2->aval != wlenk_nLast2)
		printf("\t wlenk_nLast2 %d vs %d\n", out_data->wlenk_nLast2->aval, wlenk_nLast2);
	if (out_data->wlenk_regular->aval != wlenk_regular)
		printf("\t wlenk_regular %d vs %d\n", out_data->wlenk_regular->aval, wlenk_regular);
	if (out_data->wlen_regular->aval != wlen_regular)
		printf("\t wlen_regular %d vs %d\n", out_data->wlen_regular->aval, wlen_regular);
	if (out_data->kCurLast_1->aval != kCurLast_1)
		printf("\t kCurLast_1 %d vs %d\n", out_data->kCurLast_1->aval, kCurLast_1);

	if(new_conv_inst){

		if (out_data->inst_k->aval != inst_k)
			printf("\t inst_k %d vs %d\n", out_data->inst_k->aval, inst_k);
		if (out_data->new_wlenk->aval != new_wlenk)
			printf("\t new_wlenk %d vs %d\n", out_data->new_wlenk->aval, new_wlenk);
		if (out_data->new_wlenk_last->aval != new_wlenk_last)
			printf("\t new_wlenk_last %d vs %d\n", out_data->new_wlenk_last->aval, new_wlenk_last);
		if (out_data->new_maxRowCount->aval != new_maxRowCount)
			printf("\t new_maxRowCount %d vs %d\n", out_data->new_maxRowCount->aval, new_maxRowCount);
		if (out_data->new_lastLen->aval != new_lastLen)
			printf("\t new_lastLen %d vs %d\n", out_data->new_lastLen->aval, new_lastLen);
		if (out_data->new_outputBufH1->aval != new_outputBufH1)
			printf("\t new_outputBufH1 %d vs %d\n", out_data->new_outputBufH1->aval, new_outputBufH1);
		if (out_data->new_outputAddr->aval != new_outputAddr)
			printf("\t new_outputAddr %d vs %d\n", out_data->new_outputAddr->aval, new_outputAddr);
		if (out_data->new_outputFrameStart->aval != new_outputFrameStart)
			printf("\t new_outputFrameStart %d vs %d\n", out_data->new_outputFrameStart->aval, new_outputFrameStart);
		if (out_data->new_readWidth->aval != new_readWidth)
			printf("\t new_readWidth %d vs %d\n", out_data->new_readWidth->aval, new_readWidth);
		val = SV_GET_SIGNED_BITS(out_data->new_rowAddr->aval, 5);
		if (val != new_rowAddr)
			printf("\t new_rowAddr %d vs %d\n", val, new_rowAddr);
		val = SV_GET_SIGNED_BITS(out_data->new_rowNum->aval, 5);
		if (val != new_rowNum)
			printf("\t new_rowNum %d vs %d\n", val, new_rowNum);
		if (out_data->new_kCur->aval != new_kCur)
			printf("\t new_kCur %d vs %d\n", out_data->new_kCur->aval, new_kCur);
		if (out_data->new_kOut->aval != new_kOut)
			printf("\t new_kOut %d vs %d\n", out_data->new_kOut->aval, new_kOut);
		if (out_data->new_usedGroups->aval != new_usedGroups)
			printf("\t new_usedGroups %d vs %d\n", out_data->new_usedGroups->aval, new_usedGroups);
		if (out_data->new_wtotal->aval != new_wtotal)
			printf("\t new_wtotal %d vs %d\n", out_data->new_wtotal->aval, new_wtotal);
		if (out_data->new_addrNextFrame->aval != new_addrNextFrame)
			printf("\t new_addrNextFrame %d vs %d\n", out_data->new_addrNextFrame->aval, new_addrNextFrame);
		if(doRes){
			if (out_data->new_isReadResA != new_isReadResA)
				printf("\t new_isReadResA %d vs %d\n", out_data->new_isReadResA, new_isReadResA);
			if (out_data->new_resSize->aval != new_resSize)
				printf("\t new_resSize %d vs %d\n", out_data->new_resSize->aval, new_resSize);
			if (out_data->new_resReadSize->aval != new_resReadSize)
				printf("\t new_resReadSize %d vs %d\n", out_data->new_resReadSize->aval, new_resReadSize);
			if (out_data->new_resFrameMax->aval != new_resFrameMax)
				printf("\t new_resFrameMax %d vs %d\n", out_data->new_resFrameMax->aval, new_resFrameMax);
			if (out_data->new_resFrameCount->aval != new_resFrameCount)
				printf("\t new_resFrameCount %d vs %d\n", out_data->new_resFrameCount->aval, new_resFrameCount);
			if (out_data->new_resRowCount->aval != new_resRowCount)
				printf("\t new_resRowCount %d vs %d\n", out_data->new_resRowCount->aval, new_resRowCount);
			if (out_data->new_nextResAddr->aval != new_nextResAddr)
				printf("\t new_nextResAddr %d vs %d\n", out_data->new_nextResAddr->aval, new_nextResAddr);
			if (out_data->new_frameResAddr->aval != new_frameResAddr)
				printf("\t new_frameResAddr %d vs %d\n", out_data->new_frameResAddr->aval, new_frameResAddr);
			if (out_data->new_resLen->aval != new_resLen)
				printf("\t new_resLen %d vs %d\n", out_data->new_resLen->aval, new_resLen);
			if (out_data->new_outResGapSize->aval != new_outResGapSize)
				printf("\t new_outResGapSize %d vs %d\n", out_data->new_outResGapSize->aval, new_outResGapSize);
			if (out_data->new_kRes->aval != new_kRes)
				printf("\t new_kRes %d vs %d\n", out_data->new_kRes->aval, new_kRes);
			
		}
	}
}

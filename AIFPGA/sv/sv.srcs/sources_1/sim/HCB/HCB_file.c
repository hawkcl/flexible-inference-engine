#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"

#define WEIGHT_DATA_WIDTH	8
#define MAX_LOAD_WIDTH		33
#define COMPUTING_GROUP_SIZE	7
//#define WEIGHT_BUS_SIZE 8 
//#define DETAIL_VERIFY
#define MULTI_BIT_NUM 20 
#define WEIGHT_BIT_NUM 8
#define FEATURE_BIT_NUM 8 

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("d:/aidata/bank0_hcb_input.txt", "rt");
	fout = fopen("d:/aidata/bank0_hcb_output.txt", "rt");
	assert(fin);
	assert(fout);
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(HCB_inputs* in_data)
{
	int i;
	int num;
	int inst_enable;
	int start;
	int stop;
	int pwrite_isFetchNextInst;
	int pread_busValid;
	int pread_isFeature;
	int pread_seqNum;
	int dataBus[33];
	int pcweight_seq;
	int pcweight_busValid;
	int pcweight_dataBus[32];
	int pread_RequestFull;
	int ptoken;
	int pwrite_isWritable;

	int ret_data[32];
	int ret_seq;
	int ret_len;
	int ret_token;
	int ret_dtype;

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

	fscanf(fin, " %d", &inst_enable);
	in_data->inst_enable = inst_enable;
	if(inst_enable){
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

	fscanf(fin, " %d %d %d %d %d %d"
			, &start, &stop, &pwrite_isFetchNextInst
			, &pread_busValid, &pread_isFeature, &pread_seqNum);

	fscanf(fin, " %d %d %d %d %d\n", &pcweight_seq, &pcweight_busValid
			, &pread_RequestFull, &ptoken, &pwrite_isWritable);

	in_data->start = start;
	in_data->stop = stop;
	in_data->pwrite_isFetchNextInst = pwrite_isFetchNextInst;
	in_data->pread_busValid = pread_busValid;
	in_data->pread_isFeature = pread_isFeature;

	in_data->pread_seqNum->aval = pread_seqNum;
	in_data->pread_seqNum->bval = 0;
	in_data->pcweight_seq->aval = pcweight_seq;
	in_data->pcweight_seq->bval = 0;
	in_data->ptoken->aval = ptoken;
	in_data->ptoken->bval = 0;

	in_data->pcweight_busValid = pcweight_busValid;
	in_data->pread_RequestFull = pread_RequestFull;
	in_data->pwrite_isWritable = pwrite_isWritable;

	if (pcweight_busValid){
		for (i = 0; i < WEIGHT_DATA_WIDTH * 4; i++){
			fscanf(fin, " %d", pcweight_dataBus + i);
			in_data->pcweight_dataBus[i]->aval = pcweight_dataBus[i];
			in_data->pcweight_dataBus[i]->bval = 0;
		}
	}
	if (pread_busValid){
		if (pread_isFeature){
			for (i = 0; i < MAX_LOAD_WIDTH; i++){
				fscanf(fin, " %d", dataBus + i);
				in_data->dataBus[i]->aval = dataBus[i];
				in_data->dataBus[i]->bval = 0;
			}
		}
		else{
			fscanf(fin, " %d %d %d %d", &ret_seq, &ret_len, &ret_token, &ret_dtype);
			for (i = 0; i < ret_len; i++){
				fscanf(fin, " %d", ret_data + i);
				in_data->pread_dataBus.data[i]->aval = ret_data[i];
				in_data->pread_dataBus.data[i]->bval = 0;
			}
			in_data->pread_dataBus.seq->aval = ret_seq;
			in_data->pread_dataBus.seq->bval = 0;
			in_data->pread_dataBus.len->aval = ret_len;
			in_data->pread_dataBus.len->bval = 0;
			in_data->pread_dataBus.token->aval = ret_token;
			in_data->pread_dataBus.token->bval = 0;
			in_data->pread_dataBus.dtype->aval = ret_dtype;
			in_data->pread_dataBus.dtype->bval = 0;

		}
	}
}



void compare_outputs(const HCB_outputs* out_data)
{
	int i;
	int num;
	int weights_almost_full;
	int instfifo_full;
	int token_set;
	int max_token;
	int pread_RequestValid;
	int pwrite_data[7];
	int pwrite_enable;
	int pwrite_addr;
	int pwrite_len;
	int pwrite_setNextInst;
	int isFetchNextInst;
	int workingProgress;
	int isLoadingFroze;
	int isReadingFeatures;
	int isReadingWeights;
    int            isRunning;
    int            reqFeature;
    int            finishedSeq;
    int            workingSeq;
    int            reqWeight;

	int addr;
	int seq;
	int len;
	int token;
	int dtype;
	int isRamA;
	int isRamB;
	int val;

	int new_conv_inst;
	int state;
	int input_src;
	int isWeightValid;
	int isBMWeightValid;
	int isInitLayer;
	int isLastLayer;
	int isPrefetchWeight;
	int isPrefetchBMWeight;
	int isLoadingNextFeatures;
	int nextWeight;
	int cgSwitchOutput;
	int isPrefetchNextVolume;
	int isOnOutput;
	int waiting_out;
	int isNextVolumeReady;
	int startPrefetching;
	int new_params_readFeatures;
	int startConvOut;
	int sendBackUpInput_valid;
	int initFSteps;
	int initWSteps;
	int weightId;
	int inst_k;
	int iterCountDown;
	int isOutputReady;
	int backupId;
	int isBackupValid;
	int outputReadPos;
	int outputWritePos;
    int isStopable;
	int outputRows;
	int weightsBus[8];
	int backupBus[7];
	int shiftInputs[7];
	int equal;
	int 	mq0, aq0, sq0, psumq0;
	int 	mq1, aq1, sq1, psumq1;
	int 	mq2, aq2, sq2, psumq2;
	int out0, out1, out2;

	if(EOF ==fscanf(fout, "%d", &num))
		exit(0);
	printf("output %d , time %ld\n", num, out_data->tm);


	fscanf(fout, "%d %d %d", &isRunning, &weights_almost_full
			, &instfifo_full); 
	if(!isRunning)
		return;

	fscanf(fout, "%d", &pwrite_enable); 

	if (pwrite_enable){
		fscanf(fout, "%d %d", &pwrite_addr, &pwrite_len);
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fscanf(fout, " %d", pwrite_data + i);
	}

	fscanf(fout, " %d %d %d %d %d %d %d", &token_set, &max_token
			, &pwrite_setNextInst, &isFetchNextInst
			, &workingProgress, &pread_RequestValid, &isStopable);

	if (pread_RequestValid){
		fscanf(fout, " %d %d %d %d %d %d %d", &addr, &seq
				, &len, &token, &dtype
				, &isRamA, &isRamB);
	}




	if (out_data->weights_almost_full != weights_almost_full)
		printf("\t weights_almost_full %d vs %d\n", out_data->weights_almost_full, weights_almost_full);
	if (out_data->instfifo_full != instfifo_full)
		printf("\t instfifo_full %d vs %d\n", out_data->instfifo_full, instfifo_full);
	if (out_data->pread_RequestValid != pread_RequestValid)
		printf("\t pread_RequestValid %d vs %d\n", out_data->pread_RequestValid, pread_RequestValid);
	if (out_data->isStopable != isStopable)
		printf("\t isStopable %d vs %d\n", out_data->isStopable, isStopable);
	if (out_data->pwrite_enable != pwrite_enable)
		printf("\t pwrite_enable %d vs %d\n", out_data->pwrite_enable, pwrite_enable);
	if (out_data->pwrite_setNextInst != pwrite_setNextInst)
		printf("\t pwrite_setNextInst %d vs %d\n", out_data->pwrite_setNextInst, pwrite_setNextInst);
	if (out_data->isFetchNextInst != isFetchNextInst)
		printf("\t isFetchNextInst %d vs %d\n", out_data->isFetchNextInst, isFetchNextInst);

	if (out_data->workingProgress->aval != workingProgress)
		printf("\t workingProgress %d vs %d\n", out_data->workingProgress->aval, workingProgress);

	if(token_set){
        if (out_data->token_set != token_set)
            printf("\t token_set %d vs %d\n", out_data->token_set, token_set);
		if (out_data->max_token->aval != max_token)
			printf("\t max_token %d vs %d\n", out_data->max_token->aval, max_token);
    }

	if(pwrite_enable){
		if (out_data->pwrite_addr->aval != pwrite_addr)
			printf("\t pwrite_addr %d vs %d\n", out_data->pwrite_addr->aval, pwrite_addr);
		int equal = 1;
		for(i = 0; i < pwrite_len; i++){
			val = SV_GET_SIGNED_BITS(out_data->pwrite_data[i]->aval, FEATURE_BIT_NUM - 1);
			if (val != pwrite_data[i])
				equal = 0;
		}
		if(!equal)
		{
			printf("\nexpected");
			for (i = 0; i < pwrite_len; i++)
				printf(" %d", pwrite_data[i]);
			printf("\n");
		}
			printf("dataOut ");
			for (i = 0; i < pwrite_len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->pwrite_data[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\n");

	}

	if (pread_RequestValid){
		if (out_data->pread_request.addr->aval != addr)
			printf("\t pread_request.addr %d vs %d\n", out_data->pread_request.addr->aval, addr);
		if (out_data->pread_request.seq->aval != seq)
			printf("\t pread_request.seq %d vs %d\n", out_data->pread_request.seq->aval, seq);
		if (out_data->pread_request.len->aval != len)
			printf("\t pread_request.len %d vs %d\n", out_data->pread_request.len->aval, len);
		if (out_data->pread_request.token->aval != token)
			printf("\t pread_request.token %d vs %d\n", out_data->pread_request.token->aval, token);
		if (out_data->pread_request.dtype->aval != dtype)
			printf("\t pread_request.dtype %d vs %d\n", out_data->pread_request.dtype->aval, dtype);

		if (out_data->pread_request.isRamA != isRamA)
			printf("\t pread_request.isRamA %d vs %d\n", out_data->pread_request.isRamA, isRamA);
		if (out_data->pread_request.isRamB != isRamB)
			printf("\t pread_request.isRamB %d vs %d\n", out_data->pread_request.isRamB, isRamB);
	}

    fscanf(fout, "%d %d %d %d %d %d %d %d", &isRunning
		, &isReadingFeatures, &reqFeature, &finishedSeq
		, &workingSeq, &isReadingWeights
		, &reqWeight, &isLoadingFroze);

	if (out_data->isReadingFeatures != isReadingFeatures)
		printf("\t isReadingFeatures %d vs %d\n", out_data->isReadingFeatures, isReadingFeatures);
	if (out_data->isLoadingFroze != isLoadingFroze)
		printf("\t isLoadingFroze %d vs %d\n", out_data->isLoadingFroze, isLoadingFroze);
	if (out_data->isReadingWeights != isReadingWeights)
		printf("\t isReadingWeights %d vs %d\n", out_data->isReadingWeights, isReadingWeights);
	if (out_data->isRunning != isRunning)
		printf("\t isRunning %d vs %d\n", out_data->isRunning, isRunning);
	if (out_data->reqFeature->aval != reqFeature)
		printf("\t reqFeature %d vs %d\n", out_data->reqFeature->aval, reqFeature);
	if (out_data->finishedSeq->aval != finishedSeq)
		printf("\t finishedSeq %d vs %d\n", out_data->finishedSeq->aval, finishedSeq);
	if (out_data->workingSeq->aval != workingSeq)
		printf("\t workingSeq %d vs %d\n", out_data->workingSeq->aval, workingSeq);
	if (out_data->reqWeight->aval != reqWeight)
		printf("\t reqWeight %d vs %d\n", out_data->reqWeight->aval, reqWeight);
#ifdef DETAIL_VERIFY

	fscanf(fout, "%d %d %d %d %d %d %d", &new_conv_inst
			, &state, &input_src, &isWeightValid
			, &isBMWeightValid, &isInitLayer, &isLastLayer);

	fscanf(fout, "%d %d %d %d %d", &isPrefetchWeight
			, &isPrefetchBMWeight, &isLoadingNextFeatures
			, &nextWeight, &cgSwitchOutput);

	fscanf(fout, " %d %d %d %d %d %d %d %d", &isPrefetchNextVolume, &isOnOutput
			, &waiting_out, &isNextVolumeReady, &startPrefetching
			, &new_params_readFeatures, &startConvOut, &sendBackUpInput_valid);

	if (out_data->state->aval != state)
		printf("\t state %d vs %d\n", out_data->state->aval, state);
	if (out_data->input_src->aval != input_src)
		printf("\t input_src %d vs %d\n", out_data->input_src->aval, input_src);

	if (out_data->new_conv_inst != new_conv_inst)
		printf("\t new_conv_inst %d vs %d\n", out_data->new_conv_inst, new_conv_inst);
	if (out_data->isReadingFeatures != isReadingFeatures)
		printf("\t isReadingFeatures %d vs %d\n", out_data->isReadingFeatures, isReadingFeatures);
	if (out_data->isWeightValid != isWeightValid)
		printf("\t isWeightValid %d vs %d\n", out_data->isWeightValid, isWeightValid);
	if (out_data->isBMWeightValid != isBMWeightValid)
		printf("\t isBMWeightValid %d vs %d\n", out_data->isBMWeightValid, isBMWeightValid);
	if (out_data->isInitLayer != isInitLayer)
		printf("\t isInitLayer %d vs %d\n", out_data->isInitLayer, isInitLayer);
	if (out_data->isLastLayer != isLastLayer)
		printf("\t isLastLayer %d vs %d\n", out_data->isLastLayer, isLastLayer);
	if (out_data->isPrefetchWeight != isPrefetchWeight)
		printf("\t isPrefetchWeight %d vs %d\n", out_data->isPrefetchWeight, isPrefetchWeight);
	if (out_data->isPrefetchBMWeight != isPrefetchBMWeight)
		printf("\t isPrefetchBMWeight %d vs %d\n", out_data->isPrefetchBMWeight, isPrefetchBMWeight);
	if (out_data->isLoadingNextFeatures != isLoadingNextFeatures)
		printf("\t isLoadingNextFeatures %d vs %d\n", out_data->isLoadingNextFeatures, isLoadingNextFeatures);
	if (out_data->nextWeight != nextWeight)
		printf("\t nextWeight %d vs %d\n", out_data->nextWeight, nextWeight);
	if (out_data->cgSwitchOutput != cgSwitchOutput)
		printf("\t cgSwitchOutput %d vs %d\n", out_data->cgSwitchOutput, cgSwitchOutput);
	if (out_data->isPrefetchNextVolume != isPrefetchNextVolume)
		printf("\t isPrefetchNextVolume %d vs %d\n", out_data->isPrefetchNextVolume, isPrefetchNextVolume);
	if (out_data->isOnOutput != isOnOutput)
		printf("\t isOnOutput %d vs %d\n", out_data->isOnOutput, isOnOutput);
	if (out_data->waiting_out != waiting_out)
		printf("\t waiting_out %d vs %d\n", out_data->waiting_out, waiting_out);
	if (out_data->isNextVolumeReady != isNextVolumeReady)
		printf("\t isNextVolumeReady %d vs %d\n", out_data->isNextVolumeReady, isNextVolumeReady);
	if (out_data->startPrefetching != startPrefetching)
		printf("\t startPrefetching %d vs %d\n", out_data->startPrefetching, startPrefetching);
	if (out_data->new_params_readFeatures != new_params_readFeatures)
		printf("\t new_params_readFeatures %d vs %d\n", out_data->new_params_readFeatures, new_params_readFeatures);
	if (out_data->startConvOut != startConvOut)
		printf("\t startConvOut %d vs %d\n", out_data->startConvOut, startConvOut);
	if (out_data->sendBackUpInput_valid != sendBackUpInput_valid)
		printf("\t sendBackUpInput_valid %d vs %d\n", out_data->sendBackUpInput_valid, sendBackUpInput_valid);

	fscanf(fout, " %d %d %d %d %d %d %d", &initWSteps, &initFSteps
			, &weightId, &inst_k, &iterCountDown
			, &isOutputReady, &backupId);
	fscanf(fout, " %d %d %d %d", &isBackupValid, &outputReadPos
			, &outputWritePos, &outputRows);
	if(out_data->initFSteps->aval != initFSteps)
		printf("\t initFSteps %d vs %d\n", out_data->initFSteps->aval, initFSteps);
	if(out_data->initWSteps->aval != initWSteps)
		printf("\t initWSteps %d vs %d\n", out_data->initWSteps->aval, initWSteps);
	if(isBMWeightValid || isWeightValid)
		if(out_data->weightId->aval != weightId)
			printf("\t weightId %d vs %d\n", out_data->weightId->aval, weightId);
	if(out_data->inst_k->aval != inst_k)
		printf("\t inst_k %d vs %d\n", out_data->inst_k->aval, inst_k);
	if(out_data->iterCountDown->aval != iterCountDown)
		printf("\t iterCountDown %d vs %d\n", out_data->iterCountDown->aval, iterCountDown);
	if(isBackupValid)
		if(out_data->backupId->aval != backupId)
			printf("\t backupId %d vs %d\n", out_data->backupId->aval, backupId);
	if(out_data->outputReadPos->aval != outputReadPos)
		printf("\t outputReadPos %d vs %d\n", out_data->outputReadPos->aval, outputReadPos);
	if(out_data->outputWritePos->aval != outputWritePos)
		printf("\t outputWritePos %d vs %d\n", out_data->outputWritePos->aval, outputWritePos);
	if(out_data->outputRows->aval != outputRows)
		printf("\t outputRows %d vs %d\n", out_data->outputRows->aval, outputRows);

	if (out_data->isOutputReady != isOutputReady)
		printf("\t isOutputReady %d vs %d\n", out_data->isOutputReady, isOutputReady);
	if (out_data->isBackupValid != isBackupValid)
		printf("\t isBackupValid %d vs %d\n", out_data->isBackupValid, isBackupValid);

	if (isWeightValid){
		int len;
		fscanf(fout, "%d", &len);
		for (i = 0; i < len; i++)
			fscanf(fout, " %d", weightsBus+i);
		equal = 1;
		for (i = 0; i < len; i++){
			int val = SV_GET_SIGNED_BITS(out_data->weightsBus[i]->aval, WEIGHT_BIT_NUM - 1);
			if(val != weightsBus[i])
				equal = 0;
		}
		if(!equal)
		{
			printf("weightBus ");
			for (i = 0; i < len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->weightsBus[i]->aval, WEIGHT_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected ");
			for (i = 0; i < len; i++)
				printf(" %d", weightsBus[i]);
			printf("\n");
		}
	}

	if (isBMWeightValid){
		int len;
		fscanf(fout, "%d", &len);
		for (i = 0; i < len; i++)
			fscanf(fout, " %d", weightsBus+i);
		equal = 1;
		for (i = 0; i < len; i++){
			int val = SV_GET_SIGNED_BITS(out_data->weightsBus[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != weightsBus[i])
				equal = 0;
		}
		if(!equal)
		{
			printf("bmWeightBus ");
			for (i = 0; i < len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->weightsBus[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected    ");
			for (i = 0; i < len; i++)
				printf(" %d", weightsBus[i]);
			printf("\n");
		}
	}

	if (isBackupValid){
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fscanf(fout, " %d", backupBus+i);
		equal = 1;
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			int val = SV_GET_SIGNED_BITS(out_data->backupBus[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != backupBus[i])
				equal = 0;
		}

		if(!equal)
		{
			printf("backupBus");
			for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
				int val = SV_GET_SIGNED_BITS(out_data->backupBus[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected  ");
			for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
				printf(" %d", backupBus[i]);
			printf("\n");
		}
	}

	equal = 1;
	//int len;
	fscanf(fout, "%d", &len);
	if(len){
		for (i = 0; i < len; i++)	{
			fscanf(fout, "%d", shiftInputs + i);
		}
		for (i = 0; i < len; i++)	{
			int val = SV_GET_SIGNED_BITS(out_data->shiftInputs[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != shiftInputs[i])
				equal = 0;
		}

		if(!equal)
		{
			printf("shiftinput");
			for (i = 0; i < len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->shiftInputs[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected  ");
			for (i = 0; i < len; i++)
				printf(" %d", shiftInputs[i]);
			printf("\n");
		}
	}
	fscanf(fout, "%d", &len);
	if(len > 0){
        int val;
		fscanf(fout, " %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n"
			, &aq0, &sq0, &mq0, &psumq0
			, &aq1, &sq1, &mq1, &psumq1
			, &aq2, &sq2, &mq2, &psumq2
			, &out0, &out1, &out2);
		val = SV_GET_SIGNED_BITS(out_data->aq0->aval, MULTI_BIT_NUM - 1);
		if(val != aq0)
			printf("\t aq0 %d vs %d\n", val, aq0);
		val = SV_GET_SIGNED_BITS(out_data->sq0->aval, MULTI_BIT_NUM - 1);
		if(val != sq0)
			printf("\t sq0 %d vs %d\n", val, sq0);
		val = SV_GET_SIGNED_BITS(out_data->mq0->aval, MULTI_BIT_NUM - 1);
		if(val != mq0)
			printf("\t mq0 %d vs %d\n", val, mq0);
		val = SV_GET_SIGNED_BITS(out_data->psumq0->aval, MULTI_BIT_NUM - 1);
		//if(val != psumq0)
		//	printf("\t psumq0 %d vs %d\n", val, psumq0);
		val = SV_GET_SIGNED_BITS(out_data->aq1->aval, MULTI_BIT_NUM - 1);
		if(val != aq1)
			printf("\t aq1 %d vs %d\n", val, aq1);
		val = SV_GET_SIGNED_BITS(out_data->sq1->aval, MULTI_BIT_NUM - 1);
		if(val != sq1)
			printf("\t sq1 %d vs %d\n", val, sq1);
		val = SV_GET_SIGNED_BITS(out_data->mq1->aval, MULTI_BIT_NUM - 1);
		if(val != mq1)
			printf("\t mq1 %d vs %d\n", val, mq1);
		val = SV_GET_SIGNED_BITS(out_data->psumq1->aval, MULTI_BIT_NUM - 1);
		//if(val != psumq1)
		//	printf("\t psumq1 %d vs %d\n", val, psumq1);
		val = SV_GET_SIGNED_BITS(out_data->aq2->aval, MULTI_BIT_NUM - 1);
		if(val != aq2)
			printf("\t aq2 %d vs %d\n", val, aq2);
		val = SV_GET_SIGNED_BITS(out_data->sq2->aval, MULTI_BIT_NUM - 1);
		if(val != sq2)
			printf("\t sq2 %d vs %d\n", val, sq2);
		val = SV_GET_SIGNED_BITS(out_data->mq2->aval, MULTI_BIT_NUM - 1);
		if(val != mq2)
			printf("\t mq2 %d vs %d\n", val, mq2);
		val = SV_GET_SIGNED_BITS(out_data->psumq2->aval, MULTI_BIT_NUM - 1);
		//if(val != psumq2)
		//	printf("\t psumq2 %d vs %d\n", val, psumq2);
		if(isOutputReady){
			val = SV_GET_SIGNED_BITS(out_data->out0->aval, MULTI_BIT_NUM - 1);
			if(val != out0)
				printf("\t out0 %d vs %d\n", val, out0);
			val = SV_GET_SIGNED_BITS(out_data->out1->aval, MULTI_BIT_NUM - 1);
			if(val != out1)
				printf("\t out1 %d vs %d\n", val, out1);
			val = SV_GET_SIGNED_BITS(out_data->out2->aval, MULTI_BIT_NUM - 1);
			if(val != out2)
				printf("\t out2 %d vs %d\n", val, out2);
		
		}

	}
#endif
}

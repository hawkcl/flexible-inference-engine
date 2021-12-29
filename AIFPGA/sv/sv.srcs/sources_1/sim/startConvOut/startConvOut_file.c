#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"


FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank0_startconvout_input.txt", "rt");
	fout = fopen("D:/aidata/bank0_startconvout_output.txt", "rt");
	printf("files opened");
	assert(fin);
	assert(fout);
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(startConvOut_inputs* in_data)
{
	int num;
	int enable;
	int isNextVolumeReady;
	int isPrefetchNextVolume_next;
	int isPrefetchNextVolume;
	int reset_isOnOutput;
	int kt;
	int ks;
	int numGroups;
	int k;
	int doRes;
	int doUpSample;
	int outputBufW1;
	int outFrameSize;
	int outW;
	int outputAddrGap;
	int maxpool_stride;
	int curSeq;
	int newWriteInst;
	int outputBufH1Orig;
	int outputAddr;
	int outputFrameStart;
	int new_params;
	int new_kOut;
	int usedCGLast;
	int usedCG0;
	int kCurLast;

	if(EOF == fscanf(fin, "%d", &num))
		exit(0);
	printf("read %d\n", num);

	fscanf(fin, "%d %d %d", &new_params, &new_kOut, &enable);
	if(enable){
		fscanf(fin, " %d %d %d %d %d %d %d", &isNextVolumeReady, &isPrefetchNextVolume_next
				, &isPrefetchNextVolume, &kt, &ks
				, &numGroups, &k);
		fscanf(fin, " %d %d %d %d %d %d %d", &doRes, &doUpSample
				, &outputBufW1, &outFrameSize, &outW
				, &outputAddrGap, &maxpool_stride);
		fscanf(fin, " %d %d %d %d %d", &curSeq, &newWriteInst
				, &outputBufH1Orig, &outputAddr
				, &outputFrameStart);
		fscanf(fin, " %d %d %d", &usedCGLast, &usedCG0, &kCurLast);
	}
	fscanf(fin, " %d", &reset_isOnOutput);

	in_data->new_params = new_params;
	in_data->enable = enable;
	in_data->reset_isOnOutput = reset_isOnOutput;
	in_data->new_kOut->aval = new_kOut;
	in_data->new_kOut->bval = 0;

	if(enable){
		in_data->isNextVolumeReady = isNextVolumeReady;
		in_data->isPrefetchNextVolume_next = isPrefetchNextVolume_next;
		in_data->isPrefetchNextVolume = isPrefetchNextVolume;
		in_data->kt->aval = kt;
		in_data->kt->bval = 0;
		in_data->ks->aval = ks;
		in_data->ks->bval = 0;
		in_data->numGroups->aval = numGroups;
		in_data->numGroups->bval = 0;
		in_data->k->aval = k;
		in_data->k->bval = 0;

		in_data->doRes = doRes;
		in_data->doUpSample = doUpSample;
		in_data->newWriteInst = newWriteInst;

		in_data->outputBufW1->aval = outputBufW1;
		in_data->outputBufW1->bval = 0;
		in_data->outFrameSize->aval = outFrameSize;
		in_data->outFrameSize->bval = 0;
		in_data->outW->aval = outW;
		in_data->outW->bval = 0;
		in_data->outputAddrGap->aval = outputAddrGap;
		in_data->outputAddrGap->bval = 0;
		in_data->maxpool_stride->aval = maxpool_stride;
		in_data->maxpool_stride->bval = 0;
		in_data->curSeq->aval = curSeq;
		in_data->curSeq->bval = 0;
		in_data->outputBufH1Orig->aval = outputBufH1Orig;
		in_data->outputBufH1Orig->bval = 0;
		in_data->outputAddr->aval = outputAddr;
		in_data->outputAddr->bval = 0;
		in_data->outputFrameStart->aval = outputFrameStart;
		in_data->outputFrameStart->bval = 0;
		in_data->new_kOut->aval = new_kOut;
		in_data->new_kOut->bval = 0;
		in_data->usedCGLast->aval = usedCGLast;
		in_data->usedCGLast->bval = 0;
		in_data->usedCG0->aval = usedCG0;
		in_data->usedCG0->bval = 0;
		in_data->kCurLast->aval = kCurLast;
		in_data->kCurLast->bval = 0;

	}
}



void compare_outputs(const startConvOut_outputs* out_data)
{
	int num;
	int isOnOutput;
	int waiting_out;
	int cgSwitchOutput;
	int doRes_out;
	int doUpSample_out;
	int outputBufW1_out;
	int outFrameSize_out;
	int outW_out;
	int outW_out2;
	int maxpool_stride_out;
	int outputAddrGap_out;
	int k_out;
	int curSeq_out;
	int newWriteInst_out;
	int outputBufH1_out;
	int set_out_params;
	int outputAddr_out;
	int outputFrameStart_out;
	int set_LastOutput;
	int outputIdxMax;
	int kOut;

	if(EOF ==fscanf(fout, "%d", &num))
		exit(0);
	printf("output %d\n", num);

	fscanf(fout, " %d %d %d %d %d %d %d", &isOnOutput, &waiting_out
			, &cgSwitchOutput, &doRes_out, &doUpSample_out
			, &outputBufW1_out, &outFrameSize_out);

	fscanf(fout, " %d %d %d %d %d %d %d", &outW_out, &outW_out2
			, &maxpool_stride_out, &outputAddrGap_out
			, &k_out, &curSeq_out, &newWriteInst_out);

	fscanf(fout, " %d %d %d %d %d %d %d\n", &outputBufH1_out, &set_out_params
			, &outputAddr_out, &outputFrameStart_out
			, &set_LastOutput, &outputIdxMax, &kOut);

	if(out_data->isOnOutput != isOnOutput)
		printf("\t isOnOutput %d vs %d\n", out_data->isOnOutput, isOnOutput);
	if(out_data->waiting_out != waiting_out)
		printf("\t waiting_out %d vs %d\n", out_data->waiting_out, waiting_out);
	if(out_data->cgSwitchOutput != cgSwitchOutput)
		printf("\t cgSwitchOutput %d vs %d\n", out_data->cgSwitchOutput, cgSwitchOutput);
	if(out_data->doRes_out != doRes_out)
		printf("\t doRes_out %d vs %d\n", out_data->doRes_out, doRes_out);
	if(out_data->doUpSample_out != doUpSample_out)
		printf("\t doUpSample_out %d vs %d\n", out_data->doUpSample_out, doUpSample_out);
	if(out_data->newWriteInst_out != newWriteInst_out)
		printf("\t newWriteInst_out %d vs %d\n", out_data->newWriteInst_out, newWriteInst_out);
	if(out_data->set_out_params != set_out_params)
		printf("\t set_out_params %d vs %d\n", out_data->set_out_params, set_out_params);
	if(out_data->set_LastOutput != set_LastOutput)
		printf("\t set_LastOutput %d vs %d\n", out_data->set_LastOutput, set_LastOutput);

	if(out_data->outputBufW1_out->aval != outputBufW1_out)
		printf("\t outputBufW1_out %d vs %d\n", out_data->outputBufW1_out->aval, outputBufW1_out);
	if(out_data->outFrameSize_out->aval != outFrameSize_out)
		printf("\t outFrameSize_out %d vs %d\n", out_data->outFrameSize_out->aval, outFrameSize_out);
	if(out_data->outW_out->aval != outW_out)
		printf("\t outW_out %d vs %d\n", out_data->outW_out->aval, outW_out);
	if(out_data->outW_out2->aval != outW_out2)
		printf("\t outW_out2 %d vs %d\n", out_data->outW_out2->aval, outW_out2);
	if(out_data->maxpool_stride_out->aval != maxpool_stride_out)
		printf("\t maxpool_stride_out %d vs %d\n", out_data->maxpool_stride_out->aval, maxpool_stride_out);
	if(out_data->outputAddrGap_out->aval != outputAddrGap_out)
		printf("\t outputAddrGap_out %d vs %d\n", out_data->outputAddrGap_out->aval, outputAddrGap_out);
	if(out_data->k_out->aval != k_out)
		printf("\t k_out %d vs %d\n", out_data->k_out->aval, k_out);
	if(out_data->curSeq_out->aval != curSeq_out)
		printf("\t curSeq_out %d vs %d\n", out_data->curSeq_out->aval, curSeq_out);
	if(out_data->outputBufH1_out->aval != outputBufH1_out)
		printf("\t outputBufH1_out %d vs %d\n", out_data->outputBufH1_out->aval, outputBufH1_out);
	if(set_out_params){
		if(out_data->outputAddr_out->aval != outputAddr_out)
			printf("\t outputAddr_out %d vs %d\n", out_data->outputAddr_out->aval, outputAddr_out);
		if(out_data->outputFrameStart_out->aval != outputFrameStart_out)
			printf("\t outputFrameStart_out %d vs %d\n", out_data->outputFrameStart_out->aval, outputFrameStart_out);
	}
	if(out_data->outputIdxMax->aval != outputIdxMax)
		printf("\t outputIdxMax %d vs %d\n", out_data->outputIdxMax->aval, outputIdxMax);
	if(out_data->kOut->aval != kOut)
		printf("\t kOut %d vs %d\n", out_data->kOut->aval, kOut);

}

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"

#define CG_NUM	12
#define COMPUTING_GROUP_SIZE	7
#define FEATURE_BIT_NUM 8

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank1_processconvout_input.txt", "rt");
	fout = fopen("D:/aidata/bank1_processconvout_output.txt", "rt");
	assert(fin);
	assert(fout);
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(processConvOut_inputs* in_data)
{
	int i , j;
	int num;
	int state;
    int enable;
    int isOnOutput;
    int pwrite_isWritable;
    int resBuf_empty;
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
    int outputIdxMax;
    int pre_output[12][7];
    int resBuf[7];
    int set_LastOutput;
    int new_params;
    int new_outputAddr;
    int new_outputFrameStart;
    int set_out_params;
    int new_outputAddr_out;
    int new_outputFrameStart_out;
    int res_len;

	if(EOF == fscanf(fin, "%d", &num))
		exit(0);
	printf("read %d\n", num);

	fscanf(fin, " %d %d %d %d %d %d %d", &state, &enable
		, &isOnOutput, &pwrite_isWritable
		, &resBuf_empty
		, &doRes_out, &doUpSample_out);

	fscanf(fin, " %d %d %d %d %d %d %d", &outputBufW1_out, &outFrameSize_out
		, &outW_out, &outW_out2, &maxpool_stride_out
		, &outputAddrGap_out, &k_out);

	fscanf(fin, " %d %d %d %d %d %d %d\n", &curSeq_out, &newWriteInst_out
		, &outputBufH1_out, &outputIdxMax
		, &new_params, &new_outputAddr, &new_outputFrameStart);

	if (isOnOutput){
		for (i = 0; i < CG_NUM; i++){
			for (j = 0; j < COMPUTING_GROUP_SIZE; j++)
				fscanf(fin, " %d", pre_output[i] + j);
		}
	}else
		for (i = 0; i < CG_NUM; i++){
			for (j = 0; j < COMPUTING_GROUP_SIZE; j++)
				pre_output[i][j] = -1;
		}

	//res
	fscanf(fin, " %d", &res_len);
	for (i = 0; i < res_len; i++)
		fscanf(fin, " %d", resBuf+i);

	fscanf(fin, " %d %d %d %d", &set_LastOutput, &set_out_params
		, &new_outputAddr_out, &new_outputFrameStart_out);

	in_data->state->aval = state;
	in_data->state->bval = 0;
	in_data->enable = enable;
	in_data->isOnOutput = isOnOutput;
	in_data->pwrite_isWritable = pwrite_isWritable;
	in_data->resBuf_empty = resBuf_empty;
	in_data->doRes_out = doRes_out;
	in_data->doUpSample_out = doUpSample_out;
	in_data->newWriteInst_out = newWriteInst_out;
	in_data->set_LastOutput = set_LastOutput;
	in_data->new_params = new_params;
	in_data->set_out_params = set_out_params;
	in_data->outputBufW1_out->aval = outputBufW1_out;
	in_data->outputBufW1_out->bval = 0;
	in_data->outFrameSize_out->aval = outFrameSize_out;
	in_data->outFrameSize_out->bval = 0;
	in_data->outW_out->aval = outW_out;
	in_data->outW_out->bval = 0;
	in_data->outW_out2->aval = outW_out2;
	in_data->outW_out2->bval = 0;
	in_data->maxpool_stride_out->aval = maxpool_stride_out;
	in_data->maxpool_stride_out->bval = 0;
	in_data->outputAddrGap_out->aval = outputAddrGap_out;
	in_data->outputAddrGap_out->bval = 0;
	in_data->k_out->aval = k_out;
	in_data->k_out->bval = 0;
	in_data->curSeq_out->aval = curSeq_out;
	in_data->curSeq_out->bval = 0;
	in_data->outputBufH1_out->aval = outputBufH1_out;
	in_data->outputBufH1_out->bval = 0;
	in_data->outputIdxMax->aval = outputIdxMax;
	in_data->outputIdxMax->bval = 0;
	in_data->new_outputAddr->aval = new_outputAddr;
	in_data->new_outputAddr->bval = 0;
	in_data->new_outputFrameStart->aval = new_outputFrameStart;
	in_data->new_outputFrameStart->bval = 0;
	in_data->new_outputAddr_out->aval = new_outputAddr_out;
	in_data->new_outputAddr_out->bval = 0;
	in_data->new_outputFrameStart_out->aval = new_outputFrameStart_out;
	in_data->new_outputFrameStart_out->bval = 0;

	for (i = 0; i < CG_NUM; i++){
		for (j = 0; j < COMPUTING_GROUP_SIZE; j++){
			in_data->pre_output[i][j]->aval = pre_output[i][j];
			in_data->pre_output[i][j]->bval = 0;
		}
	}
	for(i = 0; i < COMPUTING_GROUP_SIZE; i++){
		in_data->resBuf[i]->aval = resBuf[i];
		in_data->resBuf[i]->bval = 0;
	}
}



void compare_outputs(const processConvOut_outputs* out_data)
{
	int i;
	int num;
	int res_en;
    int pwrite_data[7];
    int pwrite_enable;
    int pwrite_addr;
    int pwrite_setNextInst;
    int out_row;
    int reset_state;
    int outputAddr;
    int outputFrameStart;
    int reset_isOnOutput;
    int outputCGIdx;
    int outputCGIdx0;
    int outputFrameStart_out;
    int outputUPSteps;
    int data_len;

	if(EOF ==fscanf(fout, "%d", &num))
		exit(0);
	printf("output %d\n", num);

	fscanf(fout, "%d", &pwrite_enable);
	if(pwrite_enable){
		fscanf(fout, "%d %d", &pwrite_addr, &data_len);
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			fscanf(fout, " %d", pwrite_data + i);
	}
	fscanf(fout, "%d %d %d %d", &outputCGIdx, &outputCGIdx0
		, &outputFrameStart_out, &outputUPSteps);
	fscanf(fout, " %d %d %d %d %d %d %d", &res_en, &pwrite_setNextInst
		, &out_row, &reset_state, &outputAddr
		, &outputFrameStart, &reset_isOnOutput);

	if(out_data->res_en != res_en)
		printf("\t res_en %d vs %d\n", out_data->res_en, res_en);
	if(out_data->pwrite_enable != pwrite_enable)
		printf("\t pwrite_enable %d vs %d\n", out_data->pwrite_enable, pwrite_enable);
	if(out_data->pwrite_setNextInst != pwrite_setNextInst)
		printf("\t pwrite_setNextInst %d vs %d\n", out_data->pwrite_setNextInst, pwrite_setNextInst);
	if(out_data->reset_state != reset_state)
		printf("\t reset_state %d vs %d\n", out_data->reset_state, reset_state);
	if(out_data->reset_isOnOutput != reset_isOnOutput)
		printf("\t reset_isOnOutput %d vs %d\n", out_data->reset_isOnOutput, reset_isOnOutput);
	
	if(out_data->out_row->aval != out_row)
		printf("\t out_row %d vs %d\n", out_data->out_row->aval, out_row);
	if(out_data->outputAddr->aval != outputAddr)
		printf("\t outputAddr %d vs %d\n", out_data->outputAddr->aval, outputAddr);
	if(out_data->outputFrameStart->aval != outputFrameStart)
		printf("\t outputFrameStart %d vs %d\n", out_data->outputFrameStart->aval, outputFrameStart);
	if(out_data->outputCGIdx->aval != outputCGIdx)
		printf("\t outputCGIdx %d vs %d\n", out_data->outputCGIdx->aval, outputCGIdx);
	if(out_data->outputCGIdx0->aval != outputCGIdx0)
		printf("\t outputCGIdx0 %d vs %d\n", out_data->outputCGIdx0->aval, outputCGIdx0);
	if(out_data->outputFrameStart_out->aval != outputFrameStart_out)
		printf("\t outputFrameStart_out %d vs %d\n", out_data->outputFrameStart_out->aval, outputFrameStart_out);
	if(out_data->outputUPSteps->aval != outputUPSteps)
		printf("\t outputUPSteps %d vs %d\n", out_data->outputUPSteps->aval, outputUPSteps);
	

	if(pwrite_enable){
		if(out_data->pwrite_addr->aval != pwrite_addr)
			printf("\t pwrite_addr %d vs %d\n", out_data->pwrite_addr->aval, pwrite_addr);
		int equal = 1;
		for (i = 0; i < data_len; i++)	{
			int val = SV_GET_SIGNED_BITS(out_data->pwrite_data[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != pwrite_data[i])
				equal = 0;
		}
		if(!equal)
		{
			printf("dataOut ");
			for (i = 0; i < data_len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->pwrite_data[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected");
			for (i = 0; i < data_len; i++)
				printf(" %d", pwrite_data[i]);
			printf("\n");
		}
	
	}
}

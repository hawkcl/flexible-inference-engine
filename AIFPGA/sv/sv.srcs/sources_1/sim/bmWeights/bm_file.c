#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

#define BM_READ_WIDTH 6 
#define FEATURE_BIT_NUM 8

FILE *fin;
FILE *fout;
int prev_len;
void init_files() 
{
	fin = fopen("D:/aidata/bank0_bmweight_input.txt", "rt");
	fout = fopen("D:/aidata/bank0_bmweight_output.txt", "rt");
	prev_len = 0;
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(bm_inputs* in_data)
{
	
	int i , num;
	int enSendBMWeights, len;
	int pread_busValid;
    	int pread_isFeature;
    	int curSeq;
    	int token;
    	int new_conv_inst;
	int data_seq, data_len, data_token, data_dtype;

	if(EOF == fscanf(fin, "%d %d %d", &num, &enSendBMWeights, &len))
		exit(0);

	fscanf(fin, " %d %d %d %d %d",&pread_busValid, &pread_isFeature, &curSeq, &token, &new_conv_inst);
	fscanf(fin, " %d %d %d %d", &data_seq, &data_len, &data_token, &data_dtype);
	printf("read %d, type %d\n", num, data_dtype);

	in_data->num = num;
	in_data->enSendBMWeights = enSendBMWeights ;
	in_data->len->aval = len;
	in_data->len->bval = 0;
	in_data->pread_busValid = pread_busValid;
	in_data->pread_isFeature = pread_isFeature;
	in_data->curSeq->aval = curSeq;
	in_data->curSeq->bval = 0;
	in_data->token->aval = token;
	in_data->token->bval = 0;
	in_data->new_conv_inst = new_conv_inst ;
	
	in_data->data.seq->aval = data_seq;
	in_data->data.seq->bval = 0;
	in_data->data.len->aval = data_len;
	in_data->data.len->bval = 0;
	in_data->data.token->aval = data_token;
	in_data->data.token->bval = 0;
	in_data->data.dtype->aval = data_dtype;
	in_data->data.dtype->bval = 0;	
	

	for (i = 0; i < BM_READ_WIDTH; i++){
		int tmp;
		fscanf(fin, " %d", &tmp);
		in_data->data.data[i]->aval = tmp;
		in_data->data.data[i]->bval = 0;
	}
}


int bmWeightBus[8];
void compare_outputs(const bm_outputs* out_data)
{
	int i;
	int num;
	int enough_data;
	int numBuf;
	int rd_en;
	int len; 

	int receivedBM;
	int wr_en;
    int isEmpty;
    int sz;
	
	if(EOF ==fscanf(fout, "%d %d %d %d %d %d %d", &num, &enough_data, &isEmpty, &sz, &numBuf, &rd_en, &len))
		exit(0);
	printf("output %d\n", num);
	if(len > 0)
	if(out_data->enough_data != enough_data)
		printf("\tenough_data %d vs %d\n", out_data->enough_data, enough_data);
	if(out_data->numBuf->aval != numBuf)
		printf("\tnumBuf %d vs %d\n", out_data->numBuf->aval, numBuf);
	if(out_data->rd_en != rd_en)
		printf("\trd_en %d vs %d\n", out_data->rd_en, rd_en);
	if(out_data->isEmpty != isEmpty)
		printf("\t isEmpty %d vs %d\n", out_data->isEmpty, isEmpty);

	int equal = 1;
	for (i = 0; i < prev_len; i++){
		int val = SV_GET_SIGNED_BITS(out_data->bmWeightBus[i]->aval, FEATURE_BIT_NUM - 1);
		if(val != bmWeightBus[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("bmWeightBus ");
		for (i = 0; i < prev_len; i++){
			int val = SV_GET_SIGNED_BITS(out_data->bmWeightBus[i]->aval, FEATURE_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected    ");
		for (i = 0; i < prev_len; i++)
			printf(" %d", bmWeightBus[i]);
		printf("\n");
	}
	for (i = 0; i < len; i++){
		fscanf(fout, " %d", bmWeightBus + i);
	}
	prev_len = len;

	fscanf(fout, "%d %d", &receivedBM, &wr_en);
	if(out_data->receivedBM->aval != receivedBM)
		printf("\treceivedBM %d vs %d\n", out_data->receivedBM->aval, receivedBM);
	if(out_data->wr_en != wr_en)
		printf("\twr_en %d vs %d\n", out_data->wr_en, wr_en);
    printf("wen %d, isempty %d\n", wr_en, isEmpty);

}

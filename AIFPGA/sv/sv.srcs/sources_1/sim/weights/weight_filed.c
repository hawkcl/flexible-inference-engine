#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

#define WEIGHT_READ_WIDTH 32 

FILE *fin;
FILE *fout;
int prev_len;
int fifo_len;
int in_count;
int out_count;
void init_files() 
{
	fin = fopen("D:/aidata/bank3_weight_input.txt", "rt");
	fout = fopen("D:/aidata/bank3_weight_output.txt", "rt");
	prev_len = 0;
	fifo_len = 0;
	in_count = 0;
	out_count = 0;
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(weight_inputs* in_data)
{
	
	int i , num;
	int enSendWeights, len;
	int isRunning;
    	int pcweight_busValid;
    	int pcweight_seq;
    	int new_weight_params;
    	int new_weightReadPos;
	int new_nextWeightRead, new_endWeightRead, new_reqSeqW, new_conv_inst;

	if(EOF == fscanf(fin, "%d %d %d", &num, &enSendWeights, &len))
		exit(0);
	fscanf(fin, " %d %d %d %d %d",&isRunning, &pcweight_busValid, &pcweight_seq, &new_weight_params, &new_conv_inst);
	fscanf(fin, " %d %d %d %d", &new_weightReadPos, &new_nextWeightRead, &new_endWeightRead, &new_reqSeqW);
	//printf("read %d\n", num);

	in_data->enSendWeights = enSendWeights ;
	in_data->len->aval = len;
	in_data->len->bval = 0;
	in_data->isRunning = isRunning;
	in_data->pcweight_busValid = pcweight_busValid;
	in_data->pcweight_seq->aval = pcweight_seq;
	in_data->pcweight_seq->bval = 0;
	in_data->new_weight_params = new_weight_params ;
	in_data->new_weightReadPos->aval = new_weightReadPos;
	in_data->new_weightReadPos->bval = 0;
	in_data->new_nextWeightRead->aval = new_nextWeightRead;
	in_data->new_nextWeightRead->bval = 0;
	in_data->new_endWeightRead->aval = new_endWeightRead;
	in_data->new_endWeightRead->bval = 0;
	in_data->new_reqSeqW->aval = new_reqSeqW;
	in_data->new_reqSeqW->bval = 0;
	in_data->new_conv_inst = new_conv_inst ;
	
	if(pcweight_busValid)
	for (i = 0; i < WEIGHT_READ_WIDTH; i++){
		int tmp;
		fscanf(fin, " %d", &tmp);
		in_data->w_bus[i]->aval = tmp;
		in_data->w_bus[i]->bval = 0;
	}
}


int weightsBus[8];
int fifodata[8];
void compare_outputs(const weight_outputs* out_data)
{
	int i;
	int num;
	int isWeightValid;
	int numBuf;
	int rd_en;
	int len; 

	int isReadingWeights, weightReadPos, nextWeightRead, endWeightRead;
	int wr_len;

	if(EOF ==fscanf(fout, "%d %d %d %d %d", &num, &isWeightValid, &numBuf, &rd_en, &len))
		exit(0);
	printf("output %d\n", num);
	if(out_data->numBuf->aval != numBuf)
		printf("\tnumBuf %d vs %d\n", out_data->numBuf->aval, numBuf);
	//if(out_data->rd_en != rd_en)
	//	printf("\trd_en %d vs %d\n", out_data->rd_en, rd_en);
	if(isWeightValid){
		//printf("bus at %d :", out_count++);
		for (i = 0; i < len; i++){
			fscanf(fout, " %d", weightsBus + i);
		//	printf(" %d", weightsBus[i]);
		}
		//printf("\n");
		prev_len = len;
	}else
		prev_len = 0;

	int equal = 1;
	for (i = 0; i < prev_len; i++){
		int val = SV_GET_SIGNED_BITS(out_data->weightsBus[i]->aval, 11);
		if(val != weightsBus[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("weightsBus ");
		for (i = 0; i < prev_len; i++){
			int val = SV_GET_SIGNED_BITS(out_data->weightsBus[i]->aval, 11);
			printf(" %d", val);
		}
		printf("\nexpected    ");
		for (i = 0; i < prev_len; i++)
			printf(" %d", weightsBus[i]);
		printf("\n");
	}
	

	fscanf(fout, "%d %d %d %d %d", &isReadingWeights, &weightReadPos, &nextWeightRead, &endWeightRead, &wr_len);
	if(out_data->weightReadPos->aval != weightReadPos)
		printf("\tweightReadPos %d vs %d\n", out_data->weightReadPos->aval, weightReadPos);
	if(out_data->nextWeightRead->aval != nextWeightRead)
		printf("\tnextWeightRead %d vs %d\n", out_data->nextWeightRead->aval, nextWeightRead);
	if(out_data->endWeightRead->aval != endWeightRead)
		printf("\tendWeightRead %d vs %d\n", out_data->endWeightRead->aval, endWeightRead);
	if(out_data->isReadingWeights != isReadingWeights)
		printf("\tisReadingWeights %d vs %d\n", out_data->isReadingWeights, isReadingWeights);
	for(i = 0; i < wr_len; i++){
		fscanf(fout, " %d", fifodata + i);
	}
	fifo_len = wr_len;
	equal = 1;
	for (i = 0; i < fifo_len; i++){
		int val = SV_GET_SIGNED_BITS(out_data->fifodata[i]->aval, 11);
		if(val != fifodata[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("fifodata ");
		for (i = 0; i < fifo_len; i++){
			int val = SV_GET_SIGNED_BITS(out_data->fifodata[i]->aval, 11);
			printf(" %d", val);
		}
		printf("\nexpected ");
		for (i = 0; i < fifo_len; i++)
			printf(" %d", fifodata[i]);
		printf("\n");
	}
	
	if(wr_len > 0){
		//printf("fifo at %d :", in_count++);
		for(i = 0; i < wr_len; i++){
		//	printf(" %d", fifodata[i]);
		}
		//printf("\n");
	}
}

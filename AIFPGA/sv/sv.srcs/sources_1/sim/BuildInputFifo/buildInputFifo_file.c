#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

#define INPUT_MEM_WIDTH	12
#define FEATURE_BIT_NUM  8

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank3_buildinputfifo_input.txt", "rt");
	fout = fopen("D:/aidata/bank3_buildinputfifo_output.txt", "rt");
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(buildInputFifo_inputs* in_data)
{
	int i, j;
	int num;
	int state;
    int readCLast;
    int outputBufH1;
    int downPad;
    int topPad;
    int k;
    int stride;
    int rowNum;
    int reset_params;
    int new_params;
    int reset_iLayers;
    int new_rowAddr;
    int input_full;
    int ab_data[12];
    int ab_empty;
    int ab_en;
	
	if(EOF == fscanf(fin, "%d", &num))
		exit(0);
	//printf("read %d\n", num);
	fscanf(fin, " %d %d %d %d %d %d", &state, &readCLast
		,&outputBufH1, &downPad, &topPad, &k);
	fscanf(fin, " %d %d %d %d %d %d %d %d", &stride, &rowNum
		, &reset_params, &new_params, &reset_iLayers, &new_rowAddr
		, &input_full, &ab_empty);
	fscanf(fin, "%d", &ab_en);
	if(ab_en)
		for (i = 0; i < INPUT_MEM_WIDTH; i++)
			fscanf(fin, " %d", ab_data+i);
	else
		for (i = 0; i < INPUT_MEM_WIDTH; i++)
			ab_data[i] = -1;



	in_data->state->aval = state;
	in_data->state->bval = 0;
	in_data->readCLast->aval = readCLast;
	in_data->readCLast->bval = 0;
	in_data->outputBufH1->aval = outputBufH1;
	in_data->outputBufH1->bval = 0;
	in_data->downPad->aval = downPad;
	in_data->downPad->bval = 0;
	in_data->topPad->aval = topPad;
	in_data->topPad->bval = 0;
	in_data->k->aval = k;
	in_data->k->bval = 0;
	in_data->stride->aval = stride;
	in_data->stride->bval = 0;
	in_data->rowNum->aval = rowNum;
	in_data->rowNum->bval = 0;
	in_data->reset_params = reset_params;
	in_data->new_params = new_params;
	in_data->reset_iLayers = reset_iLayers;
	in_data->new_rowAddr->aval = new_rowAddr;
	in_data->new_rowAddr->bval = 0;
	in_data->input_full = input_full;
	in_data->ab_empty = ab_empty;
	
	for (i = 0; i < INPUT_MEM_WIDTH; i++){
		in_data->ab_data[i]->aval = ab_data[i];
		in_data->ab_data[i]->bval = 0;
	}
}



void compare_outputs(const buildInputFifo_outputs* out_data)
{
	int i;
	int num, rw;
	int input_wr_en;
    int input_data_out[12];
    int ab_rd_en;
    int iLayers;
    int rowAddr;
	
	if(EOF ==fscanf(fout, "%d %d %d", &num, &rw, &input_wr_en))
		exit(0);
	printf("output %d\n", num);
	if(input_wr_en)
		for (i = 0; i < INPUT_MEM_WIDTH; i++)
			fscanf(fout, " %d", input_data_out+i);
	fscanf(fout, " %d %d %d", &ab_rd_en, &iLayers, &rowAddr);

	if(out_data->input_wr_en != input_wr_en)
		printf("\tinput_wr_en %d vs %d\n", out_data->input_wr_en, input_wr_en);
	if(out_data->ab_rd_en != ab_rd_en)
		printf("\tab_rd_en %d vs %d\n", out_data->ab_rd_en, ab_rd_en);
	if(out_data->iLayers->aval != iLayers)
		printf("\tiLayers %d vs %d\n", out_data->iLayers->aval, iLayers);
	int row = SV_GET_SIGNED_BITS(out_data->rowAddr->aval, 5);
	if(row != rowAddr)
		printf("\trowAddr %d vs %d\n", row, rowAddr);


	int equal = 1;
	if(input_wr_en)
	for (i = 0; i < rw; i++)	{
		int val = SV_GET_SIGNED_BITS(out_data->input_data_out[i]->aval, FEATURE_BIT_NUM - 1);
		if(val != input_data_out[i])
			equal = 0;
	}

	if(!equal)
	{
		printf("input_data_out");
		for (i = 0; i < rw; i++){
			int val = SV_GET_SIGNED_BITS(out_data->input_data_out[i]->aval, FEATURE_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected  ");
		for (i = 0; i < rw; i++)
			printf(" %d", input_data_out[i]);
		printf("\n");
	}
}

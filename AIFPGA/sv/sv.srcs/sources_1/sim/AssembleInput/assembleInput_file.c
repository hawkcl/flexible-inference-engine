#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

#define INPUT_MEM_WIDTH	12
#define FEATURE_BIT_NUM 8

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank0_assembleinput_input.txt", "rt");
	fout = fopen("D:/aidata/bank0_assembleinput_output.txt", "rt");
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(assembleInput_inputs* in_data)
{
	int i;
	int num;
    int doAssemble;
    int buffer_full;
    int inputs_buffer_empty;
    int readWidth;
    int data_input[12];
    int prefetchFrameSize;
    int new_param;
    int reset_param;
    int new_addrNextFrame;
    int curVolumeSize;
    int maxRowCount;
    int lastLen;
    int en;

	
	if(EOF == fscanf(fin, "%d", &num))
		exit(0);
	printf("read %d\n", num);

	fscanf(fin, " %d %d %d %d"
		, &doAssemble, &buffer_full, &inputs_buffer_empty, &readWidth);
	fscanf(fin, " %d %d %d %d %d %d %d", &prefetchFrameSize, &new_param, &reset_param
		, &new_addrNextFrame, &curVolumeSize
		, &maxRowCount, &lastLen);
	fscanf(fin, "%d", &en);
	if(en){
		for (i = 0; i < INPUT_MEM_WIDTH; i++)
			fscanf(fin, " %d", data_input + i);
	
	}else
		for (i = 0; i < INPUT_MEM_WIDTH; i++)
			data_input[i] = -1;


	in_data->doAssemble = doAssemble;
	in_data->buffer_full = buffer_full;
	in_data->inputs_buffer_empty = inputs_buffer_empty;

	in_data->readWidth->aval = readWidth;
	in_data->readWidth->bval = 0;
	in_data->prefetchFrameSize->aval = prefetchFrameSize;
	in_data->prefetchFrameSize->bval = 0;
	
	in_data->new_param = new_param;
	in_data->reset_param = reset_param;

	in_data->new_addrNextFrame->aval = new_addrNextFrame;
	in_data->new_addrNextFrame->bval = 0;
	in_data->curVolumeSize->aval = curVolumeSize;
	in_data->curVolumeSize->bval = 0;
	in_data->maxRowCount->aval = maxRowCount;
	in_data->maxRowCount->bval = 0;
	in_data->lastLen->aval = lastLen;
	in_data->lastLen->bval = 0;
	for (i = 0; i < INPUT_MEM_WIDTH; i++){
		in_data->data_input[i]->aval = data_input[i];
		in_data->data_input[i]->bval = 0;
	}
}

void compare_outputs(const assembleInput_outputs* out_data)
{
	int i;
	int num, rw;
	int buffer_wen;
    int buffer_data[12];
    int ren;
    int addrOut;
    int resetAssemble;
    int atmpSize;
    int curRowCount;
    int addrNextFrame;
    int addrCurAssemble;
	
	if(EOF ==fscanf(fout, "%d %d", &num, &rw))
		exit(0);
	printf("output %d\n", num);

	fscanf(fout, "%d", &buffer_wen);
	if(buffer_wen)
	for (i = 0; i < INPUT_MEM_WIDTH; i++)
		fscanf(fout, " %d", buffer_data+i);

	fscanf(fout, " %d %d", &ren, &addrOut);
	fscanf(fout, " %d %d %d %d %d", &resetAssemble, &atmpSize, &curRowCount
		, &addrCurAssemble, &addrNextFrame);

	
	if(out_data->resetAssemble != resetAssemble)
		printf("\tresetAssemble %d vs %d\n", out_data->resetAssemble, resetAssemble);
	
	if(out_data->atmpSize->aval != atmpSize)
		printf("\tatmpSize %d vs %d\n", out_data->atmpSize->aval, atmpSize);
	if(out_data->curRowCount->aval != curRowCount)
		printf("\tcurRowCount %d vs %d\n", out_data->curRowCount->aval, curRowCount);
	if(out_data->addrCurAssemble->aval != addrCurAssemble)
		printf("\taddrCurAssemble %d vs %d\n", out_data->addrCurAssemble->aval, addrCurAssemble);
	if(out_data->addrNextFrame->aval != addrNextFrame)
		printf("\taddrNextFrame %d vs %d\n", out_data->addrNextFrame->aval, addrNextFrame);
	if(buffer_wen == 0){
		if(out_data->buffer_wen)
			printf("\tbuffer_wen %d vs 0\n", out_data->buffer_wen);
	}else{
		if(out_data->buffer_wen != 1)
			printf("\tbuffer_wen %d vs 1\n", out_data->buffer_wen);

		int equal = 1;
		for (i = 0; i < rw; i++)	{
			int val = SV_GET_SIGNED_BITS(out_data->buffer_data[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != buffer_data[i])
				equal = 0;
		}
		if(!equal)
		{
			printf("buffer_data ");
			for (i = 0; i < INPUT_MEM_WIDTH; i++){
				int val = SV_GET_SIGNED_BITS(out_data->buffer_data[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected");
			for (i = 0; i < INPUT_MEM_WIDTH; i++)
				printf(" %d", buffer_data[i]);
			printf("\n");
		}
	}
	if(ren == 0){
		if(out_data->ren)
			printf("\tren %d vs 0\n", out_data->ren);
	}else{
		if(out_data->ren != 1)
			printf("\tren %d vs 1\n", out_data->ren);

	}
}

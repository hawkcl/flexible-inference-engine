#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

#define MAX_K	7
#define MAX_SHIFT_SIZE 6
#define FEATURE_BIT_NUM 8

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank3_shiftinput_input.txt", "rt");
	fout = fopen("D:/aidata/bank3_shiftinput_output.txt", "rt");
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(shiftinput_inputs* in_data)
{
	int i, j;
	int num;
	int input_src;
	int k; 
	int shiftBufBackup[7][6];
	
	
	if(EOF == fscanf(fin, "%d %d %d", &num, &input_src, &k))
		exit(0);
	printf("read %d\n", num);

	in_data->input_src->aval = input_src;
	in_data->input_src->bval = 0;
	in_data->k->aval = k;
	in_data->k->bval = 0;
	
	for (i = 0; i < MAX_K; i++){
		for (j = 0; j < MAX_SHIFT_SIZE; j++){
			fscanf(fin, " %d", shiftBufBackup[i]+j);
			in_data->shiftBufBackup[i][j]->aval = shiftBufBackup[i][j];
			in_data->shiftBufBackup[i][j]->bval = 0;
		}
	}
}



void compare_outputs(const shiftinput_outputs* out_data)
{
	int i;
	int num;
	int cmp;
	int k;
	int shiftInputs[7];
	
	if(EOF ==fscanf(fout, "%d %d %d", &num, &cmp, &k))
		exit(0);
	printf("output %d\n", num);
	
	int equal = 1;
	for (i = 0; i < k; i++)	{
		fscanf(fout, "%d", shiftInputs + i);
	}
	if(cmp)
	for (i = 0; i < k; i++)	{
		int val = SV_GET_SIGNED_BITS(out_data->shiftInputs[i]->aval, FEATURE_BIT_NUM - 1);
		if(val != shiftInputs[i])
			equal = 0;
	}

	if(!equal)
	{
		printf("shiftinput");
		for (i = 0; i < k; i++){
			int val = SV_GET_SIGNED_BITS(out_data->shiftInputs[i]->aval, FEATURE_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected  ");
		for (i = 0; i < k; i++)
			printf(" %d", shiftInputs[i]);
		printf("\n");
	}
}

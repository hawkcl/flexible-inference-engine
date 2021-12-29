#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"
#include <assert.h>

#define INPUT_MEM_WIDTH	12
#define FEATURE_BIT_NUM  8

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank0_sendbackupinput_input.txt", "rt");
	fout = fopen("D:/aidata/bank0_sendbackupinput_output.txt", "rt");
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(sendBackUpInput_inputs* in_data)
{
	int i, j;
	int num;
	int sendBackUpInput_valid;
	int backupId;
	int fifo_data[12];
	int fifo_empty;
	int readWidth;
	int leftPad;

	if(EOF == fscanf(fin, "%d %d %d %d %d", &num, &readWidth, &leftPad
				, &sendBackUpInput_valid, &fifo_empty))
		exit(0);
	printf("read %d\n", num);

	if(sendBackUpInput_valid && !fifo_empty){
		fscanf(fin, "%d", &backupId);
		for(i = 0; i < INPUT_MEM_WIDTH; i++)
			fscanf(fin, "%d",fifo_data  + i);
	}


	in_data->sendBackUpInput_valid = sendBackUpInput_valid;
	in_data->fifo_empty = fifo_empty;

	in_data->backupId->aval = backupId;
	in_data->backupId->bval = 0;
	in_data->readWidth->aval = readWidth;
	in_data->readWidth->bval = 0;
	in_data->leftPad->aval = leftPad;
	in_data->leftPad->bval = 0;

	for (i = 0; i < INPUT_MEM_WIDTH; i++){
		in_data->fifo_data[i]->aval = fifo_data[i];
		in_data->fifo_data[i]->bval = 0;
	}
}



void compare_outputs(const sendBackUpInput_outputs* out_data)
{
	int i, j;
	int num, len;
	int rd_en;
	int shiftBufBackup[7][6];
	int backupBus[7];
	int isBackupValid;

	if(EOF ==fscanf(fout, "%d %d %d", &num, &rd_en, &isBackupValid))
		exit(0);
	printf("output %d\n", num);
	if(rd_en && isBackupValid){
		fscanf(fout, "%d", &len);
		assert(len <= 7);
		for (i = 0; i < len; i++)
			fscanf(fout, " %d", backupBus+i);
		for(i = 0; i < 7; i++)
			for(j = 0; j < 6; j++)
				fscanf(fout, " %d", shiftBufBackup[i]+j);
	}else
		len = 0;

	if(out_data->rd_en != rd_en)
		printf("\trd_en %d vs %d\n", out_data->rd_en, rd_en);
	if(out_data->isBackupValid != isBackupValid)
		printf("\tisBackupValid %d vs %d\n", out_data->isBackupValid, isBackupValid);
	if(rd_en && isBackupValid){
		int equal = 1;
		for (i = 0; i < len; i++){
			int val = SV_GET_SIGNED_BITS(out_data->backupBus[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != backupBus[i])
				equal = 0;
		}

		if(!equal)
		{
			printf("backupBus");
			for (i = 0; i < len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->backupBus[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected  ");
			for (i = 0; i < len; i++)
				printf(" %d", backupBus[i]);
			printf("\n");
		}
		equal = 1;
		for(i = 0; i < 7; i++)
			for(j = 0; j < 6; j++)
		{
			int val = SV_GET_SIGNED_BITS(out_data->shiftBufBackup[i][j]->aval, FEATURE_BIT_NUM - 1);
			if(val != shiftBufBackup[i][j])
				equal = 0;
		}

		if(!equal)
		{
			printf("shift   ");
			for(i = 0; i < 7; i++)
			for(j = 0; j < 6; j++)
			{
				int val = SV_GET_SIGNED_BITS(out_data->backupBus[i]->aval, FEATURE_BIT_NUM - 1);
				printf("%c%d", (i == 0 && j > 0)?",":" ", val);
			}
			printf("\nexpected");
			for(i = 0; i < 7; i++)
			for(j = 0; j < 6; j++)
			{
				printf(" %d", (i == 0 && j > 0)?",":" ", backupBus[i]);
			}
			printf("\n");
		}
	}

}

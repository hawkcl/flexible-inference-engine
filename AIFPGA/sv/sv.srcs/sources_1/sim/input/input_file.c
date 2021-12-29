#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

#define MAX_LOAD_WIDTH	33
#define COMPUTING_GROUP_SIZE 7
#define INPUT_MEM_WIDTH	12
#define FEATURE_BIT_NUM 8

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank2_input_input.txt", "rt");
	fout = fopen("D:/aidata/bank2_input_output.txt", "rt");
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(input_inputs* in_data)
{
	int i;
	int num;
	int pread_busValid;
    int pread_isFeature;
    int isReadingFeatures;
    int isLoadingFroze;
    int isLoadingNextFeatures;
    int pread_seqNum;
    int reqSeqF;
    int writeWidth;
    int new_params_readFeatures;
    int readPos;
    int volumeSize;
    int usedWords;
    int dataBus[33];
    int doAssemble;
    int readWidth;
    int prefetchFrameSize;
    int new_conv_inst;
    int startPrefetching;
    int new_addrNextFrame;
    int curVolumeSize;
    int maxRowCount;
    int lastLen;
    int state;
    int readCLast;
    int outputBufH1;
    int downPad;
    int topPad;
    int k;
    int stride;
    int rowNum; //signed
    int reset_iLayers;
    int new_rowAddr; //signed
    int sendBackUpInput_valid;
    int backupId;
    int leftPad;
    int input_src;
	
	
	if(EOF == fscanf(fin, "%d", &num))
		exit(0);
	printf("read %d\n", num);

	fscanf(fin, " %d %d %d %d %d %d", &pread_busValid, &pread_isFeature, &isReadingFeatures
		, &isLoadingFroze, &isLoadingNextFeatures, &pread_seqNum);
	fscanf(fin, " %d %d %d %d %d %d", &reqSeqF, &writeWidth, &new_params_readFeatures
		, &readPos, &volumeSize, &usedWords);
	//AssembleInput
	fscanf(fin, " %d %d", &doAssemble, &readWidth);
	fscanf(fin, " %d %d %d %d %d %d %d", &prefetchFrameSize, &new_conv_inst, &startPrefetching
		, &new_addrNextFrame, &curVolumeSize
		, &maxRowCount, &lastLen);
	
	//BuildInputFifo
	fscanf(fin, " %d %d %d %d %d %d", &state, &readCLast
		, &outputBufH1, &downPad, &topPad, &k);
	fscanf(fin, " %d %d %d %d\n", &stride, &rowNum
		, &reset_iLayers, &new_rowAddr);

	//SendBackUpInput
	fscanf(fin, " %d %d %d", &sendBackUpInput_valid, &backupId, &leftPad);
	
	//SetupShiftInputs
	fscanf(fin, " %d", &input_src);

	if (pread_busValid && pread_isFeature && isReadingFeatures)
		for (i = 0; i < MAX_LOAD_WIDTH; i++)
			fscanf(fin, " %d", dataBus + i);
	else
		for (i = 0; i < MAX_LOAD_WIDTH; i++)
			dataBus[i] = -1;

	in_data->pread_busValid = pread_busValid;
	in_data->pread_isFeature = pread_isFeature;
	in_data->isReadingFeatures = isReadingFeatures;
	in_data->isLoadingFroze = isLoadingFroze;
	in_data->isLoadingNextFeatures = isLoadingNextFeatures;

	in_data->pread_seqNum->aval = pread_seqNum;
	in_data->pread_seqNum->bval = 0;
	in_data->reqSeqF->aval = reqSeqF;
	in_data->reqSeqF->bval = 0;
	in_data->writeWidth->aval = writeWidth;
	in_data->writeWidth->bval = 0;
	
	in_data->new_params_readFeatures = new_params_readFeatures;

	in_data->readPos->aval = readPos;
	in_data->readPos->bval = 0;
	in_data->volumeSize->aval = volumeSize;
	in_data->volumeSize->bval = 0;
	in_data->usedWords->aval = usedWords;
	in_data->usedWords->bval = 0;

	in_data->doAssemble = doAssemble;
	in_data->readWidth->aval = readWidth;
	in_data->readWidth->bval = 0;
	in_data->prefetchFrameSize->aval = prefetchFrameSize;
	in_data->prefetchFrameSize->bval = 0;
	
	in_data->new_conv_inst = new_conv_inst;
	in_data->startPrefetching = startPrefetching;

	in_data->new_addrNextFrame->aval = new_addrNextFrame;
	in_data->new_addrNextFrame->bval = 0;
	in_data->curVolumeSize->aval = curVolumeSize;
	in_data->curVolumeSize->bval = 0;
	in_data->maxRowCount->aval = maxRowCount;
	in_data->maxRowCount->bval = 0;
	in_data->lastLen->aval = lastLen;
	in_data->lastLen->bval = 0;
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
	
	in_data->reset_iLayers = reset_iLayers;
	in_data->new_rowAddr->aval = new_rowAddr;
	in_data->new_rowAddr->bval = 0;
	in_data->sendBackUpInput_valid = sendBackUpInput_valid;

	in_data->backupId->aval = backupId;
	in_data->backupId->bval = 0;
	in_data->leftPad->aval = leftPad;
	in_data->leftPad->bval = 0;
	in_data->input_src->aval = input_src;
	in_data->input_src->bval = 0;

	for (i = 0; i < MAX_LOAD_WIDTH; i++){
		in_data->dataBus[i]->aval = dataBus[i];
		in_data->dataBus[i]->bval = 0;
	}
}



void compare_outputs(const input_outputs* out_data)
{
	int i;
	int num;
	int setLoadingFroze;
    int resetLoadingFroze;
    int resetLoadingNextFeatures;
    int resetReadingFeatures;
    int resetAssemble;
    int backupBus[7];
    int isBackupValid;
    int shiftInputs[7];
    int nextWritePos;
    int ibSize;
    int atmpSize;
    int curRowCount;
    int addrNextFrame;
    int addrCurAssemble;
    int iLayers;
    int rowAddr; //signed
    int inputs_buffer_progfull, inputs_buffer_wen;
	int inputs_buffer_ren, inputs_buffer_empty;
    int inputs_raddr;
	int input_requested, addrNextAssemble;

    int input_ren;
     int assemble_buff_wen, assemble_buff_ren, is_assemble_buff_full, is_assemble_buff_empty;
     int inputfifo_wen, inputfifo_ren, is_input_fifo_full, is_input_fifo_empty;

    int shift_len;
    int backup_len;
    int rf_len, rf_addr;
    int rf_dataOut[INPUT_MEM_WIDTH];
	
	if(EOF ==fscanf(fout, "%d", &num))
		exit(0);
	printf("output %d\n", num);
	/*{
		printf("input buffer : ");
		for(i = 0; i< INPUT_MEM_WIDTH; i++)
			printf(" %d", out_data->input_buffer[i]->aval);
		printf("\n");
	}*/
	fscanf(fout, "%d", &rf_len);
	
	if(rf_len > 0){
		fscanf(fout, "%d", &rf_addr);
		for (i = 0; i < rf_len; i++)
			fscanf(fout, " %d", rf_dataOut + i);
	}

	fscanf(fout, " %d %d %d %d %d %d %d %d %d", &input_ren
		, &assemble_buff_wen, &assemble_buff_ren, &is_assemble_buff_full, &is_assemble_buff_empty
		, &inputfifo_wen, &inputfifo_ren, &is_input_fifo_full, &is_input_fifo_empty);
	if(out_data->input_ren != input_ren)
		printf("\tinput_ren %d vs %d\n", out_data->input_ren, input_ren);
	if(out_data->assemble_buff_wen != assemble_buff_wen)
		printf("\t assemble_buff_wen %d vs %d\n", out_data->assemble_buff_wen, assemble_buff_wen);
	if(out_data->assemble_buff_ren != assemble_buff_ren)
		printf("\t assemble_buff_ren %d vs %d\n", out_data->assemble_buff_ren, assemble_buff_ren);
	if(is_assemble_buff_full)
		if(out_data->is_assemble_buff_full != is_assemble_buff_full)
			printf("\t is_assemble_buff_full %d vs %d\n", out_data->is_assemble_buff_full, is_assemble_buff_full);
	if(is_assemble_buff_empty)
		if(out_data->is_assemble_buff_empty != is_assemble_buff_empty)
			printf("\t is_assemble_buff_empty %d vs %d\n", out_data->is_assemble_buff_empty, is_assemble_buff_empty);
	if(out_data->inputfifo_wen != inputfifo_wen)
		printf("\t inputfifo_wen %d vs %d\n", out_data->inputfifo_wen, inputfifo_wen);
	if(out_data->inputfifo_ren != inputfifo_ren)
		printf("\t inputfifo_ren %d vs %d\n", out_data->inputfifo_ren, inputfifo_ren);
	if(is_input_fifo_full)
		if(out_data->is_input_fifo_full != is_input_fifo_full)
			printf("\t is_input_fifo_full %d vs %d\n", out_data->is_input_fifo_full, is_input_fifo_full);
	if(is_input_fifo_empty)
		if(out_data->is_input_fifo_empty != is_input_fifo_empty)
			printf("\t is_input_fifo_empty %d vs %d\n", out_data->is_input_fifo_empty, is_input_fifo_empty);

	fscanf(fout, " %d %d %d %d %d %d", &setLoadingFroze, &resetLoadingFroze, &resetLoadingNextFeatures
		, &resetReadingFeatures, &ibSize, &nextWritePos);

	fscanf(fout, " %d %d %d %d %d", &resetAssemble, &atmpSize, &curRowCount
		, &addrCurAssemble, &addrNextFrame);

	fscanf(fout, " %d %d", &iLayers, &rowAddr);

    fscanf(fout, " %d %d %d %d %d %d %d", &inputs_buffer_progfull, &inputs_buffer_wen
		, &inputs_buffer_ren, &inputs_buffer_empty, &inputs_raddr
		, &input_requested, &addrNextAssemble);

	fscanf(fout, "%d", &shift_len);
	if (shift_len > 0){
		for (i = 0; i < shift_len; i++)
			fscanf(fout, " %d", shiftInputs + i);
	}
	fscanf(fout, "%d", &isBackupValid);
	if (isBackupValid){
		fscanf(fout, "%d", &backup_len);
		for (i = 0; i < backup_len; i++)
			fscanf(fout, "%d", backupBus + i);
	}
	
	if(out_data->inputs_buffer_progfull != inputs_buffer_progfull)
		printf("\tinputs_buffer_progfull %d vs %d\n", out_data->inputs_buffer_progfull, inputs_buffer_progfull);
	if(out_data->inputs_buffer_wen != inputs_buffer_wen)
		printf("\t inputs_buffer_wen %d vs %d\n", out_data->inputs_buffer_wen, inputs_buffer_wen);
	if(out_data->inputs_buffer_ren != inputs_buffer_ren)
		printf("\t inputs_buffer_ren %d vs %d\n", out_data->inputs_buffer_ren, inputs_buffer_ren);
	if(out_data->inputs_buffer_ren != inputs_buffer_ren)
		printf("\t inputs_buffer_ren %d vs %d\n", out_data->inputs_buffer_ren, inputs_buffer_ren);
    if(input_ren)
	if(out_data->inputs_raddr->aval != (inputs_raddr / 12))
		printf("\t inputs_raddr %d vs %d\n", out_data->inputs_raddr->aval, inputs_raddr);
	if(out_data->input_requested != input_requested)
		printf("\t input_requested %d vs %d\n", out_data->input_requested, input_requested);
	if(out_data->addrNextAssemble->aval != (addrNextAssemble / 12))
		printf("\t addrNextAssemble %d vs %d\n", out_data->addrNextAssemble->aval, addrNextAssemble);
	if(out_data->setLoadingFroze != setLoadingFroze)
		printf("\tsetLoadingFroze %d vs %d\n", out_data->setLoadingFroze, setLoadingFroze);
	if(out_data->resetLoadingFroze != resetLoadingFroze)
		printf("\tresetLoadingFroze %d vs %d\n", out_data->resetLoadingFroze, resetLoadingFroze);
	if(out_data->resetLoadingNextFeatures != resetLoadingNextFeatures)
		printf("\tresetLoadingNextFeatures %d vs %d\n", out_data->resetLoadingNextFeatures, resetLoadingNextFeatures);
	if(out_data->resetReadingFeatures != resetReadingFeatures)
		printf("\tresetReadingFeatures %d vs %d\n", out_data->resetReadingFeatures, resetReadingFeatures);

	if(out_data->ibSize->aval != ibSize)
		printf("\tibSize %d vs %d\n", out_data->ibSize->aval, ibSize);
	if(out_data->nextWritePos->aval != nextWritePos)
		printf("\tnextWritePos %d vs %d\n", out_data->nextWritePos->aval, nextWritePos);

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

	if(out_data->iLayers->aval != iLayers)
		printf("\tiLayers %d vs %d\n", out_data->iLayers->aval, iLayers);
	int row = SV_GET_SIGNED_BITS(out_data->rowAddr->aval, 5);
	if(row != rowAddr)
		printf("\trowAddr %d vs %d\n", row, rowAddr);

	if(out_data->isBackupValid != isBackupValid)
		printf("\tisBackupValid %d vs %d\n", out_data->isBackupValid, isBackupValid);
	
	int equal = 1;
	if(shift_len)
	for (i = 0; i < shift_len; i++)	{
		int val = SV_GET_SIGNED_BITS(out_data->shiftInputs[i]->aval, FEATURE_BIT_NUM - 1);
		if(val != shiftInputs[i])
			equal = 0;
	}

	if(!equal)
	{
		printf("shiftInputs");
		for (i = 0; i < shift_len; i++){
			int val = SV_GET_SIGNED_BITS(out_data->shiftInputs[i]->aval, FEATURE_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected  ");
		for (i = 0; i < shift_len; i++)
			printf(" %d", shiftInputs[i]);
		printf("\n");
	}

	if(isBackupValid){
		equal = 1;
		for (i = 0; i < backup_len; i++){
			int val = SV_GET_SIGNED_BITS(out_data->backupBus[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != backupBus[i])
				equal = 0;
		}

		if(!equal)
		{
			printf("backupBus");
			for (i = 0; i < backup_len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->backupBus[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected  ");
			for (i = 0; i < backup_len; i++)
				printf(" %d", backupBus[i]);
			printf("\n");
		}
	}


	if(rf_len == 0){
		if(out_data->rf_wen)
			printf("\trf_wen %d vs 0\n", out_data->rf_wen);
	}else{
		if(out_data->rf_wen != 1)
			printf("\trf_wen %d vs 1\n", out_data->rf_wen);
		if(out_data->rf_addrOut->aval * INPUT_MEM_WIDTH != rf_addr)
			printf("\trf_addrOut %d vs %d\n", out_data->rf_addrOut->aval, rf_addr);

		int equal = 1;
		for (i = 0; i < rf_len; i++)	{
			int val = SV_GET_SIGNED_BITS(out_data->rf_dataOut[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != rf_dataOut[i])
				equal = 0;
		}
		if(!equal)
		{
			printf("rf_dataOut ");
			for (i = 0; i < rf_len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->rf_dataOut[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected");
			for (i = 0; i < rf_len; i++)
				printf(" %d", rf_dataOut[i]);
			printf("\n");
		}
	}
}

#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

#define MAX_LOAD_WIDTH	33
#define INPUT_MEM_WIDTH	12
#define  FEATURE_BIT_NUM  8

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank3_readfeature_input.txt", "rt");
	fout = fopen("D:/aidata/bank3_readfeature_output.txt", "rt");
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(readFeatures_inputs* in_data)
{
	int i;
	int num;
	int pread_busValid, pread_isFeature;
	int isReadingFeatures, isLoadingFroze;
	int isLoadingNextFeatures;
	int pread_seqNum, reqSeqF;
	int writeWidth;

	int new_params;
	int readPos;
	int volumeSize;

	int usedWords;
	int  dataBus[MAX_LOAD_WIDTH];

	if(EOF == fscanf(fin, "%d %d %d %d %d %d %d", &num, &pread_busValid
				, &pread_isFeature, &isReadingFeatures
				, &isLoadingFroze, &isLoadingNextFeatures, &pread_seqNum))
		exit(0);
	printf("read %d\n", num);

	fscanf(fin, "%d %d %d %d %d %d", &reqSeqF, &writeWidth, &new_params
			, &readPos, &volumeSize, &usedWords);

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
	in_data->new_params = new_params;

	in_data->readPos->aval = readPos;
	in_data->readPos->bval = 0;
	in_data->volumeSize->aval = volumeSize;
	in_data->volumeSize->bval = 0;
	in_data->usedWords->aval = usedWords;
	in_data->usedWords->bval = 0;


	if (pread_busValid){
		for (i = 0; i < MAX_LOAD_WIDTH; i++){
			fscanf(fin, " %d", dataBus + i);
			in_data->dataBus[i]->aval = dataBus[i];
			in_data->dataBus[i]->bval = 0;
		}
	}

}



void compare_outputs(const readFeatures_outputs* out_data)
{
	int i;
	int num;
	int len;
	int addr;
	int dataOut[INPUT_MEM_WIDTH];
	int setLoadingFroze;
	int resetLoadingFroze;
	int resetLoadingNextFeatures;
	int resetReadingFeatures;
	int nextWritePos;
	int ibSize;




	if(EOF ==fscanf(fout, "%d %d", &num, &len))
		exit(0);
	printf("output %d\n", num);

	if(len > 0){
		fscanf(fout, "%d", &addr);
		for (i = 0; i < len; i++)
			fscanf(fout, " %d", dataOut + i);
	}
	fscanf(fout, " %d %d %d %d %d %d\n", &setLoadingFroze, &resetLoadingFroze, &resetLoadingNextFeatures
			, &resetReadingFeatures, &ibSize, &nextWritePos);

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
	if(len == 0){
		if(out_data->wen)
			printf("\twen %d vs 0\n", out_data->wen);
	}else{
		if(out_data->wen != 1)
			printf("\twen %d vs 1\n", out_data->wen);
		if(out_data->addrOut->aval * INPUT_MEM_WIDTH != addr)
			printf("\taddrOut %d vs %d\n", out_data->addrOut->aval, addr);

		int equal = 1;
		for (i = 0; i < len; i++)	{
			int val = SV_GET_SIGNED_BITS(out_data->dataOut[i]->aval, FEATURE_BIT_NUM - 1);
			if(val != dataOut[i])
				equal = 0;
		}
		if(!equal)
		{
			printf("dataOut ");
			for (i = 0; i < len; i++){
				int val = SV_GET_SIGNED_BITS(out_data->dataOut[i]->aval, FEATURE_BIT_NUM - 1);
				printf(" %d", val);
			}
			printf("\nexpected");
			for (i = 0; i < len; i++)
				printf(" %d", dataOut[i]);
			printf("\n");
		}
	}

}

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank0_hcbctrl_input.txt", "rt");
	fout = fopen("D:/aidata/bank0_hcbctrl_output.txt", "rt");
	assert(fin);
	assert(fout);
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(HCBCtrl_inputs* in_data)
{
	int num;
	int enable;
    int stop;
    int waiting_out;
    int k;
    int stride;
    int doBM;
    int doRelu;
    int doLRelu;
    int doRes;
    int isOnOutput;
    int reset_isOnOutput;
    int BM_enough_data;
    int w_enough_data;
    int receivedRes;
    int totalRes;
    int input_fifo_empty;
    int readCLast;
    int new_conv_inst;
    int Ks;
    int kt;
    int new_wtotal;
    int numGroups;
    int reset_state;
    int resetLoadingNextFeatures;
    int resetReadingFeatures;
    int new_params_prefetch;
    int setLoadingFroze;
    int resetLoadingFroze;
    int writeWidth;
    int resetAssemble;
    int new_readWidth;
    int new_outputBufH1;
    int new_rowNum;
    int prefetchFrameSize;
    int new_kCur;
    int new_usedGroups;
    int inst_k;
    int kOut;
    int kCurLast;
    int usedGroupsLast;
    int wtotal_n;
    int wlenk_nLast;
    int wtotalLast;
    int wlenk_nLast2;
    int wlenk_regular;
    int wlen_regular;
    int new_wlenk;
    int new_wlenk_last;
    int kCurLast_1;
    int new_maxRowCount;
    int new_lastLen;

	if(EOF == fscanf(fin, "%d", &num))
		exit(0);
	printf("read %d\n", num);

	fscanf(fin, " %d %d %d %d %d %d %d %d", &enable, &stop
		, &waiting_out, &k, &stride
		, &doBM, &doRelu, &doLRelu);

	fscanf(fin, " %d %d %d %d", &doRes
		, &isOnOutput, &receivedRes, &totalRes); //w_enough_data
	
	fscanf(fin, " %d %d %d %d %d %d %d %d", &input_fifo_empty, &readCLast
		, &new_conv_inst, &Ks, &kt
		, &new_wtotal, &numGroups, &writeWidth);
	
	fscanf(fin, " %d %d %d %d %d %d %d %d", &new_readWidth, &new_outputBufH1
		, &new_rowNum, &prefetchFrameSize, &new_kCur
		, &new_usedGroups, &inst_k, &kOut);

	fscanf(fin, " %d %d %d %d %d %d %d %d", &kCurLast, &usedGroupsLast
		, &wtotal_n, &wlenk_nLast, &wtotalLast
		, &wlenk_nLast2, &wlenk_regular, &wlen_regular);

	fscanf(fin, " %d %d %d %d %d", &new_wlenk, &new_wlenk_last
		, &kCurLast_1, &new_maxRowCount, &new_lastLen);

	fscanf(fin, " %d %d %d %d %d %d %d %d %d %d\n", &reset_isOnOutput, &reset_state
		, &BM_enough_data //BM_enough_data
		, &w_enough_data
		, &resetLoadingNextFeatures, &resetReadingFeatures, &new_params_prefetch
		, &setLoadingFroze, &resetLoadingFroze, &resetAssemble);


	in_data->enable = enable;
	in_data->stop = stop;
	in_data->waiting_out = waiting_out;

	in_data->k->aval = k;
	in_data->k->bval = 0;
	in_data->stride->aval = stride;
	in_data->stride->bval = 0;
	
	in_data->doBM = doBM;
	in_data->doRelu = doRelu;
	in_data->doLRelu = doLRelu;
	in_data->doRes = doRes;

	
	in_data->isOnOutput = isOnOutput;
	in_data->reset_isOnOutput = reset_isOnOutput;
	in_data->BM_enough_data = BM_enough_data;
	in_data->w_enough_data = w_enough_data;

	in_data->receivedRes->aval = receivedRes;
	in_data->receivedRes->bval = 0;
	in_data->totalRes->aval = totalRes;
	in_data->totalRes->bval = 0;
	in_data->input_fifo_empty = input_fifo_empty;
	in_data->readCLast->aval = readCLast;
	in_data->readCLast->bval = 0;
	in_data->new_conv_inst = new_conv_inst;


	in_data->Ks->aval = Ks;
	in_data->Ks->bval = 0;
	in_data->kt->aval = kt;
	in_data->kt->bval = 0;
	in_data->new_wtotal->aval = new_wtotal;
	in_data->new_wtotal->bval = 0;
	in_data->numGroups->aval = numGroups;
	in_data->numGroups->bval = 0;

	in_data->reset_state = reset_state;
	in_data->resetLoadingNextFeatures = resetLoadingNextFeatures;
	in_data->resetReadingFeatures = resetReadingFeatures;
	in_data->new_params_prefetch = new_params_prefetch;
	in_data->setLoadingFroze = setLoadingFroze;
	in_data->resetLoadingFroze = resetLoadingFroze;
	in_data->writeWidth->aval = writeWidth;
	in_data->writeWidth->bval = 0;
	in_data->resetAssemble = resetAssemble;

	in_data->new_readWidth->aval = new_readWidth;
	in_data->new_readWidth->bval = 0;
	in_data->new_outputBufH1->aval = new_outputBufH1;
	in_data->new_outputBufH1->bval = 0;
	in_data->new_rowNum->aval = new_rowNum;
	in_data->new_rowNum->bval = 0;
	in_data->prefetchFrameSize->aval = prefetchFrameSize;
	in_data->prefetchFrameSize->bval = 0;
	in_data->new_kCur->aval = new_kCur;
	in_data->new_kCur->bval = 0;
	in_data->new_usedGroups->aval = new_usedGroups;
	in_data->new_usedGroups->bval = 0;
	in_data->inst_k->aval = inst_k;
	in_data->inst_k->bval = 0;
	in_data->kOut->aval = kOut;
	in_data->kOut->bval = 0;
	in_data->kCurLast->aval = kCurLast;
	in_data->kCurLast->bval = 0;
	in_data->usedGroupsLast->aval = usedGroupsLast;
	in_data->usedGroupsLast->bval = 0;
	in_data->wtotal_n->aval = wtotal_n;
	in_data->wtotal_n->bval = 0;
	in_data->wlenk_nLast->aval = wlenk_nLast;
	in_data->wlenk_nLast->bval = 0;
	in_data->wtotalLast->aval = wtotalLast;
	in_data->wtotalLast->bval = 0;
	in_data->wlenk_nLast2->aval = wlenk_nLast2;
	in_data->wlenk_nLast2->bval = 0;
	in_data->wlenk_regular->aval = wlenk_regular;
	in_data->wlenk_regular->bval = 0;
	in_data->wlen_regular->aval = wlen_regular;
	in_data->wlen_regular->bval = 0;
	in_data->new_wlenk->aval = new_wlenk;
	in_data->new_wlenk->bval = 0;
	in_data->new_wlenk_last->aval = new_wlenk_last;
	in_data->new_wlenk_last->bval = 0;
	in_data->kCurLast_1->aval = kCurLast_1;
	in_data->kCurLast_1->bval = 0;
	in_data->new_maxRowCount->aval = new_maxRowCount;
	in_data->new_maxRowCount->bval = 0;
	in_data->new_lastLen->aval = new_lastLen;
	in_data->new_lastLen->bval = 0;
}



void compare_outputs(const HCBCtrl_outputs* out_data)
{
	int num;
	int is_cycle_froze;
	int startPrefetching;
    int startConvOut;
    int BMlen;
    int wlenk;
    int enSendBMWeights;
    int enSendWeights;
    int isBMWeightValid;
    int isWeightValid;
    int weightId;
    int sendBackUpInput_valid;
    int backupId;
    int isOutputReady;
    int nextWeight;
    int readWidth;
    int rowNum; //signed
    int reset_iLayers;
    int loadNextInst;
    int isPrefetchNextVolume_next;
    int isPrefetchNextVolume;
    int workingProgress_o;
    int doOutScale_o;
    int doAssemble_o;
    int usedWords_o;
    int isInitLayer_o;
    int isReadingFeatures_o;
    int isLoadingFroze_o;
    int hasNextFeatureParams_o;
    int isLoadingNextFeatures_o;
    int isLReluWeight_o;
    int iterCountDown_o;
    int outputReadPos_o;
    int outputWritePos_o;
    int state_o;
    int state_next_o;
    int outputBufH1_o;
    int isNextVolumeReady_o;
    int bmPhase_o;
    int isRunning_o;
    int maxRowCount;
    int lastLen;
    int outLayerCount;
	int initFSteps;
	int initWSteps;
	int initBMWSteps;
	int layerCount;
	int usedGroups;
	int isBackupValid;
	int input_src;
	int wtotal;
	int wlen;

	if(EOF ==fscanf(fout, "%d", &num))
		exit(0);
	printf("output %d time %d\n", num, out_data->tm);


	fscanf(fout, " %d %d %d %d %d %d %d %d %d"
        , &is_cycle_froze, &startPrefetching, &startConvOut
		, &BMlen, &wlenk, &enSendBMWeights
		, &enSendWeights, &isBMWeightValid, &isWeightValid);

	fscanf(fout, " %d %d %d %d %d %d %d %d %d", &weightId, &sendBackUpInput_valid
		, &isBackupValid, &backupId, &isOutputReady, &nextWeight
		, &readWidth, &rowNum, &reset_iLayers);

	fscanf(fout, " %d %d %d %d %d %d %d %d", &loadNextInst, &isPrefetchNextVolume_next
		, &isPrefetchNextVolume, &workingProgress_o, &doOutScale_o
		, &doAssemble_o, &usedWords_o, &isInitLayer_o);

	fscanf(fout, " %d %d %d %d %d %d %d %d", &isReadingFeatures_o, &isLoadingFroze_o
		, &hasNextFeatureParams_o, &isLoadingNextFeatures_o, &isLReluWeight_o
		, &iterCountDown_o, &outputReadPos_o, &outputWritePos_o);

	fscanf(fout, " %d %d %d %d %d %d %d %d", &state_o, &state_next_o
		, &outputBufH1_o, &isNextVolumeReady_o, &bmPhase_o
		, &isRunning_o, &maxRowCount, &lastLen);

	fscanf(fout, " %d %d %d %d %d %d %d %d %d", &input_src, &outLayerCount, &initFSteps
		, &initWSteps, &initBMWSteps, &layerCount, &usedGroups, &wtotal, &wlen);

	/*if(num > 7258954){
		printf("state %d, initWStep %d, wtotat %d, wlen %d\n", state_o, initWSteps, wtotal, wlen);
		printf("state %d, initWStep %d, wtotat %d, wlen %d, flag %d\n"
		, out_data->state_o->aval, out_data->initWSteps->aval, out_data->wtotal->aval
		, out_data->wlen->aval, out_data->flag);
	}

	if(num > 7259054)
		exit(0);
	*/
	
	
	if(out_data->is_cycle_froze != is_cycle_froze)
		printf("\t is_cycle_froze %d vs %d\n", out_data->is_cycle_froze, is_cycle_froze);
	if(out_data->startPrefetching != startPrefetching)
		printf("\t startPrefetching %d vs %d\n", out_data->startPrefetching, startPrefetching);
	if(out_data->startConvOut != startConvOut)
		printf("\t startConvOut %d vs %d\n", out_data->startConvOut, startConvOut);
	if(enSendBMWeights)	
	if(out_data->BMlen->aval != BMlen)
		printf("\t BMlen %d vs %d\n", out_data->BMlen->aval, BMlen);
	if(out_data->wlenk->aval != wlenk)
		printf("\t wlenk %d vs %d\n", out_data->wlenk->aval, wlenk);
	if(out_data->wlen->aval != wlen)
		printf("\t wlen %d vs %d\n", out_data->wlen->aval, wlen);
	if(out_data->wtotal->aval != wtotal)
		printf("\t wtotal %d vs %d\n", out_data->wtotal->aval, wtotal);
	
	if(out_data->enSendBMWeights != enSendBMWeights)
		printf("\t enSendBMWeights %d vs %d\n", out_data->enSendBMWeights, enSendBMWeights);
    if(!is_cycle_froze){
        if(out_data->enSendWeights != enSendWeights)
            printf("\t enSendWeights %d vs %d\n", out_data->enSendWeights, enSendWeights);
    }
	if(out_data->isBMWeightValid != isBMWeightValid)
		printf("\t isBMWeightValid %d vs %d\n", out_data->isBMWeightValid, isBMWeightValid);
	if(out_data->isWeightValid != isWeightValid)
		printf("\t isWeightValid %d vs %d\n", out_data->isWeightValid, isWeightValid);
	if(isBMWeightValid || isWeightValid && !is_cycle_froze)
	if(out_data->weightId->aval != weightId)
		printf("\t weightId %d vs %d\n", out_data->weightId->aval, weightId);
	if(out_data->sendBackUpInput_valid != sendBackUpInput_valid)
		printf("\t sendBackUpInput_valid %d vs %d\n", out_data->sendBackUpInput_valid, sendBackUpInput_valid);
	if(isBackupValid)
	if(out_data->backupId->aval != backupId)
		printf("\t backupId %d vs %d\n", out_data->backupId->aval, backupId);

	if(out_data->isOutputReady != isOutputReady)
		printf("\t isOutputReady %d vs %d\n", out_data->isOutputReady, isOutputReady);
	if(out_data->nextWeight != nextWeight)
		printf("\t nextWeight %d vs %d\n", out_data->nextWeight, nextWeight);
	
	if(out_data->readWidth->aval != readWidth)
		printf("\t readWidth %d vs %d\n", out_data->readWidth->aval, readWidth);
	int val = SV_GET_SIGNED_BITS(out_data->rowNum->aval, 5);
	if(val != rowNum)//signed
		printf("\t rowNum %d vs %d\n", val, rowNum);

	if(out_data->reset_iLayers != reset_iLayers)
		printf("\t reset_iLayers %d vs %d\n", out_data->reset_iLayers, reset_iLayers);
	if(out_data->loadNextInst != loadNextInst)
		printf("\t loadNextInst %d vs %d\n", out_data->loadNextInst, loadNextInst);
	if(out_data->isPrefetchNextVolume_next != isPrefetchNextVolume_next)
		printf("\t isPrefetchNextVolume_next %d vs %d\n", out_data->isPrefetchNextVolume_next, isPrefetchNextVolume_next);
	if(out_data->isPrefetchNextVolume != isPrefetchNextVolume)
		printf("\t isPrefetchNextVolume %d vs %d\n", out_data->isPrefetchNextVolume, isPrefetchNextVolume);

	if(out_data->workingProgress_o->aval != workingProgress_o)
		printf("\t workingProgress_o %d vs %d\n", out_data->workingProgress_o->aval, workingProgress_o);
	if(out_data->doAssemble_o != doAssemble_o)
		printf("\t doAssemble_o %d vs %d\n", out_data->doAssemble_o, doAssemble_o);
	if(out_data->usedWords_o->aval != usedWords_o)
		printf("\t usedWords_o %d vs %d\n", out_data->usedWords_o->aval, usedWords_o);

	if(out_data->isInitLayer_o != isInitLayer_o)
		printf("\t isInitLayer_o %d vs %d\n", out_data->isInitLayer_o, isInitLayer_o);
	if(out_data->isReadingFeatures_o != isReadingFeatures_o)
		printf("\t isReadingFeatures_o %d vs %d\n", out_data->isReadingFeatures_o, isReadingFeatures_o);
	if(out_data->isLoadingFroze_o != isLoadingFroze_o)
		printf("\t isLoadingFroze_o %d vs %d\n", out_data->isLoadingFroze_o, isLoadingFroze_o);
	if(out_data->hasNextFeatureParams_o != hasNextFeatureParams_o)
		printf("\t hasNextFeatureParams_o %d vs %d\n", out_data->hasNextFeatureParams_o, hasNextFeatureParams_o);
	if(out_data->isLoadingNextFeatures_o != isLoadingNextFeatures_o)
		printf("\t isLoadingNextFeatures_o %d vs %d\n", out_data->isLoadingNextFeatures_o, isLoadingNextFeatures_o);
	if(out_data->isLReluWeight_o != isLReluWeight_o)
		printf("\t isLReluWeight_o %d vs %d\n", out_data->isLReluWeight_o, isLReluWeight_o);

	if(out_data->iterCountDown_o->aval != iterCountDown_o)
		printf("\t iterCountDown_o %d vs %d\n", out_data->iterCountDown_o->aval, iterCountDown_o);
	if(out_data->outputReadPos_o->aval != outputReadPos_o)
		printf("\t outputReadPos_o %d vs %d\n", out_data->outputReadPos_o->aval, outputReadPos_o);
	if(out_data->outputWritePos_o->aval != outputWritePos_o)
		printf("\t outputWritePos_o %d vs %d\n", out_data->outputWritePos_o->aval, outputWritePos_o);
	if(out_data->state_o->aval != state_o)
		printf("\t state_o %d vs %d\n", out_data->state_o->aval, state_o);
	if(out_data->state_next_o->aval != state_next_o)
		printf("\t state_next_o %d vs %d\n", out_data->state_next_o->aval, state_next_o);
	if(out_data->outputBufH1_o->aval != outputBufH1_o)
		printf("\t outputBufH1_o %d vs %d\n", out_data->outputBufH1_o->aval, outputBufH1_o);

	if(out_data->isNextVolumeReady_o != isNextVolumeReady_o)
		printf("\t isNextVolumeReady_o %d vs %d\n", out_data->isNextVolumeReady_o, isNextVolumeReady_o);
	if(out_data->bmPhase_o != bmPhase_o)
		printf("\t bmPhase_o %d vs %d\n", out_data->bmPhase_o, bmPhase_o);
	if(out_data->isRunning_o != isRunning_o)
		printf("\t isRunning_o %d vs %d\n", out_data->isRunning_o, isRunning_o);

	if(out_data->maxRowCount->aval != maxRowCount)
		printf("\t maxRowCount %d vs %d\n", out_data->maxRowCount->aval, maxRowCount);
	if(out_data->lastLen->aval != lastLen)
		printf("\t lastLen %d vs %d\n", out_data->lastLen->aval, lastLen);
	if(out_data->outLayerCount->aval != outLayerCount)
		printf("\t outLayerCount %d vs %d\n", out_data->outLayerCount->aval, outLayerCount);
	if(out_data->initFSteps->aval != initFSteps)
		printf("\t initFSteps %d vs %d\n", out_data->initFSteps->aval, initFSteps);
	if(out_data->initWSteps->aval != initWSteps)
		printf("\t initWSteps %d vs %d\n", out_data->initWSteps->aval, initWSteps);
	if(out_data->initBMWSteps->aval != initBMWSteps)
		printf("\t initBMWSteps %d vs %d\n", out_data->initBMWSteps->aval, initBMWSteps);
	if(out_data->layerCount->aval != layerCount)
		printf("\t layerCount %d vs %d\n", out_data->layerCount->aval, layerCount);
	if(out_data->usedGroups->aval != usedGroups)
		printf("\t usedGroups %d vs %d\n", out_data->usedGroups->aval, usedGroups);
	if(out_data->input_src->aval != input_src)
		printf("\t input_src %d vs %d\n", out_data->input_src->aval, input_src);
}

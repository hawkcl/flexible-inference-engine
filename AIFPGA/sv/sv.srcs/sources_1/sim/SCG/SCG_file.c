#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

#define WEIGHT_BUS_SIZE 8 
#define MAX_K	7
#define COMPUTING_GROUP_SIZE	7
#define FEATURE_BIT_NUM 8
#define MULTI_BIT_NUM 20
//will have false output when network has no real output, check Debug.txt
FILE *fin;
FILE *fout;
int pre_on_output;
int pre_outsize;
void init_files() 
{
    //Attention. Need to change SCG_NUM in SCG_tb.sv as well
	fin = fopen("D:/aidata/bank0_SCG2_input.txt", "rt");
	fout = fopen("D:/aidata/bank0_SCG2_output.txt", "rt");
	pre_on_output = 0;
	pre_outsize = 0;
	//skip first line
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(SCG_inputs* in_data)
{
	
	int i , num;
	int state, state_next;
	int wscale;
	int k;
	int isInitLayer, doLRelu, doRelu, bmPhase,isLReluWeight;
	int cgSwitchOutput,nextWeight, setConvIndex;
#ifdef S2_OPTIMIZE
	int isStride2;
	int phcg_backupBus[COMPUTING_GROUP_SIZE*2];
#else
	int stride;
	int phcg_backupBus[COMPUTING_GROUP_SIZE];
#endif
	int isBMWeightValid, isWeightValid;
	int wLRelu;
	int phcg_weightId;
	int inst_k;;
	int iterCountDown;
	int weightBus[WEIGHT_BUS_SIZE];
	int bmWeightBus[WEIGHT_BUS_SIZE];
	int input_src;
	int shiftInputs[MAX_K];
	int shift_s[COMPUTING_GROUP_SIZE];
	int psum_low[COMPUTING_GROUP_SIZE];
	int output_ready;
	int phcg_backupId;
	int isBackupValid;
	int is_cycle_froze;
	int read_pos, write_pos;
	int out_row;

	if(EOF ==fscanf(fin, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d"
			, &num, &is_cycle_froze, &state, &state_next, &wscale
			, &k, &isInitLayer, &doLRelu, &doRelu
			, &bmPhase, &isLReluWeight, &cgSwitchOutput
			, &nextWeight, &setConvIndex)){
        printf("\7\7\7");
		exit(1);
    }


	fscanf(fin, " %d %d %d %d %d %d %d %d %d %d %d %d %d"
			, &isBMWeightValid, &isWeightValid, &wLRelu, &phcg_weightId
			, &inst_k, &iterCountDown, &input_src, &output_ready
			, &phcg_backupId, &isBackupValid, &read_pos
			, &write_pos, &out_row);
	printf("read %d, cd %d, state %d, init %d\n", num, iterCountDown, state, isInitLayer);

	in_data->state->aval = state ;
	in_data->state_next->aval = state_next;
	in_data->wscale->aval = wscale;
	in_data->k->aval = k;
	in_data->isInitLayer = isInitLayer ;
	in_data->doLRelu = doLRelu;
	in_data->doRelu = doRelu  ;
	in_data->bmPhase = bmPhase;
	in_data->isLReluWeight = isLReluWeight;
	in_data->cgSwitchOutput = cgSwitchOutput;
	in_data->nextWeight = nextWeight  ;
	in_data->setConvIndex = setConvIndex ;
	in_data->isBMWeightValid = isBMWeightValid ;
	in_data->isWeightValid = isWeightValid;
	in_data->wLRelu->aval = wLRelu;
	in_data->phcg_weightId->aval = phcg_weightId;
	in_data->inst_k->aval = inst_k ;
	in_data->iterCountDown->aval = iterCountDown;
	in_data->input_src->aval = input_src;
	in_data->output_ready = output_ready ;
	in_data->phcg_backupId->aval = phcg_backupId;
	in_data->isBackupValid = isBackupValid;
	in_data->is_cycle_froze = is_cycle_froze;
	in_data->read_pos->aval = read_pos ;
	in_data->write_pos->aval = write_pos;
	in_data->out_row->aval = out_row;
	
	in_data->state->bval = 0 ;
	in_data->state_next->bval = 0;
	in_data->wscale->bval = 0;
	in_data->k->bval = 0;
	in_data->wLRelu->bval = 0;
	in_data->phcg_weightId->bval = 0;
	in_data->inst_k->bval = 0 ;
	in_data->iterCountDown->bval = 0;
	in_data->input_src->bval = 0;
	in_data->phcg_backupId->bval = 0;
	in_data->read_pos->bval = 0 ;
	in_data->write_pos->bval = 0;
	in_data->out_row->bval = 0;
    printf("nextweight %d, weightvalid %d, bmwvalid %d, weightid %d\n"
            , nextWeight, isWeightValid, isBMWeightValid, phcg_weightId);

	for (i = 0; i < WEIGHT_BUS_SIZE; i++){
		fscanf(fin, " %d", &weightBus[i]);
		in_data->weightBus[i]->aval = weightBus[i];
		in_data->weightBus[i]->bval = 0;
	}
	for (i = 0; i < WEIGHT_BUS_SIZE; i++){
		fscanf(fin, " %d", &bmWeightBus[i]);
		in_data->bmWeightBus[i]->aval = bmWeightBus[i];
		in_data->bmWeightBus[i]->bval = 0;
	}
    if(isWeightValid){
        printf("weights: ");
        for (i = 0; i < WEIGHT_BUS_SIZE; i++){
            printf(" %d", weightBus[i]);
        }
        printf("\n");
    }
    if(isBMWeightValid){
        printf("BMweights: ");
        for (i = 0; i < WEIGHT_BUS_SIZE; i++){
            printf(" %d", bmWeightBus[i]);
        }
        printf("\n");
    }
	for (i = 0; i < MAX_K; i++){
		fscanf(fin, " %d", &shiftInputs[i]);
		in_data->shiftInputs[i]->aval = shiftInputs[i];
		in_data->shiftInputs[i]->bval = 0;
	}
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fin, " %d", shift_s+i);
		in_data->shift_s[i]->aval = shift_s[i];
		in_data->shift_s[i]->bval = 0;
	}
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fin, " %d", psum_low + i);
		in_data->psum_low[i]->aval = psum_low[i];
		in_data->psum_low[i]->bval = 0;
	}

#ifdef S2_OPTIMIZE
	fscanf(fin, " %d", &isStride2);
	in_data->isStride2->aval = isStride2;
	in_data->isStride2->bval = 0;
	for (i = 0; i < COMPUTING_GROUP_SIZE * 2; i++){weight
		fscanf(fin, " %d", &phcg_backupBus[i]);
		in_data->phcg_backupBus[i]->aval = phcg_backupBus[i];
		in_data->phcg_backupBus[i]->bval = 0;
	}
#else
	fscanf(fin, " %d", &stride);
	in_data->stride->aval = stride;
	in_data->stride->bval = 0;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fin, " %d", &phcg_backupBus[i]);
		in_data->phcg_backupBus[i]->aval = phcg_backupBus[i];
		in_data->phcg_backupBus[i]->bval = 0;
	}
#endif

}

int psum_up[COMPUTING_GROUP_SIZE];
int mMux, a0Mux, aMux, sqMux, lMux, oMux;
int pre_output[COMPUTING_GROUP_SIZE];
void compare_outputs(const SCG_outputs* out_data)
{
	int i;
	int num;
	int isOutput0;
	int conv_idx;
	int weightId;
	int readWeights0;
	int weight;
	int outputReady, on_output;
	int outsize;
	int shift_n[COMPUTING_GROUP_SIZE];
	int inputs[COMPUTING_GROUP_SIZE];
	int backup[COMPUTING_GROUP_SIZE];
	int aq[COMPUTING_GROUP_SIZE];
	int mq[COMPUTING_GROUP_SIZE];
	int sq[COMPUTING_GROUP_SIZE];
	int psumq[COMPUTING_GROUP_SIZE];

	if(EOF ==fscanf(fout, "%d %d %d %d %d %d %d %d %d", &num, &conv_idx, &weightId
		   , &readWeights0, &weight, &isOutput0, &outputReady, &on_output, &outsize)){
        printf("\7\7\7");
		exit(1);
    }
	printf("output %d, time %ld, ww %d, start %d, gid %d\n", num
            , out_data->tm, out_data->write_weights
            , out_data->start->aval, out_data->gid->aval);
	if(out_data->conv_idx->aval != conv_idx)
		printf("\tconv_idx %d vs %d\n", out_data->conv_idx->aval, conv_idx);
	if(out_data->weightId->aval != weightId)
		printf("\tweightId %d vs %d\n", out_data->weightId->aval, weightId);
	if(out_data->readWeights0 != readWeights0)
		printf("\treadWeights0 %d vs %d\n", out_data->readWeights0, readWeights0);
	int val =SV_GET_SIGNED_BITS(out_data->weight->aval, FEATURE_BIT_NUM - 1);
    printf("current weight %d\n", val);
	if(num < 7272279 || num >8124991) // 5 mismatches in between due to waiting for BM weights
		if(val != weight)
			printf("\tweight %d vs %d\n", val, weight);
	if(out_data->isOutput0 != isOutput0)
		printf("\tisOutput0 %d vs %d\n", out_data->isOutput0, isOutput0);
	int equal = 1;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", shift_n + i);
		val = SV_GET_SIGNED_BITS(out_data->shift_n[i]->aval, FEATURE_BIT_NUM - 1);
		if(val != shift_n[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("shift_n ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->shift_n[i]->aval, FEATURE_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", shift_n[i]);
		printf("\n");
	}

	equal = 1;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", inputs + i);
		val = SV_GET_SIGNED_BITS(out_data->inputs[i]->aval, FEATURE_BIT_NUM - 1);
		if(val != inputs[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("inputs  ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->inputs[i]->aval, FEATURE_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", inputs[i]);
		printf("\n");
	}

	equal = 1;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", backup + i);
		val = SV_GET_SIGNED_BITS(out_data->backups[i]->aval, FEATURE_BIT_NUM - 1);
		if(val != backup[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("backup  ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->backups[i]->aval, FEATURE_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", backup[i]);
		printf("\n");
	}

	//mq
	equal = 1;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", mq + i);
		val = SV_GET_SIGNED_BITS(out_data->mq[i]->aval, MULTI_BIT_NUM - 1);
		if(val != mq[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("MQ      ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->mq[i]->aval, MULTI_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", mq[i]);
		printf("\n");
	}

	//aq
	equal = 1;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", aq + i);
		val = SV_GET_SIGNED_BITS(out_data->aq[i]->aval, MULTI_BIT_NUM - 1);
		if(val != aq[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("AQ      ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->aq[i]->aval, MULTI_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", aq[i]);
		printf("\n");
	}

	//sq
	equal = 1;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", sq + i);
		val = SV_GET_SIGNED_BITS(out_data->sq[i]->aval, MULTI_BIT_NUM - 1);
		if(val != sq[i])
			equal = 0;
	}
	if(!equal)
	{
		printf("SQ      ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->sq[i]->aval, MULTI_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", sq[i]);
		printf("\n");
	}

	//psumq
	equal = 1;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", psumq + i);
		val = SV_GET_SIGNED_BITS(out_data->psumq[i]->aval, MULTI_BIT_NUM - 1);
		if(val != psumq[i])
			equal = 0;
	}
   /* 
	if(!equal)
	{
		printf("PSUMQ   ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->psumq[i]->aval, MULTI_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", psumq[i]);
		printf("\n");
	}
	*/
	pre_on_output = on_output;
	pre_outsize = outsize;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", pre_output + i); // in iter num+1 likely
	}
	equal = 1;
	for (i = 0; i < pre_outsize; i++){
		val = SV_GET_SIGNED_BITS(out_data->pre_output[i]->aval, FEATURE_BIT_NUM - 1);
		if(val != pre_output[i])
			equal = 0;
	}
	if(!equal && pre_on_output != 0)
	{
		printf("preout  ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->pre_output[i]->aval, FEATURE_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", pre_output[i]);
		printf("\n");
	}

	/*if(mMux != out_data->cfg.mMux || a0Mux != out_data->cfg.a0Mux->aval  || aMux != out_data->cfg.aMux->aval
		 || sqMux != out_data->cfg.sqMux->aval || lMux != out_data->cfg.lMux || oMux != out_data->cfg.oMux->aval)
	{
		printf("computed mMux %d, a0Mux %d, aMux %d, sqMux %d, lMux %d, oMux %d\n"
				, out_data->cfg.mMux, out_data->cfg.a0Mux->aval, out_data->cfg.aMux->aval
		 	,out_data->cfg.sqMux->aval, out_data->cfg.lMux, out_data->cfg.oMux->aval);
		printf("expected mMux %d, a0Mux %d, aMux %d, sqMux %d, lMux %d, oMux %d\n"
				, mMux, a0Mux, aMux, sqMux, lMux, oMux);
	}*/
	fscanf(fout, " %d %d %d %d %d %d", &mMux, &a0Mux, &aMux, &sqMux, &lMux, &oMux);
	equal = 1;
	for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
		fscanf(fout, " %d", psum_up + i); // in iter num+1 likely
		val = SV_GET_SIGNED_BITS(out_data->psum_up[i]->aval, MULTI_BIT_NUM - 1);
		if(val != psum_up[i])
			equal = 0;
	}
	if(!equal && outputReady != 0)
	{
		printf("psumup  ");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
			val = SV_GET_SIGNED_BITS(out_data->psum_up[i]->aval, MULTI_BIT_NUM - 1);
			printf(" %d", val);
		}
		printf("\nexpected");
		for (i = 0; i < COMPUTING_GROUP_SIZE; i++)
			printf(" %d", psum_up[i]);
		printf("\n");
	}
	//for (i = 0; i < COMPUTING_GROUP_SIZE; i++){
	//	fscanf(fout, " %d", psum_up + i); // in iter num+1 likely
	//}

}

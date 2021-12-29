#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"
#include "dpiheader.h"

FILE *fin;
FILE *fout;
void init_files() 
{
	fin = fopen("D:/aidata/bank0_readextra_input.txt", "rt");
	fout = fopen("D:/aidata/bank0_readextra_output.txt", "rt");
	//char line[5000];
	//fgets(line, 5000, fout);
}

void read_inputs(rex_inputs* in_data)
{

	int num;
	int isReadingFeatures, pread_RequestFull;
	int isResMaster; 
	int this_token, ptoken;
	int res_full;
	int doRes; 
#ifdef S2_OPTIMIZE
	int isStride2;
#endif
	int mode;
	int outputBufW1, outputBufH1Orig; 
	int outW;
	int outFrameSize;
	int outputAddrGap, outFrameGapSize;
	int curSeq;
	int ks;
	int numGroups;
	int kCurLast;
	int resSize0;
	int resSizeLast;
	int resLen0;
	int resLenLast;
	int usedGroupsLast;

	int setParam;
	int new_kRes;    
	int new_isReadResA;
	int new_nextResAddr;
	int new_frameResAddr;
	int new_resRowCount;
	int new_resSize;
	int new_resReadSize;
	int new_resFrameCount;
	int new_resFrameMax;
	int new_resLen; 
	int new_outResGapSize; 
	int totalRes;
	int kCurLast_1;
	int resetRequestingRes;
    int extWeights_ren;
    int resBuf_ren;

	if(EOF == fscanf(fin, "%d", &num))
		exit(0);
	//printf("read %d\n", num);
	
#ifdef S2_OPTIMIZE
	fscanf(fin, " %d", &isStride2);
	in_data->isStride2 = isStride2
#endif
	fscanf(fin, " %d", &isReadingFeatures);
	fscanf(fin, " %d", &pread_RequestFull);
	fscanf(fin, " %d", &isResMaster);
	fscanf(fin, " %d", &this_token);
	fscanf(fin, " %d", &ptoken);
	fscanf(fin, " %d", &res_full);
	fscanf(fin, " %d", &doRes);
	fscanf(fin, " %d", &mode);
	fscanf(fin, " %d", &outputBufW1);
	fscanf(fin, " %d", &outputBufH1Orig);
	fscanf(fin, " %d", &outW);
	fscanf(fin, " %d", &outFrameSize);
	fscanf(fin, " %d", &outputAddrGap);
	fscanf(fin, " %d", &outFrameGapSize);
	fscanf(fin, " %d", &curSeq);
	fscanf(fin, " %d", &ks);
	fscanf(fin, " %d", &numGroups);
	fscanf(fin, " %d", &kCurLast);
	fscanf(fin, " %d", &resSize0);
	fscanf(fin, " %d", &resSizeLast);
	fscanf(fin, " %d", &resLen0);
	fscanf(fin, " %d", &resLenLast);
	fscanf(fin, " %d", &usedGroupsLast);
	fscanf(fin, " %d", &setParam);
	fscanf(fin, " %d", &new_kRes);
	fscanf(fin, " %d", &new_isReadResA);
	fscanf(fin, " %d", &new_nextResAddr);
	fscanf(fin, " %d", &new_frameResAddr);
	fscanf(fin, " %d", &new_resRowCount);
	fscanf(fin, " %d", &new_resSize);
	fscanf(fin, " %d", &new_resReadSize);
	fscanf(fin, " %d", &new_resFrameCount);
	fscanf(fin, " %d", &new_resFrameMax);
	fscanf(fin, " %d", &new_resLen);
	fscanf(fin, " %d", &new_outResGapSize);
	fscanf(fin, " %d", &totalRes);
	fscanf(fin, " %d", &kCurLast_1);
	fscanf(fin, " %d", &resetRequestingRes);
	fscanf(fin, " %d", &extWeights_ren);
	fscanf(fin, " %d", &resBuf_ren);


	in_data->isReadingFeatures = isReadingFeatures ;
	in_data->pread_RequestFull = pread_RequestFull ;
	in_data->isResMaster = isResMaster ;
	in_data->this_token->aval = this_token;
	in_data->this_token->bval = 0;
	in_data->ptoken->aval = ptoken;
	in_data->ptoken->bval = 0;
	in_data->res_full = res_full ;
	in_data->doRes = doRes ;	
	in_data->mode->aval = mode;
	in_data->mode->bval = 0;
	in_data->outputBufW1->aval = outputBufW1;
	in_data->outputBufW1->bval = 0;
	in_data->outputBufH1Orig->aval = outputBufH1Orig;
	in_data->outputBufH1Orig->bval = 0;
	in_data->outW->aval = outW;
	in_data->outW->bval = 0;
	in_data->outFrameSize->aval = outFrameSize;
	in_data->outFrameSize->bval = 0;
	in_data->outputAddrGap->aval = outputAddrGap;
	in_data->outputAddrGap->bval = 0;
	in_data->outFrameGapSize->aval = outFrameGapSize;
	in_data->outFrameGapSize->bval = 0;
	in_data->curSeq->aval = curSeq;
	in_data->curSeq->bval = 0;
	in_data->ks->aval = ks;
	in_data->ks->bval = 0;
	in_data->numGroups->aval = numGroups;
	in_data->numGroups->bval = 0;
	in_data->kCurLast->aval = kCurLast;
	in_data->kCurLast->bval = 0;
	in_data->resSize0->aval = resSize0;
	in_data->resSize0->bval = 0;
	in_data->resSizeLast->aval = resSizeLast;
	in_data->resSizeLast->bval = 0;
	in_data->resLen0->aval = resLen0;
	in_data->resLen0->bval = 0;
	in_data->resLenLast->aval = resLenLast;
	in_data->resLenLast->bval = 0;
	in_data->usedGroupsLast->aval = usedGroupsLast;
	in_data->usedGroupsLast->bval = 0;
	in_data->setParam = setParam ;	
	in_data->new_kRes->aval = new_kRes;
	in_data->new_kRes->bval = 0;
	in_data->new_isReadResA = new_isReadResA ;	
	in_data->new_nextResAddr->aval = new_nextResAddr;
	in_data->new_nextResAddr->bval = 0;
	in_data->new_frameResAddr->aval = new_frameResAddr;
	in_data->new_frameResAddr->bval = 0;
	in_data->new_resRowCount->aval = new_resRowCount;
	in_data->new_resRowCount->bval = 0;
	in_data->new_resSize->aval = new_resSize;
	in_data->new_resSize->bval = 0;
	in_data->new_resReadSize->aval = new_resReadSize;
	in_data->new_resReadSize->bval = 0;
	in_data->new_resFrameCount->aval = new_resFrameCount;
	in_data->new_resFrameCount->bval = 0;
	in_data->new_resFrameMax->aval = new_resFrameMax;
	in_data->new_resFrameMax->bval = 0;
	in_data->new_resLen->aval = new_resLen;
	in_data->new_resLen->bval = 0;
	in_data->new_outResGapSize->aval = new_outResGapSize;
	in_data->new_outResGapSize->bval = 0;
	in_data->totalRes->aval = totalRes;
	in_data->totalRes->bval = 0;
	in_data->kCurLast_1->aval = kCurLast_1;
	in_data->kCurLast_1->bval = 0;
	in_data->resetRequestingRes = resetRequestingRes ;	
	in_data->extWeights_ren = extWeights_ren ;	
	in_data->resBuf_ren = resBuf_ren ;	


}



void compare_outputs(const rex_outputs* out_data)
{
	int num;
	int enRequest;
	int addr;
	int seq;
	int len;
	int token;
	int dtype;
	int isRamA;
	int isRamB;
	
	if(EOF ==fscanf(fout, "%d %d", &num, &enRequest))
		exit(0);
	printf("output %d\n", num);
	/*printf("out_data : enquest %d, enable %d, enable_bm %d, preferres %d, extfull %d, reqBM %d, askedbm %d, totalbm %d\n"
			, out_data->enRequest
			, out_data->enable, out_data->enable_bm
			, out_data->isPreferRes, out_data->extWeights_full
			, out_data->requestingBM, out_data->askedBM->aval
			, out_data->totalBM->aval);
	printf("\t isReadingFeatures %d, pread_RequestFull %d, isResMaster %d, this_token %d, ptoken %d\n"
			, out_data->isReadingFeatures
			, out_data->pread_RequestFull
			, out_data->isResMaster
			, out_data->this_token->aval, out_data->ptoken->aval);*/
	if(enRequest == 0){
		if(out_data->enRequest != enRequest)
			printf("\tenRequest %d vs %d\n", out_data->enRequest, enRequest);
		return;
	}

	fscanf(fout, "%d %d %d %d %d %d %d"
		, &addr
		, &seq
		, &len
		, &token
		, &dtype
		, &isRamA
		, &isRamB);

	if(out_data->enRequest != enRequest)
		printf("\tenRequest %d vs %d\n", out_data->enRequest, enRequest);

	if(out_data->request.addr->aval != addr)
		printf("\taddr %d vs %d\n", out_data->request.addr->aval, addr);
	if(out_data->request.seq->aval != seq)
		printf("\tseq %d vs %d\n", out_data->request.seq->aval, seq);
	if(out_data->request.len->aval != len)
		printf("\tlen %d vs %d\n", out_data->request.len->aval, len);
	if(out_data->request.token->aval != token)
		printf("\ttoken %d vs %d\n", out_data->request.token->aval, token);
	if(out_data->request.dtype->aval != dtype)
		printf("\tdtype %d vs %d\n", out_data->request.dtype->aval, dtype);
	if(out_data->request.isRamA != isRamA)
		printf("\tisRamA %d vs %d\n", out_data->request.isRamA, isRamA);
	if(out_data->request.isRamB != isRamB)
		printf("\tisRamB %d vs %d\n", out_data->request.isRamB, isRamB);

}

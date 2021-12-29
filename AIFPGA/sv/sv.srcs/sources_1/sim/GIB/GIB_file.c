#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "svdpi.h"
#include "dpiheader.h"

#define COMPUTING_GROUP_SIZE   7
#define BANK_NUM            4

FILE *fin;
FILE *fout;
int cmp_endseq;
void init_files() 
{
    fin = fopen("D:/aidata/gib_input.txt", "rt");
    fout = fopen("D:/aidata/gib_output.txt", "rt");
    assert(fin);
    assert(fout);
    cmp_endseq = 0;
    //char line[5000];
    //fgets(line, 5000, fout);
}

void read_inputs(GIB_inputs* in_data)
{
    int i;
    int num;
    int rama_finishedSeq;
    int ramb_finishedSeq;
    int pcwrite_finishedSeq;
    int addressBuffer_empty;
    int addressBuffer_rdata;
    int pcread_busValid;
    int pcread_isFeature;
    int cb_ibfull[6];
    int             hcb_isStopable[BANK_NUM];
    int             read_isStopable;
    int             write_isStopable;
    int             weight_isStopable;
    
    int pcread_RequestGIBValid;

    int dtype;
    int seq;
    int len;
    int token;
    int data[28];

    if(EOF == fscanf(fin, "%d", &num))
        exit(0);
    printf("read %d\n", num);

    fscanf(fin, "%d %d %d %d%d %d %d %d"
			, &rama_finishedSeq, &ramb_finishedSeq, &pcwrite_finishedSeq
			, &addressBuffer_empty, &addressBuffer_rdata
			, &pcread_busValid, &pcread_isFeature, &pcread_RequestGIBValid);
    for (i = 0; i < BANK_NUM + 2; i++)
        fscanf(fin, " %d", cb_ibfull + i);
    for (i = 0; i < BANK_NUM ; i++)
        fscanf(fin, " %d", hcb_isStopable + i);
    fscanf(fin, "%d %d %d", &read_isStopable, &weight_isStopable, &write_isStopable);

    in_data->addressBuffer_empty = addressBuffer_empty;
    in_data->pcread_busValid = pcread_busValid;
    in_data->pcread_isFeature = pcread_isFeature;
    in_data->pcread_RequestGIBValid = pcread_RequestGIBValid;
    in_data->cb_ibfull[0] = cb_ibfull[0];
    in_data->cb_ibfull[1] = cb_ibfull[1];
    in_data->cb_ibfull[2] = cb_ibfull[2];
    in_data->cb_ibfull[3] = cb_ibfull[3];
    in_data->cb_ibfull[4] = cb_ibfull[4];
    in_data->cb_ibfull[5] = cb_ibfull[5];

    in_data->hcb_isStopable[0] = hcb_isStopable[0];
    in_data->hcb_isStopable[1] = hcb_isStopable[1];
    in_data->hcb_isStopable[2] = hcb_isStopable[2];
    in_data->hcb_isStopable[3] = hcb_isStopable[3];
    in_data->read_isStopable = read_isStopable;
    in_data->weight_isStopable = weight_isStopable;
    in_data->write_isStopable = write_isStopable;

    in_data->rama_finishedSeq->aval = rama_finishedSeq;
    in_data->rama_finishedSeq->bval = 0;
    in_data->ramb_finishedSeq->aval = ramb_finishedSeq;
    in_data->ramb_finishedSeq->bval = 0;
    in_data->pcwrite_finishedSeq->aval = pcwrite_finishedSeq;
    in_data->pcwrite_finishedSeq->bval = 0;
    in_data->addressBuffer_rdata->aval = addressBuffer_rdata;
    in_data->addressBuffer_rdata->bval = 0;
    if (pcread_busValid && !pcread_isFeature){
        int data_len;
        fscanf(fin, "%d %d %d %d %d", &seq, &len, &token, &dtype, &data_len);
        
        in_data->pread_dataBus.dtype->aval = dtype;
        in_data->pread_dataBus.dtype->bval = 0;
        in_data->pread_dataBus.seq->aval = seq;
        in_data->pread_dataBus.seq->bval = 0;
        in_data->pread_dataBus.len->aval = len;
        in_data->pread_dataBus.len->bval = 0;
        in_data->pread_dataBus.token->aval = token;
        in_data->pread_dataBus.token->bval = 0;
       
        for(i = 0; i < data_len; i++){
            fscanf(fin, "%d", data + i);
            in_data->pread_dataBus.data[i]->aval = data[i];
            in_data->pread_dataBus.data[i]->bval = 0;
        }
    }

}

void verify_HCB(const GIB_outputs* out_data, char *name)
{
    int inst_enable = 0;
    int i;

    if(strcmp(name, "hcb") == 0)
        inst_enable = 1;
    if(!inst_enable){
        for(i = 0; i < BANK_NUM; i++){
            if (out_data->inst_enable[i] != inst_enable)
                printf("\t inst_enable_%d %d vs %d\n", i, out_data->inst_enable[i], inst_enable);
        }
    }else{
        int Id;
        int itype;
        int reqSeqNum;
        int reqProgress;
        int reqSeqNumW;
        int reqProgressW;
        int seqNum;
        int W;
        int H;
        int C;
        int Waddr;
        int WEnd;
        int weightPos;
        int ReadPos;
        int ResPos;
        int W1;
        int H1;
        int X;
        int Y;
        int S;
        int lPad;
        int rPad;
        int K;
        int M;
        int Kh;
        int Ks;
        int Kt;
        int Res_addr;
        int wScale;
        int fScale;
        int BM_addr;
        int wLRelu;
        int weightToken;
        int maxpool_size;
        int maxpool_stride;
        int mode;
        int isResMaster;
        int isProgressMaster;
        int isRaddr_a;
        int doRes;
        int doRelu;
        int doLRelu;
        int doBM;
        int doUpSample;
        int newWriteInst;
        int outbufsize;
        int ofsize;
        int outyx;
        int outputAddrGap;
        int outkh;
        int ng;
        int gu;
        int resSize;
        int resSizeLast;
        int resLen;
        int resLenLast;
        int pfs;
        int volumeSize;
        int kCurLast;
        int wtotal_n;
        int wtotalLast;
        int wlenk_regular;
        int wlenk_nLast;
        int wlenk_nLast2;
        int totalBM;
        int totalRes;     
        fscanf(fout, " %d %d %d %d %d %d %d %d\n", &Id, &itype
				, &reqSeqNum, &reqProgress, &reqSeqNumW
				, &reqProgressW, &seqNum, &W);
        printf(" hcb Id : %d\n", Id);

		fscanf(fout, " %d %d %d %d %d %d %d %d\n", &H, &C
				, &Waddr, &WEnd, &weightPos
				, &ReadPos, &ResPos, &W1);
		fscanf(fout, " %d %d %d %d %d %d %d %d\n", &H1, &X
				, &Y, &S, &lPad
				, &rPad, &K, &M);
		fscanf(fout, " %d %d %d %d %d %d %d %d\n", &Kh, &Ks
				, &Kt, &Res_addr, &wScale
				, &fScale, &BM_addr, &wLRelu);
		fscanf(fout, " %d %d %d %d %d %d %d\n", &weightToken, &maxpool_size
				, &maxpool_stride, &mode, &isResMaster
				, &isProgressMaster, &isRaddr_a);
		fscanf(fout, " %d %d %d %d %d %d %d %d\n", &doRes, &doRelu
				, &doLRelu, &doBM, &doUpSample
				, &newWriteInst, &outbufsize, &ofsize);
		fscanf(fout, " %d %d %d %d %d %d %d %d\n", &outyx, &outputAddrGap
				, &outkh, &ng, &gu
				, &resSize, &resSizeLast, &resLen);
		fscanf(fout, " %d %d %d %d %d %d %d %d\n", &resLenLast, &pfs
				, &volumeSize, &kCurLast, &wtotal_n
				, &wtotalLast, &wlenk_regular, &wlenk_nLast);
		fscanf(fout, " %d %d %d", &wlenk_nLast2, &totalBM, &totalRes);
        assert(Id < 4 && Id >= 0);
        for(i = 0; i < BANK_NUM; i++){
            if (out_data->inst_enable[i] != (i == Id))
                printf("\t inst_enable_%d %d vs %d\n", i, out_data->inst_enable[i], (i == Id));
        }

        if (out_data->cb_inst[Id].isResMaster != isResMaster)
            printf("\t cb_inst_%d.isResMaster %d vs %d\n", Id, out_data->cb_inst[Id].isResMaster, isResMaster);
        if (out_data->cb_inst[Id].isProgressMaster != isProgressMaster)
            printf("\t cb_inst_%d.isProgressMaster %d vs %d\n", Id, out_data->cb_inst[Id].isProgressMaster, isProgressMaster);
        if (out_data->cb_inst[Id].isRaddr_a != isRaddr_a)
            printf("\t cb_inst_%d.isRaddr_a %d vs %d\n", Id, out_data->cb_inst[Id].isRaddr_a, isRaddr_a);
        if (out_data->cb_inst[Id].doRes != doRes)
            printf("\t cb_inst_%d.doRes %d vs %d\n", Id, out_data->cb_inst[Id].doRes, doRes);
        if (out_data->cb_inst[Id].doRelu != doRelu)
            printf("\t cb_inst_%d.doRelu %d vs %d\n", Id, out_data->cb_inst[Id].doRelu, doRelu);
        if (out_data->cb_inst[Id].doLRelu != doLRelu)
            printf("\t cb_inst_%d.doLRelu %d vs %d\n", Id, out_data->cb_inst[Id].doLRelu, doLRelu);
        if (out_data->cb_inst[Id].doBM != doBM)
            printf("\t cb_inst_%d.doBM %d vs %d\n", Id, out_data->cb_inst[Id].doBM, doBM);
        if (out_data->cb_inst[Id].doUpSample != doUpSample)
            printf("\t cb_inst_%d.doUpSample %d vs %d\n", Id, out_data->cb_inst[Id].doUpSample, doUpSample);
        if (out_data->cb_inst[Id].newWriteInst != newWriteInst)
            printf("\t cb_inst_%d.newWriteInst %d vs %d\n", Id, out_data->cb_inst[Id].newWriteInst, newWriteInst);
        

        if (out_data->cb_inst[Id].Id->aval != Id)
            printf("\t cb_inst_%d.Id %d vs %d\n", Id, out_data->cb_inst[Id].Id->aval, Id);
        if (out_data->cb_inst[Id].itype->aval != itype)
            printf("\t cb_inst_%d.itype %d vs %d\n", Id, out_data->cb_inst[Id].itype->aval, itype);
        if (out_data->cb_inst[Id].reqSeqNum->aval != reqSeqNum)
            printf("\t cb_inst_%d.reqSeqNum %d vs %d\n", Id, out_data->cb_inst[Id].reqSeqNum->aval, reqSeqNum);
        if (out_data->cb_inst[Id].reqProgress->aval != reqProgress)
            printf("\t cb_inst_%d.reqProgress %d vs %d\n", Id, out_data->cb_inst[Id].reqProgress->aval, reqProgress);
        if (out_data->cb_inst[Id].reqSeqNumW->aval != reqSeqNumW)
            printf("\t cb_inst_%d.reqSeqNumW %d vs %d\n", Id, out_data->cb_inst[Id].reqSeqNumW->aval, reqSeqNumW);
        if (out_data->cb_inst[Id].reqProgressW->aval != reqProgressW)
            printf("\t cb_inst_%d.reqProgressW %d vs %d\n", Id, out_data->cb_inst[Id].reqProgressW->aval, reqProgressW);
        if (out_data->cb_inst[Id].seqNum->aval != seqNum)
            printf("\t cb_inst_%d.seqNum %d vs %d\n", Id, out_data->cb_inst[Id].seqNum->aval, seqNum);
        if (out_data->cb_inst[Id].W->aval != W)
            printf("\t cb_inst_%d.W %d vs %d\n", Id, out_data->cb_inst[Id].W->aval, W);
        if (out_data->cb_inst[Id].H->aval != H)
            printf("\t cb_inst_%d.H %d vs %d\n", Id, out_data->cb_inst[Id].H->aval, H);
        if (out_data->cb_inst[Id].C->aval != C)
            printf("\t cb_inst_%d.C %d vs %d\n", Id, out_data->cb_inst[Id].C->aval, C);
        if (out_data->cb_inst[Id].Waddr->aval != Waddr)
            printf("\t cb_inst_%d.Waddr %d vs %d\n", Id, out_data->cb_inst[Id].Waddr->aval, Waddr);
        if (out_data->cb_inst[Id].WEnd->aval != WEnd)
            printf("\t cb_inst_%d.WEnd %d vs %d\n", Id, out_data->cb_inst[Id].WEnd->aval, WEnd);
        if (out_data->cb_inst[Id].weightPos->aval != weightPos)
            printf("\t cb_inst_%d.weightPos %d vs %d\n", Id, out_data->cb_inst[Id].weightPos->aval, weightPos);
        if (out_data->cb_inst[Id].ReadPos->aval != ReadPos)
            printf("\t cb_inst_%d.ReadPos %d vs %d\n", Id, out_data->cb_inst[Id].ReadPos->aval, ReadPos);
        if (out_data->cb_inst[Id].ResPos->aval != ResPos)
            printf("\t cb_inst_%d.ResPos %d vs %d\n", Id, out_data->cb_inst[Id].ResPos->aval, ResPos);
        if (out_data->cb_inst[Id].W1->aval != W1)
            printf("\t cb_inst_%d.W1 %d vs %d\n", Id, out_data->cb_inst[Id].W1->aval, W1);
        if (out_data->cb_inst[Id].H1->aval != H1)
            printf("\t cb_inst_%d.H1 %d vs %d\n", Id, out_data->cb_inst[Id].H1->aval, H1);
        if (out_data->cb_inst[Id].X->aval != X)
            printf("\t cb_inst_%d.X %d vs %d\n", Id, out_data->cb_inst[Id].X->aval, X);
        if (out_data->cb_inst[Id].Y->aval != Y)
            printf("\t cb_inst_%d.Y %d vs %d\n", Id, out_data->cb_inst[Id].Y->aval, Y);
        if (out_data->cb_inst[Id].S->aval != S)
            printf("\t cb_inst_%d.S %d vs %d\n", Id, out_data->cb_inst[Id].S->aval, S);
        if (out_data->cb_inst[Id].lPad->aval != lPad)
            printf("\t cb_inst_%d.lPad %d vs %d\n", Id, out_data->cb_inst[Id].lPad->aval, lPad);
        if (out_data->cb_inst[Id].rPad->aval != rPad)
            printf("\t cb_inst_%d.rPad %d vs %d\n", Id, out_data->cb_inst[Id].rPad->aval, rPad);
        if (out_data->cb_inst[Id].K->aval != K)
            printf("\t cb_inst_%d.K %d vs %d\n", Id, out_data->cb_inst[Id].K->aval, K);
        if (out_data->cb_inst[Id].M->aval != M)
            printf("\t cb_inst_%d.M %d vs %d\n", Id, out_data->cb_inst[Id].M->aval, M);
        if (out_data->cb_inst[Id].Kh->aval != Kh)
            printf("\t cb_inst_%d.Kh %d vs %d\n", Id, out_data->cb_inst[Id].Kh->aval, Kh);
        if (out_data->cb_inst[Id].Ks->aval != Ks)
            printf("\t cb_inst_%d.Ks %d vs %d\n", Id, out_data->cb_inst[Id].Ks->aval, Ks);
        if (out_data->cb_inst[Id].Kt->aval != Kt)
            printf("\t cb_inst_%d.Kt %d vs %d\n", Id, out_data->cb_inst[Id].Kt->aval, Kt);
        if (out_data->cb_inst[Id].Res_addr->aval != Res_addr)
            printf("\t cb_inst_%d.Res_addr %d vs %d\n", Id, out_data->cb_inst[Id].Res_addr->aval, Res_addr);
        if (out_data->cb_inst[Id].wScale->aval != wScale)
            printf("\t cb_inst_%d.wScale %d vs %d\n", Id, out_data->cb_inst[Id].wScale->aval, wScale);
        if (out_data->cb_inst[Id].fScale->aval != fScale)
            printf("\t cb_inst_%d.fScale %d vs %d\n", Id, out_data->cb_inst[Id].fScale->aval, fScale);
        if (out_data->cb_inst[Id].BM_addr->aval != BM_addr)
            printf("\t cb_inst_%d.BM_addr %d vs %d\n", Id, out_data->cb_inst[Id].BM_addr->aval, BM_addr);
        if (out_data->cb_inst[Id].wLRelu->aval != wLRelu)
            printf("\t cb_inst_%d.wLRelu %d vs %d\n", Id, out_data->cb_inst[Id].wLRelu->aval, wLRelu);
        if (out_data->cb_inst[Id].weightToken->aval != weightToken)
            printf("\t cb_inst_%d.weightToken %d vs %d\n", Id, out_data->cb_inst[Id].weightToken->aval, weightToken);
        if (out_data->cb_inst[Id].maxpool_size->aval != maxpool_size)
            printf("\t cb_inst_%d.maxpool_size %d vs %d\n", Id, out_data->cb_inst[Id].maxpool_size->aval, maxpool_size);
        if (out_data->cb_inst[Id].maxpool_stride->aval != maxpool_stride)
            printf("\t cb_inst_%d.maxpool_stride %d vs %d\n", Id, out_data->cb_inst[Id].maxpool_stride->aval, maxpool_stride);
        if (out_data->cb_inst[Id].mode->aval != mode)
            printf("\t cb_inst_%d.mode %d vs %d\n", Id, out_data->cb_inst[Id].mode->aval, mode);
        if (out_data->cb_inst[Id].outbufsize->aval != outbufsize)
            printf("\t cb_inst_%d.outbufsize %d vs %d\n", Id, out_data->cb_inst[Id].outbufsize->aval, outbufsize);
        if (out_data->cb_inst[Id].ofsize->aval != ofsize)
            printf("\t cb_inst_%d.ofsize %d vs %d\n", Id, out_data->cb_inst[Id].ofsize->aval, ofsize);
        if (out_data->cb_inst[Id].outyx->aval != outyx)
            printf("\t cb_inst_%d.outyx %d vs %d\n", Id, out_data->cb_inst[Id].outyx->aval, outyx);
        if (out_data->cb_inst[Id].outputAddrGap->aval != outputAddrGap)
            printf("\t cb_inst_%d.outputAddrGap %d vs %d\n", Id, out_data->cb_inst[Id].outputAddrGap->aval, outputAddrGap);
        if (out_data->cb_inst[Id].outkh->aval != outkh)
            printf("\t cb_inst_%d.outkh %d vs %d\n", Id, out_data->cb_inst[Id].outkh->aval, outkh);
        if (out_data->cb_inst[Id].ng->aval != ng)
            printf("\t cb_inst_%d.ng %d vs %d\n", Id, out_data->cb_inst[Id].ng->aval, ng);
        if (out_data->cb_inst[Id].gu->aval != gu)
            printf("\t cb_inst_%d.gu %d vs %d\n", Id, out_data->cb_inst[Id].gu->aval, gu);
        if (out_data->cb_inst[Id].resSize->aval != resSize)
            printf("\t cb_inst_%d.resSize %d vs %d\n", Id, out_data->cb_inst[Id].resSize->aval, resSize);
        if (out_data->cb_inst[Id].resSizeLast->aval != resSizeLast)
            printf("\t cb_inst_%d.resSizeLast %d vs %d\n", Id, out_data->cb_inst[Id].resSizeLast->aval, resSizeLast);
        if (out_data->cb_inst[Id].resLen->aval != resLen)
            printf("\t cb_inst_%d.resLen %d vs %d\n", Id, out_data->cb_inst[Id].resLen->aval, resLen);
        if (out_data->cb_inst[Id].resLenLast->aval != resLenLast)
            printf("\t cb_inst_%d.resLenLast %d vs %d\n", Id, out_data->cb_inst[Id].resLenLast->aval, resLenLast);
        if (out_data->cb_inst[Id].pfs->aval != pfs)
            printf("\t cb_inst_%d.pfs %d vs %d\n", Id, out_data->cb_inst[Id].pfs->aval, pfs);
        if (out_data->cb_inst[Id].volumeSize->aval != volumeSize)
            printf("\t cb_inst_%d.volumeSize %d vs %d\n", Id, out_data->cb_inst[Id].volumeSize->aval, volumeSize);
        if (out_data->cb_inst[Id].kCurLast->aval != kCurLast)
            printf("\t cb_inst_%d.kCurLast %d vs %d\n", Id, out_data->cb_inst[Id].kCurLast->aval, kCurLast);
        if (out_data->cb_inst[Id].wtotal_n->aval != wtotal_n)
            printf("\t cb_inst_%d.wtotal_n %d vs %d\n", Id, out_data->cb_inst[Id].wtotal_n->aval, wtotal_n);
        if (out_data->cb_inst[Id].wtotalLast->aval != wtotalLast)
            printf("\t cb_inst_%d.wtotalLast %d vs %d\n", Id, out_data->cb_inst[Id].wtotalLast->aval, wtotalLast);
        if (out_data->cb_inst[Id].wlenk_regular->aval != wlenk_regular)
            printf("\t cb_inst_%d.wlenk_regular %d vs %d\n", Id, out_data->cb_inst[Id].wlenk_regular->aval, wlenk_regular);
        if (out_data->cb_inst[Id].wlenk_nLast->aval != wlenk_nLast)
            printf("\t cb_inst_%d.wlenk_nLast %d vs %d\n", Id, out_data->cb_inst[Id].wlenk_nLast->aval, wlenk_nLast);
        if (out_data->cb_inst[Id].wlenk_nLast2->aval != wlenk_nLast2)
            printf("\t cb_inst_%d.wlenk_nLast2 %d vs %d\n", Id, out_data->cb_inst[Id].wlenk_nLast2->aval, wlenk_nLast2);
        if (out_data->cb_inst[Id].totalBM->aval != totalBM)
            printf("\t cb_inst_%d.totalBM %d vs %d\n", Id, out_data->cb_inst[Id].totalBM->aval, totalBM);
        if (out_data->cb_inst[Id].totalRes->aval != totalRes)
            printf("\t cb_inst_%d.totalRes %d vs %d\n", Id, out_data->cb_inst[Id].totalRes->aval, totalRes);
        
    }
}
void verify_Read(const GIB_outputs* out_data, char *name)
{
    int crinst_enable = 0;
    int mode;
    int reqSeqNum;
    int reqProgress;
    int seqNum;
    int W;
    int H;
    int C;
    int Maddr;
    int W1;
    int W2;
    int H1;
    int X;
    int Y;
    int S;
    int lPad;
    int rPad;
    int isMaddr_a;
    int isMaddr_b;
    int isRes_a;
    if(strcmp(name, "read") == 0)
        crinst_enable = 1;
    if (out_data->crinst_enable != crinst_enable)
        printf("\t crinst_enable %d vs %d\n", out_data->crinst_enable, crinst_enable);

    if(crinst_enable){
       fscanf(fout, "%d %d %d %d %d %d"
				, &mode, &reqSeqNum, &reqProgress
				, &seqNum, &W, &H);
        fscanf(fout, " %d %d %d %d %d %d"
				, &C, &Maddr, &W1
				, &W2, &H1, &X);
        fscanf(fout, " %d %d %d %d %d %d %d\n", &Y
				, &S, &lPad, &rPad
				, &isMaddr_a, &isMaddr_b, &isRes_a);

        if (out_data->crinst.mode->aval != mode)
            printf("\t crinst.mode %d vs %d\n", out_data->crinst.mode->aval, mode);
        if (out_data->crinst.reqSeqNum->aval != reqSeqNum)
            printf("\t crinst.reqSeqNum %d vs %d\n", out_data->crinst.reqSeqNum->aval, reqSeqNum);
        if (out_data->crinst.reqProgress->aval != reqProgress)
            printf("\t crinst.reqProgress %d vs %d\n", out_data->crinst.reqProgress->aval, reqProgress);
        if (out_data->crinst.seqNum->aval != seqNum)
            printf("\t crinst.seqNum %d vs %d\n", out_data->crinst.seqNum->aval, seqNum);
        if (out_data->crinst.W->aval != W)
            printf("\t crinst.W %d vs %d\n", out_data->crinst.W->aval, W);
        if (out_data->crinst.H->aval != H)
            printf("\t crinst.H %d vs %d\n", out_data->crinst.H->aval, H);
        if (out_data->crinst.C->aval != C)
            printf("\t crinst.C %d vs %d\n", out_data->crinst.C->aval, C);
        if (out_data->crinst.Maddr->aval != Maddr)
            printf("\t crinst.Maddr %d vs %d\n", out_data->crinst.Maddr->aval, Maddr);
        if (out_data->crinst.W1->aval != W1)
            printf("\t crinst.W1 %d vs %d\n", out_data->crinst.W1->aval, W1);
        if (out_data->crinst.W2->aval != W2)
            printf("\t crinst.W2 %d vs %d\n", out_data->crinst.W2->aval, W2);
        if (out_data->crinst.H1->aval != H1)
            printf("\t crinst.H1 %d vs %d\n", out_data->crinst.H1->aval, H1);
        if (out_data->crinst.X->aval != X)
            printf("\t crinst.X %d vs %d\n", out_data->crinst.X->aval, X);
        if (out_data->crinst.Y->aval != Y)
            printf("\t crinst.Y %d vs %d\n", out_data->crinst.Y->aval, Y);
        if (out_data->crinst.S->aval != S)
            printf("\t crinst.S %d vs %d\n", out_data->crinst.S->aval, S);
        if (out_data->crinst.lPad->aval != lPad)
            printf("\t crinst.lPad %d vs %d\n", out_data->crinst.lPad->aval, lPad);
        if (out_data->crinst.rPad->aval != rPad)
            printf("\t crinst.rPad %d vs %d\n", out_data->crinst.rPad->aval, rPad);

        if (out_data->crinst.isRes_a != isRes_a)
            printf("\t crinst.isRes_a %d vs %d\n", out_data->crinst.isRes_a, isRes_a);
        if (out_data->crinst.isMaddr_a != isMaddr_a)
            printf("\t crinst.isMaddr_a %d vs %d\n", out_data->crinst.isMaddr_a, isMaddr_a);
        if (out_data->crinst.isMaddr_b != isMaddr_b)
            printf("\t crinst.isMaddr_b %d vs %d\n", out_data->crinst.isMaddr_b, isMaddr_b);

    }
}
void verify_Write(const GIB_outputs* out_data, char *name)
{
    int cwinst_enable = 0;
    int mode;
    int dataWidth;
    int dataWidth2;
    int Oaddr;
    int outH1;
    int isUpsample;
    int isMaddr_a;
    int isMaddr_b;
    int maxpool_stride;
    int maxpool_size;
    if(strcmp(name, "write") == 0)
        cwinst_enable = 1;
    if (out_data->cwinst_enable != cwinst_enable)
        printf("\t cwinst_enable %d vs %d\n", out_data->cwinst_enable, cwinst_enable);

    if(cwinst_enable){
        fscanf(fout, "%d %d %d %d %d %d %d %d %d %d\n", &mode
			, &dataWidth, &dataWidth2, &Oaddr
			, &outH1, &isUpsample, &isMaddr_a
			, &isMaddr_b, &maxpool_stride, &maxpool_size);

        if (out_data->cwinst.isUpsample != isUpsample)
            printf("\t cwinst.isUpsample %d vs %d\n", out_data->cwinst.isUpsample, isUpsample);
        if (out_data->cwinst.isMaddr_a != isMaddr_a)
            printf("\t cwinst.isMaddr_a %d vs %d\n", out_data->cwinst.isMaddr_a, isMaddr_a);
        if (out_data->cwinst.isMaddr_b != isMaddr_b)
            printf("\t cwinst.isMaddr_b %d vs %d\n", out_data->cwinst.isMaddr_b, isMaddr_b);

        if (out_data->cwinst.mode->aval != mode)
            printf("\t cwinst.mode %d vs %d\n", out_data->cwinst.mode->aval, mode);
        if (out_data->cwinst.dataWidth->aval != dataWidth)
            printf("\t cwinst.dataWidth %d vs %d\n", out_data->cwinst.dataWidth->aval, dataWidth);
        if (out_data->cwinst.dataWidth2->aval != dataWidth2)
            printf("\t cwinst.dataWidth2 %d vs %d\n", out_data->cwinst.dataWidth2->aval, dataWidth2);
        if (out_data->cwinst.Oaddr->aval != Oaddr)
            printf("\t cwinst.Oaddr %d vs %d\n", out_data->cwinst.Oaddr->aval, Oaddr);
        if (out_data->cwinst.outH1->aval != outH1)
            printf("\t cwinst.outH1 %d vs %d\n", out_data->cwinst.outH1->aval, outH1);
        if (out_data->cwinst.maxpool_stride->aval != maxpool_stride)
            printf("\t cwinst.maxpool_stride %d vs %d\n", out_data->cwinst.maxpool_stride->aval, maxpool_stride);
        if (out_data->cwinst.maxpool_size->aval != maxpool_size)
            printf("\t cwinst.maxpool_size %d vs %d\n", out_data->cwinst.maxpool_size->aval, maxpool_size);
    }
}
void verify_Weight(const GIB_outputs* out_data, char *name)
{
    int isReadRam;
    int isWriteRam;
    int mode;
    int dropSize;
    int seqNum;
    int Oaddr;
    int size;
    
    int cwtinst_enable = 0;
    if(strcmp(name, "weight") == 0)
        cwtinst_enable = 1;
    if (out_data->cwtinst_enable != cwtinst_enable)
        printf("\t cwtinst_enable %d vs %d\n", out_data->cwtinst_enable, cwtinst_enable);

    if(cwtinst_enable){
        fscanf(fout, "%d %d %d %d %d %d %d\n", &isReadRam
			, &isWriteRam, &mode, &Oaddr
			, &seqNum, &dropSize, &size);
        if (out_data->cwtinst.isReadRam != isReadRam)
            printf("\t cwtinst.isReadRam %d vs %d\n", out_data->cwtinst.isReadRam, isReadRam);
        if (out_data->cwtinst.isWriteRam != isWriteRam)
            printf("\t cwtinst.isWriteRam %d vs %d\n", out_data->cwtinst.isWriteRam, isWriteRam);
        if (out_data->cwtinst.mode->aval != mode)
            printf("\t cwtinst.mode %d vs %d\n", out_data->cwtinst.mode->aval, mode);
        if (out_data->cwtinst.dropSize->aval != dropSize)
            printf("\t cwtinst.dropSize %d vs %d\n", out_data->cwtinst.dropSize->aval, dropSize);
        if (out_data->cwtinst.seqNum->aval != seqNum)
            printf("\t cwtinst.seqNum %d vs %d\n", out_data->cwtinst.seqNum->aval, seqNum);
        if (out_data->cwtinst.Oaddr->aval != Oaddr)
            printf("\t cwtinst.Oaddr %d vs %d\n", out_data->cwtinst.Oaddr->aval, Oaddr);
        if (out_data->cwtinst.size->aval != size)
            printf("\t cwtinst.size %d vs %d\n", out_data->cwtinst.size->aval, size);
    }
}
void verify_Option(const GIB_outputs* out_data, char *name)
{
    int i;
    int cb_start = 0;
    int cb_stop = 0;
    if(strcmp(name, "start") == 0)
        cb_start = 1;
    if(strcmp(name, "stop") == 0)
        cb_stop = 1;
    for(i = 0; i < BANK_NUM; i++){
        if (out_data->cb_start[i] != cb_start)
            printf("\t cb_start_%d %d vs %d\n", i, out_data->cb_start[i], cb_start);
        if (out_data->cb_stop[i] != cb_stop)
            printf("\t cb_stop_%d %d vs %d\n", i, out_data->cb_stop[i], cb_stop);
    }
}
int end_fifo_wen;
void verify_End(const GIB_outputs* out_data, char *name)
{
    end_fifo_wen = 0;
    if(strcmp(name, "end") == 0)
        end_fifo_wen = 1;
    if (out_data->end_fifo_wen != end_fifo_wen)
        printf("\t end_fifo_wen %d vs %d\n", out_data->end_fifo_wen, end_fifo_wen);
}

void verify_reqGIB(const GIB_outputs* out_data, int reqGIBValid)
{
    int addr;
	int seq;
	int len;
	int token;
	int dtype;
	int isRamA;
	int isRamB;
    if (out_data->reqGIBValid != reqGIBValid)
        printf("\t reqGIBValid %d vs %d\n", out_data->reqGIBValid, reqGIBValid);
    if(reqGIBValid){
        fscanf(fout, "%d %d %d %d %d %d %d"
			, &addr , &seq , &len , &token
			, &dtype , &isRamA , &isRamB);

        if (out_data->reqGIB.addr->aval != addr)
            printf("\t reqGIB.addr %d vs %d\n", out_data->reqGIB.addr->aval, addr);
        if (out_data->reqGIB.seq->aval != seq)
            printf("\t reqGIB.seq %d vs %d\n", out_data->reqGIB.seq->aval, seq);
        if (out_data->reqGIB.len->aval != len)
            printf("\t reqGIB.len %d vs %d\n", out_data->reqGIB.len->aval, len);
        if (out_data->reqGIB.token->aval != token)
            printf("\t reqGIB.token %d vs %d\n", out_data->reqGIB.token->aval, token);
        if (out_data->reqGIB.dtype->aval != dtype)
            printf("\t reqGIB.dtype %d vs %d\n", out_data->reqGIB.dtype->aval, dtype);
        if (out_data->reqGIB.isRamA != isRamA)
            printf("\t reqGIB.isRamA %d vs %d\n", out_data->reqGIB.isRamA, isRamA);
        if (out_data->reqGIB.isRamB != isRamB)
            printf("\t reqGIB.isRamB %d vs %d\n", out_data->reqGIB.isRamB, isRamB);
    }
}

void compare_outputs(const GIB_outputs* out_data)
{
    int i;
    int num;
    int pif_AddOutput;
    int endInst_oAddr;
    int endInst_oSize;
    int addressBuffer_ren;
    int reqGIBValid;
    //RequestItem_t_unpack reqGIB;
    int cb_start[4];
    int cb_stop[4];
    int inst_enable[4];
    //InstructionHCB_unpack cb_inst[4];
    int cwtinst_enable;
    //InstructionWeight_unpack cwtinst;
    int crinst_enable;
    //InstructionRead_unpack crinst;
    int cwinst_enable;
    //InstructionWrite_unpack cwinst;
    int address;
    int addressValid;
    int fetchMore;
    int endValid;
    int readLen;
    int maxLen;
    int itype;
    int pendingRequest;
    int doDecodeInstruction;
    int end_reqSeqNum;
    char name[100];

    //printf("\t out seq %d\n", out_data->reqdata.seq->aval);

    if(EOF ==fscanf(fout, "%d %d", &num, &pif_AddOutput))
        exit(0);
    printf("output %d\n", num);

     if (out_data->pif_AddOutput != pif_AddOutput)
        printf("\t pif_AddOutput %d vs %d\n", out_data->pif_AddOutput, pif_AddOutput);
    if(pif_AddOutput){
        fscanf(fout, "%d %d", &endInst_oAddr, &endInst_oSize);
        if (out_data->endInst_oAddr->aval != endInst_oAddr)
            printf("\t endInst_oAddr %d vs %d\n", out_data->endInst_oAddr->aval, endInst_oAddr);
        if (out_data->endInst_oSize->aval != endInst_oSize)
            printf("\t endInst_oSize %d vs %d\n", out_data->endInst_oSize->aval, endInst_oSize);
    }

    fscanf(fout, "%d", &reqGIBValid);
    verify_reqGIB(out_data, reqGIBValid);

    fscanf(fout, "%s", name);
    verify_HCB(out_data, name);
    verify_Read(out_data, name);
    verify_Write(out_data, name);
    verify_Weight(out_data, name);
    verify_Option(out_data, name);
    verify_End(out_data, name);

    fscanf(fout, " %d %d %d %d %d %d %d %d %d %d %d", &addressBuffer_ren
			, &address, &addressValid, &fetchMore
			, &endValid, &readLen, &maxLen
			, &itype, &pendingRequest, &doDecodeInstruction
			, &end_reqSeqNum);


   

    if (out_data->addressBuffer_ren != addressBuffer_ren)
        printf("\t addressBuffer_ren %d vs %d\n", out_data->addressBuffer_ren, addressBuffer_ren);
    if (out_data->addressValid != addressValid)
        printf("\t addressValid %d vs %d\n", out_data->addressValid, addressValid);
    if (out_data->fetchMore != fetchMore)
        printf("\t fetchMore %d vs %d\n", out_data->fetchMore, fetchMore);
    if (out_data->endValid != endValid)
        printf("\t endValid %d vs %d\n", out_data->endValid, endValid);
    if (out_data->pendingRequest != pendingRequest)
        printf("\t pendingRequest %d vs %d\n", out_data->pendingRequest, pendingRequest);
    if (out_data->doDecodeInstruction != doDecodeInstruction)
        printf("\t doDecodeInstruction %d vs %d\n", out_data->doDecodeInstruction, doDecodeInstruction);
    
    if (out_data->address->aval != address)
        printf("\t address %d vs %d\n", out_data->address->aval, address);
    if (out_data->readLen->aval != readLen)
        printf("\t readLen %d vs %d\n", out_data->readLen->aval, readLen);
    if (out_data->maxLen->aval != maxLen)
        printf("\t maxLen %d vs %d\n", out_data->maxLen->aval, maxLen);
    if (out_data->itype->aval != itype)
        printf("\t itype %d vs %d\n", out_data->itype->aval, itype);
    if(cmp_endseq > 2)
    if (out_data->end_reqSeqNum->aval != end_reqSeqNum)
        printf("\t end_reqSeqNum %d vs %d\n", out_data->end_reqSeqNum->aval, end_reqSeqNum);
    if(end_fifo_wen)
        cmp_endseq ++;
    
}

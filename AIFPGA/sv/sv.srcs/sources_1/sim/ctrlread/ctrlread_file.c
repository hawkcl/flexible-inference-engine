#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"

#define MAX_LOAD_WIDTH   33
#define BANK_NUM            4
#define FEATURE_BIT_NUM 8

FILE *fin;
FILE *fout;
void init_files() 
{
    fin = fopen("D:/aidata/ctrlread_input.txt", "rt");
    fout = fopen("D:/aidata/ctrlread_output.txt", "rt");
    assert(fin);
    assert(fout);
    //char line[5000];
    //fgets(line, 5000, fout);
}

void read_inputs(ctrlread_inputs* in_data)
{
    int i;
    int num;
    int crinst_enable;
    InstructionRead_unpack crinst;
    int cb_isRunning[4];
    int cb_isReadingFeatures[4];
    int cb_isLoadingFroze[4];
    int cb_ReqFeature[4];
    int cb_FinishedSeq[4];
    int cb_WorkingSeq[4];
    int cb_WorkingProgress[4];
    int requestValid;
    RequestItem_t_unpack ritem[4];
    int reqGIBValid;
    RequestItem_t_unpack reqGIB;
    int ddr_data[33];
    int rama_data[33];
    int ramb_data[33];
    int len;

    int inst_mode;
    int inst_reqSeqNum;
    int inst_reqProgress;
    int inst_seqNum;
    int inst_W;
    int inst_H;
    int inst_C;
    int inst_Maddr;
    int inst_W1;
    int inst_W2;
    int inst_H1;
    int inst_X;
    int inst_Y;
    int inst_S;
    int inst_lPad;
    int inst_rPad;
    int inst_isMaddr_a;
    int inst_isMaddr_b;
    int inst_isRes_a;

    int ritem_addr;
    int ritem_seq;
    int ritem_len;
    int ritem_token;
    int ritem_dtype;
    int ritem_isRamA;
    int ritem_isRamB;

    int reqGIB_addr;
    int reqGIB_seq;
    int reqGIB_len;
    int reqGIB_token;
    int reqGIB_dtype;
    int reqGIB_isRamA;
    int reqGIB_isRamB;
    int ddr_data_id;
    int ddr_read_ready;

    if(EOF == fscanf(fin, "%d %d %d", &num, &ddr_data_id, &ddr_read_ready))
        exit(0);
    printf("read %d\n", num);

    in_data->ddr_read_ready = ddr_read_ready;
    in_data->ddr_data_id->aval = ddr_data_id;
    in_data->ddr_data_id->bval = 0;

    for (i = 0; i < BANK_NUM; i++){
        fscanf(fin, "%d %d %d %d %d %d %d", cb_isRunning + i
                , cb_isReadingFeatures + i , cb_isLoadingFroze + i, cb_ReqFeature + i
                , cb_FinishedSeq + i, cb_WorkingSeq + i, cb_WorkingProgress + i);

        in_data->cb_isRunning[i] = cb_isRunning[i];
        in_data->cb_isReadingFeatures[i] = cb_isReadingFeatures[i];
        in_data->cb_isLoadingFroze[i] = cb_isLoadingFroze[i];
        in_data->cb_ReqFeature[i]->aval = cb_ReqFeature[i];
        in_data->cb_ReqFeature[i]->bval = 0;
        in_data->cb_FinishedSeq[i]->aval = cb_FinishedSeq[i];
        in_data->cb_FinishedSeq[i]->bval = 0;
        in_data->cb_WorkingSeq[i]->aval = cb_WorkingSeq[i];
        in_data->cb_WorkingSeq[i]->bval = 0;
        in_data->cb_WorkingProgress[i]->aval = cb_WorkingProgress[i];
        in_data->cb_WorkingProgress[i]->bval = 0;
    }

    fscanf(fin, "%d", &len); //rama
    assert(len == 0);
    fscanf(fin, "%d", &len); //ramb
    assert(len == 0);
    fscanf(fin, "%d", &len);
    if(len){
        for(i = 0; i < len; i++){
            fscanf(fin, "%d", ddr_data + i);
            in_data->ddr_data[i]->aval = ddr_data[i];
            in_data->ddr_data[i]->bval = 0;
        }
    }
    
    fscanf(fin, "%d", &crinst_enable);
    in_data->crinst_enable = crinst_enable;
    if (crinst_enable){
        fscanf(fin, " %d %d %d %d %d %d"
            , &inst_mode, &inst_reqSeqNum, &inst_reqProgress
            , &inst_seqNum, &inst_W, &inst_H);
        fscanf(fin, " %d %d %d %d %d %d"
            , &inst_C, &inst_Maddr, &inst_W1
            , &inst_W2, &inst_H1, &inst_X);
        fscanf(fin, " %d %d %d %d %d %d %d\n", &inst_Y
            , &inst_S, &inst_lPad, &inst_rPad
            , &inst_isMaddr_a, &inst_isMaddr_b, &inst_isRes_a);
        in_data->crinst.isMaddr_a = inst_isMaddr_a;
        in_data->crinst.isMaddr_b = inst_isMaddr_b;
        in_data->crinst.isRes_a = inst_isRes_a;
        in_data->crinst.mode->aval = inst_mode;
        in_data->crinst.mode->bval = 0;
        in_data->crinst.reqSeqNum->aval = inst_reqSeqNum;
        in_data->crinst.reqSeqNum->bval = 0;
        in_data->crinst.reqProgress->aval = inst_reqProgress;
        in_data->crinst.reqProgress->bval = 0;
        in_data->crinst.seqNum->aval = inst_seqNum;
        in_data->crinst.seqNum->bval = 0;
        in_data->crinst.W->aval = inst_W;
        in_data->crinst.W->bval = 0;
        in_data->crinst.H->aval = inst_H;
        in_data->crinst.H->bval = 0;
        in_data->crinst.C->aval = inst_C;
        in_data->crinst.C->bval = 0;
        in_data->crinst.Maddr->aval = inst_Maddr;
        in_data->crinst.Maddr->bval = 0;
        in_data->crinst.W1->aval = inst_W1;
        in_data->crinst.W1->bval = 0;
        in_data->crinst.W2->aval = inst_W2;
        in_data->crinst.W2->bval = 0;
        in_data->crinst.H1->aval = inst_H1;
        in_data->crinst.H1->bval = 0;
        in_data->crinst.X->aval = inst_X;
        in_data->crinst.X->bval = 0;
        in_data->crinst.Y->aval = inst_Y;
        in_data->crinst.Y->bval = 0;
        in_data->crinst.S->aval = inst_S;
        in_data->crinst.S->bval = 0;
        in_data->crinst.lPad->aval = inst_lPad;
        in_data->crinst.lPad->bval = 0;
        in_data->crinst.rPad->aval = inst_rPad;
        in_data->crinst.rPad->bval = 0;
    }
		
    fscanf(fin, "%d", &requestValid);
    if(requestValid < 0)
        in_data->requestValid->aval = 0;
    else
        in_data->requestValid->aval = 1 << requestValid;
    in_data->requestValid->bval = 0;
    if (requestValid >= 0){
        fscanf(fin, "%d %d %d %d %d %d %d\n", &ritem_addr
            , &ritem_seq, &ritem_len, &ritem_token
            , &ritem_dtype, &ritem_isRamA, &ritem_isRamB);

        in_data->ritem[requestValid].isRamA = ritem_isRamA;
        in_data->ritem[requestValid].isRamB = ritem_isRamB;

        in_data->ritem[requestValid].addr->aval = ritem_addr;
        in_data->ritem[requestValid].addr->bval = 0;
        in_data->ritem[requestValid].seq->aval = ritem_seq;
        in_data->ritem[requestValid].seq->bval = 0;
        in_data->ritem[requestValid].len->aval = ritem_len;
        in_data->ritem[requestValid].len->bval = 0;
        in_data->ritem[requestValid].token->aval = ritem_token;
        in_data->ritem[requestValid].token->bval = 0;
        in_data->ritem[requestValid].dtype->aval = ritem_dtype;
        in_data->ritem[requestValid].dtype->bval = 0;
    }

    fscanf(fin, "%d", &reqGIBValid);
    in_data->reqGIBValid = reqGIBValid;
    if (reqGIBValid){
        fscanf(fin, "%d %d %d %d %d %d %d\n", &reqGIB_addr
            , &reqGIB_seq, &reqGIB_len, &reqGIB_token
            , &reqGIB_dtype, &reqGIB_isRamA, &reqGIB_isRamB);

        in_data->reqGIB.isRamA = reqGIB_isRamA;
        in_data->reqGIB.isRamB = reqGIB_isRamB;

        in_data->reqGIB.addr->aval = reqGIB_addr;
        in_data->reqGIB.addr->bval = 0;
        in_data->reqGIB.seq->aval = reqGIB_seq;
        in_data->reqGIB.seq->bval = 0;
        in_data->reqGIB.len->aval = reqGIB_len;
        in_data->reqGIB.len->bval = 0;
        in_data->reqGIB.token->aval = reqGIB_token;
        in_data->reqGIB.token->bval = 0;
        in_data->reqGIB.dtype->aval = reqGIB_dtype;
        in_data->reqGIB.dtype->bval = 0;
    }
}



void compare_outputs(const ctrlread_outputs* out_data)
{
    int i;
    int num;
    int ddr_enable;
    int ddr_addr;
    int ddr_len;
    int rama_ren;
    int ramb_ren;
    int ram_addr;
    int ram_len;
    int pread_waitForSeq;
    int pread_busValid;
    int pread_isFeature;
    int pread_RequestFull;
    int pread_SeqNum;
    int data_bus[33];
    int data[32];
    int seq;
    int len;
    int token;
    int dtype;
    int data_fifo_empty;
    int data_fifo_progfull;
    int dataIdx;
    int reqGIBValid;
    int ddr_id;
    int input_data_fifo_wen;
    int input_data_fifo_ren;
    int isStopable;
    int liveCount;
    int readMoreData;
    int newReqSeq;
    int data_fifo_ren;
    int data_fifo_wen;

    //printf("\t out seq %d\n", out_data->reqdata.seq->aval);

    if(EOF ==fscanf(fout, "%d %d %d %d", &num, &data_fifo_empty
                , &data_fifo_progfull, &dataIdx))
        exit(0);
    printf("output %d\n", num);

    fscanf(fout, "%d %d", &pread_busValid, &pread_isFeature);
    
    if(pread_busValid){
        if(!pread_isFeature){
            fscanf(fout, "%d %d %d %d", &seq, &len, &token, &dtype);
            for (i = 0; i < len; i++)
					fscanf(fout, " %d", data + i);
        }
        else {
            fscanf(fout, " %d", &len);
            for (i = 0; i < len; i++)
					fscanf(fout, " %d", data_bus + i);
        }
    }
    fscanf(fout, "%d %d %d %d %d %d %d %d %d %d %d %d %d %d"
            , &input_data_fifo_wen, &input_data_fifo_ren
            , &ddr_id, &reqGIBValid
			, &ddr_enable, &ddr_addr, &ddr_len, &rama_ren
			, &ramb_ren, &ram_addr, &ram_len, &pread_waitForSeq
			, &pread_RequestFull, &pread_SeqNum);
    fscanf(fout, "%d %d %d %d %d %d", &isStopable, &liveCount, &readMoreData, &newReqSeq, &data_fifo_wen, &data_fifo_ren);
   

    if (out_data->data_fifo_wen != data_fifo_wen)
        printf("\t data_fifo_wen %d vs %d\n", out_data->data_fifo_wen, data_fifo_wen);
    if (out_data->data_fifo_ren != data_fifo_ren)
        printf("\t data_fifo_ren %d vs %d\n", out_data->data_fifo_ren, data_fifo_ren);
    if (out_data->input_data_fifo_wen != input_data_fifo_wen)
        printf("\t input_data_fifo_wen %d vs %d\n", out_data->input_data_fifo_wen, input_data_fifo_wen);
    if (out_data->input_data_fifo_ren != input_data_fifo_ren)
        printf("\t input_data_fifo_ren %d vs %d\n", out_data->input_data_fifo_ren, input_data_fifo_ren);
    if (out_data->readMoreData != readMoreData)
        printf("\t readMoreData %d vs %d\n", out_data->readMoreData, readMoreData);
    if (out_data->newReqSeq != newReqSeq)
        printf("\t newReqSeq %d vs %d\n", out_data->newReqSeq, newReqSeq);
    if (out_data->liveCount->aval != liveCount)
        printf("\t liveCount %d vs %d\n", out_data->liveCount->aval, liveCount);
    if (out_data->ddr_id->aval != ddr_id)
        printf("\t ddr_id %d vs %d\n", out_data->ddr_id->aval, ddr_id);
    if (out_data->reqGIBValid != reqGIBValid)
        printf("\t reqGIBValid %d vs %d\n", out_data->reqGIBValid, reqGIBValid);
    if (out_data->ddr_enable != ddr_enable)
        printf("\t ddr_enable %d vs %d\n", out_data->ddr_enable, ddr_enable);
    if(ddr_enable){
        if (out_data->ddr_addr->aval != ddr_addr)
            printf("\t ddr_addr %d vs %d\n", out_data->ddr_addr->aval, ddr_addr);
        if (out_data->ddr_len->aval != ddr_len)
            printf("\t ddr_len %d vs %d\n", out_data->ddr_len->aval, ddr_len);
    }
    if (out_data->rama_ren != rama_ren)
        printf("\t rama_ren %d vs %d\n", out_data->rama_ren, rama_ren);
    if (out_data->ramb_ren != ramb_ren)
        printf("\t ramb_ren %d vs %d\n", out_data->ramb_ren, ramb_ren);
    if(ramb_ren || rama_ren){
        if (out_data->ram_addr->aval != ram_addr)
            printf("\t ram_addr %d vs %d\n", out_data->ram_addr->aval, ram_addr);
        if (out_data->ram_len->aval != ram_len)
            printf("\t ram_len %d vs %d\n", out_data->ram_len->aval, ram_len);
    }
    if (out_data->pread_waitForSeq != pread_waitForSeq)
        printf("\t pread_waitForSeq %d vs %d\n", out_data->pread_waitForSeq, pread_waitForSeq);
    if (out_data->pread_busValid != pread_busValid)
        printf("\t pread_busValid %d vs %d\n", out_data->pread_busValid, pread_busValid);
    if (out_data->pread_RequestFull != pread_RequestFull)
        printf("\t pread_RequestFull %d vs %d\n", out_data->pread_RequestFull, pread_RequestFull);
    if (out_data->isStopable != isStopable)
        printf("\t isStopable %d vs %d\n", out_data->isStopable, isStopable);
    
    
    if (out_data->pread_SeqNum->aval != pread_SeqNum)
        printf("\t pread_SeqNum %d vs %d\n", out_data->pread_SeqNum->aval, pread_SeqNum);
   

    if (pread_busValid){
        if (out_data->pread_isFeature != pread_isFeature)
            printf("\t pread_isFeature %d vs %d\n", out_data->pread_isFeature, pread_isFeature);
        if(pread_isFeature){
            int equal = 1;
            for (i = 0; i < len; i++){
                int val = SV_GET_SIGNED_BITS(out_data->data_bus[i]->aval, FEATURE_BIT_NUM - 1);
                if(val != data_bus[i])
                    equal = 0;
            }
            if(!equal)
            {
                printf("data_bus %d :", len);
                for (i = 0; i < len; i++){
                    int val = SV_GET_SIGNED_BITS(out_data->data_bus[i]->aval, FEATURE_BIT_NUM - 1);
                    printf(" %d", val);
                }
                printf("\nexpected %d :", len);
                for (i = 0; i < len; i++)
                    printf(" %d", data_bus[i]);
                printf("\n");
            }
        }
        else{
            
            int equal = 1;
            if (out_data->reqdata.seq->aval != seq)
                printf("\t seq %d vs %d\n", out_data->reqdata.seq->aval, seq);
            int rlen = out_data->reqdata.len->aval;
            if (rlen != len && (((rlen + 1)/2) != len))
                printf("\t len %d vs %d\n", out_data->reqdata.len->aval, len);
            if (out_data->reqdata.token->aval != token)
                printf("\t token %d vs %d\n", out_data->reqdata.token->aval, token);
            if (out_data->reqdata.dtype->aval != dtype)
                printf("\t dtype %d vs %d\n", out_data->reqdata.dtype->aval, dtype);
            for (i = 0; i < len; i++){
                int val = SV_GET_SIGNED_BITS(out_data->reqdata.data[i]->aval, FEATURE_BIT_NUM - 1);
                if(val != data[i] && out_data->reqdata.data[i]->aval != data[i]) // unsigned for GIB
                    equal = 0;
            }
            if(!equal)
            {
                printf("reqdata    ");
                for (i = 0; i < len; i++){
                    int val = SV_GET_SIGNED_BITS(out_data->reqdata.data[i]->aval, FEATURE_BIT_NUM - 1);
                    printf(" %d", val);
                }
                printf("\nexpected ");
                for (i = 0; i < len; i++)
                    printf(" %d", data[i]);
                printf("\n");
            }
        }
    }
}

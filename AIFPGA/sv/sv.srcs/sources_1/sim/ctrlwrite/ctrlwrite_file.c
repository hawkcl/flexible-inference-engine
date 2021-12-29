#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"

#define COMPUTING_GROUP_SIZE   7
#define BANK_NUM            4
#define FEATURE_BIT_NUM 8

FILE *fin;
FILE *fout;
void init_files() 
{
    fin = fopen("D:/aidata/ctrlwrite_input.txt", "rt");
    fout = fopen("D:/aidata/ctrlwrite_output.txt", "rt");
    assert(fin);
    assert(fout);
    //char line[5000];
    //fgets(line, 5000, fout);
}

void read_inputs(ctrlwrite_inputs* in_data)
{
    int i, j;
    int num;
    int cwinst_enable;
    int cb0_finishedSeq;
    int cb_isFetchNextInst[4];
    int pwrite_setNextInst[4];
    int pwrite_data[4][7];
    int pwrite_enable[4];
    int pwrite_addr[4];

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
    int ddr_write_ready;

    if(EOF == fscanf(fin, "%d %d %d %d", &num, &cb0_finishedSeq, &cwinst_enable , &ddr_write_ready))
        exit(0);
    printf("read %d\n", num);

    in_data->cb0_finishedSeq->aval = cb0_finishedSeq;
    in_data->cb0_finishedSeq->bval = 0;
    in_data->cwinst_enable = cwinst_enable;
    in_data->ddr_write_ready = ddr_write_ready;
    if (cwinst_enable){
        fscanf(fin, "%d %d %d %d %d %d %d %d %d %d\n", &mode
			, &dataWidth, &dataWidth2, &Oaddr
			, &outH1, &isUpsample, &isMaddr_a
			, &isMaddr_b, &maxpool_stride, &maxpool_size);
        
        in_data->cwinst.isUpsample = isUpsample;
        in_data->cwinst.isMaddr_a = isMaddr_a;
        in_data->cwinst.isMaddr_b = isMaddr_b;
        in_data->cwinst.mode->aval = mode;
        in_data->cwinst.mode->bval = 0;
        in_data->cwinst.dataWidth->aval = dataWidth;
        in_data->cwinst.dataWidth->bval = 0;
        in_data->cwinst.dataWidth2->aval = dataWidth2;
        in_data->cwinst.dataWidth2->bval = 0;
        in_data->cwinst.Oaddr->aval = Oaddr;
        in_data->cwinst.Oaddr->bval = 0;
        in_data->cwinst.outH1->aval = outH1;
        in_data->cwinst.outH1->bval = 0;
        in_data->cwinst.maxpool_stride->aval = maxpool_stride;
        in_data->cwinst.maxpool_stride->bval = 0;
        in_data->cwinst.maxpool_size->aval = maxpool_size;
        in_data->cwinst.maxpool_size->bval = 0;
    }

    for (i = 0; i < BANK_NUM; i++){
        fscanf(fin, "%d %d %d", cb_isFetchNextInst + i
                , pwrite_setNextInst + i , pwrite_enable + i);

        in_data->cb_isFetchNextInst[i] = cb_isFetchNextInst[i];
        in_data->pwrite_setNextInst[i] = pwrite_setNextInst[i];
        in_data->pwrite_enable[i] = pwrite_enable[i];
        if(pwrite_enable[i]){
            int len;
            fscanf(fin, "%d %d", pwrite_addr + i, &len);
            in_data->pwrite_addr[i]->aval = pwrite_addr[i];
            in_data->pwrite_addr[i]->bval = 0;
            for(j = 0; j < len; j++){
                fscanf(fin, "%d", pwrite_data[i] + j);
                in_data->pwrite_data[i][j]->aval = pwrite_data[i][j];
                in_data->pwrite_data[i][j]->bval = 0;
            }
        }
    }

}



void compare_outputs(const ctrlwrite_outputs* out_data)
{
    int i;
    int num;
    int pwrite_finishedSeq;
    int pwrite_isFetchNextInst;
    int pwrite_isWritable[4];
    int ddr_write_enable;
    int ddr_write_addr;
    int ddr_write_len;
    int rama_write_enable;
    int ramb_write_enable;
    int ram_write_addr;
    int ram_write_len;
    int isStopable;
    int outbuf[28];
    int len;

    int fifo_empty[4];
    int fifo_full[4];
    int fifo_ren[4];
    int idx;
    int curH01;
    int curH23;
    int pool_flush_01;
    int pool_flush_23;
    int addr_pool_01;
    int addr_pool_23;

    //printf("\t out seq %d\n", out_data->reqdata.seq->aval);

    if(EOF ==fscanf(fout, "%d %d %d %d %d %d %d %d", &num, &pwrite_finishedSeq
                , &pwrite_isFetchNextInst, pwrite_isWritable
                , pwrite_isWritable + 1, pwrite_isWritable + 2, pwrite_isWritable + 3
                , &isStopable))
        exit(0);
    printf("output %d\n", num);

    for (i = 0; i < BANK_NUM; i++){
        fscanf(fout, " %d %d", fifo_empty + i, fifo_full + i);
    }

    fscanf(fout, "%d", &len);
    for(i = 0; i < len; i++){
        fscanf(fout, "%d", outbuf + i);
    }

    fscanf(fout, "%d %d %d %d %d %d %d", &ddr_write_enable
        , &ddr_write_addr, &ddr_write_len, &rama_write_enable
        , &ramb_write_enable, &ram_write_addr, &ram_write_len);

    fscanf(fout, " %d %d %d %d %d %d %d", &idx
			, &curH01, &curH23, &pool_flush_01
			, &pool_flush_23, &addr_pool_01, &addr_pool_23);

    for (i = 0; i < BANK_NUM; i++){
        fscanf(fout, " %d", fifo_ren + i);
    }

    if (out_data->pwrite_isFetchNextInst != pwrite_isFetchNextInst)
        printf("\t pwrite_isFetchNextInst %d vs %d\n", out_data->pwrite_isFetchNextInst, pwrite_isFetchNextInst);
    if (out_data->ddr_write_enable != ddr_write_enable)
        printf("\t ddr_write_enable %d vs %d\n", out_data->ddr_write_enable, ddr_write_enable);
    if (out_data->rama_write_enable != rama_write_enable)
        printf("\t rama_write_enable %d vs %d\n", out_data->rama_write_enable, rama_write_enable);
    if (out_data->ramb_write_enable != ramb_write_enable)
        printf("\t ramb_write_enable %d vs %d\n", out_data->ramb_write_enable, ramb_write_enable);
    if (out_data->isStopable != isStopable)
        printf("\t isStopable %d vs %d\n", out_data->isStopable, isStopable);
    if (out_data->pool_flush_01 != pool_flush_01)
        printf("\t pool_flush_01 %d vs %d\n", out_data->pool_flush_01, pool_flush_01);
    if (out_data->pool_flush_23 != pool_flush_23)
        printf("\t pool_flush_23 %d vs %d\n", out_data->pool_flush_23, pool_flush_23);
    for(i = 0; i < BANK_NUM; i++){
        if (out_data->pwrite_isWritable[i] != pwrite_isWritable[i])
            printf("\t pwrite_isWritable_%d %d vs %d\n", i, out_data->pwrite_isWritable[i], pwrite_isWritable[i]);
        if (out_data->fifo_empty[i] != fifo_empty[i])
            printf("\t fifo_empty%d %d vs %d\n", i, out_data->fifo_empty[i], fifo_empty[i]);
        if (out_data->fifo_full[i] != fifo_full[i])
            printf("\t fifo_full%d %d vs %d\n", i, out_data->fifo_full[i], fifo_full[i]);
        if (out_data->fifo_ren[i] != fifo_ren[i])
            printf("\t fifo_ren%d %d vs %d\n", i, out_data->fifo_ren[i], fifo_ren[i]);
    }

    if(ddr_write_enable){
        if (out_data->ddr_write_addr->aval != ddr_write_addr)
            printf("\t ddr_write_addr %d vs %d\n", out_data->ddr_write_addr->aval, ddr_write_addr);
        if (out_data->ddr_write_len->aval != ddr_write_len)
            printf("\t ddr_write_len %d vs %d\n", out_data->ddr_write_len->aval, ddr_write_len);
    }
    if(rama_write_enable || ramb_write_enable){
        if (out_data->ram_write_addr->aval != ram_write_addr)
            printf("\t ram_write_addr %d vs %d\n", out_data->ram_write_addr->aval, ram_write_addr);
        if (out_data->ram_write_len->aval != ram_write_len)
            printf("\t ram_write_len %d vs %d\n", out_data->ram_write_len->aval, ram_write_len);
    }
    
    if (out_data->idx->aval != idx)
        printf("\t idx %d vs %d\n", out_data->idx->aval, idx);
    if (out_data->curH01->aval != curH01)
        printf("\t curH01 %d vs %d\n", out_data->curH01->aval, curH01);
    if (out_data->curH23->aval != curH23)
        printf("\t curH23 %d vs %d\n", out_data->curH23->aval, curH23);
    if (out_data->addr_pool_01->aval != addr_pool_01)
        printf("\t addr_pool_01 %d vs %d\n", out_data->addr_pool_01->aval, addr_pool_01);
    if (out_data->addr_pool_23->aval != addr_pool_23)
        printf("\t addr_pool_23 %d vs %d\n", out_data->addr_pool_23->aval, addr_pool_23);
    if (out_data->pwrite_finishedSeq->aval != pwrite_finishedSeq)
        printf("\t pwrite_finishedSeq %d vs %d\n", out_data->pwrite_finishedSeq->aval, pwrite_finishedSeq);
   
    if(rama_write_enable || ramb_write_enable || ddr_write_enable)
        assert(len > 0);

    if (len > 0){
        int equal = 1;
        for (i = 0; i < len; i++){
            int val = SV_GET_SIGNED_BITS(out_data->outbuf[i]->aval, FEATURE_BIT_NUM - 1);
            if(val != outbuf[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("outbuf %d :", len);
            for (i = 0; i < len; i++){
                int val = SV_GET_SIGNED_BITS(out_data->outbuf[i]->aval, FEATURE_BIT_NUM - 1);
                printf(" %d", val);
            }
            printf("\nexpected %d :", len);
            for (i = 0; i < len; i++)
                printf(" %d", outbuf[i]);
            printf("\n");
        }
            /*printf("outbuf %d :", len);
            for (i = 0; i < len; i++){
                int val = SV_GET_SIGNED_BITS(out_data->outbuf[i]->aval, FEATURE_BIT_NUM - 1);
                printf(" %d", val);
            }
            printf("\n");*/
    }
}

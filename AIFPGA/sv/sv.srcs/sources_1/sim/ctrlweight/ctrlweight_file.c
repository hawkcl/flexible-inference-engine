#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"

#define WEIGHT_READ_WIDTH   32
#define BANK_NUM            4
#define WEIGHT_BIT_NUM  8

FILE *fin;
FILE *fout;
void init_files() 
{
    fin = fopen("D:/aidata/ctrlweight_input.txt", "rt");
    fout = fopen("D:/aidata/ctrlweight_output.txt", "rt");
    assert(fin);
    assert(fout);
    //char line[5000];
    //fgets(line, 5000, fout);
}

void read_inputs(ctrlweight_inputs* in_data)
{
    int i;
    int num;
    int ddr_read_ready;
    int valid_id;
    int cwinst_enable;
    int weight_data[32];
    int cb_isReadingWeights[4];
    int cb_isWeightFull[4];
    int cb_ReqWeight[4];
    int isReadRam;
    int isWriteRam;
    int mode;
    int dropSize;
    int seqNum;
    int Oaddr;
    int size;
    int w_len;


    if(EOF == fscanf(fin, "%d %d", &num, &ddr_read_ready))
        exit(0);
    printf("read %d\n", num);
    in_data->ddr_read_ready = ddr_read_ready;

    for (i = 0; i < BANK_NUM; i++){
        fscanf(fin, " %d %d %d", cb_isReadingWeights + i
                , cb_ReqWeight + i , cb_isWeightFull + i);

        in_data->cb_isReadingWeights[i] = cb_isReadingWeights[i];
        in_data->cb_ReqWeight[i]->aval = cb_ReqWeight[i];
        in_data->cb_ReqWeight[i]->bval = 0;
        in_data->cb_isWeightFull[i] = cb_isWeightFull[i];
    }

    fscanf(fin, " %d", &cwinst_enable);
    in_data->cwinst_enable = cwinst_enable;
    if(cwinst_enable){
        fscanf(fin, "%d %d %d %d %d %d %d\n", &isReadRam
                , &isWriteRam, &mode, &Oaddr
                , &seqNum, &dropSize, &size);

        in_data->cwinst.isReadRam = isReadRam;
        in_data->cwinst.isWriteRam = isWriteRam;
        in_data->cwinst.mode->aval = mode;
        in_data->cwinst.mode->bval = 0;
        in_data->cwinst.Oaddr->aval = Oaddr;
        in_data->cwinst.Oaddr->bval = 0;
        in_data->cwinst.seqNum->aval = seqNum;
        in_data->cwinst.seqNum->bval = 0;
        in_data->cwinst.dropSize->aval = dropSize;
        in_data->cwinst.dropSize->bval = 0;
        in_data->cwinst.size->aval = size;
        in_data->cwinst.size->bval = 0;
    }

    
    fscanf(fin, " %d %d", &valid_id, &w_len);
    in_data->valid_id->aval = valid_id;
    in_data->valid_id->bval = 0;
    if(w_len > 0)
    {
        for (i = 0; i < w_len; i++){
            fscanf(fin, " %d", weight_data + i);
            in_data->weight_data[i]->aval = weight_data[i];
            in_data->weight_data[i]->bval = 0;
        }
    }
}



void compare_outputs(const ctrlweight_outputs* out_data)
{
    int i;
    int num;
    int weight_ddr_id;
    int weight_ram_enable;
    int weight_ram_addr;
    int pcweight_busValid;
    int pcweight_seq;
    int w_bus[32];
    int hasMoreData;
    int nextReadAddr;
    int dataIdx;
    int saved_enable;
    int read_mem;
    int data_fifo_ren;
    int data_fifo_wen;
    int data_fifo_empty;
    int data_fifo_progfull;
    int weight_mem_ren;
    int weight_mem_wen;
    int bus_len;
    int isStopable;

    if(EOF ==fscanf(fout, "%d %d %d %d %d", &num, &data_fifo_empty
                , &data_fifo_progfull, &dataIdx, &isStopable))
        exit(0);
    printf("output %d\n", num);
    //printf("  mode %d, dataIdx %d, data_progfull %d, hasMoreData %d, save_enable %d\n"
    //        , out_data->mode->aval, out_data->dataIdx->aval, out_data->data_fifo_progfull
    //        , out_data->hasMoreData, out_data->saved_enable);

    fscanf(fout, "%d %d %d %d %d %d %d", &weight_ram_enable
            , &weight_ddr_id, &weight_ram_addr
            , &pcweight_busValid, &pcweight_seq, &hasMoreData
            , &nextReadAddr);
    fscanf(fout, " %d %d %d %d %d %d", &saved_enable, &read_mem
            , &data_fifo_ren, &data_fifo_wen, &weight_mem_ren, &weight_mem_wen);

    if (pcweight_busValid){
        fscanf(fout, " %d", &bus_len);
        for (i = 0; i < bus_len; i++)
            fscanf(fout, " %d", w_bus+i);
    }




    if (out_data->weight_ram_enable != weight_ram_enable)
        printf("\t weight_ram_enable %d vs %d\n", out_data->weight_ram_enable, weight_ram_enable);
    if (out_data->pcweight_busValid != pcweight_busValid)
        printf("\t pcweight_busValid %d vs %d\n", out_data->pcweight_busValid, pcweight_busValid);
    if (out_data->isStopable != isStopable)
        printf("\t isStopable %d vs %d\n", out_data->isStopable, isStopable);
    if (out_data->hasMoreData != hasMoreData)
        printf("\t hasMoreData %d vs %d\n", out_data->hasMoreData, hasMoreData);
    if (out_data->saved_enable != saved_enable)
        printf("\t saved_enable %d vs %d\n", out_data->saved_enable, saved_enable);
    if (out_data->read_mem != read_mem)
        printf("\t read_mem %d vs %d\n", out_data->read_mem, read_mem);
    if (out_data->data_fifo_ren != data_fifo_ren)
        printf("\t data_fifo_ren %d vs %d\n", out_data->data_fifo_ren, data_fifo_ren);
    if (out_data->data_fifo_wen != data_fifo_wen)
        printf("\t data_fifo_wen %d vs %d\n", out_data->data_fifo_wen, data_fifo_wen);
    if (out_data->data_fifo_empty != data_fifo_empty)
        printf("\t data_fifo_empty %d vs %d\n", out_data->data_fifo_empty, data_fifo_empty);
    if (out_data->data_fifo_progfull != data_fifo_progfull)
        printf("\t data_fifo_progfull %d vs %d\n", out_data->data_fifo_progfull, data_fifo_progfull);
    if (out_data->weight_mem_ren != weight_mem_ren)
        printf("\t weight_mem_ren %d vs %d\n", out_data->weight_mem_ren, weight_mem_ren);
    if (out_data->weight_mem_wen != weight_mem_wen)
        printf("\t weight_mem_wen %d vs %d\n", out_data->weight_mem_wen, weight_mem_wen);

    if(weight_ram_enable)
        if (out_data->weight_ram_addr->aval != weight_ram_addr)
            printf("\t weight_ram_addr %d vs %d\n", out_data->weight_ram_addr->aval, weight_ram_addr);
    if (out_data->pcweight_seq->aval != pcweight_seq)
        printf("\t pcweight_seq %d vs %d\n", out_data->pcweight_seq->aval, pcweight_seq);
    if (out_data->nextReadAddr->aval != nextReadAddr)
        printf("\t nextReadAddr %d vs %d\n", out_data->nextReadAddr->aval, nextReadAddr);
    if (out_data->dataIdx->aval != dataIdx)
        printf("\t dataIdx %d vs %d\n", out_data->dataIdx->aval, dataIdx);
    if (out_data->weight_ddr_id->aval != weight_ddr_id)
        printf("\t weight_ddr_id %d vs %d\n", out_data->weight_ddr_id->aval, weight_ddr_id);

    if (pcweight_busValid){
        int equal = 1;
        for (i = 0; i < bus_len; i++){
            int val = SV_GET_SIGNED_BITS(out_data->w_bus[i]->aval, WEIGHT_BIT_NUM - 1);
            if(val != w_bus[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("w_bus    ");
            for (i = 0; i < bus_len; i++){
                int val = SV_GET_SIGNED_BITS(out_data->w_bus[i]->aval, WEIGHT_BIT_NUM - 1);
                printf(" %d", val);
            }
            printf("\nexpected ");
            for (i = 0; i < bus_len; i++)
                printf(" %d", w_bus[i]);
            printf("\n");
        }
    }
}

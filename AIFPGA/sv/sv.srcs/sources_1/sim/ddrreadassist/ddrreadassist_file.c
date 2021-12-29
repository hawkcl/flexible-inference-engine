#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"

#define DDR_DATAWIDTH   32

FILE *fin;
FILE *fout;
void init_files() 
{
    fin = fopen("D:/aidata/ddrread_ddrd_read_input.txt", "rt");
    fout = fopen("D:/aidata/ddrread_ddrd_read_output.txt", "rt");
    assert(fin);
    assert(fout);
    //char line[5000];
    //fgets(line, 5000, fout);
}

void read_inputs(ddrreadassist_inputs* in_data)
{
    int i;
    int num;
    int req_valid;
    int req_id;
    int req_addr;
    int req_len;
    int ddr_vid;
    int ddr_data[32];
    int ddr_isLast;


    if(EOF == fscanf(fin, "%d %d", &num, &ddr_vid))
        exit(0);
    printf("read %d\n", num);

    
    in_data->ddr_vid->aval = ddr_vid;
    in_data->ddr_vid->bval = 0;
    if (ddr_vid != 0){
        fscanf(fin, " %d", &ddr_isLast);
        in_data->ddr_isLast = ddr_isLast;
        for (i = 0; i < DDR_DATAWIDTH; i++){
            fscanf(fin, " %d", ddr_data + i);
            in_data->ddr_data[i]->aval = ddr_data[i];
            in_data->ddr_data[i]->bval = 0;
        }
    }
    fscanf(fin, " %d", &req_valid);
    in_data->req_valid = req_valid;
    if(req_valid){
        fscanf(fin, " %d %d %d", &req_id, &req_addr, &req_len);
        in_data->req_id->aval = req_id;
        in_data->req_id->bval = 0;
        in_data->req_addr->aval = req_addr;
        in_data->req_addr->bval = 0;
        in_data->req_len->aval = req_len;
        in_data->req_len->bval = 0;
    }
}



void compare_outputs(const ddrreadassist_outputs* out_data)
{
    int i;
    int num;
    int read_ready;
    int valid_id;
    int valid_data[66];
    int data_next[66];
    int axi_rid;
    int axi_raddr;
    int axi_len;
    int read_request;
    int read_freeze;
    int next_addr;
    int buf_addr;
    int saved_buf[32];
    int len, data_len;

    if(EOF ==fscanf(fout, "%d %d %d", &num, &read_ready, &read_request))
        exit(0);
    printf("output %d\n", num);
    if(read_request){
        fscanf(fout, "%d %d %d", &axi_rid, &axi_raddr, &axi_len);
    }

    fscanf(fout, " %d", &read_freeze);
    fscanf(fout, " %d", &valid_id);
    if (valid_id != 0){
        fscanf(fout, " %d", &len);
        printf("output_len %d\n", len);
        for (i = 0; i < len; i++)
            fscanf(fout, " %d", valid_data + i);
    }
    fscanf(fout, " %d %d %d", &next_addr, &buf_addr, &data_len);
    for (i = 0; i < DDR_DATAWIDTH; i++)
        fscanf(fout, " %d", saved_buf+i);
    if(data_len > 0)
        for (i = 0; i < data_len; i++)
            fscanf(fout, " %d", data_next+i);
  
    //if (out_data->read_ready != read_ready)
    //    printf("\t read_ready %d vs %d\n", out_data->read_ready, read_ready);
    if (out_data->read_request != read_request)
        printf("\t read_request %d vs %d\n", out_data->read_request, read_request);
    if (out_data->read_freeze != read_freeze)
        printf("\t read_freeze %d vs %d\n", out_data->read_freeze, read_freeze);
    

    if(read_request){
        if (out_data->axi_rid->aval != axi_rid)
            printf("\t axi_rid %d vs %d\n", out_data->axi_rid->aval, axi_rid);
        if (out_data->axi_raddr->aval != axi_raddr)
            printf("\t axi_raddr %d vs %d\n", out_data->axi_raddr->aval, axi_raddr);
        if (out_data->axi_len->aval != axi_len)
            printf("\t axi_len %d vs %d\n", out_data->axi_len->aval, axi_len);
    }
    if (out_data->valid_id->aval != valid_id)
        printf("\t valid_id %d vs %d\n", out_data->valid_id->aval, valid_id);
    
    if (valid_id != 0){
        int equal = 1;
        for (i = 0; i < len; i++){
            int val = out_data->valid_data[i]->aval;
            if(val != valid_data[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("valid_data");
            for (i = 0; i < len; i++){
                int val = out_data->valid_data[i]->aval;
                printf(" %d", val);
            }
            printf("\nexpected  ");
            for (i = 0; i < len; i++)
                printf(" %d", valid_data[i]);
            printf("\n");
        }
    }
    if (out_data->next_addr->aval != next_addr)
        printf("\t next_addr %d vs %d\n", out_data->next_addr->aval, next_addr);
    if (out_data->buf_addr->aval != buf_addr)
        printf("\t buf_addr %d vs %d\n", out_data->buf_addr->aval, buf_addr);

    {
        int equal = 1;
        for (i = 0; i < DDR_DATAWIDTH; i++){
            int val = out_data->saved_buf[i]->aval;
            if(val != saved_buf[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("saved_buf");
            for (i = 0; i < DDR_DATAWIDTH; i++){
                int val = out_data->saved_buf[i]->aval;
                printf(" %d", val);
            }
            printf("\nexpected ");
            for (i = 0; i < DDR_DATAWIDTH; i++)
                printf(" %d", saved_buf[i]);
            printf("\n");
        }
    }
    if (data_len > 0){
        int equal = 1;
        for (i = 0; i < data_len; i++){
            int val = out_data->data_next[i]->aval;
            if(val != data_next[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("data_next");
            for (i = 0; i < data_len; i++){
                int val = out_data->data_next[i]->aval;
                printf(" %d", val);
            }
            printf("\nexpected ");
            for (i = 0; i < data_len; i++)
                printf(" %d", data_next[i]);
            printf("\n");
        }
    }
}

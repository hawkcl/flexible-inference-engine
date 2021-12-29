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
    fin = fopen("D:/aidata/ddrwrite_DDRWrite_input.txt", "rt");
    fout = fopen("D:/aidata/ddrwrite_DDRWrite_output.txt", "rt");
    assert(fin);
    assert(fout);
    //char line[5000];
    //fgets(line, 5000, fout);
}

void read_inputs(ddrwriteassist_inputs* in_data)
{
    int i;
    int num;
    int req_valid;
    int req_addr;
    int req_len;
    int req_data[56];
    int axi_ready;


    if(EOF == fscanf(fin, "%d %d %d", &num, &axi_ready, &req_valid))
        exit(0);
    printf("read %d\n", num);
    in_data->req_valid = req_valid;
    in_data->axi_ready = axi_ready;
    
    if (req_valid != 0){
        fscanf(fin, " %d %d", &req_addr, &req_len);
        in_data->req_addr->aval = req_addr;
        in_data->req_addr->bval = 0;
        in_data->req_len->aval = req_len;
        in_data->req_len->bval = 0;
        for (i = 0; i < req_len; i++){
            fscanf(fin, " %d", req_data + i);
            in_data->req_data[i]->aval = req_data[i];
            in_data->req_data[i]->bval = 0;
        }
    }
}



void compare_outputs(const ddrwriteassist_outputs* out_data)
{
    int i;
    int num;
    int write_ready;
    int write_request;
    int axi_wid;
    int axi_waddr;
    int axi_wstrobe;
    int axi_wdata[32];
    int buf_addr;
    int buf_start;
    int buf_end;
    int idle_count;
    int next_fifo_addr;
    int busy_state;
    int buf_used;
    int saved_buf[32];
    int flash_saved;
    int do_process;
    int saved_pos;
    int saved_start;
    int data_pos;
    int saddr;

    if(EOF ==fscanf(fout, "%d %d %d", &num, &write_ready, &write_request))
        exit(0);
    printf("output %d\n", num);
    if(write_request){
        fscanf(fout, "%d %d %d", &axi_wid, &axi_waddr, &axi_wstrobe);
        for (i = 0; i < DDR_DATAWIDTH; i++)
            fscanf(fout, " %d", axi_wdata + i);
    }
    fscanf(fout, " %d %d %d %d %d %d %d", &buf_addr
			, &buf_start, &buf_end, &idle_count
			, &next_fifo_addr, &busy_state, &buf_used);
    for (i = 0; i < DDR_DATAWIDTH; i++)
        fscanf(fout, " %d", saved_buf + i);
    fscanf(fout, " %d %d %d %d %d %d", &flash_saved
        , &do_process, &saved_pos, &saved_start
        , &data_pos, &saddr);

    if (out_data->write_ready != write_ready)
        printf("\t write_ready %d vs %d\n", out_data->write_ready, write_ready);
    if (out_data->write_request != write_request)
        printf("\t write_request %d vs %d\n", out_data->write_request, write_request);
    if (out_data->busy_state != busy_state)
        printf("\t busy_state %d vs %d\n", out_data->busy_state, busy_state);
    if (out_data->buf_used != buf_used)
        printf("\t buf_used %d vs %d\n", out_data->buf_used, buf_used);
    if (out_data->flash_saved != flash_saved)
        printf("\t flash_saved %d vs %d\n", out_data->flash_saved, flash_saved);
    if (out_data->do_process != do_process)
        printf("\t do_process %d vs %d\n", out_data->do_process, do_process);
    

    if(write_request){
        int equal = 1;
        if (out_data->axi_wid->aval != axi_wid)
            printf("\t axi_wid %d vs %d\n", out_data->axi_wid->aval, axi_wid);
        if (out_data->axi_waddr->aval != axi_waddr)
            printf("\t axi_waddr %d vs %d\n", out_data->axi_waddr->aval, axi_waddr);
        if ((unsigned)(out_data->axi_wstrobe->aval) != (axi_wstrobe))
            printf("\t axi_wstrobe %u vs %u\n", out_data->axi_wstrobe->aval, axi_wstrobe);

        for (i = 0; i < DDR_DATAWIDTH; i++){
            int val = out_data->axi_wdata[i]->aval;
            if(val != axi_wdata[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("axi_wdata");
            for (i = 0; i < DDR_DATAWIDTH; i++){
                int val = out_data->axi_wdata[i]->aval;
                printf(" %d", val);
            }
            printf("\nexpected ");
            for (i = 0; i < DDR_DATAWIDTH; i++)
                printf(" %d", axi_wdata[i]);
            printf("\n");
        }
    }
    if (out_data->buf_addr->aval != buf_addr)
        printf("\t buf_addr %d vs %d\n", out_data->buf_addr->aval, buf_addr);
    if (out_data->buf_start->aval != buf_start)
        printf("\t buf_start %d vs %d\n", out_data->buf_start->aval, buf_start);
    if (out_data->buf_end->aval != buf_end)
        printf("\t buf_end %d vs %d\n", out_data->buf_end->aval, buf_end);
    if (out_data->idle_count->aval != idle_count)
        printf("\t idle_count %d vs %d\n", out_data->idle_count->aval, idle_count);
    if (out_data->next_fifo_addr->aval != next_fifo_addr)
        printf("\t next_fifo_addr %d vs %d\n", out_data->next_fifo_addr->aval, next_fifo_addr);
    if (out_data->saved_pos->aval != saved_pos)
        printf("\t saved_pos %d vs %d\n", out_data->saved_pos->aval, saved_pos);
    if (out_data->saved_start->aval != saved_start)
        printf("\t saved_start %d vs %d\n", out_data->saved_start->aval, saved_start);
    if (out_data->data_pos->aval != data_pos)
        printf("\t data_pos %d vs %d\n", out_data->data_pos->aval, data_pos);
    if (out_data->saddr->aval != saddr)
        printf("\t saddr %d vs %d\n", out_data->saddr->aval, saddr);

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
    
}

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "svdpi.h"
#include "dpiheader.h"

#define INTERFACE_LEN  200

FILE *fin;
FILE *fout;
void init_files() 
{
    fin = fopen("D:/aidata/cloud_input.txt", "rt");
    fout = fopen("D:/aidata/cloud_output.txt", "rt");
    assert(fin);
    assert(fout);
    //char line[5000];
    //fgets(line, 5000, fout);
}

void read_inputs(cloud_inputs* in_data)
{
    int i;
    int num;
    int buf_received;
    int buffer[208];
    

    if(EOF == fscanf(fin, "%d %d", &num, &buf_received))
        exit(0);
    printf("read %d\n", num);
    in_data->buf_received = buf_received;

    if (buf_received){
        for (i = 0; i < INTERFACE_LEN + 8; i++){
            fscanf(fin, " %d", buffer + i);
            in_data->buffer[i]->aval = buffer[i];
            in_data->buffer[i]->bval = 0;
        }
    }
}



void compare_outputs(const cloud_outputs* out_data)
{
    int i;
    int num;
    int addrbuf_enable;
    int inst_address;
    int output_enable;
    int output_addr;
    int output_data[200];
    int output_len;
    int ren_weight;
    int read_addr_weight;
    int read_len_weight;
    int read_data_weight[200];
    int ren_data1;
    int read_addr_data1;
    int read_len_data1;
    int read_data_data1[200];

    int wen_data1;
    int write_addr_data1;
    int write_len_data1;
    int write_data_data1[200];

    //printf("\t out seq %d\n", out_data->reqdata.seq->aval);

    if(EOF ==fscanf(fout, "%d %d %d %d %d %d", &num, &addrbuf_enable, &inst_address
			, &output_enable, &output_addr, &output_len))
        exit(0);
    printf("output %d\n", num);

    if (out_data->addrbuf_enable != addrbuf_enable)
        printf("\t addrbuf_enable %d vs %d\n", out_data->addrbuf_enable, addrbuf_enable);
    if (out_data->output_enable != output_enable)
        printf("\t output_enable %d vs %d\n", out_data->output_enable, output_enable);
    if(addrbuf_enable){
        if (out_data->inst_address->aval != inst_address)
            printf("\t inst_address %d vs %d\n", out_data->inst_address->aval, inst_address);
    
    }
    if (output_enable){
        int equal = 1;
        if (out_data->output_addr->aval != output_addr)
            printf("\t output_addr %d vs %d\n", out_data->output_addr->aval, output_addr);
        if (out_data->output_len->aval != output_len)
            printf("\t output_len %d vs %d\n", out_data->output_len->aval, output_len);
        for (i = 0; i < output_len; i++){
            fscanf(fout, " %d", output_data + i);
        }
        for (i = 0; i < output_len; i++){
            int val = out_data->output_data[i]->aval;
            if(val != output_data[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("output_data %d :", output_len);
            for (i = 0; i < output_len; i++){
                int val = out_data->output_data[i]->aval;
                printf(" %d", val);
            }
            printf("\nexpected %d :", output_len);
            for (i = 0; i < output_len; i++)
                printf(" %d", output_data[i]);
            printf("\n");
        }
    }
    fscanf(fout, " %d %d %d", &ren_weight, &ren_data1, &wen_data1);
    if (out_data->ren_weight != ren_weight)
        printf("\t wen_data1 %d vs %d\n", out_data->ren_weight, ren_weight);
    if (ren_weight){
        int equal = 1;
        fscanf(fout, "%d %d", &read_addr_weight, &read_len_weight);
        if (out_data->read_addr_weight->aval != read_addr_weight)
            printf("\t read_addr_weight %d vs %d\n", out_data->read_addr_weight->aval, read_addr_weight);
        if (out_data->read_len_weight->aval != read_len_weight)
            printf("\t read_len_weight %d vs %d\n", out_data->read_len_weight->aval, read_len_weight);
        for (i = 0; i < read_len_weight; i++)
            fscanf(fout, " %d", read_data_weight + i);
        for (i = 0; i < read_len_weight; i++){
            int val = out_data->read_data_weight[i]->aval;
            if(val != read_data_weight[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("read_data_weight %d :", read_len_weight);
            for (i = 0; i < read_len_weight; i++){
                int val = out_data->read_data_weight[i]->aval;
                printf(" %d", val);
            }
            printf("\nexpected %d :", read_len_weight);
            for (i = 0; i < read_len_weight; i++)
                printf(" %d", read_data_weight[i]);
            printf("\n");
        }
    }
    if (out_data->ren_data1 != ren_data1)
        printf("\t ren_data1 %d vs %d\n", out_data->ren_data1, ren_data1);
    if (ren_data1){
        int equal = 1;
        fscanf(fout, "%d %d", &read_addr_data1, &read_len_data1);
        if (out_data->read_addr_data1->aval != read_addr_data1)
            printf("\t read_addr_data1 %d vs %d\n", out_data->read_addr_data1->aval, read_addr_data1);
        if (out_data->read_len_data1->aval != read_len_data1)
            printf("\t read_len_data1 %d vs %d\n", out_data->read_len_data1->aval, read_len_data1);
        for (i = 0; i < read_len_data1; i++)
            fscanf(fout, " %d", read_data_data1 + i);

        for (i = 0; i < read_len_data1; i++){
            int val = out_data->read_data_data1[i]->aval;
            if(val != read_data_data1[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("read_data_data1 %d :", read_len_data1);
            for (i = 0; i < read_len_data1; i++){
                int val = out_data->read_data_data1[i]->aval;
                printf(" %d", val);
            }
            printf("\nexpected %d :", read_len_data1);
            for (i = 0; i < read_len_data1; i++)
                printf(" %d", read_data_data1[i]);
            printf("\n");
        }
    }
    if (out_data->wen_data1 != wen_data1)
        printf("\t wen_data1 %d vs %d\n", out_data->wen_data1, wen_data1);

    if (wen_data1){
        int equal = 1;
        fscanf(fout, "%d %d", &write_addr_data1, &write_len_data1);
        if (out_data->write_addr_data1->aval != write_addr_data1)
            printf("\t write_addr_data1 %d vs %d\n", out_data->write_addr_data1->aval, write_addr_data1);
        if (out_data->write_len_data1->aval != write_len_data1)
            printf("\t write_len_data1 %d vs %d\n", out_data->write_len_data1->aval, write_len_data1);
        for (i = 0; i < write_len_data1; i++)
            fscanf(fout, " %d", write_data_data1 + i);

        for (i = 0; i < write_len_data1; i++){
            int val = out_data->write_data_data1[i]->aval;
            if(val != write_data_data1[i])
                equal = 0;
        }
        if(!equal)
        {
            printf("write_data_data1 %d :", write_len_data1);
            for (i = 0; i < write_len_data1; i++){
                int val = out_data->write_data_data1[i]->aval;
                printf(" %d", val);
            }
            printf("\nexpected         %d :", write_len_data1);
            for (i = 0; i < write_len_data1; i++)
                printf(" %d", write_data_data1[i]);
            printf("\n");
        }
    }
}

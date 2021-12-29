`timescale 1ns / 1ns
module Cloud 
import definitions_pkg::*;                  
(
    input  logic                    clock       , // Clock Input
    input  logic                    resetN ,
    input  logic                    buf_received,
    input  logic [7 : 0]            buffer[DDR_LEN_SIZE + 8], // 200 + 8

    output logic                        output_enable,
    output logic [DDR_ADDR_WIDTH-1:0]   output_addr,
    output logic [DDR_DATA_WIDTH-1:0]   output_data[DDR_LEN_SIZE],
    output logic [DDR_LEN_WIDTH-1 : 0]  output_len
); 

logic                           add_output;
logic   [DDR_ADDR_WIDTH-1:0]    add_output_address;
logic   [DDR_ADDR_WIDTH-1:0]    add_output_size;

logic                           addrbuf_enable;
mem_addr_t                      inst_address;

logic   [DDR_DATA_WIDTH-1:0]    read_data_weight[DDR_LEN_SIZE];
logic                           ren_weight;
logic   [DDR_ADDR_WIDTH-1:0]    read_addr_weight;
logic   [DDR_LEN_WIDTH-1 : 0]   read_len_weight;

logic   [DDR_DATA_WIDTH-1:0]    read_data_data1[DDR_LEN_SIZE];
logic                           ren_data1;
logic   [DDR_ADDR_WIDTH-1:0]    read_addr_data1;
logic   [DDR_LEN_WIDTH-1 : 0]   read_len_data1;

logic                           wen_data1;
logic   [DDR_ADDR_WIDTH-1:0]    write_addr_data1;
logic   [DDR_LEN_WIDTH-1 : 0]   write_len_data1;
logic   [DDR_DATA_WIDTH-1:0]    write_data_data1[DDR_LEN_SIZE];


logic   [DDR_DATA_WIDTH-1:0]    read_data_data[DDR_LEN_SIZE];
logic                           ren_data;
logic   [DDR_ADDR_WIDTH-1:0]    read_addr_data;
logic   [DDR_LEN_WIDTH-1 : 0]   read_len_data;

logic                           wen_data;
logic   [DDR_ADDR_WIDTH-1:0]    write_addr_data;
logic   [DDR_LEN_WIDTH-1 : 0]   write_len_data;
logic   [DDR_DATA_WIDTH-1:0]    write_data_data[DDR_LEN_SIZE];

logic                           wen_weight;
logic   [DDR_ADDR_WIDTH-1:0]    write_addr_weight;
logic   [DDR_LEN_WIDTH-1 : 0]   write_len_weight;
logic   [DDR_DATA_WIDTH-1:0]    write_data_weight[DDR_LEN_SIZE];

//GIB
seq_t 		                    rama_finishedSeq;
seq_t 		                    ramb_finishedSeq;
logic                           addressBuffer_empty;
logic                           addressBuffer_full;
mem_addr_t                      addressBuffer_rdata;
logic         [BANK_NUM+1 : 0]  cb_ibfull;

logic                           addressBuffer_ren;
logic                           reqGIBValid;
RequestItem_t                   reqGIB;
logic                           cb_start[BANK_NUM];
logic                           cb_stop[BANK_NUM];
logic 		                    inst_enable[BANK_NUM];
InstructionHCB 	                cb_inst[BANK_NUM];
logic 		                    cwtinst_enable;
InstructionWeight               cwtinst;
logic 		                    crinst_enable;
InstructionRead 	            crinst;
logic 		                    cwinst_enable;
InstructionWrite                cwinst;
logic 		                    hcb_isStopable[BANK_NUM];
logic                           read_isStopable;
logic                           write_isStopable;
logic                           weight_isStopable;

//ctrlread
logic                           cb_isRunning[BANK_NUM];
logic                           cb_isReadingFeatures[BANK_NUM];
logic                           cb_isLoadingFroze[BANK_NUM];
seq_t                           cb_ReqFeature[BANK_NUM];
seq_t                           cb_FinishedSeq[BANK_NUM];
seq_t                           cb_WorkingSeq[BANK_NUM];
seq_t                           cb_WorkingProgress[BANK_NUM];
logic                           ddr_read_ready;

logic                           [BANK_NUM-1:0]requestValid;
RequestItem_t                   ritem[BANK_NUM];
ddr_id_t                                    ddr_data_id;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]    ddr_data;
s_feature_t     [MAX_LOAD_WIDTH - 1 : 0]    rama_data;
s_feature_t     [MAX_LOAD_WIDTH - 1 : 0]    ramb_data;
logic                           rama_ren;
logic                           ramb_ren;
mem_addr_t                      ram_addr;
ctrl_width_t                    ram_len;
ddr_id_t                        ddr_id;

logic                           pread_waitForSeq;
logic 		                    pread_busValid;
logic 		                    pread_isFeature;
logic                           pcread_RequestGIBValid;
logic                           pread_RequestFull;
seq_t                           pread_SeqNum;
s_feature_t 	[MAX_LOAD_WIDTH - 1 : 0]    data_bus;

//CtrlWrite
seq_t                           cb0_finishedSeq;
logic     [BANK_NUM - 1: 0]     cb_isFetchNextInst;
logic                           pwrite_setNextInst[BANK_NUM];

s_feature_t 	[COMPUTING_GROUP_SIZE-1:0]  pwrite_data[BANK_NUM];
logic 	  [BANK_NUM-1:0]        pwrite_enable;
mem_addr_t 	                    pwrite_addr[BANK_NUM];
logic                           ddr_write_ready;

seq_t                           pwrite_finishedSeq;
logic                           pwrite_isFetchNextInst;
logic                           pwrite_isWritable[BANK_NUM];

logic                           rama_write_enable;
logic                           ramb_write_enable;
mem_addr_t                      ram_write_addr;
ctrl_width_t                    ram_write_len;
s_feature_t  [BRAM_BUS_WIDTH - 1 : 0] outbuf;

//CtrlWeight
logic                           ddr_read_ready_w;
ddr_id_t                        weight_valid_id;
logic                           cb_isReadingWeights[BANK_NUM];
logic                           cb_isWeightFull[BANK_NUM];
seq_t                           cb_ReqWeight[BANK_NUM];
logic   	[WEIGHT_READ_WIDTH * 3 / 2 - 1 : 0][DDR_DATA_WIDTH-1:0]weight_data;

ddr_id_t                        weight_ddr_id;
logic 		                    pcweight_busValid;
seq_t 		                    pcweight_seq;
s_weight_t  	                w_bus[WEIGHT_READ_WIDTH];

//HCB
token_t 		                ptoken;
logic 		                    token_set[BANK_NUM];
token_t 		                max_token[BANK_NUM];

// DDR
ddr_id_t                        axi_rid;
mem_addr_t                      axi_raddr;
ddr_width_t                     axi_len;
logic                           read_request;
logic                           read_freeze;
ddr_id_t                        ddr_vid;
ubyte_t  [DDR_DATAWIDTH-1 : 0]  ddr_rdata;
logic                           ddr_isLast;

logic                           write_request;
ddr_id_t                        axi_wid;
mem_addr_t                      axi_waddr;
logic    [DDR_DATAWIDTH-1 : 0]  axi_wstrobe;
ubyte_t  [DDR_DATAWIDTH-1 : 0]  axi_wdata;

ddr_id_t                        w_axi_rid;
mem_addr_t                      w_axi_raddr;
ddr_width_t                     w_axi_len;
logic                           w_read_request;
logic                           w_read_freeze;
ddr_id_t                        w_ddr_vid;
ubyte_t  [PS_DDR_DATAWIDTH-1 : 0]  w_ddr_rdata;
logic                           w_ddr_isLast;

genvar geni;

Token token(.token(ptoken), .token_set(token_set[0]), .max_token(max_token[0]) ,.clock, .resetN);

generate
    for (geni=0; geni< BANK_NUM; geni = geni + 1) begin : hcb
        HCB #(.id(geni)) h
        (   .clock                                  , .resetN
            , .inst_enable(inst_enable[geni])       , .start(cb_start[geni])
            , .stop(cb_stop[geni])                  , .pwrite_isFetchNextInst
            , .inst(cb_inst[geni])                  , .pread_busValid
            , .pread_isFeature                      , .pread_seqNum(pread_SeqNum)
            , .dataBus(data_bus)                    , .pcweight_seq
            , .pcweight_busValid                    , .pcweight_dataBus(w_bus)
            , .pread_RequestFull                    , .ptoken
            , .pread_dataBus(data_bus)              , .pwrite_isWritable(pwrite_isWritable[geni])
            , .weights_almost_full(cb_isWeightFull[geni])   , .instfifo_full(cb_ibfull[geni])
            , .token_set(token_set[geni])           , .max_token(max_token[geni])
            , .pread_RequestValid(requestValid[geni])       , .pread_request(ritem[geni])
            , .pwrite_data(pwrite_data[geni])       , .pwrite_enable (pwrite_enable[geni])
            , .pwrite_addr(pwrite_addr[geni])       , .pwrite_setNextInst(pwrite_setNextInst[geni])
            , .isFetchNextInst(cb_isFetchNextInst[geni])       , .workingProgress(cb_WorkingProgress[geni])
            , .isRunning(cb_isRunning[geni])        , .isReadingFeatures(cb_isReadingFeatures[geni])
            , .reqFeature(cb_ReqFeature[geni])      , .finishedSeq(cb_FinishedSeq[geni])
            , .workingSeq(cb_WorkingSeq[geni])      , .isReadingWeights(cb_isReadingWeights[geni])
            , .reqWeight(cb_ReqWeight[geni])        , .isLoadingFroze(cb_isLoadingFroze[geni])
            , .isStopable(hcb_isStopable[geni])
         );
    end 
endgenerate 
/*
always_comb
begin
    for(int i = 0; i < WEIGHT_READ_WIDTH * 3 / 2; i++)
        weight_data[i] = read_data_weight[i];
end
*/
CtrlWeight ctrlweight(
      .clock                                , .resetN
    , .cwinst_enable(cwtinst_enable)
    , .cwinst(cwtinst)                      , .ddr_read_ready(ddr_read_ready_w)
    , .valid_id(weight_valid_id)            , .weight_ram_enable(ren_weight)
    , .weight_ddr_id(weight_ddr_id)
    , .weight_ram_addr(read_addr_weight)    , .weight_write_len(read_len_weight)
    , .weight_data                          , .wt_inst_fifo_full(cb_ibfull[BANK_NUM])       
    , .cb_isReadingWeights                  , .cb_isWeightFull
    , .cb_ReqWeight                         , .pcweight_busValid
    , .pcweight_seq                         , .w_bus
    , .isStopable(weight_isStopable)
);

always_comb
begin
    for(int i = 0; i < BRAM_BUS_WIDTH; i++)
        {write_data_data1[2 * i + 1], write_data_data1[2 * i]} = outbuf[i];
end

CtrlWrite ctrlwrite(
      .clock                                , .resetN
    , .ddr_write_enable(wen_data1)          , .ddr_write_addr(write_addr_data1)
    , .ddr_write_len(write_len_data1)       , .outbuf
    , .cb0_finishedSeq(cb_FinishedSeq[0])   , .cwinst_enable
    , .cwinst                               , .cb_isFetchNextInst
    , .pwrite_setNextInst                   , .ddr_write_ready
    , .pwrite_data                          , .pwrite_enable
    , .pwrite_addr                          , .pwrite_finishedSeq
    , .pwrite_isFetchNextInst               , .pwrite_isWritable
    , .rama_write_enable                    , .ramb_write_enable
    , .ram_write_addr                       , .ram_write_len
    , .isStopable(write_isStopable)
);
/*
always_comb
begin
    for(int i = 0; i < MAX_LOAD_WIDTH; i++)
        ddr_data[i] = {read_data_data1[2 * i + 1], read_data_data1[2 * i]};
end
*/
CtrlRead ctrlread(
      .clock                                , .resetN
    , .ddr_enable(ren_data1)                , .ddr_addr(read_addr_data1)
    , .ddr_len(read_len_data1)              , .ddr_data
    , .rd_inst_fifo_full(cb_ibfull[BANK_NUM+ 1])      , .crinst_enable
    , .crinst                               , .cb_isRunning
    , .cb_isReadingFeatures                 , .cb_isLoadingFroze
    , .cb_ReqFeature                        , .cb_FinishedSeq
    , .cb_WorkingSeq                        , .cb_WorkingProgress
    , .requestValid                         , .ritem
    , .reqGIBValid                          , .reqGIB
    , .ddr_read_ready                       , .ddr_data_id
    , .ramb_data                            , .rama_data
    , .ddr_id                               , .rama_ren
    , .ramb_ren                             , .ram_addr
    , .ram_len                              , .pread_waitForSeq
    , .pread_busValid                       , .pread_isFeature
    , .pcread_RequestGIBValid               , .pread_RequestFull
    , .pread_SeqNum                         , .data_bus
    , .isStopable(read_isStopable)
);

GIB gib(
      .clock                                , .resetN
    , .pif_AddOutput(add_output)            , .endInst_oAddr(add_output_address)
    , .endInst_oSize(add_output_size)       , .pcread_busValid(pread_busValid) 
    , .pcread_isFeature(pread_isFeature)    , .pread_dataBus(data_bus) 
    , .pcwrite_finishedSeq(pwrite_finishedSeq)    ,.rama_finishedSeq
    , .ramb_finishedSeq                     , .addressBuffer_empty
    , .addressBuffer_rdata                  , .pcread_RequestGIBValid
    , .cb_ibfull                            , .addressBuffer_ren
    , .reqGIBValid                          , .reqGIB
    , .cb_start                             , .cb_stop
    , .inst_enable                          , .cb_inst
    , .cwtinst_enable                       , .cwtinst
    , .crinst_enable                        , .crinst
    , .cwinst_enable                        , .cwinst
    , .read_isStopable                      , .write_isStopable
    , .weight_isStopable                    , .hcb_isStopable
);

fifo_addressBuffer fifo_data(
    .clk(clock), 		        .srst(~resetN), 
    .din(inst_address), 	    .wr_en(addrbuf_enable), 
    .rd_en(addressBuffer_ren), 	.dout(addressBuffer_rdata),
    .full(addressBuffer_full),	.empty(addressBuffer_empty)
);


if_test iftest(
      .clk(clock)              , .resetN
    , .buf_received
    , .buffer
    , .read_data_data
    , .add_output
    , .add_output_address
    , .add_output_size

    , .addrbuf_enable
    , .inst_address

    , .output_enable
    , .output_addr
    , .output_data
    , .output_len

    , .ren_data
    , .read_addr_data
    , .read_len_data

    , .wen_data
    , .write_addr_data
    , .write_len_data
    , .write_data_data

    , .wen_weight
    , .write_addr_weight
    , .write_len_weight
    , .write_data_weight
);

DDRReadAssist #(.cid(DDR_WEIGHT_ID), .DATAWIDTH(PS_DDR_DATAWIDTH)) weight_read_assist
(
      .clock                           , .resetN
    , .req_valid(ren_weight)           , .req_id(weight_ddr_id)
    , .req_addr(read_addr_weight)      , .req_len(read_len_weight)
    , .axi_ready(1'b1)
    
    , .ddr_vid(w_ddr_vid)              , .ddr_data(w_ddr_rdata)
    , .ddr_isLast(w_ddr_isLast)

    , .read_ready(ddr_read_ready_w)    , .valid_id(weight_valid_id)
    , .valid_data(weight_data)

    , .axi_rid(w_axi_rid)              , .axi_raddr(w_axi_raddr)
    , .axi_len(w_axi_len)              , .read_request(w_read_request)
    , .read_freeze(w_read_freeze)
);

DDR_delay DDR_weight (.clk(clock)       , .resetN
    , .axi_rid(w_axi_rid)              , .axi_raddr(w_axi_raddr)
    , .axi_len(w_axi_len)              , .read_request(w_read_request)
    , .read_freeze(w_read_freeze)      , .ddr_vid(w_ddr_vid)
    , .ddr_data(w_ddr_rdata)           , .ddr_isLast(w_ddr_isLast)

    , .wen(wen_weight)                 , .write_len(write_len_weight)
    , .write_addr(write_addr_weight)   , .write_data(write_data_weight)
);

DDRReadAssist #(.cid(DDR_FEATURE_ID), .DATAWIDTH(DDR_DATAWIDTH)) data_read_assist
(
      .clock                            , .resetN
    , .req_valid(ren_data1)             , .req_id(ddr_id)
    , .req_addr(read_addr_data1)        , .req_len(read_len_data1)
    , .axi_ready(1'b1)
    
    , .ddr_vid                          , .ddr_data(ddr_rdata)
    , .ddr_isLast

    , .read_ready(ddr_read_ready)       , .valid_id(ddr_data_id)
    , .valid_data(ddr_data)

    , .axi_rid                          , .axi_raddr
    , .axi_len                          , .read_request
    , .read_freeze
);

DDRWriteAssist #(.cid(DDR_FEATURE_ID)) data_write_assist
(
    .clock                              , .resetN
    , .req_valid(wen_data1)             , .req_addr(write_addr_data1)
    , .req_len(write_len_data1)         , .req_data(outbuf)
    , .axi_ready(1'b1)
    
    , .write_ready(ddr_write_ready)     , .write_request
    , .axi_wid                          , .axi_waddr
    , .axi_wstrobe                      , .axi_wdata
);
DDR     DDR_data (.clk(clock)           , .resetN
    , .axi_rid                          , .axi_raddr
    , .axi_len                          , .read_request
    , .read_freeze                      , .ddr_vid
    , .ddr_data(ddr_rdata)              , .ddr_isLast(ddr_isLast)
    , .write_request                    , .axi_waddr
    , .axi_wstrobe                      , .axi_wdata

    , .ren2(ren_data)                 , .read_len2(read_len_data)
    , .read_addr2(read_addr_data)     , .read_data2(read_data_data)
    , .wen2(wen_data)                 , .write_len2(write_len_data)
    , .write_addr2(write_addr_data)   , .write_data2(write_data_data)
);

endmodule

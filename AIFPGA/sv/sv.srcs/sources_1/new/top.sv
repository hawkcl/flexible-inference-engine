`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2019 12:17:37 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top
import definitions_pkg::*;
(
    //memory ports
    inout [31:0]                       ddr3_dq,
	inout [3:0]                        ddr3_dqs_n,
	inout [3:0]                        ddr3_dqs_p,
	output [14:0]                      ddr3_addr,
	output [2:0]                       ddr3_ba,
	output                             ddr3_ras_n,
	output                             ddr3_cas_n,
	output                             ddr3_we_n,
	output                             ddr3_reset_n,
	output [0:0]                       ddr3_ck_p,
	output [0:0]                       ddr3_ck_n,
	output [0:0]                       ddr3_cke,
	output [0:0]                       ddr3_cs_n,
	output [3:0]                       ddr3_dm,
	output [0:0]                       ddr3_odt,

    //PS
    inout [14:0]DDR_PS_addr,
  inout [2:0]DDR_PS_ba,
  inout DDR_PS_cas_n,
  inout DDR_PS_ck_n,
  inout DDR_PS_ck_p,
  inout DDR_PS_cke,
  inout DDR_PS_cs_n,
  inout [3:0]DDR_PS_dm,
  inout [31:0]DDR_PS_dq,
  inout [3:0]DDR_PS_dqs_n,
  inout [3:0]DDR_PS_dqs_p,
  inout DDR_PS_odt,
  inout DDR_PS_ras_n,
  inout DDR_PS_reset_n,
  inout DDR_PS_we_n,
  inout FIXED_IO_ddr_vrn,
  inout FIXED_IO_ddr_vrp,
  inout [53:0]FIXED_IO_mio,
  inout FIXED_IO_ps_clk,
  inout FIXED_IO_ps_porb,
  inout FIXED_IO_ps_srstb,

    // ethernet interface
    output      e_reset,
	output      e_mdc,
	inout       e_mdio,
	output[3:0] rgmii_txd,
	output      rgmii_txctl,
	output      rgmii_txc,
	input[3:0]  rgmii_rxd,
	input       rgmii_rxctl,
	input       rgmii_rxc,
`ifdef IN_SIMULATION
    output                          ui_clk,
    output                          ui_clk_sync_rst,    
	output                             arp_request,
`endif
	
	//Differential system clocks
	input                              sys_clk_p,
	input                              sys_clk_n,
	output [3:0]                        led,
    //output                  init_calib_complete,
	output                             fan_pwm,
	input                              sys_rst
    
    );
`ifndef IN_SIMULATION
    logic arp_request;
logic ui_clk;
logic ui_clk_sync_rst;
`endif
logic init_calib_complete;

logic clk_ps;

//read request
ddr_id_t                            axi2_rid;
mem_addr_t                          axi2_raddr;
ddr_width_t                         axi2_len;
logic                               read_request2;
logic                               read_freeze2;

logic                               axi2_rready;
ddr_id_t                            ddr_vid2;
ubyte_t  [DDR_DATAWIDTH-1 : 0]      ddr_data2;
logic                               ddr_isLast2;

//write request
logic                               write_request2;
mem_addr_t                          axi2_waddr;
logic    [DDR_DATAWIDTH-1 : 0]      axi2_wstrobe;
ubyte_t  [DDR_DATAWIDTH-1 : 0]      axi2_wdata;
logic                               axi2_wready;


//read request
ddr_id_t                            axi1_rid;
mem_addr_t                          axi1_raddr;
ddr_width_t                         axi1_len;
logic                               read_request1;
logic                               read_freeze1;

logic                               axi1_rready;
ddr_id_t                            ddr_vid1;
ubyte_t  [DDR_DATAWIDTH-1 : 0]      ddr_data1;
logic                               ddr_isLast1;

//write request
logic                               write_request1;
mem_addr_t                          axi1_waddr;
logic    [DDR_DATAWIDTH-1 : 0]      axi1_wstrobe;
ubyte_t  [DDR_DATAWIDTH-1 : 0]      axi1_wdata;
logic                               axi1_wready;

logic					rec_fifo_almost_full;
logic [(DDR_DATAWIDTH + 4)*8 : 0] 	rec_fifo_data;
logic					rec_fifo_en;
logic [(PS_DDR_DATAWIDTH + 4)*8 : 0] 	rec_fifo_data_weight;
logic					rec_fifo_en_weight;

//read request
ddr_id_t                            ps_axi_rid;
mem_addr_t                          ps_axi_raddr;
ddr_width_t                         ps_axi_len;
logic                               ps_read_request;
logic                               ps_read_freeze;

logic                               ps_axi_rready;
ddr_id_t                            ps_ddr_vid;
ubyte_t  [PS_DDR_DATAWIDTH-1 : 0]      ps_ddr_data;
logic                               ps_ddr_isLast;

//write request
logic                               ps_write_request;
mem_addr_t                          ps_axi_waddr;
logic    [PS_DDR_DATAWIDTH-1 : 0]      ps_axi_wstrobe;
ubyte_t  [PS_DDR_DATAWIDTH-1 : 0]      ps_axi_wdata;
logic                               ps_axi_wready;


    //send_fifo
logic [7:0]				send_fifo_cnt;
logic					send_fifo_flash;
logic                   send_fifo_empty;
logic					send_fifo_en;
//logic [(PS_DDR_DATAWIDTH)*8 - 1 : 0] 	send_fifo_data;
logic [(DDR_DATAWIDTH)*8 - 1 : 0] 	send_fifo_data;

logic                    net_clk;
logic                    ps_clk;
//logic                    ps_rst_n;
logic                    rec_fifo_almost_full_weight;

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
logic                           data_axi_ready;
logic   [DDR_ADDR_WIDTH-1:0]    read_addr_data1;
logic   [DDR_LEN_WIDTH-1 : 0]   read_len_data1;

logic                           wen_data1;
logic   [DDR_ADDR_WIDTH-1:0]    write_addr_data1;
logic   [DDR_LEN_WIDTH-1 : 0]   write_len_data1;
`ifdef IN_SIMULATION
logic   [DDR_DATA_WIDTH-1:0]    write_data_data1[DDR_LEN_SIZE]; // for simulation
`endif


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
logic   	[WEIGHT_READ_WIDTH  - 1 : 0][DDR_DATA_WIDTH-1:0]weight_data;

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
logic                           w_axi_ready;
logic                           resetN;
logic                           clock;
logic               led3;
(* MARK_DEBUG="true" *)logic    [31:0]                 iter;
logic                           started;
genvar geni;

assign fan_pwm = 1'b0;
//assign led[3] = init_calib_complete;
assign resetN = ~ui_clk_sync_rst;
assign clock = ui_clk;
assign led[3] = led3;
always @(posedge clock or negedge resetN)
begin
    if (~resetN)
        led3  <=  0;
    else begin
        if(|pwrite_enable)
            led3 <= 1;
    end
end

always @(posedge clock or negedge resetN)
begin
    if (~resetN)
        iter  <=  '0;
    else if(started)
        iter <= iter + 1;
end

always @(posedge clock or negedge resetN)
begin
    if (~resetN)
        started  <=  0;
    else if(cb_start[0])
        started <= 1;
end

Token token(
    .token(ptoken)                                  , .token_set(token_set[0]), 
    .max_token(max_token[0])                        , .clock, 
    .resetN);

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
    for(int i = 0; i < WEIGHT_READ_WIDTH; i++)
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

`ifdef IN_SIMULATION
always_comb
begin
    for(int i = 0; i < BRAM_BUS_WIDTH; i++)
        {write_data_data1[2 * i + 1], write_data_data1[2 * i]} = outbuf[i];
end
`endif

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
    .wr_clk(net_clk),
    .rd_clk(clock), 		        .rst(~resetN), 
    .din(inst_address), 	    .wr_en(addrbuf_enable), 
    .rd_en(addressBuffer_ren), 	.dout(addressBuffer_rdata),
    .full(addressBuffer_full),	.empty(addressBuffer_empty)
);



DDRReadAssist #(.cid(DDR_WEIGHT_ID), .DATAWIDTH(PS_DDR_DATAWIDTH)) weight_read_assist
(
      .clock                           , .resetN
    , .req_valid(ren_weight)           , .req_id(weight_ddr_id)
    , .req_addr(read_addr_weight)      , .req_len(read_len_weight)
    , .axi_ready(w_axi_ready)
    
    , .ddr_vid(w_ddr_vid)              , .ddr_data(w_ddr_rdata)
    , .ddr_isLast(w_ddr_isLast)

    , .read_ready(ddr_read_ready_w)    , .valid_id(weight_valid_id)
    , .valid_data(weight_data)

    , .axi_rid(w_axi_rid)              , .axi_raddr(w_axi_raddr)
    , .axi_len(w_axi_len)              , .read_request(w_read_request)
    , .read_freeze(w_read_freeze)
);

DDRReadAssist #(.cid(DDR_FEATURE_ID), .DATAWIDTH(DDR_DATAWIDTH)) data_read_assist
(
      .clock                            , .resetN
    , .req_valid(ren_data1)             , .req_id(ddr_id)
    , .req_addr(read_addr_data1)        , .req_len(read_len_data1)
    , .axi_ready(data_axi_ready)
    
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
    , .axi_ready(axi1_wready)
    
    , .write_ready(ddr_write_ready)     , .write_request
    , .axi_wid                          , .axi_waddr
    , .axi_wstrobe                      , .axi_wdata
);

/*
DDR_delay DDR_weight (.clk(clock)       , .resetN
    , .axi_rid(w_axi_rid)              , .axi_raddr(w_axi_raddr)
    , .axi_len(w_axi_len)              , .read_request(w_read_request)
    , .read_freeze(w_read_freeze)      , .ddr_vid(w_ddr_vid)
    , .ddr_data(w_ddr_rdata)           , .ddr_isLast(w_ddr_isLast)

    , .wen(wen_weight)                 , .write_len(write_len_weight)
    , .write_addr(write_addr_weight)   , .write_data(write_data_weight)
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
*/
assign axi1_rid = axi_rid;
assign axi1_raddr = axi_raddr;
assign axi1_len = axi_len;
assign read_request1 = read_request;
assign read_freeze1 = read_freeze;
assign ddr_rdata = ddr_data1;
assign ddr_vid = ddr_vid1;
assign ddr_isLast = ddr_isLast1;
assign data_axi_ready = axi1_rready;

assign write_request1 = write_request;
assign axi1_waddr = axi_waddr;
assign axi1_wstrobe = axi_wstrobe;
assign axi1_wdata = axi_wdata;

assign ps_axi_rid = w_axi_rid;
assign ps_axi_raddr = w_axi_raddr;
assign ps_axi_len = w_axi_len;
assign ps_read_request = w_read_request;
assign ps_read_freeze = w_read_freeze;
assign w_ddr_rdata = ps_ddr_data;
assign w_ddr_vid = ps_ddr_vid;
assign w_ddr_isLast = ps_ddr_isLast;
assign w_axi_ready = ps_axi_rready;
/*
reg[31:0] timer_cnt;
logic ledt;
assign led[1] = ledt;
always@(posedge ui_clk)
begin
    if(timer_cnt >= 32'd199_999_999)   //1 second counter, 200M-1=199999999
    begin
        ledt <= ~ledt;
        timer_cnt <= 32'd0;
    end
    else
    begin
        ledt <= ledt;
        timer_cnt <= timer_cnt + 32'd1;
    end
    
end
*/


ddr_recif #(.DATAWIDTH(DDR_DATAWIDTH)) recif
(
    .rst_n                          (~ui_clk_sync_rst),
    .ddr_clk                        (ui_clk),
    .if_clk                         (net_clk),

    //write request
    .write_request                  (write_request2),
    .axi_waddr                      (axi2_waddr),
    .axi_wstrobe                    (axi2_wstrobe),
    .axi_wdata                      (axi2_wdata),
    .axi_wready                     (axi2_wready),

    //rec_fifo
    .rec_fifo_almost_full,
    .rec_fifo_data,
    .rec_fifo_en
);

ps_ddr_recif #(.DATAWIDTH(PS_DDR_DATAWIDTH)) ps_recif
(
    .rst_n                          (~ui_clk_sync_rst),
    .ddr_clk                        (ui_clk),
    .if_clk                         (net_clk),

    //write request
    .write_request                  (ps_write_request),
    .axi_waddr                      (ps_axi_waddr),
    .axi_wstrobe                    (ps_axi_wstrobe),
    .axi_wdata                      (ps_axi_wdata),
    .axi_wready                     (ps_axi_wready),

    //rec_fifo
    .rec_fifo_almost_full_weight,
    .rec_fifo_data_weight,
    .rec_fifo_en_weight
);
ddr_sendif sendif
(
    .rst_n                          (~ui_clk_sync_rst),
    .ddr_clk                        (ui_clk),
    .if_clk                         (net_clk),
    .ui_clk                         (ui_clk),

  //read request
    .axi_rid                        (axi2_rid),
    .axi_raddr                      (axi2_raddr),
    .axi_len                        (axi2_len),
    .read_request                   (read_request2),
    .read_freeze                    (read_freeze2),

    .axi_rready                     (axi2_rready),
    .ddr_vid                        (ddr_vid2),
    .ddr_data                       (ddr_data2),
    .ddr_isLast                     (ddr_isLast2),

    //send_fifo
    .send_fifo_cnt,
    .send_fifo_flash,
    .send_fifo_empty,
    .send_fifo_en,
    .send_fifo_data,

    .start_send                     (add_output),
    .send_addr                      (add_output_address),
    .send_len                       (add_output_size)
);

ethernet_top #(.SEND_DATAWIDTH(DDR_DATAWIDTH)) etop
//ethernet_top_test etop
(
    .sys_clk                        (ui_clk),
    .rst_n                          (~ui_clk_sync_rst),
    .led                            (led[2:0]),
    .init_calib_complete,
    .addrbuf_enable,
    .inst_address,
  
    //read request
    .rec_fifo_almost_full               (rec_fifo_almost_full),
    .rec_fifo_data                      (rec_fifo_data),
    .rec_fifo_en                        (rec_fifo_en),
    .rec_fifo_data_weight,
    .rec_fifo_en_weight,

    //write request
    .send_fifo_cnt                  (send_fifo_cnt),
    .send_fifo_flash                      (send_fifo_flash),
    .send_fifo_empty,
    .send_fifo_en                    (send_fifo_en),
    .send_fifo_data                      (send_fifo_data),

    .gmii_tx_clk                    (net_clk),
    .arp_request,

    // ethernet interface
    .e_reset,
	.e_mdc,
	.e_mdio,
	.rgmii_txd,
	.rgmii_txctl,
	.rgmii_txc,
	.rgmii_rxd,
	.rgmii_rxctl,
	.rgmii_rxc
);

ddrtop mtop
(
    .ddr3_dq,
	.ddr3_dqs_n,
	.ddr3_dqs_p,
	.ddr3_addr,
	.ddr3_ba,
	.ddr3_ras_n,
	.ddr3_cas_n,
	.ddr3_we_n,
	.ddr3_reset_n,
	.ddr3_ck_p,
	.ddr3_ck_n,
	.ddr3_cke,
	.ddr3_cs_n,
	.ddr3_dm,
	.ddr3_odt,

    .ps_clk,
    //.ps_rst_n,
    .DDR_PS_addr,
    .DDR_PS_ba,
    .DDR_PS_cas_n,
    .DDR_PS_ck_n,
    .DDR_PS_ck_p,
    .DDR_PS_cke,
    .DDR_PS_cs_n,
    .DDR_PS_dm,
    .DDR_PS_dq,
    .DDR_PS_dqs_n,
    .DDR_PS_dqs_p,
    .DDR_PS_odt,
    .DDR_PS_ras_n,
    .DDR_PS_reset_n,
    .DDR_PS_we_n,
    .FIXED_IO_ddr_vrn,
    .FIXED_IO_ddr_vrp,
    .FIXED_IO_mio,
    .FIXED_IO_ps_clk,
    .FIXED_IO_ps_porb,
    .FIXED_IO_ps_srstb,
    //read request
    .ps_axi_rid,
    .ps_axi_raddr,
    .ps_axi_len,
    .ps_read_request,
    .ps_read_freeze,

    .ps_axi_rready,
    .ps_ddr_vid,
    .ps_ddr_data,
    .ps_ddr_isLast,

    //write request
    .ps_write_request,
    .ps_axi_waddr,
    .ps_axi_wstrobe,
    .ps_axi_wdata,
    .ps_axi_wready,

    //read request
    .axi2_rid,
    .axi2_raddr,
    .axi2_len,
    .read_request2,
    .read_freeze2,

    .axi2_rready,
    .ddr_vid2,
    .ddr_data2,
    .ddr_isLast2,

    //write request
    .write_request2,
    .axi2_waddr,
    .axi2_wstrobe,
    .axi2_wdata,
    .axi2_wready,
	
    
    //read request
    .axi1_rid,
    .axi1_raddr,
    .axi1_len,
    .read_request1,
    .read_freeze1,

    .axi1_rready,
    .ddr_vid1,
    .ddr_data1,
    .ddr_isLast1,

    //write request
    .write_request1,
    .axi1_waddr,
    .axi1_wstrobe,
    .axi1_wdata,
    .axi1_wready,
	
	//Differential system clocks
	.sys_clk_p,
	.sys_clk_n,
    .init_calib_complete,
	.sys_rst,
    .ui_clk,
    .ui_clk_sync_rst
);
  
endmodule

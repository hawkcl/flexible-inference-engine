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


module rv_top
import definitions_pkg::*;
(
   
    input logic                             ui_clk,
	input logic                             aresetn,
	
    input logic                             addrbuf_enable,
    input mem_addr_t                        inst_address,

    output logic                            add_output,
    output logic   [DDR_ADDR_WIDTH-1:0]     add_output_address,
    output logic   [DDR_ADDR_WIDTH-1:0]     add_output_size,

    //axi0
    output logic [C_M_AXI_ID_WIDTH-1 : 0]   s_axi0_awid,
    output logic [AXI4_ADDR_WIDTH-1:0]      s_axi0_awaddr,
    output logic [AXI4_LEN_WIDTH-1:0]       s_axi0_awlen,
    output logic [AXI4_SIZE_WIDTH-1:0]      s_axi0_awsize,
    output logic [1:0]                      s_axi0_awburst,
    output logic [0:0]                      s_axi0_awlock,
    output logic [3:0]                      s_axi0_awcache,
    output logic [2:0]                      s_axi0_awprot,
    output logic [3:0]                      s_axi0_awqos,
    output logic                            s_axi0_awvalid,
    input  logic                            s_axi0_awready,
    output logic [DDR_DATAWIDTH*8 - 1:0]    s_axi0_wdata,
    output logic [DDR_DATAWIDTH - 1:0]      s_axi0_wstrb,
    output logic                            s_axi0_wlast,
    output logic                            s_axi0_wvalid,
    input  logic                            s_axi0_wready,
    output logic                            s_axi0_bready,
    input  logic [1:0]                      s_axi0_bresp,
    input  logic                            s_axi0_bvalid,
    output logic [C_M_AXI_ID_WIDTH-1 : 0]   s_axi0_arid,
    output logic [AXI4_ADDR_WIDTH-1:0]      s_axi0_araddr,
    output logic [AXI4_LEN_WIDTH-1:0]       s_axi0_arlen,
    output logic [AXI4_SIZE_WIDTH-1:0]      s_axi0_arsize,
    output logic [1:0]                      s_axi0_arburst,
    output logic [0:0]                      s_axi0_arlock,
    output logic [3:0]                      s_axi0_arcache,
    output logic [2:0]                      s_axi0_arprot,
    output logic [3:0]                      s_axi0_arqos,
    output logic                            s_axi0_arvalid,
    input  logic                            s_axi0_arready,
    output logic                            s_axi0_rready,
    input  logic [DDR_DATAWIDTH*8 - 1:0]    s_axi0_rdata,
    input  logic [1:0]                      s_axi0_rresp,
    input  logic                            s_axi0_rlast,
    input  logic                            s_axi0_rvalid,
    output logic [3:0]                      s_axi0_arregion,
    output logic [3:0]                      s_axi0_awregion,

    //ps_axi
    output logic [C_M_AXI_ID_WIDTH-1 : 0]   ps_axi_awid,
    output logic [AXI4_ADDR_WIDTH-1:0]      ps_axi_awaddr,
    output logic [AXI4_LEN_WIDTH-1:0]       ps_axi_awlen,
    output logic [AXI4_SIZE_WIDTH-1:0]      ps_axi_awsize,
    output logic [1:0]                      ps_axi_awburst,
    output logic [0:0]                      ps_axi_awlock,
    output logic [3:0]                      ps_axi_awcache,
    output logic [2:0]                      ps_axi_awprot,
    output logic [3:0]                      ps_axi_awqos,
    output logic                            ps_axi_awvalid,
    input  logic                            ps_axi_awready,
    output logic [DDR_DATAWIDTH*8 - 1:0]    ps_axi_wdata,
    output logic [DDR_DATAWIDTH - 1:0]      ps_axi_wstrb,
    output logic                            ps_axi_wlast,
    output logic                            ps_axi_wvalid,
    input  logic                            ps_axi_wready,
    output logic                            ps_axi_bready,
    input  logic [1:0]                      ps_axi_bresp,
    input  logic                            ps_axi_bvalid,
    output logic [C_M_AXI_ID_WIDTH-1 : 0]   ps_axi_arid,
    output logic [AXI4_ADDR_WIDTH-1:0]      ps_axi_araddr,
    output logic [AXI4_LEN_WIDTH-1:0]       ps_axi_arlen,
    output logic [AXI4_SIZE_WIDTH-1:0]      ps_axi_arsize,
    output logic [1:0]                      ps_axi_arburst,
    output logic [0:0]                      ps_axi_arlock,
    output logic [3:0]                      ps_axi_arcache,
    output logic [2:0]                      ps_axi_arprot,
    output logic [3:0]                      ps_axi_arqos,
    output logic                            ps_axi_arvalid,
    input  logic                            ps_axi_arready,
    output logic                            ps_axi_rready,
    input  logic [DDR_DATAWIDTH*8 - 1:0]    ps_axi_rdata,
    input  logic [1:0]                      ps_axi_rresp,
    input  logic                            ps_axi_rlast,
    input  logic                            ps_axi_rvalid,
    output logic [3:0]                      ps_axi_arregion,
    output logic [3:0]                      ps_axi_awregion
    
    );

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

//read request
ddr_id_t                            wt_axi_rid;
mem_addr_t                          wt_axi_raddr;
ddr_width_t                         wt_axi_len;
logic                               wt_read_request;
logic                               wt_read_freeze;

logic                               wt_axi_rready;
ddr_id_t                            wt_ddr_vid;
ubyte_t  [PS_DDR_DATAWIDTH-1 : 0]      wt_ddr_data;
logic                               wt_ddr_isLast;

//write request
logic                               wt_write_request;
mem_addr_t                          wt_axi_waddr;
logic    [PS_DDR_DATAWIDTH-1 : 0]      wt_axi_wstrobe;
ubyte_t  [PS_DDR_DATAWIDTH-1 : 0]      wt_axi_wdata;
logic                               wt_axi_wready;

logic                    net_clk;



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
(* MARK_DEBUG="true" *)logic    [31:0]                 iter;
logic                           started;
genvar geni;

assign resetN = aresetn;
assign clock = ui_clk;
assign wt_write_request = 0;
assign wt_axi_waddr = '0;
assign wt_axi_wstrobe = '0;
assign wt_axi_wdata = '0;

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
assign net_clk = clock;
fifo_addressBuffer fifo_data(
    .wr_clk(net_clk),
    .rd_clk(clock), 		        .rst(~resetN), 
    .din(inst_address), 	        .wr_en(addrbuf_enable), 
    .rd_en(addressBuffer_ren), 	    .dout(addressBuffer_rdata),
    .full(addressBuffer_full),	    .empty(addressBuffer_empty)
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

assign wt_axi_rid = w_axi_rid;
assign wt_axi_raddr = w_axi_raddr;
assign wt_axi_len = w_axi_len;
assign wt_read_request = w_read_request;
assign wt_read_freeze = w_read_freeze;
assign w_ddr_rdata = wt_ddr_data;
assign w_ddr_vid = wt_ddr_vid;
assign w_ddr_isLast = wt_ddr_isLast;
assign w_axi_ready = wt_axi_rready;
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


rv_axi4 axi4_convert
(
    .wt_axi_rid,
    .wt_axi_raddr,
    .wt_axi_len,
    .wt_read_request,
    .wt_read_freeze,

    .wt_axi_rready,
    .wt_ddr_vid,
    .wt_ddr_data,
    .wt_ddr_isLast,

    //write request
    .wt_write_request,
    .wt_axi_waddr,
    .wt_axi_wstrobe,
    .wt_axi_wdata,
    .wt_axi_wready,

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

     //axi0
    .s_axi0_awid,
    .s_axi0_awaddr,
    .s_axi0_awlen,
    .s_axi0_awsize,
    .s_axi0_awburst,
    .s_axi0_awlock,
    .s_axi0_awcache,
    .s_axi0_awprot,
    .s_axi0_awqos,
    .s_axi0_awvalid,
    .s_axi0_awready,
    .s_axi0_wdata,
    .s_axi0_wstrb,
    .s_axi0_wlast,
    .s_axi0_wvalid,
    .s_axi0_wready,
    .s_axi0_bready,
    .s_axi0_bresp,
    .s_axi0_bvalid,
    .s_axi0_arid,
    .s_axi0_araddr,
    .s_axi0_arlen,
    .s_axi0_arsize,
    .s_axi0_arburst,
    .s_axi0_arlock,
    .s_axi0_arcache,
    .s_axi0_arprot,
    .s_axi0_arqos,
    .s_axi0_arvalid,
    .s_axi0_arready,
    .s_axi0_rready,
    .s_axi0_rdata,
    .s_axi0_rresp,
    .s_axi0_rlast,
    .s_axi0_rvalid,
    .s_axi0_arregion,
    .s_axi0_awregion,

    //ps_axi
    .ps_axi_awid,
    .ps_axi_awaddr,
    .ps_axi_awlen,
    .ps_axi_awsize,
    .ps_axi_awburst,
    .ps_axi_awlock,
    .ps_axi_awcache,
    .ps_axi_awprot,
    .ps_axi_awqos,
    .ps_axi_awvalid,
    .ps_axi_awready,
    .ps_axi_wdata,
    .ps_axi_wstrb,
    .ps_axi_wlast,
    .ps_axi_wvalid,
    .ps_axi_wready,
    .ps_axi_bready,
    .ps_axi_bresp,
    .ps_axi_bvalid,
    .ps_axi_arid,
    .ps_axi_araddr,
    .ps_axi_arlen,
    .ps_axi_arsize,
    .ps_axi_arburst,
    .ps_axi_arlock,
    .ps_axi_arcache,
    .ps_axi_arprot,
    .ps_axi_arqos,
    .ps_axi_arvalid,
    .ps_axi_arready,
    .ps_axi_rready,
    .ps_axi_rdata,
    .ps_axi_rresp,
    .ps_axi_rlast,
    .ps_axi_rvalid,
    .ps_axi_arregion,
    .ps_axi_awregion,
	
	//system clocks
    .ui_clk,
    .aresetn
);
  
endmodule

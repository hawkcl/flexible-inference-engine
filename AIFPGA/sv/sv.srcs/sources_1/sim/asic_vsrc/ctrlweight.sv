//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 05:53:43
// Design Name: 
// Module Name: weightFifo
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

module CtrlWeight
import definitions_pkg::*;
(
    input logic 		clock, resetN,
    input logic 		cwinst_enable,
    input InstructionWeight 	cwinst,
    input logic         ddr_read_ready,
    input ddr_id_t      valid_id,
    input s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0]weight_data,
    input logic         cb_isReadingWeights[BANK_NUM],
    input logic         cb_isWeightFull[BANK_NUM],
    input seq_t         cb_ReqWeight[BANK_NUM],


    output logic        weight_ram_enable,
    output ddr_id_t     weight_ddr_id,
    output mem_addr_t   weight_ram_addr,
    output logic   [DDR_LEN_WIDTH-1 : 0]    weight_write_len,
    output logic 		pcweight_busValid,
    output seq_t 		pcweight_seq,
    output logic        wt_inst_fifo_full,
    output logic        isStopable,
    output s_weight_t  	w_bus[WEIGHT_READ_WIDTH]
);
parameter 		CWINST_BITS = $bits(InstructionWeight);
logic           fifo_srst;
logic 			isReadRam;
logic 			isWriteRam;
logic 			hasMoreData, hasMoreData_next;
logic 			readMoreData, readMoreData_next;
data_fifo_t     liveCount;
DATA_MODE 		mode;
mem_addr_t 		Oaddr;
seq_t 			seqNum;
logic unsigned [1:0] 	dropSize;
logic unsigned [2:0] 	cnt;
ctrl_width_t 	dataWidth;
ctrl_width_t 	pos;
mem_addr_t 		nextReadAddr, nextReadAddr_next;
mem_addr_t 		nextReceiveAddr, nextReceiveAddr_next;
mem_addr_t 		nextReadAddr_bram, nextReadAddr_bram_next;
mem_addr_t 		nextReceiveAddr_bram, nextReceiveAddr_bram_next;
mem_addr_t 		lastAddr;
logic unsigned [1:0] 	dataIdx, dataIdx_next;
logic           saved_enable;
logic           read_mem;
logic           read_input;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0] mem_data;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0] saveData;
logic           push_all;
logic [BANK_NUM - 1:0]    skip_hcb;
logic           do_skip;
logic           data_valid;

logic			inst_fifo_ren;
logic 			inst_fifo_empty;
logic 			inst_fifo_full;
InstructionWeight   inst;

logic 			input_data_fifo_ren;
logic 			input_data_fifo_wen;
logic 			input_data_fifo_empty;
logic 			input_data_fifo_full;
logic 			input_data_fifo_progfull;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0] input_data_fifo_wdata;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0] input_data_fifo_rdata;

logic 			data_fifo_ren;
logic 			data_fifo_wen;
logic 			data_fifo_empty;
logic 			data_fifo_full;
logic 			data_fifo_progfull;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0] data_fifo_wdata;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0] data_fifo_rdata;

logic           weight_mem_ren, weight_mem_ren_ff;
logic           weight_mem_wen;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0] weight_mem_wdata;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0] weight_mem_rdata;
mem_addr_t      weight_mem_raddr;
mem_addr_t      weight_mem_waddr;

assign isStopable = inst_fifo_empty && (~hasMoreData);
assign weight_ddr_id = DDR_DATA_ID;
assign data_valid = (valid_id == DDR_DATA_ID);
assign wt_inst_fifo_full = inst_fifo_full;
assign pcweight_seq = seqNum;
assign weight_write_len = WEIGHT_READ_WIDTH;
assign fifo_srst = ~resetN;
assign inst_fifo_ren = ~hasMoreData && (liveCount <= dropSize) && (mode == MODE_FOUR || dataIdx == 0) 
                    && ~inst_fifo_empty && data_fifo_empty;

assign saved_enable = mode != MODE_FOUR && dataIdx != 0;
assign read_mem = (isReadRam || ddr_read_ready) && ((liveCount + cnt) <= MAX_CTRL_BUF_SIZE) && readMoreData;
assign read_input = ~saved_enable && ~input_data_fifo_empty;

assign weight_ram_enable = read_mem && ~isReadRam;
assign weight_ram_addr = Oaddr + nextReadAddr;
assign mem_data = input_data_fifo_rdata;
assign push_all = mode == MODE_FOUR || !hasMoreData_next && dropSize == 1;

always_ff @(posedge clock)
if (!resetN)
    weight_mem_ren_ff <= '0;
else
    weight_mem_ren_ff <= weight_mem_ren;

always_ff @(posedge clock)
if (!resetN)
    {isReadRam, isWriteRam, mode, Oaddr, seqNum, dropSize, lastAddr} <= '0;
else if(inst_fifo_ren) 
begin
    isReadRam <= inst.isReadRam;
    isWriteRam <= inst.isWriteRam;
    mode <= inst.mode;
    Oaddr <= inst.Oaddr;
    seqNum <= inst.seqNum;
    dropSize <= inst.dropSize;
    lastAddr <= inst.size;
end

always_ff @(posedge clock)
if (!resetN || inst_fifo_ren)
    {nextReadAddr, nextReadAddr_bram, nextReceiveAddr, nextReceiveAddr_bram} <= '0;
else begin
    nextReadAddr <= nextReadAddr_next;
    nextReadAddr_bram <= nextReadAddr_bram_next;
    nextReceiveAddr <= nextReceiveAddr_next;
    nextReceiveAddr_bram <= nextReceiveAddr_bram_next;
end

always_comb
begin
    if(read_mem) begin
        nextReadAddr_next = nextReadAddr + WEIGHT_READ_WIDTH ;
        nextReadAddr_bram_next = nextReadAddr_bram + 1;
    end
    else begin
        nextReadAddr_next = nextReadAddr;
        nextReadAddr_bram_next = nextReadAddr_bram;
    end
end

always_comb
begin
    if(read_input) begin
        nextReceiveAddr_next = nextReceiveAddr + WEIGHT_READ_WIDTH ;
        nextReceiveAddr_bram_next = nextReceiveAddr_bram + 1;
    end
    else begin
        nextReceiveAddr_next = nextReceiveAddr;
        nextReceiveAddr_bram_next = nextReceiveAddr_bram;
    end
end

always_ff @(posedge clock)
    if (!resetN)
        {hasMoreData, readMoreData} <= '0;
    else if(inst_fifo_ren) 
        {hasMoreData, readMoreData} <= 2'b11;
    else
        {hasMoreData, readMoreData} <= {hasMoreData_next, readMoreData_next};
always_comb
    if(read_mem && nextReadAddr_next >= lastAddr)
        readMoreData_next = 1'b0;
    else
        readMoreData_next = readMoreData;

always_comb
    if(read_input && nextReceiveAddr_next >= lastAddr)
        hasMoreData_next = 1'b0;
    else
        hasMoreData_next = hasMoreData;


always_comb
begin
    if (mode == MODE_FOUR) begin
			dataWidth = WEIGHT_DATA_WIDTH * 4;
			pos = 0;
            cnt = 1;
	end
	else if (mode == MODE_TWO) begin
			dataWidth = WEIGHT_DATA_WIDTH * 2;
			pos = WEIGHT_DATA_WIDTH * 2;
            cnt = 2;
	end
	else begin
			dataWidth = WEIGHT_DATA_WIDTH;
			pos = WEIGHT_DATA_WIDTH * dataIdx;
            cnt = 4;
	end
end

always_ff @(posedge clock)
    if (!resetN || inst_fifo_ren)
        liveCount <= '0;
    else
        liveCount <= liveCount + (read_mem?cnt:0) - (data_fifo_ren?1:0);

always_ff @(posedge clock)
    if (!resetN)
        dataIdx <= '0;
    else
        dataIdx <= dataIdx_next;
always_comb
begin
    dataIdx_next = dataIdx;
    if (saved_enable) begin
        if (mode == MODE_TWO || dataIdx == 3 || (!hasMoreData && dataIdx + 1 == dropSize))
            dataIdx_next = '0;
        else
            dataIdx_next = dataIdx + 1;
    end
    else if(read_input) begin
        if(~push_all)
            dataIdx_next = 1;
    end
end

always_ff @(posedge clock)
if(read_input && !push_all)
    saveData = mem_data;

//weight data fifo
always_comb
begin
    data_fifo_wen = 1'b0;
    data_fifo_wdata = '0;
    if(saved_enable) begin
        data_fifo_wen = 1'b1;
        for(int i = 0; i < WEIGHT_READ_WIDTH; i++)
        if(i < dataWidth)
            data_fifo_wdata[i] = saveData[pos + i];
        else
            data_fifo_wdata[i] = 0;
    end
    else if(read_input) begin
        data_fifo_wen = 1'b1;
        data_fifo_wdata = mem_data;
    end
end

always_comb
begin
    for(int i =0; i < BANK_NUM; i++)
        skip_hcb[i] = (cb_isReadingWeights[i] && (cb_ReqWeight[i] == seqNum) && cb_isWeightFull[i]) || (cb_ReqWeight[i] < seqNum);
end
assign do_skip = | skip_hcb;
assign pcweight_busValid = ~do_skip && ~data_fifo_empty;
assign data_fifo_ren = pcweight_busValid;
always_comb
begin
    for(int i =0; i < WEIGHT_READ_WIDTH; i++)
        w_bus[i] = data_fifo_rdata[i];
end 

assign input_data_fifo_wen = weight_mem_ren_ff | data_valid;
assign input_data_fifo_wdata = data_valid ? weight_data : weight_mem_rdata;
assign input_data_fifo_ren = read_input;

fifo_ctrlweight_data fifo_input_data(
	    .clk(clock), 		    .srst(fifo_srst), 
	    .din(input_data_fifo_wdata), 	.wr_en(input_data_fifo_wen), 
	    .rd_en(input_data_fifo_ren), 	.dout(input_data_fifo_rdata),
        .full(input_data_fifo_full),	.empty(input_data_fifo_empty),
	    .prog_full(input_data_fifo_progfull));

fifo_ctrlweight_data fifo_data(
	    .clk(clock), 		    .srst(fifo_srst), 
	    .din(data_fifo_wdata), 	.wr_en(data_fifo_wen), 
	    .rd_en(data_fifo_ren), 	.dout(data_fifo_rdata),
        .full(data_fifo_full),	.empty(data_fifo_empty),
	    .prog_full(data_fifo_progfull));

// weight block ram
assign weight_mem_ren       = read_mem && isReadRam;
assign weight_mem_raddr     = nextReadAddr_bram;
assign weight_mem_wen       = read_input && isWriteRam;
assign weight_mem_waddr     = nextReceiveAddr_bram;
assign weight_mem_wdata     = mem_data;
ctrlweight_mem inputs (
	    .clka(clock), 		        .ena(1'b1), 
	    .wea(weight_mem_wen), 		.addra(weight_mem_waddr[WEIGHT_ADDR_WIDTH - 1 :0]), 
	    .dina(weight_mem_wdata), 	.clkb(clock), 
	    .enb(weight_mem_ren), 		
        .addrb(weight_mem_raddr[WEIGHT_ADDR_WIDTH-1:0]), .doutb(weight_mem_rdata));

//weight inst fifo
fifo_InstructionWeight fifo_wcinst(
	    .clk(clock)	, 		.srst(fifo_srst), 
	    .din(cwinst), 		.wr_en(cwinst_enable), 
	    .rd_en(inst_fifo_ren), 	.dout(inst), 
	    .full(inst_fifo_full), 	.empty(inst_fifo_empty));


endmodule

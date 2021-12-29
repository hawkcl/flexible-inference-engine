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

module CtrlWrite
import definitions_pkg::*;
(
    input logic 		clock, resetN,
    input logic 		cwinst_enable,
    input InstructionWrite 	cwinst,
    input seq_t         cb0_finishedSeq,
    input logic         [BANK_NUM - 1: 0]cb_isFetchNextInst,
    input logic         pwrite_setNextInst[BANK_NUM],
    input logic         ddr_write_ready,

    input s_feature_t 	[COMPUTING_GROUP_SIZE-1:0] pwrite_data[BANK_NUM],
    input logic 		[BANK_NUM-1:0] pwrite_enable,
    input mem_addr_t 	pwrite_addr[BANK_NUM],

    output seq_t        pwrite_finishedSeq,
    output logic        pwrite_isFetchNextInst,
    output logic        pwrite_isWritable[BANK_NUM],

    output logic        ddr_write_enable,
    output mem_addr_t   ddr_write_addr,
    output logic   [DDR_LEN_WIDTH-1 : 0]    ddr_write_len,
    output logic        rama_write_enable,
    output logic        ramb_write_enable,
    output mem_addr_t   ram_write_addr,
    output ctrl_width_t    ram_write_len,
    output logic        isStopable,
    output s_feature_t  [BRAM_BUS_WIDTH - 1 : 0] outbuf
);
parameter 		CWINST_BITS = $bits(InstructionWrite);
genvar          geni;
logic           fifo_srst;
logic           [BANK_NUM - 1: 0]nextInst;
DATA_MODE 	    mode;
logic           isWriteA;
logic           isWriteB;
width_t         dataWidth;
width_t         dataWidth2;
mem_addr_t      Oaddr;
logic           isUpsample;
pad_t           maxpool_size;
pad_t           maxpool_stride;
width_t         H1_last;
width_t         pool_width_01;
width_t         pool_width_23;
seq_t           finishedSeq;
logic           setFinishedSeq;
logic           output_enable;
logic unsigned [1:0] 	idx, idx_next;
width_t         curH01, curH01_next;
width_t         curH23, curH23_next;
logic           pool_flush_01, pool_flush_01_next;
logic           pool_flush_23, pool_flush_23_next;
mem_addr_t      addr_pool_01, addr_pool_01_next;
mem_addr_t      addr_pool_23, addr_pool_23_next;
s_feature_t     pool_max_01[COMPUTING_GROUP_SIZE * 2];
s_feature_t     pool_max_01_next[COMPUTING_GROUP_SIZE * 2];
s_feature_t     pool_max_23[COMPUTING_GROUP_SIZE * 2];
s_feature_t     pool_max_23_next[COMPUTING_GROUP_SIZE * 2];
mem_addr_t      addr;
ctrl_width_t    len;

logic			inst_fifo_ren;
logic 			inst_fifo_empty;
logic 			inst_fifo_full;
InstructionWrite   inst;

logic 			addr_fifo_ren[BANK_NUM];
logic 			addr_fifo_wen[BANK_NUM];
logic 			addr_fifo_empty[BANK_NUM];
logic 			addr_fifo_full[BANK_NUM];
mem_addr_t      addr_fifo_wdata[BANK_NUM];
mem_addr_t  	addr_fifo_rdata[BANK_NUM];

logic 			data_fifo_ren[BANK_NUM];
logic 			data_fifo_wen[BANK_NUM];
logic 			[BANK_NUM - 1: 0]data_fifo_empty;
logic 			data_fifo_full[BANK_NUM];
s_feature_t  	[COMPUTING_GROUP_SIZE - 1 : 0] data_fifo_wdata[BANK_NUM];
s_feature_t  	[COMPUTING_GROUP_SIZE - 1 : 0] data_fifo_rdata[BANK_NUM];
logic           do_produce_outputs;

assign isStopable = inst_fifo_empty;
assign do_produce_outputs = isWriteA || isWriteB || ddr_write_ready;
assign rama_write_enable = output_enable && isWriteA;
assign ramb_write_enable = output_enable && !isWriteA && isWriteB;
assign ddr_write_enable  = output_enable && !isWriteA && !isWriteB;
assign ddr_write_addr = Oaddr + addr * FEATURE_BYTE_SIZE; 
assign ddr_write_len  = len * FEATURE_BYTE_SIZE;
assign ram_write_addr = Oaddr + addr;
assign ram_write_len  = len;
//assign setFinishedSeq = output_enable && !(|pwrite_enable) && (&data_fifo_empty);
assign setFinishedSeq = !(|pwrite_enable) && (&data_fifo_empty);
assign pwrite_finishedSeq = finishedSeq;
assign fifo_srst = ~resetN;
assign inst_fifo_ren = (&nextInst) && (&data_fifo_empty) && ~inst_fifo_empty && (~pool_flush_01) && (~pool_flush_23);
assign pwrite_isFetchNextInst = &cb_isFetchNextInst;

always_ff @(posedge clock)
if (!resetN) 
    finishedSeq <= '0;
else if(setFinishedSeq)
    finishedSeq <= cb0_finishedSeq;

always_ff @(posedge clock)
if (!resetN) begin
    {curH01, curH23, pool_flush_01, pool_flush_23, idx} <= '0;
    {addr_pool_01, addr_pool_23} <= '0;
    pool_max_01   <= '{default:0};
    pool_max_23   <= '{default:0};
end
else begin
    idx    <= idx_next;
    curH01 <= curH01_next;
    curH23 <= curH23_next;
    pool_flush_01 <= pool_flush_01_next;
    pool_flush_23 <= pool_flush_23_next;
    addr_pool_01  <= addr_pool_01_next;
    addr_pool_23  <= addr_pool_23_next;
    pool_max_01   <= pool_max_01_next;
    pool_max_23   <= pool_max_23_next;
end

always_comb
begin
    curH01_next = curH01;
    curH23_next = curH23;
    if(inst_fifo_ren) begin
        curH01_next = 0;
        curH23_next = 0;
    end
    else if (do_produce_outputs && maxpool_size == 2 && !pool_flush_01 && !pool_flush_23 && 
        !data_fifo_empty[idx] && !data_fifo_empty[idx + 1] ) 
    begin
        if (idx == 0) begin
            if (curH01 == H1_last)
                curH01_next = 0;
            else
                curH01_next = curH01 + 1;
        end
        else begin
            if (curH23 == H1_last)
                curH23_next = 0;
            else
                curH23_next = curH23 + 1;
        end
    end
        
end

always_ff @(posedge clock)
if (!resetN) 
    nextInst <= '1;
else if(inst_fifo_ren)
    nextInst <= '0;
else begin
    if(pwrite_setNextInst[0])
        nextInst[0] <= 1'b1;
    if(pwrite_setNextInst[1])
        nextInst[1] <= 1'b1;
    if(pwrite_setNextInst[2])
        nextInst[2] <= 1'b1;
    if(pwrite_setNextInst[3])
        nextInst[3] <= 1'b1;
end


always_ff @(posedge clock)
if (!resetN) begin
    {mode, isWriteA, isWriteB, dataWidth, dataWidth2, Oaddr} <= '0;
    {isUpsample, maxpool_size, maxpool_stride, H1_last} <= '0;
    {pool_width_01, pool_width_23} <= '0;
end
else if(inst_fifo_ren) begin
    mode <= inst.mode;
    isWriteA <= inst.isMaddr_a;
    isWriteB <= inst.isMaddr_b;
    dataWidth <= inst.dataWidth;
    dataWidth2 <= inst.dataWidth2;
    Oaddr <= inst.Oaddr;
    isUpsample <= inst.isUpsample;
    maxpool_size <= inst.maxpool_size;
    maxpool_stride <= inst.maxpool_stride;
    H1_last <= inst.outH1;
    if(inst.maxpool_stride == 2) begin
        if (inst.mode == MODE_ONE) begin
            pool_width_01 <= inst.dataWidth * 2 / 2;
            pool_width_23 <= (inst.dataWidth + inst.dataWidth2) / 2;
        end
        else if (inst.mode == MODE_TWO) begin
            pool_width_01 <= (inst.dataWidth + inst.dataWidth2) / 2;
            pool_width_23 <= (inst.dataWidth + inst.dataWidth2) / 2;
        end
        else begin
            pool_width_01 <= inst.dataWidth / 2;
            pool_width_23 <= inst.dataWidth / 2;
        end
    end
    else begin
        if (inst.mode == MODE_ONE) begin
            pool_width_01 <= inst.dataWidth * 2;
            pool_width_23 <= (inst.dataWidth + inst.dataWidth2);
        end
        else if (inst.mode == MODE_TWO) begin
            pool_width_01 <= (inst.dataWidth + inst.dataWidth2);
            pool_width_23 <= (inst.dataWidth + inst.dataWidth2);
        end
        else begin
            pool_width_01 <= inst.dataWidth;
            pool_width_23 <= inst.dataWidth;
        end
    end
end

always_comb
begin
    output_enable = 1'b0;
    addr = 0;
    len  = 0;
    outbuf = '0;
    idx_next = idx;
    pool_flush_01_next = pool_flush_01;
    pool_flush_23_next = pool_flush_23;
    addr_pool_01_next  = addr_pool_01;
    addr_pool_23_next  = addr_pool_23;
    pool_max_01_next   = pool_max_01;
    pool_max_23_next   = pool_max_23;
    for(int i = 0; i < BANK_NUM; i++) begin
        addr_fifo_ren[i] = 0;
        data_fifo_ren[i] = 0;
    end
    if(do_produce_outputs) begin
    if (maxpool_size == 2) begin
        if (pool_flush_01) begin
            pool_flush_01_next = 1'b0;
            for (int i = 0; i < COMPUTING_GROUP_SIZE * 2; i++)
                if(i < pool_width_01)
                    outbuf[i] = pool_max_01[i];
                else
                    outbuf[i] = 0;
            output_enable = 1'b1;
            len = pool_width_01;
            addr = addr_pool_01;
        end
        else if (pool_flush_23) begin
            pool_flush_23_next = 1'b0;
            for (int i = 0; i < COMPUTING_GROUP_SIZE * 2; i++)
                if(i < pool_width_23)
                    outbuf[i] = pool_max_23[i];
                else
                    outbuf[i] = 0;
            output_enable = 1'b1;
            len = pool_width_23;
            addr = addr_pool_23;
        end
        else begin
            if (!data_fifo_empty[0] || !data_fifo_empty[1] || !data_fifo_empty[2] || !data_fifo_empty[3])
                idx_next = ((idx & 2) + 2) % BANK_NUM;
            else
                idx_next = 0;
            if (!data_fifo_empty[idx] && !data_fifo_empty[idx + 1]) begin
                automatic s_feature_t  	[COMPUTING_GROUP_SIZE - 1 : 0] p0;
                automatic s_feature_t  	[COMPUTING_GROUP_SIZE - 1 : 0] p1;
                automatic mem_addr_t    addr_fifo;
                automatic width_t       wid;
                data_fifo_ren[idx] = 1;
                data_fifo_ren[idx + 1] = 1;
                addr_fifo_ren[idx] = 1;
                addr_fifo_ren[idx + 1] = 1;
                p0 = data_fifo_rdata[idx];
                p1 = data_fifo_rdata[idx + 1];
                addr_fifo = addr_fifo_rdata[idx];

                wid = (idx == 0) ? pool_width_01 : pool_width_23;
                if (maxpool_stride == 2) begin
                    automatic logic isFirst;
                    isFirst = (((idx == 0)?curH01 : curH23) & 1) == 0;
                    //for (unsigned i = 0; i < wid; i++) begin
                    for (int i = 0; i < COMPUTING_GROUP_SIZE; i++) begin
                        automatic s_feature_t val1, val2, val;
                        automatic int k, k1;
                        if(i < wid) begin
                            k = i * 2;
                            val1 = k < dataWidth ? p0[k] : p1[k - dataWidth];
                            k1 = i * 2 + 1;
                            val2 = k1 < dataWidth ? p0[k1] : p1[k1 - dataWidth];
                            val = val1 > val2 ? val1 : val2;
                        end
                        else
                            val = 0;
                        if (isFirst) begin
                            if (idx == 0)
                                pool_max_01_next[i] = val;
                            else
                                pool_max_23_next[i] = val;
                        end
                        else begin
                            automatic s_feature_t pval = (idx == 0) ? pool_max_01[i] : pool_max_23[i];
                            outbuf[i] = pval > val ? pval : val;
                        end
                    end

                    if (isFirst) begin
                        if (idx == 0)
                            addr_pool_01_next = addr_fifo;
                        else
                            addr_pool_23_next = addr_fifo;
                    end
                    else begin
                        output_enable = 1;
                        if (idx == 0) begin
                            addr = addr_pool_01;
                            len = pool_width_01;
                        end
                        else begin
                            addr = addr_pool_23;
                            len = pool_width_23;
                        end
                    end
                end
                else begin //maxpool_stride == 2
                    //for (unsigned i = 0; i < wid; i++) begin
                    for (int i = 0; i < COMPUTING_GROUP_SIZE * 2; i++) begin
                        automatic s_feature_t val1, val2, val;
                        automatic int k, k1;
                        if(i < wid) begin
                            k = i;
                            val1 = k < dataWidth ? p0[k] : p1[k - dataWidth];
                            k1 = i + 1;
                            if (i == wid - 1)
                                val2 = val1;
                            else
                                val2 = k1 < dataWidth ? p0[k1] : p1[k1 - dataWidth];
                            val = val1 > val2 ? val1 : val2;
                        end
                        else
                            val = 0;
                        if (idx == 0) begin
                            pool_max_01_next[i] = val;
                            if (curH01 != 0) begin
                                outbuf[i] = pool_max_01[i] > val ? pool_max_01[i] : val;
                            end
                        end
                        else begin
                            pool_max_23_next[i] = val;
                            if (curH23 != 0) begin
                                outbuf[i] = pool_max_23[i] > val ? pool_max_23[i] : val;
                            end
                        end
                    end
                    if (idx == 0) begin
                        addr_pool_01_next = addr_fifo;
                        if (curH01 != 0) begin
                            addr = addr_pool_01;
                            len = pool_width_01;
                        end
                        if (curH01 == H1_last)
                            pool_flush_01_next = 1'b1;
                    end
                    else begin
                        addr_pool_23_next = addr_fifo;
                        if (curH23 != 0) begin
                            addr = addr_pool_23;
                            len = pool_width_23;
                        end
                        if (curH23 == H1_last)
                            pool_flush_23_next = 1'b1;
                    end
                    if (!(idx == 0 && curH01 == 0 || idx != 0 && curH23 == 0)) begin
                        output_enable = 1'b1;
                    end
                end
            end 
        end
    end
    else  
    if (isUpsample || mode == MODE_FOUR) begin
        if (mode == MODE_ONE && idx == 3
            || mode == MODE_TWO && ((idx & 1) == 1))
            len = dataWidth2;
        else
            len = dataWidth;

        if (!data_fifo_empty[idx]) begin
            addr_fifo_ren[idx] = 1;
            data_fifo_ren[idx] = 1;
            addr = addr_fifo_rdata[idx];
            outbuf = data_fifo_rdata[idx];
            output_enable = 1'b1;
            idx_next = (idx + 1) % BANK_NUM;
        end
        else  begin
            idx_next = (idx + 1) % BANK_NUM;
        end
    end
    else if (mode == MODE_ONE) begin
        if(!(|data_fifo_empty)) begin
            addr_fifo_ren[0] = 1;
            data_fifo_ren[0] = 1;
            addr_fifo_ren[1] = 1;
            data_fifo_ren[1] = 1;
            addr_fifo_ren[2] = 1;
            data_fifo_ren[2] = 1;
            addr_fifo_ren[3] = 1;
            data_fifo_ren[3] = 1;
            len = dataWidth * 3 + dataWidth2;
            addr = addr_fifo_rdata[0];
            output_enable = 1'b1;
            for(int i = 0; i < BRAM_BUS_WIDTH; i++) 
            begin
                if(i < dataWidth && i < COMPUTING_GROUP_SIZE)
                    outbuf[i] = data_fifo_rdata[0][i];
                else if(i < 2 * dataWidth && (i - 32'(dataWidth) < COMPUTING_GROUP_SIZE) )
                    outbuf[i] = data_fifo_rdata[1][i - 32'(dataWidth)];
                else if(i < 3 * dataWidth && (i - 32'(dataWidth) * 2 < COMPUTING_GROUP_SIZE))
                    outbuf[i] = data_fifo_rdata[2][i - 32'(dataWidth) * 2];
                else if((i < 3 * dataWidth + dataWidth2) && (i - 32'(dataWidth) * 3 < COMPUTING_GROUP_SIZE))
                    outbuf[i] = data_fifo_rdata[3][i - 32'(dataWidth) * 3];
                else
                    outbuf[i] = 0;
            end
        end
    end
    else /*if (mode == MODE_TWO)*/ begin
        if (!data_fifo_empty[idx] && !data_fifo_empty[idx + 1]) begin
            addr_fifo_ren[idx] = 1;
            data_fifo_ren[idx] = 1;
            addr_fifo_ren[idx + 1] = 1;
            data_fifo_ren[idx + 1] = 1;
            len = dataWidth + dataWidth2;
            addr = addr_fifo_rdata[idx];
            output_enable = 1'b1;
            for(int i = 0; i < BRAM_BUS_WIDTH; i++) 
            begin
                if(i < dataWidth && i < COMPUTING_GROUP_SIZE)
                    outbuf[i] = data_fifo_rdata[idx][i];
                else if((i < dataWidth + dataWidth2) && ((i - dataWidth) < COMPUTING_GROUP_SIZE))
                    outbuf[i] = data_fifo_rdata[idx + 1][i - 32'(dataWidth)];
                else
                    outbuf[i] = 0;
            end
            //outbuf = { data_fifo_rdata[idx + 1][dataWidth2-1:0], data_fifo_rdata[idx][dataWidth-1:0]};
            idx_next = (idx + 2) % BANK_NUM;
        end
        else begin
            idx_next = ((idx&2) + 2) % BANK_NUM;
        end

    end
end
end

generate
    for (geni=0; geni< BANK_NUM; geni = geni + 1) begin : fifos

    assign pwrite_isWritable[geni] = (!nextInst[geni]) && (!data_fifo_full[geni]);
    assign addr_fifo_wen[geni]     = pwrite_enable[geni];
    assign data_fifo_wen[geni]     = pwrite_enable[geni];
    assign addr_fifo_wdata[geni]   = pwrite_addr[geni];
    assign data_fifo_wdata[geni]   = pwrite_data[geni];

      fifo_ctrlwrite_addr fifo_addr(
	    .clk(clock)	, 		            .srst(fifo_srst), 
	    .din(addr_fifo_wdata[geni]),    .wr_en(addr_fifo_wen[geni]), 
	    .rd_en(addr_fifo_ren[geni]), 	.dout(addr_fifo_rdata[geni]), 
	    .full(addr_fifo_full[geni]), 	.empty(addr_fifo_empty[geni]));

      fifo_ctrlwrite_data fifo_data(
	    .clk(clock)	, 		            .srst(fifo_srst), 
	    .din(data_fifo_wdata[geni]),    .wr_en(data_fifo_wen[geni]), 
	    .rd_en(data_fifo_ren[geni]), 	.dout(data_fifo_rdata[geni]), 
	    .full(data_fifo_full[geni]), 	.empty(data_fifo_empty[geni]));
    end
endgenerate

//weight inst fifo
fifo_InstructionWrite fifo_wcinst(
	    .clk(clock)	, 		.srst(fifo_srst), 
	    .din(cwinst), 		.wr_en(cwinst_enable), 
	    .rd_en(inst_fifo_ren), 	.dout(inst), 
	    .full(inst_fifo_full), 	.empty(inst_fifo_empty));

always_comb
begin
    if(ddr_write_enable)
        $write("cwrite %x (%d), data %x %x %x %x\n", ddr_write_addr, ddr_write_len
        , outbuf[0], outbuf[1], outbuf[2], outbuf[3]);

end

endmodule

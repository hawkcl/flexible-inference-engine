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

module DDRWriteAssist
import definitions_pkg::*;
#(parameter cid = 0)
(
    input logic 		clock, resetN,
    input logic         req_valid,
    input mem_addr_t    req_addr,
    input ddr_len_t     req_len,
    input ubyte_t	[BRAM_BUS_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] req_data,
    input logic         axi_ready,
    

    output logic        write_ready,
    output logic        write_request,
    output ddr_id_t     axi_wid,
    output mem_addr_t   axi_waddr,
    //output ddr_width_t  axi_len,
    output logic    [DDR_DATAWIDTH-1 : 0] axi_wstrobe,
    output ubyte_t  [DDR_DATAWIDTH-1 : 0] axi_wdata
);

logic           fifo_srst;
mem_addr_t      buf_addr, buf_addr_next;
ddr_width_t     buf_start, buf_start_next;
ddr_width1_t    buf_end, buf_end_next; // 1 after last ocupied pos
logic [2:0]     idle_count, idle_count_next;
mem_addr_t      next_fifo_addr, next_fifo_addr_next;
logic           busy_state, busy_state_next;
logic           buf_used, buf_used_next;
ubyte_t       [DDR_DATAWIDTH-1 : 0]  saved_buf;
ubyte_t       [DDR_DATAWIDTH-1 : 0]  saved_buf_next;

logic           flash_saved;
logic           do_process;
ddr_width1_t    saved_pos;
ddr_width_t     saved_start;
ddr_len_t       data_pos;
mem_addr_t      saddr;
mem_addr_t      info_last_addr;
logic    [DDR_DATAWIDTH-1 : 0] mask0;
logic    [DDR_DATAWIDTH-1 : 0] mask1;
ddr_width1_t    len;

logic 			info_fifo_ren;
logic 			info_fifo_wen;
logic 			info_fifo_empty;
logic 			info_fifo_full;
CWriteAssistInfo_t  info_fifo_wdata;
CWriteAssistInfo_t 	info_fifo_rdata;

assign write_ready = !info_fifo_full;

always_ff @(posedge clock)
if (!resetN) begin
    {buf_addr, buf_start, buf_end, idle_count} <= '0;
    {next_fifo_addr, busy_state, buf_used, saved_buf} <= '0;
end
else begin
    {buf_addr, buf_start, buf_end, idle_count} <= {buf_addr_next, buf_start_next, buf_end_next, idle_count_next};
    {next_fifo_addr, busy_state, buf_used, saved_buf} <= {next_fifo_addr_next, busy_state_next, buf_used_next, saved_buf_next};
end

assign axi_wid = cid;
assign axi_wstrobe = mask0 ^ mask1;
assign axi_wdata = saved_buf_next;
assign info_last_addr = info_fifo_rdata.addr + info_fifo_rdata.len;

always_comb
begin
    {buf_addr_next, buf_start_next, buf_end_next, idle_count_next} =  {buf_addr, buf_start, buf_end, idle_count};
    {next_fifo_addr_next, busy_state_next, buf_used_next, saved_buf_next} =  {next_fifo_addr, busy_state, buf_used, saved_buf};
    flash_saved = 1'b0;
    do_process  = 1'b0;
    saved_pos = 0;
    saved_start = 0;
    data_pos = 0;
    saddr = 0;
    mask0 = 0;
    mask1 = 0;
    write_request = 1'b0;
    axi_waddr = 0;
    info_fifo_ren = 1'b0;
    len = 0;
    if(axi_ready) begin
    if (buf_used) begin
        if (info_fifo_empty) begin
            if (idle_count < MAX_WRITE_IDLE_COUNT)
                idle_count_next = idle_count + 1;
            else
                flash_saved = 1'b1;
        end
        else begin
            if (buf_addr + buf_end != info_fifo_rdata.addr) begin
                flash_saved = 1'b1;
            end
            else begin
                do_process = 1'b1;
                saddr = buf_addr;
                saved_pos = buf_end;
                data_pos = 0;
                saved_start = buf_start;
            end
        end
    end
    else begin
        if (busy_state) begin
            do_process = 1'b1;
            saddr = next_fifo_addr;
            saved_pos = 0;
            data_pos = next_fifo_addr - info_fifo_rdata.addr;
            saved_start = 0;
        end
        else if (!info_fifo_empty) begin
            do_process = 1'b1;
            saddr = (info_fifo_rdata.addr / DDR_DATAWIDTH) * DDR_DATAWIDTH;
            //saved_pos = info_fifo_rdata.addr - saddr;
            saved_pos = info_fifo_rdata.addr & (DDR_DATAWIDTH - 1);
            data_pos = 0;
            saved_start = saved_pos;
        end
    end
    if (flash_saved) begin
        mask0 = ((1 << buf_start) - 1);
        mask1 = ((1 << buf_end) - 1);
        write_request = 1'b1;
        axi_waddr = buf_addr;
        buf_used_next = 1'b0;
    end
    else if (do_process) begin
        if (info_last_addr < saddr + DDR_DATAWIDTH) begin
            //len = info_last_addr - saddr;
            len = info_last_addr & (DDR_DATAWIDTH - 1);
            for (int i = 0; i < DDR_DATAWIDTH; i++)
                if (i >= saved_pos && i < len)
                    saved_buf_next[i] = info_fifo_rdata.data[data_pos + i - saved_pos];
            buf_end_next = saved_pos + len - saved_pos;
            buf_start_next = saved_start;
            busy_state_next = 1'b0;
            buf_used_next = 1'b1;
            buf_addr_next = saddr;
            idle_count_next = 0;
            info_fifo_ren = 1'b1;
        end
        else begin
            for (int i = 0; i < DDR_DATAWIDTH; i++)
                if (i >= saved_pos)
                    saved_buf_next[i] = info_fifo_rdata.data[data_pos + i - saved_pos];
            mask0 = ((1 << saved_start) - 1);
            mask1 = 32'hFFFFFFFF; // 32 to DDR_DATAWIDTH
            write_request = 1'b1;
            axi_waddr = saddr;
            buf_used_next = 1'b0;
            if (info_last_addr == saddr + DDR_DATAWIDTH) begin
                info_fifo_ren = 1'b1;
                busy_state_next = 1'b0;
            end
            else begin
                busy_state_next = 1'b1;
                next_fifo_addr_next = saddr + DDR_DATAWIDTH;
            end
        end
    end
    end
end

always_comb
begin
info_fifo_wen = 1'b0;
info_fifo_wdata = '{default :0};
if(req_valid) begin
    info_fifo_wen = 1'b1;
    info_fifo_wdata.addr = req_addr;
    info_fifo_wdata.len = req_len;
        info_fifo_wdata.data = req_data;
    end
end

assign fifo_srst = ~resetN;
fifo_DDRWriteInfo fifo_writeinfo(
	    .clk(clock)	, 		    .srst(fifo_srst), 
	    .din(info_fifo_wdata),  .wr_en(info_fifo_wen), 
	    .rd_en(info_fifo_ren), 	.dout(info_fifo_rdata), 
	    .full(info_fifo_full), 	.empty(info_fifo_empty));

endmodule

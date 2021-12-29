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

module DDRReadAssist
import definitions_pkg::*;
#(parameter cid = 0, 
parameter DATAWIDTH = DDR_DATAWIDTH
)
(
    input logic 		clock, resetN,

    input logic         req_valid,
    input ddr_id_t      req_id,
    input mem_addr_t    req_addr,
    input ddr_len_t     req_len,
    
    input ddr_id_t      ddr_vid,
    input ubyte_t  [DATAWIDTH-1 : 0] ddr_data,
    input logic         ddr_isLast,
    input logic         axi_ready,
    

    output logic        read_ready,
    output ddr_id_t     valid_id,
    output ubyte_t [MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] valid_data,

    output ddr_id_t     axi_rid,
    output mem_addr_t   axi_raddr,
    output ddr_width_t  axi_len,
    output logic        read_request,
    output logic        read_freeze
);

logic           fifo_srst;
mem_addr_t      next_addr, next_addr_next;
ddr_len_t       buf_addr, buf_addr_next;
ubyte_t [MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] data;
ubyte_t [MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] data_next;
ubyte_t [DATAWIDTH - 1 : 0]saved_buf;
ubyte_t [DATAWIDTH - 1 : 0]saved_buf_next;

logic 			info_fifo_ren;
logic 			info_fifo_wen;
logic 			info_fifo_empty;
logic 			info_fifo_full;
CReadAssistInfo_t   info_fifo_wdata;
CReadAssistInfo_t  	info_fifo_rdata;

assign read_ready = (!info_fifo_full) && axi_ready;
assign valid_data = data_next;

always_ff @(posedge clock)
if (!resetN)
    {buf_addr, data, saved_buf} <= '0;
else
    {buf_addr, data, saved_buf} <= {buf_addr_next, data_next, saved_buf_next};

always_ff @(posedge clock)
if (!resetN)
    next_addr <= '0;
else
    next_addr <= next_addr_next;

assign axi_rid = cid;

always_comb
begin
    info_fifo_ren = 1'b0;
    valid_id = '0;
    read_freeze = 1'b0;
    data_next = data;
    saved_buf_next = saved_buf;
    buf_addr_next = buf_addr;
    if (!info_fifo_empty) begin
        if (info_fifo_rdata.saved_len > 0 && info_fifo_rdata.saved_only) begin
            assert (ddr_vid == '0) else $write("ddr_vid non 0 : %d, cid %d\n", ddr_vid, cid);
            //TODO : save for next cycle
            info_fifo_ren = 1'b1;
			valid_id = info_fifo_rdata.id;
            read_freeze = 1'b1;
			for (int i = 0; i < MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE; i++)
                if(i < info_fifo_rdata.saved_len)
                    data_next[i] = saved_buf[info_fifo_rdata.saved_addr + i];
        end
        else if (ddr_vid == cid) begin
			automatic ddr_len_t adr;
            automatic ddr_width1_t read_len;
            automatic ddr_width1_t faddr;
			read_len = DATAWIDTH;
			if (buf_addr == 0 && !ddr_isLast)
				read_len = DATAWIDTH - info_fifo_rdata.first_addr;

			if (buf_addr == 0 && info_fifo_rdata.saved_len > 0)
				adr = info_fifo_rdata.saved_len;
			else
				adr = buf_addr;
			
			faddr = 0;
			if (buf_addr == 0)
				faddr = info_fifo_rdata.first_addr;
            for (int i = 0; i < MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE; i++) begin
				if (i < info_fifo_rdata.saved_len)
					data_next[i] = saved_buf[i + info_fifo_rdata.saved_addr];
				else if (i >= adr)
					data_next[i] = ddr_data[(faddr + i - adr) % DATAWIDTH];
            end
            if (ddr_isLast) begin
                info_fifo_ren = 1'b1;
				valid_id = info_fifo_rdata.id;
				buf_addr_next = 0;
				for (int i = 0; i < DATAWIDTH; i++)
					saved_buf_next[i] = ddr_data[i];
            end
			else
				buf_addr_next = adr + read_len;
        end
    end
end

//DelayLoad
always_comb
begin
    info_fifo_wen = 1'b0;
    info_fifo_wdata = '{default :0};
    next_addr_next = next_addr;
    read_request = 1'b0;
    axi_len = '0;
    axi_raddr = '0;
    if(req_valid) begin
        automatic mem_addr_t saddr;
        automatic mem_addr_t eaddr;
        automatic mem_addr_t eaddr0;
        info_fifo_wen = 1'b1;
        info_fifo_wdata.id = req_id;
		saddr = (req_addr / DATAWIDTH) * DATAWIDTH;
		eaddr = req_addr + req_len;
		eaddr0 = (eaddr / DATAWIDTH) * DATAWIDTH;
        if (eaddr % DATAWIDTH != 0) begin
			info_fifo_wdata.last_len = eaddr - eaddr0;
			eaddr = eaddr0 + DATAWIDTH;
        end
		else
			info_fifo_wdata.last_len = DATAWIDTH;
        if (saddr + DATAWIDTH == next_addr) begin
			info_fifo_wdata.saved_addr = req_addr - saddr;
            if ((next_addr - req_addr) >= req_len) begin
				info_fifo_wdata.saved_len = req_len;
				info_fifo_wdata.saved_only = 1'b1;
				//axi_len = 0;
            end
            else begin
				info_fifo_wdata.saved_len = (next_addr - req_addr);
				info_fifo_wdata.saved_only = 1'b0;
            end
			saddr = next_addr;
			info_fifo_wdata.first_addr = 0;
        end
        else begin
			info_fifo_wdata.saved_addr = 0;
			info_fifo_wdata.saved_len = 0;
			info_fifo_wdata.saved_only = 1'b0;
            info_fifo_wdata.first_addr = req_addr - saddr;
        end
		axi_len = (eaddr - saddr) / DATAWIDTH;
        if (axi_len > 0) begin
            axi_len = axi_len - 1;
            axi_raddr = saddr;
            read_request = 1'b1;
			next_addr_next = eaddr;
        end
    end
end

assign fifo_srst = ~resetN;
fifo_DDRReadInfo fifo_readinfo(
	    .clk(clock)	, 		    .srst(fifo_srst), 
	    .din(info_fifo_wdata),  .wr_en(info_fifo_wen), 
	    .rd_en(info_fifo_ren), 	.dout(info_fifo_rdata), 
	    .full(info_fifo_full), 	.empty(info_fifo_empty));

endmodule

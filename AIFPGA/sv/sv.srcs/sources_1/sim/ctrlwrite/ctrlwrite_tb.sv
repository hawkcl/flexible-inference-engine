`timescale 1ns / 1ns
module ctrlwrite_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic 		cwinst_enable;
InstructionWrite 	cwinst;
seq_t         cb0_finishedSeq;
logic         [BANK_NUM - 1: 0]cb_isFetchNextInst;
logic         pwrite_setNextInst[BANK_NUM];

s_feature_t 	[COMPUTING_GROUP_SIZE-1:0] pwrite_data[BANK_NUM];
logic 		[BANK_NUM-1:0] pwrite_enable;
mem_addr_t 	pwrite_addr[BANK_NUM];

seq_t        pwrite_finishedSeq;
logic        pwrite_isFetchNextInst;
logic        pwrite_isWritable[BANK_NUM];

logic        ddr_write_enable;
mem_addr_t   ddr_write_addr;
logic   [DDR_LEN_WIDTH-1 : 0]    ddr_write_len;
logic        rama_write_enable;
logic        ramb_write_enable;
logic        ddr_write_ready;
mem_addr_t   ram_write_addr;
ctrl_width_t    ram_write_len;
s_feature_t  [BRAM_BUS_WIDTH - 1 : 0] outbuf;
logic       isStopable;

ctrlwrite_ports ports(.*);
ctrlwrite_top top(ports);

CtrlWrite ctrlwrite(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

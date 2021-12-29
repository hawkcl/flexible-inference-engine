`timescale 1ns / 1ns
module GIB_tb
import definitions_pkg::*;
();

logic clock, resetN;
seq_t 		rama_finishedSeq;
seq_t 		ramb_finishedSeq;
seq_t 		pcwrite_finishedSeq;
logic         addressBuffer_empty;
mem_addr_t    addressBuffer_rdata;
logic         pcread_busValid;
logic         pcread_isFeature;
logic         pcread_RequestGIBValid;
ReturnData_t 	pread_dataBus;
logic         [BANK_NUM+1 : 0]cb_ibfull;
logic             hcb_isStopable[BANK_NUM];
logic             read_isStopable;
logic             write_isStopable;
logic             weight_isStopable;

logic            pif_AddOutput;
mem_addr_t       endInst_oAddr;
mem_addr_t       endInst_oSize;
logic            addressBuffer_ren;
logic            reqGIBValid;
RequestItem_t    reqGIB;
logic            cb_start[BANK_NUM];
logic            cb_stop[BANK_NUM];
logic 		    inst_enable[BANK_NUM];
InstructionHCB 	cb_inst[BANK_NUM];
logic 		    cwtinst_enable;
InstructionWeight    cwtinst;
logic 		    crinst_enable;
InstructionRead 	crinst;
logic 		    cwinst_enable;
InstructionWrite cwinst;

GIB_ports ports(.*);
GIB_top top(ports);

GIB gib(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

`timescale 1ns / 1ns
module HCB_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic 		inst_enable;
logic 		start; 
logic 		stop;
logic 		pwrite_isFetchNextInst;
InstructionHCB 	inst;
logic 		pread_busValid;
logic 		pread_isFeature;
seq_t 		pread_seqNum;
s_feature_t  	[MAX_READ_WIDTH - 1: 0]dataBus;
seq_t 		pcweight_seq;
logic 		pcweight_busValid;
s_weight_t 	pcweight_dataBus[WEIGHT_MEM_BUS_SIZE];
logic 		pread_RequestFull;
token_t 	ptoken;
ReturnData_t 	pread_dataBus;
logic 		pwrite_isWritable; 

logic 		weights_almost_full;
logic 		instfifo_full;
logic 		token_set;
token_t 	max_token;
logic 		pread_RequestValid;
RequestItem_t 	pread_request;
s_feature_t 	[COMPUTING_GROUP_SIZE-1:0]pwrite_data;
logic 		pwrite_enable;
mem_addr_t 	pwrite_addr;
logic 		pwrite_setNextInst;
logic 		isFetchNextInst;
layer_addr_t 	workingProgress;
logic            isRunning;
logic            isReadingFeatures;
seq_t            reqFeature;
seq_t            finishedSeq;
seq_t            workingSeq;
logic            isReadingWeights;
seq_t            reqWeight;
logic            isLoadingFroze;
logic            isStopable;

HCB_ports ports(.*);
HCB_top top(ports);

HCB hcb(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

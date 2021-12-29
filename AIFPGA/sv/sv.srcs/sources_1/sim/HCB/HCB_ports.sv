`ifndef HCB_PORTS_SV
`define HCB_PORTS_SV

`timescale 1ns / 1ns
interface HCB_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic 		inst_enable,
output logic 		start, 
output logic 		stop,
output logic 		pwrite_isFetchNextInst,
output InstructionHCB 	inst,
output logic 		pread_busValid,
output logic 		pread_isFeature,
output seq_t 		pread_seqNum,
output s_feature_t  	[MAX_READ_WIDTH - 1: 0]dataBus,
output seq_t 		pcweight_seq,
output logic 		pcweight_busValid,
output s_weight_t 	pcweight_dataBus[WEIGHT_MEM_BUS_SIZE],
output logic 		pread_RequestFull,
output token_t 		ptoken,
output ReturnData_t 	pread_dataBus,
output logic 		pwrite_isWritable, 

input logic 		weights_almost_full,
input logic 		instfifo_full,
input logic 		token_set,
input token_t 		max_token,
input logic 		pread_RequestValid,
input RequestItem_t 	pread_request,
input s_feature_t 	[COMPUTING_GROUP_SIZE-1:0]pwrite_data,
input logic 		pwrite_enable,
input mem_addr_t 	pwrite_addr,
input logic 		pwrite_setNextInst,
input logic 		isFetchNextInst,
input layer_addr_t 	workingProgress,
input logic            isRunning,
input logic            isReadingFeatures,
input seq_t            reqFeature,
input seq_t            finishedSeq,
input seq_t            workingSeq,
input logic            isReadingWeights,
input seq_t            reqWeight,
input logic            isStopable,
input logic            isLoadingFroze
);
endinterface



`endif

`ifndef CW_PORTS_SV
`define CW_PORTS_SV

`timescale 1ns / 1ns
interface ctrlweight_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic 		cwinst_enable,
output InstructionWeight 	cwinst,
output logic         ddr_read_ready,
output ddr_id_t      valid_id,
output s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0]weight_data,
output logic         cb_isReadingWeights[BANK_NUM],
output logic         cb_isWeightFull[BANK_NUM],
output seq_t         cb_ReqWeight[BANK_NUM],


input logic        weight_ram_enable,
input ddr_id_t     weight_ddr_id,
input mem_addr_t   weight_ram_addr,
input logic 		pcweight_busValid,
input seq_t 		pcweight_seq,
input logic         wt_inst_fifo_full,
input logic         isStopable,
input s_weight_t  	w_bus[WEIGHT_READ_WIDTH]
);
endinterface



`endif

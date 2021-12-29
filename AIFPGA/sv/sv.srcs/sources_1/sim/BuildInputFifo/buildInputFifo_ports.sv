`ifndef BI_PORTS_SV
`define BI_PORTS_SV

`timescale 1ns / 1ns
interface buildInputFifo_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output HCB_STATE state,
output layer_addr_t readCLast,

output width_t outputBufH1,
output pad_t downPad, topPad,
output k_t k,
output pad_t stride,
output s_row_addr_t rowNum,

output logic reset_params, //prefetching
output logic new_params, reset_iLayers,
output s_row_addr_t new_rowAddr,

output logic input_full,
//assemble_buffer
output s_feature_t [INPUT_MEM_WIDTH - 1 : 0] ab_data,  
//output s_feature_t  ab_data[INPUT_MEM_WIDTH],  
output logic ab_empty,

//input_fifo
input logic input_wr_en,
input s_feature_t [INPUT_MEM_WIDTH - 1 : 0] input_data_out,
//input s_feature_t  input_data_out[INPUT_MEM_WIDTH],
input logic ab_rd_en
);
endinterface



`endif

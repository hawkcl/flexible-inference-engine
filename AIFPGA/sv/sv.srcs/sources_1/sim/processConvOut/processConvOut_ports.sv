`ifndef PO_PORTS_SV
`define PO_PORTS_SV

`timescale 1ns / 1ns
interface processConvOut_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output HCB_STATE state,
output logic enable,
output logic isOnOutput,
output logic pwrite_isWritable,
output logic resBuf_empty,
//input logic waiting_out,
//input logic doBatch3K1_out,
output logic doRes_out, doUpSample_out,
output width_t outputBufW1_out,
output outframe_addr_t outFrameSize_out,
output out_width_t outW_out, outW_out2,
output pad_t maxpool_stride_out,
output output_gap_t outputAddrGap_out,
output k_t k_out,
output seq_t curSeq_out, // for debug, unused now
output logic newWriteInst_out,
output width_t outputBufH1_out,
output cg_addr_t outputIdxMax,
output s_feature_t pre_output[CG_NUM][COMPUTING_GROUP_SIZE],
output s_feature_t [COMPUTING_GROUP_SIZE-1:0] resBuf,
output logic set_LastOutput,

output logic new_params,
output mem_addr_t new_outputAddr, 
output mem_addr_t new_outputFrameStart,
output logic set_out_params,
output mem_addr_t new_outputAddr_out, new_outputFrameStart_out,

input logic res_en,
input s_feature_t [COMPUTING_GROUP_SIZE - 1 : 0]pwrite_data,
input logic pwrite_enable,
input mem_addr_t pwrite_addr,
input logic pwrite_setNextInst,
input output_addr_t out_row,
input logic reset_state,    // TO IDLE
input mem_addr_t outputAddr, 
input mem_addr_t outputFrameStart,
input logic reset_isOnOutput
);
endinterface



`endif

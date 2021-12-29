`ifndef SO_PORTS_SV
`define SO_PORTS_SV

`timescale 1ns / 1ns
interface startConvOut_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic enable,
output logic isNextVolumeReady, isPrefetchNextVolume_next, isPrefetchNextVolume,
output logic reset_isOnOutput,
output layer_addr_t kt, ks,
output cg_addr_t numGroups,
output k_t k,
output logic doRes,
output logic doUpSample,
output width_t outputBufW1,
output outframe_addr_t outFrameSize,
output out_width_t outW,
output output_gap_t outputAddrGap,
output pad_t maxpool_stride,
output seq_t curSeq,
output logic newWriteInst,
output width_t outputBufH1Orig,
output mem_addr_t  outputAddr, outputFrameStart,
output logic new_params,
output layer_addr_t new_kOut,
output cg_addr_t usedCGLast,
output cg_addr_t usedCG0,
output layer_addr_t kCurLast,
//input logic batch_only_1group,
//input layer_addr_t kbe_1,
//input cg_addr_t wtotalbLast,

input logic isOnOutput,
input logic waiting_out,
input logic cgSwitchOutput,
input logic doRes_out, doUpSample_out,
input width_t outputBufW1_out,
input outframe_addr_t outFrameSize_out,
input out_width_t outW_out, outW_out2,
input pad_t maxpool_stride_out,
input output_gap_t outputAddrGap_out,
input k_t k_out,
input seq_t curSeq_out,
input logic newWriteInst_out,
input width_t outputBufH1_out,
input logic set_out_params,
input mem_addr_t outputAddr_out, outputFrameStart_out,
input logic set_LastOutput,
input cg_addr_t outputIdxMax,
input layer_addr_t kOut
);
endinterface



`endif

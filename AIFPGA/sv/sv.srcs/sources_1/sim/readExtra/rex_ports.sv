`ifndef REX_PORTS_SV
`define REX_PORTS_SV

`timescale 1ns / 1ns
interface rex_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic isReadingFeatures, pread_RequestFull,
output logic isResMaster, 
output token_t this_token, ptoken,
output logic res_full,
output logic doRes, 
`ifdef S2_OPTIMIZE	
output logic isStride2,
`endif
output DATA_MODE mode,
output width_t outputBufW1, outputBufH1Orig, 
output out_width_t outW,
output outframe_addr_t outFrameSize,
output output_gap_t outputAddrGap, outFrameGapSize,
output logic unsigned [7 : 0] curSeq,
output layer_addr_t ks,
output cg_addr_t numGroups,
output layer_addr_t kCurLast,
output res_size_t resSize0,
output res_size_t resSizeLast,
output res_len_t resLen0,
output res_len_t resLenLast,
output cg_addr_t usedGroupsLast,

output logic setParam,
output layer_addr_t new_kRes,    
output logic new_isReadResA,
output mem_addr_t new_nextResAddr,
output mem_addr_t new_frameResAddr,
output group_t new_resRowCount,
output res_size_t new_resSize,
output res_size_t new_resReadSize,
output layer_addr_t new_resFrameCount,
output layer_addr_t new_resFrameMax,
output res_len_t new_resLen, 
output output_gap_t new_outResGapSize, 
output res_size_t totalRes,
output layer_addr_t kCurLast_1,
output logic resetRequestingRes,
output logic extWeights_ren,
output logic resBuf_ren,
	
input logic enRequest,
input RequestItem_t request

);
clocking cb @(posedge clock);
default input #1ns;
input enRequest;
input request;
endclocking
endinterface



`endif

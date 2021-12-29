`ifndef PI_PORTS_SV
`define PI_PORTS_SV

`timescale 1ns / 1ns
interface processInstruction_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic enable,
output logic pwrite_isFetchNextInst,
output logic pib_empty,
output InstructionHCB inst,
output logic hasNextFeatureParams,
output logic new_params_prefetch,
output mem_bus_addr_t new_readPos,
output width_t new_writeWidth,
output input_addr_t new_volumeSize,
output seq_t new_reqSeqF,

input logic pib_en,
input logic new_conv_inst,
input k_t inst_k,
input seq_t curSeq, reqSeq,
input seq_t reqProgress,
input logic isProgressMaster,
input logic token_set,
input token_t max_token,
input k_t k,
input pad_t stride,
`ifdef S2_OPTIMIZE
input logic isStride2,
input s_row_addr_t new_nextRowStart,
input k_t new_kIter,
`endif
input out_width_t outW,
input width_t new_outputBufH1,
input width_t outputBufH1Orig,
input width_t outputBufW1,
input loc_frame_t outBufFrameSize,
input outframe_addr_t outFrameSize,
input output_gap_t outputAddrGap, outFrameGapSize,
input pad_t maxpool_stride,
input mem_addr_t new_outputAddr, 
input mem_addr_t new_outputFrameStart,
input cg_addr_t numGroups,
input token_t token,
input logic isResMaster,
input mem_bus_addr_t readPos,
input mem_bus_addr_t resPos,
input pad_t leftPad,
input width_t new_readWidth,
input width_t writeWidth,
input layer_addr_t readCLast,
input pad_t topPad, downPad,
input s_row_addr_t new_rowAddr,
input s_row_addr_t new_rowNum,
input seq_t reqSeqF,
input layer_addr_t new_kCur,
input layer_addr_t new_kOut,
input layer_addr_t Ks, kt,
input cg_addr_t new_usedGroups,
input res_size_t new_resSize,
input res_size_t new_resReadSize,
input layer_addr_t new_resFrameMax,
input logic doRes, doRelu, doLRelu, doBM, doUpSample, newWriteInst,
input s_feature_t wLRelu,
input cg_addr_t new_wtotal,
input layer_addr_t new_resFrameCount,
input group_t new_resRowCount,
input logic new_isReadResA,
input mem_addr_t new_nextResAddr,
input mem_addr_t new_frameResAddr,
input res_len_t new_resLen,
input output_gap_t new_outResGapSize,
input layer_addr_t new_kRes,  
input loc_frame_t prefetchFrameSize,
input input_addr_t volumeSize,
input input_addr_t curVolumeSize,
input DATA_MODE mode,
input scale_t fScale, wScale,
input input_addr_t new_addrNextFrame,
input res_size_t totalRes,
input cg_addr_t usedGroupsLast,
input cg_addr_t usedCGLast,
input cg_addr_t usedCG0,
input layer_addr_t kCurLast,
input res_size_t resSize0,
input res_size_t resSizeLast,
input res_len_t resLen0,
input res_len_t resLenLast,
input cg_addr_t wtotal_n,
input weight_bus_size_t wlenk_nLast,
input cg_addr_t wtotalLast,
input weight_bus_size_t wlenk_nLast2,
input weight_bus_size_t wlenk_regular,
input weight_bus_size_t wlen_regular,
input weight_bus_size_t new_wlenk,
input weight_bus_size_t new_wlenk_last,
input layer_addr_t kCurLast_1,
input width1_t new_maxRowCount,
input width_t new_lastLen
);
endinterface



`endif
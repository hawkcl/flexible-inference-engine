`ifndef AI_PORTS_SV
`define AI_PORTS_SV

`timescale 1ns / 1ns
interface assembleInput_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic doAssemble,
output logic buffer_full,
output logic inputs_buffer_empty,
output width_t readWidth,
output s_feature_t [INPUT_MEM_WIDTH - 1 : 0] data_input,
output loc_frame_t prefetchFrameSize,

output logic new_param, reset_param,
output input_addr_t new_addrNextFrame,
output input_addr_t curVolumeSize,
output width1_t maxRowCount,
output width_t lastLen,

input logic buffer_wen,
input s_feature_t [INPUT_MEM_WIDTH - 1 : 0] buffer_data,
input logic ren,
input logic resetAssemble

);
endinterface



`endif

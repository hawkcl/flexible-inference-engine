`ifndef SI_PORTS_SV
`define SI_PORTS_SV

`timescale 1ns / 1ns
interface readFeatures_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic pread_busValid, pread_isFeature,
output logic isReadingFeatures, isLoadingFroze,
output logic isLoadingNextFeatures,
output seq_t pread_seqNum, reqSeqF,
output width_t writeWidth,

output logic new_params,
output mem_bus_addr_t readPos,
output input_addr_t volumeSize,

output input_addr_t usedWords,
output s_feature_t [MAX_READ_WIDTH-1:0] dataBus,
//output s_feature_t  dataBus[MAX_READ_WIDTH],
input logic setLoadingFroze, resetLoadingFroze,
input logic resetLoadingNextFeatures, resetReadingFeatures,
input logic wen,
input logic unsigned [13:0]addrOut,
input s_feature_t [INPUT_MEM_WIDTH - 1 : 0] dataOut
//input s_feature_t  dataOut[INPUT_MEM_WIDTH]

);
endinterface



`endif

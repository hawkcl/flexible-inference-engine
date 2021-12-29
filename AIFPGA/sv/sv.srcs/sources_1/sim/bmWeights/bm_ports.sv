`ifndef BM_PORTS_SV
`define BM_PORTS_SV

`timescale 1ns / 1ns
interface bm_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic enSendBMWeights,
output weight_bus_size_t len,
output logic pread_busValid, pread_isFeature,
output ReturnData_t data,
output logic unsigned [7 : 0] curSeq,
output token_t token,
output logic new_conv_inst, //new_bm_params from ProcessInstruction
input bm_size_t receivedBM,
input s_feature_t bmWeightBus[WEIGHT_BUS_SIZE],
input logic enough_data
);
endinterface



`endif

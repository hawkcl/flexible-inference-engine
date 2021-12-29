`ifndef SI_PORTS_SV
`define SI_PORTS_SV

`timescale 1ns / 1ns
interface shiftinput_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output INPUT_SOURCE input_src,
output k_t k,
output s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE],

input s_feature_t shiftInputs[MAX_K]

);
endinterface



`endif

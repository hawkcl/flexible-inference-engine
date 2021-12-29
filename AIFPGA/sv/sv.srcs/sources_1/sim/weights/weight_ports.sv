`ifndef BM_PORTS_SV
`define BM_PORTS_SV

interface weight_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic enSendWeights,
output logic enSendBMWeights,
output weight_bus_size_t len,
output weight_bus_size_t bm_len,
output logic is_cycle_froze,
output logic isRunning, pcweight_busValid,
output seq_t pcweight_seq,
output logic new_weight_params,
output mem_bus_addr_t new_weightReadPos,
output weight_addr_t new_nextWeightRead,
output weight_addr_t new_endWeightRead,
output seq_t new_reqSeqW,
output s_weight_t  w_bus[WEIGHT_MEM_BUS_SIZE],
output logic new_conv_inst, 

input logic isReadingWeights,
input s_weight_t weightsBus[WEIGHT_BUS_SIZE],
input logic bm_enough_data,
input logic enough_data
);
endinterface



`endif

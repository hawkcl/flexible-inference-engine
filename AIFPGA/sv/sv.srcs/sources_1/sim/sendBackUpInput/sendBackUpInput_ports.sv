`ifndef BK_PORTS_SV
`define BK_PORTS_SV

`timescale 1ns / 1ns
interface sendBackUpInput_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic sendBackUpInput_valid,
output k_t backupId,
output s_feature_t [INPUT_MEM_WIDTH-1:0] fifo_data,
//output s_feature_t  fifo_data[INPUT_MEM_WIDTH],
output logic fifo_empty,
`ifdef S2_OPTIMIZE
output logic isStride2,
`endif
output width_t readWidth,
output pad_t leftPad,

input logic rd_en,
input s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE],
`ifdef S2_OPTIMIZE  
input s_feature_t backupBus[COMPUTING_GROUP_SIZE*2],
`else
input s_feature_t backupBus[COMPUTING_GROUP_SIZE],
`endif
input logic isBackupValid
);
endinterface



`endif

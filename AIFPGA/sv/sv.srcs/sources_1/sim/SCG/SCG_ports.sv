`ifndef SCG_PORTS_SV
`define SCG_PORTS_SV
`timescale 1ns / 1ns

interface SCG_ports 
	import definitions_pkg::*;
	(
input logic clock, 
output logic resetN,
output HCB_STATE state, state_next,
output scale_t wscale,
output k_t k,
output logic isInitLayer, doLRelu, doRelu, bmPhase,isLReluWeight,
output logic cgSwitchOutput,nextWeight, setConvIndex, 
`ifdef S2_OPTIMIZE
output logic isStride2,
`else
output pad_t stride,
`endif
output logic isBMWeightValid, isWeightValid,
output s_feature_t wLRelu,
output cg_addr_t phcg_weightId,
output k_t inst_k, 
output k_t iterCountDown,
output s_weight_t weightBus[WEIGHT_BUS_SIZE],
output s_feature_t bmWeightBus[WEIGHT_BUS_SIZE],
output INPUT_SOURCE input_src,
`ifdef S2_OPTIMIZE  
output s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE*2],
`else
output s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE],
`endif
output s_feature_t shiftInputs[MAX_K],
output s_feature_t shift_s[COMPUTING_GROUP_SIZE],
output s_mult_t psum_low[COMPUTING_GROUP_SIZE],
output logic output_ready,
output k_t phcg_backupId,
output logic isBackupValid,
output width_t read_pos, write_pos,
output output_addr_t out_row,
output logic is_cycle_froze,

input s_feature_t shift_n[COMPUTING_GROUP_SIZE],
input s_mult_t psum_up[COMPUTING_GROUP_SIZE],
input s_feature_t pre_output[COMPUTING_GROUP_SIZE]
);
endinterface



`endif

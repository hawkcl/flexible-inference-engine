`timescale 1ns / 1ns
module SCG_tb
import definitions_pkg::*;
();
parameter SCG_NUM = 2;
parameter BANK_NUM = 0;
parameter IS_BOTTOM = 0;

  logic clock, resetN;
  HCB_STATE state, state_next;
  scale_t wscale;
  k_t k;
  logic isInitLayer, doLRelu, doRelu, bmPhase,isLReluWeight;
  logic cgSwitchOutput,nextWeight, setConvIndex;
`ifdef S2_OPTIMIZE
  logic isStride2;
`else
  pad_t stride;
`endif
  logic isBMWeightValid, isWeightValid;
  s_feature_t wLRelu;
  cg_addr_t phcg_weightId;
  k_t inst_k;
  k_t iterCountDown;
  s_weight_t weightBus[WEIGHT_BUS_SIZE];
  s_feature_t bmWeightBus[WEIGHT_BUS_SIZE];
  INPUT_SOURCE input_src;
`ifdef S2_OPTIMIZE  
  s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE*2];
`else
  s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE];
`endif
  s_feature_t shiftInputs[MAX_K];
  s_feature_t shift_s[COMPUTING_GROUP_SIZE];
  s_mult_t psum_low[COMPUTING_GROUP_SIZE];
  logic output_ready;
  k_t phcg_backupId;
  logic isBackupValid;
  logic is_cycle_froze;
  width_t read_pos, write_pos;
  output_addr_t out_row;
  s_feature_t shift_n[COMPUTING_GROUP_SIZE];
  s_mult_t psum_up[COMPUTING_GROUP_SIZE];
  s_feature_t pre_output[COMPUTING_GROUP_SIZE];

SCG_ports ports(.*);
SCG_top top(ports);
SCG #(.id(SCG_NUM),.isBottom(IS_BOTTOM)) scg(.*);

  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

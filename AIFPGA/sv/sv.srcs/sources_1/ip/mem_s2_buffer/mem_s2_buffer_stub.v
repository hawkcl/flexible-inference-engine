// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Oct 21 13:41:31 2019
// Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub -rename_top mem_s2_buffer -prefix
//               mem_s2_buffer_ mem_s2_buffer_stub.v
// Design      : mem_s2_buffer
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z100ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *)
module mem_s2_buffer(a, d, clk, we, spo)
/* synthesis syn_black_box black_box_pad_pin="a[3:0],d[167:0],clk,we,spo[167:0]" */;
  input [3:0]a;
  input [167:0]d;
  input clk;
  input we;
  output [167:0]spo;
endmodule

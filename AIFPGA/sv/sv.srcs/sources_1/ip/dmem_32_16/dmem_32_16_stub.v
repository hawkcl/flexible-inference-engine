// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sat Dec 14 06:53:29 2019
// Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub C:/AI/AIFPGA/sv/sv.srcs/sources_1/ip/dmem_32_16/dmem_32_16_stub.v
// Design      : dmem_32_16
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z100ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *)
module dmem_32_16(a, d, dpra, clk, we, dpo)
/* synthesis syn_black_box black_box_pad_pin="a[3:0],d[19:0],dpra[3:0],clk,we,dpo[19:0]" */;
  input [3:0]a;
  input [19:0]d;
  input [3:0]dpra;
  input clk;
  input we;
  output [19:0]dpo;
endmodule
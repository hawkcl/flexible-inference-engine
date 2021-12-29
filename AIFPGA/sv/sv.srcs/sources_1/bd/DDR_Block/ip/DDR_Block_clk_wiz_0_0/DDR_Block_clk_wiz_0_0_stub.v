// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Oct 13 12:13:43 2019
// Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               c:/AI/AIFPGA/sv/sv.srcs/sources_1/bd/DDR_Block/ip/DDR_Block_clk_wiz_0_0/DDR_Block_clk_wiz_0_0_stub.v
// Design      : DDR_Block_clk_wiz_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z100ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module DDR_Block_clk_wiz_0_0(clk_out1, clk_out2, resetn, clk_in1_p, clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,clk_out2,resetn,clk_in1_p,clk_in1_n" */;
  output clk_out1;
  output clk_out2;
  input resetn;
  input clk_in1_p;
  input clk_in1_n;
endmodule

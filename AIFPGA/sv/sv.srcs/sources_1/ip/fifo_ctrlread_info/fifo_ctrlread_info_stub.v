// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Thu May  9 12:40:42 2019
// Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub -rename_top fifo_ctrlread_info -prefix
//               fifo_ctrlread_info_ fifo_ctrlread_info_stub.v
// Design      : fifo_ctrlread_info
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z100ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module fifo_ctrlread_info(clk, srst, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[1:0],wr_en,rd_en,dout[1:0],full,empty" */;
  input clk;
  input srst;
  input [1:0]din;
  input wr_en;
  input rd_en;
  output [1:0]dout;
  output full;
  output empty;
endmodule

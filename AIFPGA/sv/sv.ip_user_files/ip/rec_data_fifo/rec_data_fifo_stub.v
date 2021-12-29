// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Oct 21 13:32:03 2019
// Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub -rename_top rec_data_fifo -prefix
//               rec_data_fifo_ rec_data_fifo_stub.v
// Design      : rec_data_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z100ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module rec_data_fifo(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, wr_data_count)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[288:0],wr_en,rd_en,dout[288:0],full,empty,wr_data_count[8:0]" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [288:0]din;
  input wr_en;
  input rd_en;
  output [288:0]dout;
  output full;
  output empty;
  output [8:0]wr_data_count;
endmodule

// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Feb 18 05:50:43 2019
// Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               c:/AI/cloud/fpga/sv/sv.srcs/sources_1/ip/weights_fifo_1/weights_fifo_stub.v
// Design      : weights_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xcvu9p-flga2104-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module weights_fifo(clk, srst, din, wr_en, rd_en, dout, full, empty, 
  prog_full, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[127:0],wr_en,rd_en,dout[255:0],full,empty,prog_full,wr_rst_busy,rd_rst_busy" */;
  input clk;
  input srst;
  input [127:0]din;
  input wr_en;
  input rd_en;
  output [255:0]dout;
  output full;
  output empty;
  output prog_full;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule

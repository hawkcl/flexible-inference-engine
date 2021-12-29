// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sat Dec 14 01:28:15 2019
// Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub C:/AI/AIFPGA/sv/sv.srcs/sources_1/ip/inputs_mem/inputs_mem_stub.v
// Design      : inputs_mem
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z100ffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module inputs_mem(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[13:0],dina[95:0],clkb,enb,addrb[13:0],doutb[95:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [13:0]addra;
  input [95:0]dina;
  input clkb;
  input enb;
  input [13:0]addrb;
  output [95:0]doutb;
endmodule

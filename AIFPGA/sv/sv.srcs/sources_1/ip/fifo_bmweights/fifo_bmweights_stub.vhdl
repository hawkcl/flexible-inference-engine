-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sat Dec 14 06:52:04 2019
-- Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/AI/AIFPGA/sv/sv.srcs/sources_1/ip/fifo_bmweights/fifo_bmweights_stub.vhdl
-- Design      : fifo_bmweights
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z100ffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_bmweights is
  Port ( 
    clk : in STD_LOGIC;
    srst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 47 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 47 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    prog_full : out STD_LOGIC
  );

end fifo_bmweights;

architecture stub of fifo_bmweights is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,srst,din[47:0],wr_en,rd_en,dout[47:0],full,empty,prog_full";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_3,Vivado 2018.3";
begin
end;

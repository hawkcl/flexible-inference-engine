-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Mon Oct 21 13:41:31 2019
-- Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub -rename_top mem_s2_buffer -prefix
--               mem_s2_buffer_ mem_s2_buffer_stub.vhdl
-- Design      : mem_s2_buffer
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z100ffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mem_s2_buffer is
  Port ( 
    a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    d : in STD_LOGIC_VECTOR ( 167 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    spo : out STD_LOGIC_VECTOR ( 167 downto 0 )
  );

end mem_s2_buffer;

architecture stub of mem_s2_buffer is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a[3:0],d[167:0],clk,we,spo[167:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dist_mem_gen_v8_0_12,Vivado 2018.3";
begin
end;

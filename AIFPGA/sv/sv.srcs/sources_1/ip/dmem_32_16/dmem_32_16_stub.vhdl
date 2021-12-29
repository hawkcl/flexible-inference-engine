-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sat Dec 14 06:53:29 2019
-- Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub C:/AI/AIFPGA/sv/sv.srcs/sources_1/ip/dmem_32_16/dmem_32_16_stub.vhdl
-- Design      : dmem_32_16
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z100ffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dmem_32_16 is
  Port ( 
    a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    d : in STD_LOGIC_VECTOR ( 19 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 3 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    dpo : out STD_LOGIC_VECTOR ( 19 downto 0 )
  );

end dmem_32_16;

architecture stub of dmem_32_16 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "a[3:0],d[19:0],dpra[3:0],clk,we,dpo[19:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dist_mem_gen_v8_0_12,Vivado 2018.3";
begin
end;

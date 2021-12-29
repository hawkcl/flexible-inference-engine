-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Mon Oct 21 13:41:31 2019
-- Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode funcsim -rename_top mem_s2_buffer -prefix
--               mem_s2_buffer_ mem_s2_buffer_sim_netlist.vhdl
-- Design      : mem_s2_buffer
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z100ffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mem_s2_buffer_spram is
  port (
    spo : out STD_LOGIC_VECTOR ( 167 downto 0 );
    clk : in STD_LOGIC;
    d : in STD_LOGIC_VECTOR ( 167 downto 0 );
    we : in STD_LOGIC;
    a : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end mem_s2_buffer_spram;

architecture STRUCTURE of mem_s2_buffer_spram is
  signal qspo_int : STD_LOGIC_VECTOR ( 167 downto 0 );
  attribute RTL_KEEP : string;
  attribute RTL_KEEP of qspo_int : signal is "true";
  signal \^spo\ : STD_LOGIC_VECTOR ( 167 downto 0 );
  attribute KEEP : string;
  attribute KEEP of \qspo_int_reg[0]\ : label is "yes";
  attribute equivalent_register_removal : string;
  attribute equivalent_register_removal of \qspo_int_reg[0]\ : label is "no";
  attribute KEEP of \qspo_int_reg[100]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[100]\ : label is "no";
  attribute KEEP of \qspo_int_reg[101]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[101]\ : label is "no";
  attribute KEEP of \qspo_int_reg[102]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[102]\ : label is "no";
  attribute KEEP of \qspo_int_reg[103]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[103]\ : label is "no";
  attribute KEEP of \qspo_int_reg[104]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[104]\ : label is "no";
  attribute KEEP of \qspo_int_reg[105]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[105]\ : label is "no";
  attribute KEEP of \qspo_int_reg[106]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[106]\ : label is "no";
  attribute KEEP of \qspo_int_reg[107]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[107]\ : label is "no";
  attribute KEEP of \qspo_int_reg[108]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[108]\ : label is "no";
  attribute KEEP of \qspo_int_reg[109]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[109]\ : label is "no";
  attribute KEEP of \qspo_int_reg[10]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[10]\ : label is "no";
  attribute KEEP of \qspo_int_reg[110]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[110]\ : label is "no";
  attribute KEEP of \qspo_int_reg[111]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[111]\ : label is "no";
  attribute KEEP of \qspo_int_reg[112]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[112]\ : label is "no";
  attribute KEEP of \qspo_int_reg[113]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[113]\ : label is "no";
  attribute KEEP of \qspo_int_reg[114]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[114]\ : label is "no";
  attribute KEEP of \qspo_int_reg[115]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[115]\ : label is "no";
  attribute KEEP of \qspo_int_reg[116]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[116]\ : label is "no";
  attribute KEEP of \qspo_int_reg[117]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[117]\ : label is "no";
  attribute KEEP of \qspo_int_reg[118]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[118]\ : label is "no";
  attribute KEEP of \qspo_int_reg[119]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[119]\ : label is "no";
  attribute KEEP of \qspo_int_reg[11]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[11]\ : label is "no";
  attribute KEEP of \qspo_int_reg[120]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[120]\ : label is "no";
  attribute KEEP of \qspo_int_reg[121]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[121]\ : label is "no";
  attribute KEEP of \qspo_int_reg[122]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[122]\ : label is "no";
  attribute KEEP of \qspo_int_reg[123]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[123]\ : label is "no";
  attribute KEEP of \qspo_int_reg[124]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[124]\ : label is "no";
  attribute KEEP of \qspo_int_reg[125]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[125]\ : label is "no";
  attribute KEEP of \qspo_int_reg[126]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[126]\ : label is "no";
  attribute KEEP of \qspo_int_reg[127]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[127]\ : label is "no";
  attribute KEEP of \qspo_int_reg[128]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[128]\ : label is "no";
  attribute KEEP of \qspo_int_reg[129]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[129]\ : label is "no";
  attribute KEEP of \qspo_int_reg[12]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[12]\ : label is "no";
  attribute KEEP of \qspo_int_reg[130]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[130]\ : label is "no";
  attribute KEEP of \qspo_int_reg[131]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[131]\ : label is "no";
  attribute KEEP of \qspo_int_reg[132]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[132]\ : label is "no";
  attribute KEEP of \qspo_int_reg[133]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[133]\ : label is "no";
  attribute KEEP of \qspo_int_reg[134]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[134]\ : label is "no";
  attribute KEEP of \qspo_int_reg[135]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[135]\ : label is "no";
  attribute KEEP of \qspo_int_reg[136]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[136]\ : label is "no";
  attribute KEEP of \qspo_int_reg[137]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[137]\ : label is "no";
  attribute KEEP of \qspo_int_reg[138]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[138]\ : label is "no";
  attribute KEEP of \qspo_int_reg[139]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[139]\ : label is "no";
  attribute KEEP of \qspo_int_reg[13]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[13]\ : label is "no";
  attribute KEEP of \qspo_int_reg[140]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[140]\ : label is "no";
  attribute KEEP of \qspo_int_reg[141]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[141]\ : label is "no";
  attribute KEEP of \qspo_int_reg[142]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[142]\ : label is "no";
  attribute KEEP of \qspo_int_reg[143]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[143]\ : label is "no";
  attribute KEEP of \qspo_int_reg[144]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[144]\ : label is "no";
  attribute KEEP of \qspo_int_reg[145]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[145]\ : label is "no";
  attribute KEEP of \qspo_int_reg[146]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[146]\ : label is "no";
  attribute KEEP of \qspo_int_reg[147]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[147]\ : label is "no";
  attribute KEEP of \qspo_int_reg[148]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[148]\ : label is "no";
  attribute KEEP of \qspo_int_reg[149]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[149]\ : label is "no";
  attribute KEEP of \qspo_int_reg[14]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[14]\ : label is "no";
  attribute KEEP of \qspo_int_reg[150]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[150]\ : label is "no";
  attribute KEEP of \qspo_int_reg[151]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[151]\ : label is "no";
  attribute KEEP of \qspo_int_reg[152]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[152]\ : label is "no";
  attribute KEEP of \qspo_int_reg[153]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[153]\ : label is "no";
  attribute KEEP of \qspo_int_reg[154]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[154]\ : label is "no";
  attribute KEEP of \qspo_int_reg[155]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[155]\ : label is "no";
  attribute KEEP of \qspo_int_reg[156]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[156]\ : label is "no";
  attribute KEEP of \qspo_int_reg[157]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[157]\ : label is "no";
  attribute KEEP of \qspo_int_reg[158]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[158]\ : label is "no";
  attribute KEEP of \qspo_int_reg[159]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[159]\ : label is "no";
  attribute KEEP of \qspo_int_reg[15]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[15]\ : label is "no";
  attribute KEEP of \qspo_int_reg[160]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[160]\ : label is "no";
  attribute KEEP of \qspo_int_reg[161]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[161]\ : label is "no";
  attribute KEEP of \qspo_int_reg[162]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[162]\ : label is "no";
  attribute KEEP of \qspo_int_reg[163]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[163]\ : label is "no";
  attribute KEEP of \qspo_int_reg[164]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[164]\ : label is "no";
  attribute KEEP of \qspo_int_reg[165]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[165]\ : label is "no";
  attribute KEEP of \qspo_int_reg[166]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[166]\ : label is "no";
  attribute KEEP of \qspo_int_reg[167]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[167]\ : label is "no";
  attribute KEEP of \qspo_int_reg[16]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[16]\ : label is "no";
  attribute KEEP of \qspo_int_reg[17]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[17]\ : label is "no";
  attribute KEEP of \qspo_int_reg[18]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[18]\ : label is "no";
  attribute KEEP of \qspo_int_reg[19]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[19]\ : label is "no";
  attribute KEEP of \qspo_int_reg[1]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[1]\ : label is "no";
  attribute KEEP of \qspo_int_reg[20]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[20]\ : label is "no";
  attribute KEEP of \qspo_int_reg[21]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[21]\ : label is "no";
  attribute KEEP of \qspo_int_reg[22]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[22]\ : label is "no";
  attribute KEEP of \qspo_int_reg[23]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[23]\ : label is "no";
  attribute KEEP of \qspo_int_reg[24]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[24]\ : label is "no";
  attribute KEEP of \qspo_int_reg[25]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[25]\ : label is "no";
  attribute KEEP of \qspo_int_reg[26]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[26]\ : label is "no";
  attribute KEEP of \qspo_int_reg[27]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[27]\ : label is "no";
  attribute KEEP of \qspo_int_reg[28]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[28]\ : label is "no";
  attribute KEEP of \qspo_int_reg[29]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[29]\ : label is "no";
  attribute KEEP of \qspo_int_reg[2]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[2]\ : label is "no";
  attribute KEEP of \qspo_int_reg[30]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[30]\ : label is "no";
  attribute KEEP of \qspo_int_reg[31]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[31]\ : label is "no";
  attribute KEEP of \qspo_int_reg[32]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[32]\ : label is "no";
  attribute KEEP of \qspo_int_reg[33]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[33]\ : label is "no";
  attribute KEEP of \qspo_int_reg[34]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[34]\ : label is "no";
  attribute KEEP of \qspo_int_reg[35]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[35]\ : label is "no";
  attribute KEEP of \qspo_int_reg[36]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[36]\ : label is "no";
  attribute KEEP of \qspo_int_reg[37]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[37]\ : label is "no";
  attribute KEEP of \qspo_int_reg[38]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[38]\ : label is "no";
  attribute KEEP of \qspo_int_reg[39]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[39]\ : label is "no";
  attribute KEEP of \qspo_int_reg[3]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[3]\ : label is "no";
  attribute KEEP of \qspo_int_reg[40]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[40]\ : label is "no";
  attribute KEEP of \qspo_int_reg[41]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[41]\ : label is "no";
  attribute KEEP of \qspo_int_reg[42]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[42]\ : label is "no";
  attribute KEEP of \qspo_int_reg[43]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[43]\ : label is "no";
  attribute KEEP of \qspo_int_reg[44]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[44]\ : label is "no";
  attribute KEEP of \qspo_int_reg[45]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[45]\ : label is "no";
  attribute KEEP of \qspo_int_reg[46]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[46]\ : label is "no";
  attribute KEEP of \qspo_int_reg[47]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[47]\ : label is "no";
  attribute KEEP of \qspo_int_reg[48]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[48]\ : label is "no";
  attribute KEEP of \qspo_int_reg[49]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[49]\ : label is "no";
  attribute KEEP of \qspo_int_reg[4]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[4]\ : label is "no";
  attribute KEEP of \qspo_int_reg[50]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[50]\ : label is "no";
  attribute KEEP of \qspo_int_reg[51]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[51]\ : label is "no";
  attribute KEEP of \qspo_int_reg[52]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[52]\ : label is "no";
  attribute KEEP of \qspo_int_reg[53]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[53]\ : label is "no";
  attribute KEEP of \qspo_int_reg[54]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[54]\ : label is "no";
  attribute KEEP of \qspo_int_reg[55]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[55]\ : label is "no";
  attribute KEEP of \qspo_int_reg[56]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[56]\ : label is "no";
  attribute KEEP of \qspo_int_reg[57]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[57]\ : label is "no";
  attribute KEEP of \qspo_int_reg[58]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[58]\ : label is "no";
  attribute KEEP of \qspo_int_reg[59]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[59]\ : label is "no";
  attribute KEEP of \qspo_int_reg[5]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[5]\ : label is "no";
  attribute KEEP of \qspo_int_reg[60]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[60]\ : label is "no";
  attribute KEEP of \qspo_int_reg[61]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[61]\ : label is "no";
  attribute KEEP of \qspo_int_reg[62]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[62]\ : label is "no";
  attribute KEEP of \qspo_int_reg[63]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[63]\ : label is "no";
  attribute KEEP of \qspo_int_reg[64]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[64]\ : label is "no";
  attribute KEEP of \qspo_int_reg[65]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[65]\ : label is "no";
  attribute KEEP of \qspo_int_reg[66]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[66]\ : label is "no";
  attribute KEEP of \qspo_int_reg[67]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[67]\ : label is "no";
  attribute KEEP of \qspo_int_reg[68]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[68]\ : label is "no";
  attribute KEEP of \qspo_int_reg[69]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[69]\ : label is "no";
  attribute KEEP of \qspo_int_reg[6]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[6]\ : label is "no";
  attribute KEEP of \qspo_int_reg[70]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[70]\ : label is "no";
  attribute KEEP of \qspo_int_reg[71]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[71]\ : label is "no";
  attribute KEEP of \qspo_int_reg[72]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[72]\ : label is "no";
  attribute KEEP of \qspo_int_reg[73]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[73]\ : label is "no";
  attribute KEEP of \qspo_int_reg[74]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[74]\ : label is "no";
  attribute KEEP of \qspo_int_reg[75]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[75]\ : label is "no";
  attribute KEEP of \qspo_int_reg[76]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[76]\ : label is "no";
  attribute KEEP of \qspo_int_reg[77]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[77]\ : label is "no";
  attribute KEEP of \qspo_int_reg[78]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[78]\ : label is "no";
  attribute KEEP of \qspo_int_reg[79]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[79]\ : label is "no";
  attribute KEEP of \qspo_int_reg[7]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[7]\ : label is "no";
  attribute KEEP of \qspo_int_reg[80]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[80]\ : label is "no";
  attribute KEEP of \qspo_int_reg[81]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[81]\ : label is "no";
  attribute KEEP of \qspo_int_reg[82]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[82]\ : label is "no";
  attribute KEEP of \qspo_int_reg[83]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[83]\ : label is "no";
  attribute KEEP of \qspo_int_reg[84]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[84]\ : label is "no";
  attribute KEEP of \qspo_int_reg[85]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[85]\ : label is "no";
  attribute KEEP of \qspo_int_reg[86]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[86]\ : label is "no";
  attribute KEEP of \qspo_int_reg[87]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[87]\ : label is "no";
  attribute KEEP of \qspo_int_reg[88]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[88]\ : label is "no";
  attribute KEEP of \qspo_int_reg[89]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[89]\ : label is "no";
  attribute KEEP of \qspo_int_reg[8]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[8]\ : label is "no";
  attribute KEEP of \qspo_int_reg[90]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[90]\ : label is "no";
  attribute KEEP of \qspo_int_reg[91]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[91]\ : label is "no";
  attribute KEEP of \qspo_int_reg[92]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[92]\ : label is "no";
  attribute KEEP of \qspo_int_reg[93]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[93]\ : label is "no";
  attribute KEEP of \qspo_int_reg[94]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[94]\ : label is "no";
  attribute KEEP of \qspo_int_reg[95]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[95]\ : label is "no";
  attribute KEEP of \qspo_int_reg[96]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[96]\ : label is "no";
  attribute KEEP of \qspo_int_reg[97]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[97]\ : label is "no";
  attribute KEEP of \qspo_int_reg[98]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[98]\ : label is "no";
  attribute KEEP of \qspo_int_reg[99]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[99]\ : label is "no";
  attribute KEEP of \qspo_int_reg[9]\ : label is "yes";
  attribute equivalent_register_removal of \qspo_int_reg[9]\ : label is "no";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_0_0 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_100_100 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_101_101 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_102_102 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_103_103 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_104_104 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_105_105 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_106_106 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_107_107 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_108_108 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_109_109 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_10_10 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_110_110 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_111_111 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_112_112 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_113_113 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_114_114 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_115_115 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_116_116 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_117_117 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_118_118 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_119_119 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_11_11 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_120_120 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_121_121 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_122_122 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_123_123 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_124_124 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_125_125 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_126_126 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_127_127 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_128_128 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_129_129 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_12_12 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_130_130 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_131_131 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_132_132 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_133_133 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_134_134 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_135_135 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_136_136 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_137_137 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_138_138 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_139_139 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_13_13 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_140_140 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_141_141 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_142_142 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_143_143 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_144_144 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_145_145 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_146_146 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_147_147 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_148_148 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_149_149 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_14_14 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_150_150 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_151_151 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_152_152 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_153_153 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_154_154 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_155_155 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_156_156 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_157_157 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_158_158 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_159_159 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_15_15 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_160_160 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_161_161 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_162_162 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_163_163 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_164_164 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_165_165 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_166_166 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_167_167 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_16_16 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_17_17 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_18_18 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_19_19 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_1_1 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_20_20 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_21_21 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_22_22 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_23_23 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_24_24 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_25_25 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_26_26 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_27_27 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_28_28 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_29_29 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_2_2 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_30_30 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_31_31 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_32_32 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_33_33 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_34_34 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_35_35 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_36_36 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_37_37 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_38_38 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_39_39 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_3_3 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_40_40 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_41_41 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_42_42 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_43_43 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_44_44 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_45_45 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_46_46 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_47_47 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_48_48 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_49_49 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_4_4 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_50_50 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_51_51 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_52_52 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_53_53 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_54_54 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_55_55 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_56_56 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_57_57 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_58_58 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_59_59 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_5_5 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_60_60 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_61_61 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_62_62 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_63_63 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_64_64 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_65_65 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_66_66 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_67_67 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_68_68 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_69_69 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_6_6 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_70_70 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_71_71 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_72_72 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_73_73 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_74_74 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_75_75 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_76_76 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_77_77 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_78_78 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_79_79 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_7_7 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_80_80 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_81_81 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_82_82 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_83_83 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_84_84 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_85_85 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_86_86 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_87_87 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_88_88 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_89_89 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_8_8 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_90_90 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_91_91 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_92_92 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_93_93 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_94_94 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_95_95 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_96_96 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_97_97 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_98_98 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_99_99 : label is "RAM16X1S";
  attribute XILINX_LEGACY_PRIM of ram_reg_0_15_9_9 : label is "RAM16X1S";
begin
  spo(167 downto 0) <= \^spo\(167 downto 0);
\qspo_int_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(0),
      Q => qspo_int(0),
      R => '0'
    );
\qspo_int_reg[100]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(100),
      Q => qspo_int(100),
      R => '0'
    );
\qspo_int_reg[101]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(101),
      Q => qspo_int(101),
      R => '0'
    );
\qspo_int_reg[102]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(102),
      Q => qspo_int(102),
      R => '0'
    );
\qspo_int_reg[103]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(103),
      Q => qspo_int(103),
      R => '0'
    );
\qspo_int_reg[104]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(104),
      Q => qspo_int(104),
      R => '0'
    );
\qspo_int_reg[105]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(105),
      Q => qspo_int(105),
      R => '0'
    );
\qspo_int_reg[106]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(106),
      Q => qspo_int(106),
      R => '0'
    );
\qspo_int_reg[107]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(107),
      Q => qspo_int(107),
      R => '0'
    );
\qspo_int_reg[108]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(108),
      Q => qspo_int(108),
      R => '0'
    );
\qspo_int_reg[109]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(109),
      Q => qspo_int(109),
      R => '0'
    );
\qspo_int_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(10),
      Q => qspo_int(10),
      R => '0'
    );
\qspo_int_reg[110]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(110),
      Q => qspo_int(110),
      R => '0'
    );
\qspo_int_reg[111]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(111),
      Q => qspo_int(111),
      R => '0'
    );
\qspo_int_reg[112]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(112),
      Q => qspo_int(112),
      R => '0'
    );
\qspo_int_reg[113]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(113),
      Q => qspo_int(113),
      R => '0'
    );
\qspo_int_reg[114]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(114),
      Q => qspo_int(114),
      R => '0'
    );
\qspo_int_reg[115]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(115),
      Q => qspo_int(115),
      R => '0'
    );
\qspo_int_reg[116]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(116),
      Q => qspo_int(116),
      R => '0'
    );
\qspo_int_reg[117]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(117),
      Q => qspo_int(117),
      R => '0'
    );
\qspo_int_reg[118]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(118),
      Q => qspo_int(118),
      R => '0'
    );
\qspo_int_reg[119]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(119),
      Q => qspo_int(119),
      R => '0'
    );
\qspo_int_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(11),
      Q => qspo_int(11),
      R => '0'
    );
\qspo_int_reg[120]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(120),
      Q => qspo_int(120),
      R => '0'
    );
\qspo_int_reg[121]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(121),
      Q => qspo_int(121),
      R => '0'
    );
\qspo_int_reg[122]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(122),
      Q => qspo_int(122),
      R => '0'
    );
\qspo_int_reg[123]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(123),
      Q => qspo_int(123),
      R => '0'
    );
\qspo_int_reg[124]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(124),
      Q => qspo_int(124),
      R => '0'
    );
\qspo_int_reg[125]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(125),
      Q => qspo_int(125),
      R => '0'
    );
\qspo_int_reg[126]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(126),
      Q => qspo_int(126),
      R => '0'
    );
\qspo_int_reg[127]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(127),
      Q => qspo_int(127),
      R => '0'
    );
\qspo_int_reg[128]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(128),
      Q => qspo_int(128),
      R => '0'
    );
\qspo_int_reg[129]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(129),
      Q => qspo_int(129),
      R => '0'
    );
\qspo_int_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(12),
      Q => qspo_int(12),
      R => '0'
    );
\qspo_int_reg[130]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(130),
      Q => qspo_int(130),
      R => '0'
    );
\qspo_int_reg[131]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(131),
      Q => qspo_int(131),
      R => '0'
    );
\qspo_int_reg[132]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(132),
      Q => qspo_int(132),
      R => '0'
    );
\qspo_int_reg[133]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(133),
      Q => qspo_int(133),
      R => '0'
    );
\qspo_int_reg[134]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(134),
      Q => qspo_int(134),
      R => '0'
    );
\qspo_int_reg[135]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(135),
      Q => qspo_int(135),
      R => '0'
    );
\qspo_int_reg[136]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(136),
      Q => qspo_int(136),
      R => '0'
    );
\qspo_int_reg[137]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(137),
      Q => qspo_int(137),
      R => '0'
    );
\qspo_int_reg[138]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(138),
      Q => qspo_int(138),
      R => '0'
    );
\qspo_int_reg[139]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(139),
      Q => qspo_int(139),
      R => '0'
    );
\qspo_int_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(13),
      Q => qspo_int(13),
      R => '0'
    );
\qspo_int_reg[140]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(140),
      Q => qspo_int(140),
      R => '0'
    );
\qspo_int_reg[141]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(141),
      Q => qspo_int(141),
      R => '0'
    );
\qspo_int_reg[142]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(142),
      Q => qspo_int(142),
      R => '0'
    );
\qspo_int_reg[143]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(143),
      Q => qspo_int(143),
      R => '0'
    );
\qspo_int_reg[144]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(144),
      Q => qspo_int(144),
      R => '0'
    );
\qspo_int_reg[145]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(145),
      Q => qspo_int(145),
      R => '0'
    );
\qspo_int_reg[146]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(146),
      Q => qspo_int(146),
      R => '0'
    );
\qspo_int_reg[147]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(147),
      Q => qspo_int(147),
      R => '0'
    );
\qspo_int_reg[148]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(148),
      Q => qspo_int(148),
      R => '0'
    );
\qspo_int_reg[149]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(149),
      Q => qspo_int(149),
      R => '0'
    );
\qspo_int_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(14),
      Q => qspo_int(14),
      R => '0'
    );
\qspo_int_reg[150]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(150),
      Q => qspo_int(150),
      R => '0'
    );
\qspo_int_reg[151]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(151),
      Q => qspo_int(151),
      R => '0'
    );
\qspo_int_reg[152]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(152),
      Q => qspo_int(152),
      R => '0'
    );
\qspo_int_reg[153]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(153),
      Q => qspo_int(153),
      R => '0'
    );
\qspo_int_reg[154]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(154),
      Q => qspo_int(154),
      R => '0'
    );
\qspo_int_reg[155]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(155),
      Q => qspo_int(155),
      R => '0'
    );
\qspo_int_reg[156]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(156),
      Q => qspo_int(156),
      R => '0'
    );
\qspo_int_reg[157]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(157),
      Q => qspo_int(157),
      R => '0'
    );
\qspo_int_reg[158]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(158),
      Q => qspo_int(158),
      R => '0'
    );
\qspo_int_reg[159]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(159),
      Q => qspo_int(159),
      R => '0'
    );
\qspo_int_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(15),
      Q => qspo_int(15),
      R => '0'
    );
\qspo_int_reg[160]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(160),
      Q => qspo_int(160),
      R => '0'
    );
\qspo_int_reg[161]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(161),
      Q => qspo_int(161),
      R => '0'
    );
\qspo_int_reg[162]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(162),
      Q => qspo_int(162),
      R => '0'
    );
\qspo_int_reg[163]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(163),
      Q => qspo_int(163),
      R => '0'
    );
\qspo_int_reg[164]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(164),
      Q => qspo_int(164),
      R => '0'
    );
\qspo_int_reg[165]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(165),
      Q => qspo_int(165),
      R => '0'
    );
\qspo_int_reg[166]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(166),
      Q => qspo_int(166),
      R => '0'
    );
\qspo_int_reg[167]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(167),
      Q => qspo_int(167),
      R => '0'
    );
\qspo_int_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(16),
      Q => qspo_int(16),
      R => '0'
    );
\qspo_int_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(17),
      Q => qspo_int(17),
      R => '0'
    );
\qspo_int_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(18),
      Q => qspo_int(18),
      R => '0'
    );
\qspo_int_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(19),
      Q => qspo_int(19),
      R => '0'
    );
\qspo_int_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(1),
      Q => qspo_int(1),
      R => '0'
    );
\qspo_int_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(20),
      Q => qspo_int(20),
      R => '0'
    );
\qspo_int_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(21),
      Q => qspo_int(21),
      R => '0'
    );
\qspo_int_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(22),
      Q => qspo_int(22),
      R => '0'
    );
\qspo_int_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(23),
      Q => qspo_int(23),
      R => '0'
    );
\qspo_int_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(24),
      Q => qspo_int(24),
      R => '0'
    );
\qspo_int_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(25),
      Q => qspo_int(25),
      R => '0'
    );
\qspo_int_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(26),
      Q => qspo_int(26),
      R => '0'
    );
\qspo_int_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(27),
      Q => qspo_int(27),
      R => '0'
    );
\qspo_int_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(28),
      Q => qspo_int(28),
      R => '0'
    );
\qspo_int_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(29),
      Q => qspo_int(29),
      R => '0'
    );
\qspo_int_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(2),
      Q => qspo_int(2),
      R => '0'
    );
\qspo_int_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(30),
      Q => qspo_int(30),
      R => '0'
    );
\qspo_int_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(31),
      Q => qspo_int(31),
      R => '0'
    );
\qspo_int_reg[32]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(32),
      Q => qspo_int(32),
      R => '0'
    );
\qspo_int_reg[33]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(33),
      Q => qspo_int(33),
      R => '0'
    );
\qspo_int_reg[34]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(34),
      Q => qspo_int(34),
      R => '0'
    );
\qspo_int_reg[35]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(35),
      Q => qspo_int(35),
      R => '0'
    );
\qspo_int_reg[36]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(36),
      Q => qspo_int(36),
      R => '0'
    );
\qspo_int_reg[37]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(37),
      Q => qspo_int(37),
      R => '0'
    );
\qspo_int_reg[38]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(38),
      Q => qspo_int(38),
      R => '0'
    );
\qspo_int_reg[39]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(39),
      Q => qspo_int(39),
      R => '0'
    );
\qspo_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(3),
      Q => qspo_int(3),
      R => '0'
    );
\qspo_int_reg[40]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(40),
      Q => qspo_int(40),
      R => '0'
    );
\qspo_int_reg[41]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(41),
      Q => qspo_int(41),
      R => '0'
    );
\qspo_int_reg[42]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(42),
      Q => qspo_int(42),
      R => '0'
    );
\qspo_int_reg[43]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(43),
      Q => qspo_int(43),
      R => '0'
    );
\qspo_int_reg[44]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(44),
      Q => qspo_int(44),
      R => '0'
    );
\qspo_int_reg[45]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(45),
      Q => qspo_int(45),
      R => '0'
    );
\qspo_int_reg[46]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(46),
      Q => qspo_int(46),
      R => '0'
    );
\qspo_int_reg[47]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(47),
      Q => qspo_int(47),
      R => '0'
    );
\qspo_int_reg[48]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(48),
      Q => qspo_int(48),
      R => '0'
    );
\qspo_int_reg[49]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(49),
      Q => qspo_int(49),
      R => '0'
    );
\qspo_int_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(4),
      Q => qspo_int(4),
      R => '0'
    );
\qspo_int_reg[50]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(50),
      Q => qspo_int(50),
      R => '0'
    );
\qspo_int_reg[51]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(51),
      Q => qspo_int(51),
      R => '0'
    );
\qspo_int_reg[52]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(52),
      Q => qspo_int(52),
      R => '0'
    );
\qspo_int_reg[53]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(53),
      Q => qspo_int(53),
      R => '0'
    );
\qspo_int_reg[54]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(54),
      Q => qspo_int(54),
      R => '0'
    );
\qspo_int_reg[55]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(55),
      Q => qspo_int(55),
      R => '0'
    );
\qspo_int_reg[56]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(56),
      Q => qspo_int(56),
      R => '0'
    );
\qspo_int_reg[57]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(57),
      Q => qspo_int(57),
      R => '0'
    );
\qspo_int_reg[58]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(58),
      Q => qspo_int(58),
      R => '0'
    );
\qspo_int_reg[59]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(59),
      Q => qspo_int(59),
      R => '0'
    );
\qspo_int_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(5),
      Q => qspo_int(5),
      R => '0'
    );
\qspo_int_reg[60]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(60),
      Q => qspo_int(60),
      R => '0'
    );
\qspo_int_reg[61]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(61),
      Q => qspo_int(61),
      R => '0'
    );
\qspo_int_reg[62]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(62),
      Q => qspo_int(62),
      R => '0'
    );
\qspo_int_reg[63]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(63),
      Q => qspo_int(63),
      R => '0'
    );
\qspo_int_reg[64]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(64),
      Q => qspo_int(64),
      R => '0'
    );
\qspo_int_reg[65]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(65),
      Q => qspo_int(65),
      R => '0'
    );
\qspo_int_reg[66]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(66),
      Q => qspo_int(66),
      R => '0'
    );
\qspo_int_reg[67]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(67),
      Q => qspo_int(67),
      R => '0'
    );
\qspo_int_reg[68]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(68),
      Q => qspo_int(68),
      R => '0'
    );
\qspo_int_reg[69]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(69),
      Q => qspo_int(69),
      R => '0'
    );
\qspo_int_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(6),
      Q => qspo_int(6),
      R => '0'
    );
\qspo_int_reg[70]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(70),
      Q => qspo_int(70),
      R => '0'
    );
\qspo_int_reg[71]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(71),
      Q => qspo_int(71),
      R => '0'
    );
\qspo_int_reg[72]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(72),
      Q => qspo_int(72),
      R => '0'
    );
\qspo_int_reg[73]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(73),
      Q => qspo_int(73),
      R => '0'
    );
\qspo_int_reg[74]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(74),
      Q => qspo_int(74),
      R => '0'
    );
\qspo_int_reg[75]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(75),
      Q => qspo_int(75),
      R => '0'
    );
\qspo_int_reg[76]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(76),
      Q => qspo_int(76),
      R => '0'
    );
\qspo_int_reg[77]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(77),
      Q => qspo_int(77),
      R => '0'
    );
\qspo_int_reg[78]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(78),
      Q => qspo_int(78),
      R => '0'
    );
\qspo_int_reg[79]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(79),
      Q => qspo_int(79),
      R => '0'
    );
\qspo_int_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(7),
      Q => qspo_int(7),
      R => '0'
    );
\qspo_int_reg[80]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(80),
      Q => qspo_int(80),
      R => '0'
    );
\qspo_int_reg[81]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(81),
      Q => qspo_int(81),
      R => '0'
    );
\qspo_int_reg[82]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(82),
      Q => qspo_int(82),
      R => '0'
    );
\qspo_int_reg[83]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(83),
      Q => qspo_int(83),
      R => '0'
    );
\qspo_int_reg[84]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(84),
      Q => qspo_int(84),
      R => '0'
    );
\qspo_int_reg[85]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(85),
      Q => qspo_int(85),
      R => '0'
    );
\qspo_int_reg[86]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(86),
      Q => qspo_int(86),
      R => '0'
    );
\qspo_int_reg[87]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(87),
      Q => qspo_int(87),
      R => '0'
    );
\qspo_int_reg[88]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(88),
      Q => qspo_int(88),
      R => '0'
    );
\qspo_int_reg[89]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(89),
      Q => qspo_int(89),
      R => '0'
    );
\qspo_int_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(8),
      Q => qspo_int(8),
      R => '0'
    );
\qspo_int_reg[90]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(90),
      Q => qspo_int(90),
      R => '0'
    );
\qspo_int_reg[91]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(91),
      Q => qspo_int(91),
      R => '0'
    );
\qspo_int_reg[92]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(92),
      Q => qspo_int(92),
      R => '0'
    );
\qspo_int_reg[93]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(93),
      Q => qspo_int(93),
      R => '0'
    );
\qspo_int_reg[94]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(94),
      Q => qspo_int(94),
      R => '0'
    );
\qspo_int_reg[95]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(95),
      Q => qspo_int(95),
      R => '0'
    );
\qspo_int_reg[96]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(96),
      Q => qspo_int(96),
      R => '0'
    );
\qspo_int_reg[97]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(97),
      Q => qspo_int(97),
      R => '0'
    );
\qspo_int_reg[98]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(98),
      Q => qspo_int(98),
      R => '0'
    );
\qspo_int_reg[99]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(99),
      Q => qspo_int(99),
      R => '0'
    );
\qspo_int_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^spo\(9),
      Q => qspo_int(9),
      R => '0'
    );
ram_reg_0_15_0_0: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(0),
      O => \^spo\(0),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_100_100: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(100),
      O => \^spo\(100),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_101_101: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(101),
      O => \^spo\(101),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_102_102: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(102),
      O => \^spo\(102),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_103_103: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(103),
      O => \^spo\(103),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_104_104: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(104),
      O => \^spo\(104),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_105_105: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(105),
      O => \^spo\(105),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_106_106: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(106),
      O => \^spo\(106),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_107_107: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(107),
      O => \^spo\(107),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_108_108: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(108),
      O => \^spo\(108),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_109_109: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(109),
      O => \^spo\(109),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_10_10: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(10),
      O => \^spo\(10),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_110_110: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(110),
      O => \^spo\(110),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_111_111: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(111),
      O => \^spo\(111),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_112_112: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(112),
      O => \^spo\(112),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_113_113: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(113),
      O => \^spo\(113),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_114_114: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(114),
      O => \^spo\(114),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_115_115: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(115),
      O => \^spo\(115),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_116_116: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(116),
      O => \^spo\(116),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_117_117: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(117),
      O => \^spo\(117),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_118_118: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(118),
      O => \^spo\(118),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_119_119: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(119),
      O => \^spo\(119),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_11_11: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(11),
      O => \^spo\(11),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_120_120: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(120),
      O => \^spo\(120),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_121_121: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(121),
      O => \^spo\(121),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_122_122: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(122),
      O => \^spo\(122),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_123_123: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(123),
      O => \^spo\(123),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_124_124: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(124),
      O => \^spo\(124),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_125_125: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(125),
      O => \^spo\(125),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_126_126: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(126),
      O => \^spo\(126),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_127_127: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(127),
      O => \^spo\(127),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_128_128: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(128),
      O => \^spo\(128),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_129_129: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(129),
      O => \^spo\(129),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_12_12: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(12),
      O => \^spo\(12),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_130_130: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(130),
      O => \^spo\(130),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_131_131: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(131),
      O => \^spo\(131),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_132_132: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(132),
      O => \^spo\(132),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_133_133: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(133),
      O => \^spo\(133),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_134_134: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(134),
      O => \^spo\(134),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_135_135: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(135),
      O => \^spo\(135),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_136_136: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(136),
      O => \^spo\(136),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_137_137: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(137),
      O => \^spo\(137),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_138_138: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(138),
      O => \^spo\(138),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_139_139: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(139),
      O => \^spo\(139),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_13_13: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(13),
      O => \^spo\(13),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_140_140: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(140),
      O => \^spo\(140),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_141_141: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(141),
      O => \^spo\(141),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_142_142: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(142),
      O => \^spo\(142),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_143_143: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(143),
      O => \^spo\(143),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_144_144: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(144),
      O => \^spo\(144),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_145_145: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(145),
      O => \^spo\(145),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_146_146: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(146),
      O => \^spo\(146),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_147_147: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(147),
      O => \^spo\(147),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_148_148: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(148),
      O => \^spo\(148),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_149_149: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(149),
      O => \^spo\(149),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_14_14: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(14),
      O => \^spo\(14),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_150_150: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(150),
      O => \^spo\(150),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_151_151: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(151),
      O => \^spo\(151),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_152_152: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(152),
      O => \^spo\(152),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_153_153: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(153),
      O => \^spo\(153),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_154_154: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(154),
      O => \^spo\(154),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_155_155: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(155),
      O => \^spo\(155),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_156_156: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(156),
      O => \^spo\(156),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_157_157: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(157),
      O => \^spo\(157),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_158_158: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(158),
      O => \^spo\(158),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_159_159: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(159),
      O => \^spo\(159),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_15_15: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(15),
      O => \^spo\(15),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_160_160: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(160),
      O => \^spo\(160),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_161_161: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(161),
      O => \^spo\(161),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_162_162: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(162),
      O => \^spo\(162),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_163_163: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(163),
      O => \^spo\(163),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_164_164: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(164),
      O => \^spo\(164),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_165_165: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(165),
      O => \^spo\(165),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_166_166: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(166),
      O => \^spo\(166),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_167_167: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(167),
      O => \^spo\(167),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_16_16: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(16),
      O => \^spo\(16),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_17_17: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(17),
      O => \^spo\(17),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_18_18: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(18),
      O => \^spo\(18),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_19_19: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(19),
      O => \^spo\(19),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_1_1: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(1),
      O => \^spo\(1),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_20_20: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(20),
      O => \^spo\(20),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_21_21: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(21),
      O => \^spo\(21),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_22_22: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(22),
      O => \^spo\(22),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_23_23: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(23),
      O => \^spo\(23),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_24_24: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(24),
      O => \^spo\(24),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_25_25: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(25),
      O => \^spo\(25),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_26_26: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(26),
      O => \^spo\(26),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_27_27: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(27),
      O => \^spo\(27),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_28_28: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(28),
      O => \^spo\(28),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_29_29: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(29),
      O => \^spo\(29),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_2_2: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(2),
      O => \^spo\(2),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_30_30: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(30),
      O => \^spo\(30),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_31_31: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(31),
      O => \^spo\(31),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_32_32: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(32),
      O => \^spo\(32),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_33_33: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(33),
      O => \^spo\(33),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_34_34: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(34),
      O => \^spo\(34),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_35_35: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(35),
      O => \^spo\(35),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_36_36: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(36),
      O => \^spo\(36),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_37_37: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(37),
      O => \^spo\(37),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_38_38: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(38),
      O => \^spo\(38),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_39_39: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(39),
      O => \^spo\(39),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_3_3: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(3),
      O => \^spo\(3),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_40_40: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(40),
      O => \^spo\(40),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_41_41: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(41),
      O => \^spo\(41),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_42_42: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(42),
      O => \^spo\(42),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_43_43: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(43),
      O => \^spo\(43),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_44_44: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(44),
      O => \^spo\(44),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_45_45: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(45),
      O => \^spo\(45),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_46_46: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(46),
      O => \^spo\(46),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_47_47: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(47),
      O => \^spo\(47),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_48_48: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(48),
      O => \^spo\(48),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_49_49: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(49),
      O => \^spo\(49),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_4_4: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(4),
      O => \^spo\(4),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_50_50: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(50),
      O => \^spo\(50),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_51_51: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(51),
      O => \^spo\(51),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_52_52: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(52),
      O => \^spo\(52),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_53_53: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(53),
      O => \^spo\(53),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_54_54: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(54),
      O => \^spo\(54),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_55_55: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(55),
      O => \^spo\(55),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_56_56: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(56),
      O => \^spo\(56),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_57_57: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(57),
      O => \^spo\(57),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_58_58: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(58),
      O => \^spo\(58),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_59_59: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(59),
      O => \^spo\(59),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_5_5: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(5),
      O => \^spo\(5),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_60_60: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(60),
      O => \^spo\(60),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_61_61: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(61),
      O => \^spo\(61),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_62_62: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(62),
      O => \^spo\(62),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_63_63: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(63),
      O => \^spo\(63),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_64_64: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(64),
      O => \^spo\(64),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_65_65: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(65),
      O => \^spo\(65),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_66_66: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(66),
      O => \^spo\(66),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_67_67: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(67),
      O => \^spo\(67),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_68_68: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(68),
      O => \^spo\(68),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_69_69: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(69),
      O => \^spo\(69),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_6_6: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(6),
      O => \^spo\(6),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_70_70: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(70),
      O => \^spo\(70),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_71_71: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(71),
      O => \^spo\(71),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_72_72: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(72),
      O => \^spo\(72),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_73_73: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(73),
      O => \^spo\(73),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_74_74: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(74),
      O => \^spo\(74),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_75_75: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(75),
      O => \^spo\(75),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_76_76: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(76),
      O => \^spo\(76),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_77_77: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(77),
      O => \^spo\(77),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_78_78: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(78),
      O => \^spo\(78),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_79_79: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(79),
      O => \^spo\(79),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_7_7: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(7),
      O => \^spo\(7),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_80_80: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(80),
      O => \^spo\(80),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_81_81: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(81),
      O => \^spo\(81),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_82_82: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(82),
      O => \^spo\(82),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_83_83: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(83),
      O => \^spo\(83),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_84_84: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(84),
      O => \^spo\(84),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_85_85: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(85),
      O => \^spo\(85),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_86_86: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(86),
      O => \^spo\(86),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_87_87: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(87),
      O => \^spo\(87),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_88_88: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(88),
      O => \^spo\(88),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_89_89: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(89),
      O => \^spo\(89),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_8_8: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(8),
      O => \^spo\(8),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_90_90: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(90),
      O => \^spo\(90),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_91_91: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(91),
      O => \^spo\(91),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_92_92: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(92),
      O => \^spo\(92),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_93_93: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(93),
      O => \^spo\(93),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_94_94: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(94),
      O => \^spo\(94),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_95_95: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(95),
      O => \^spo\(95),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_96_96: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(96),
      O => \^spo\(96),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_97_97: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(97),
      O => \^spo\(97),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_98_98: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(98),
      O => \^spo\(98),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_99_99: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(99),
      O => \^spo\(99),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_9_9: unisim.vcomponents.RAM32X1S
    generic map(
      INIT => X"00000000"
    )
        port map (
      A0 => a(0),
      A1 => a(1),
      A2 => a(2),
      A3 => a(3),
      A4 => '0',
      D => d(9),
      O => \^spo\(9),
      WCLK => clk,
      WE => we
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mem_s2_buffer_dist_mem_gen_v8_0_12_synth is
  port (
    spo : out STD_LOGIC_VECTOR ( 167 downto 0 );
    clk : in STD_LOGIC;
    d : in STD_LOGIC_VECTOR ( 167 downto 0 );
    we : in STD_LOGIC;
    a : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end mem_s2_buffer_dist_mem_gen_v8_0_12_synth;

architecture STRUCTURE of mem_s2_buffer_dist_mem_gen_v8_0_12_synth is
begin
\gen_sp_ram.spram_inst\: entity work.mem_s2_buffer_spram
     port map (
      a(3 downto 0) => a(3 downto 0),
      clk => clk,
      d(167 downto 0) => d(167 downto 0),
      spo(167 downto 0) => spo(167 downto 0),
      we => we
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mem_s2_buffer_dist_mem_gen_v8_0_12 is
  port (
    a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    d : in STD_LOGIC_VECTOR ( 167 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 3 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    i_ce : in STD_LOGIC;
    qspo_ce : in STD_LOGIC;
    qdpo_ce : in STD_LOGIC;
    qdpo_clk : in STD_LOGIC;
    qspo_rst : in STD_LOGIC;
    qdpo_rst : in STD_LOGIC;
    qspo_srst : in STD_LOGIC;
    qdpo_srst : in STD_LOGIC;
    spo : out STD_LOGIC_VECTOR ( 167 downto 0 );
    dpo : out STD_LOGIC_VECTOR ( 167 downto 0 );
    qspo : out STD_LOGIC_VECTOR ( 167 downto 0 );
    qdpo : out STD_LOGIC_VECTOR ( 167 downto 0 )
  );
  attribute C_ADDR_WIDTH : integer;
  attribute C_ADDR_WIDTH of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 4;
  attribute C_DEFAULT_DATA : string;
  attribute C_DEFAULT_DATA of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is "0";
  attribute C_DEPTH : integer;
  attribute C_DEPTH of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 16;
  attribute C_ELABORATION_DIR : string;
  attribute C_ELABORATION_DIR of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is "./";
  attribute C_FAMILY : string;
  attribute C_FAMILY of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is "zynq";
  attribute C_HAS_CLK : integer;
  attribute C_HAS_CLK of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_HAS_D : integer;
  attribute C_HAS_D of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_HAS_DPO : integer;
  attribute C_HAS_DPO of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_DPRA : integer;
  attribute C_HAS_DPRA of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_I_CE : integer;
  attribute C_HAS_I_CE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO : integer;
  attribute C_HAS_QDPO of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO_CE : integer;
  attribute C_HAS_QDPO_CE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO_CLK : integer;
  attribute C_HAS_QDPO_CLK of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO_RST : integer;
  attribute C_HAS_QDPO_RST of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO_SRST : integer;
  attribute C_HAS_QDPO_SRST of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QSPO : integer;
  attribute C_HAS_QSPO of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QSPO_CE : integer;
  attribute C_HAS_QSPO_CE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QSPO_RST : integer;
  attribute C_HAS_QSPO_RST of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QSPO_SRST : integer;
  attribute C_HAS_QSPO_SRST of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_SPO : integer;
  attribute C_HAS_SPO of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_HAS_WE : integer;
  attribute C_HAS_WE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_MEM_INIT_FILE : string;
  attribute C_MEM_INIT_FILE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is "no_coe_file_loaded";
  attribute C_MEM_TYPE : integer;
  attribute C_MEM_TYPE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_PARSER_TYPE : integer;
  attribute C_PARSER_TYPE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_PIPELINE_STAGES : integer;
  attribute C_PIPELINE_STAGES of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_QCE_JOINED : integer;
  attribute C_QCE_JOINED of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_QUALIFY_WE : integer;
  attribute C_QUALIFY_WE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_READ_MIF : integer;
  attribute C_READ_MIF of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_REG_A_D_INPUTS : integer;
  attribute C_REG_A_D_INPUTS of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_REG_DPRA_INPUT : integer;
  attribute C_REG_DPRA_INPUT of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_SYNC_ENABLE : integer;
  attribute C_SYNC_ENABLE of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_WIDTH : integer;
  attribute C_WIDTH of mem_s2_buffer_dist_mem_gen_v8_0_12 : entity is 168;
end mem_s2_buffer_dist_mem_gen_v8_0_12;

architecture STRUCTURE of mem_s2_buffer_dist_mem_gen_v8_0_12 is
  signal \<const0>\ : STD_LOGIC;
begin
  dpo(167) <= \<const0>\;
  dpo(166) <= \<const0>\;
  dpo(165) <= \<const0>\;
  dpo(164) <= \<const0>\;
  dpo(163) <= \<const0>\;
  dpo(162) <= \<const0>\;
  dpo(161) <= \<const0>\;
  dpo(160) <= \<const0>\;
  dpo(159) <= \<const0>\;
  dpo(158) <= \<const0>\;
  dpo(157) <= \<const0>\;
  dpo(156) <= \<const0>\;
  dpo(155) <= \<const0>\;
  dpo(154) <= \<const0>\;
  dpo(153) <= \<const0>\;
  dpo(152) <= \<const0>\;
  dpo(151) <= \<const0>\;
  dpo(150) <= \<const0>\;
  dpo(149) <= \<const0>\;
  dpo(148) <= \<const0>\;
  dpo(147) <= \<const0>\;
  dpo(146) <= \<const0>\;
  dpo(145) <= \<const0>\;
  dpo(144) <= \<const0>\;
  dpo(143) <= \<const0>\;
  dpo(142) <= \<const0>\;
  dpo(141) <= \<const0>\;
  dpo(140) <= \<const0>\;
  dpo(139) <= \<const0>\;
  dpo(138) <= \<const0>\;
  dpo(137) <= \<const0>\;
  dpo(136) <= \<const0>\;
  dpo(135) <= \<const0>\;
  dpo(134) <= \<const0>\;
  dpo(133) <= \<const0>\;
  dpo(132) <= \<const0>\;
  dpo(131) <= \<const0>\;
  dpo(130) <= \<const0>\;
  dpo(129) <= \<const0>\;
  dpo(128) <= \<const0>\;
  dpo(127) <= \<const0>\;
  dpo(126) <= \<const0>\;
  dpo(125) <= \<const0>\;
  dpo(124) <= \<const0>\;
  dpo(123) <= \<const0>\;
  dpo(122) <= \<const0>\;
  dpo(121) <= \<const0>\;
  dpo(120) <= \<const0>\;
  dpo(119) <= \<const0>\;
  dpo(118) <= \<const0>\;
  dpo(117) <= \<const0>\;
  dpo(116) <= \<const0>\;
  dpo(115) <= \<const0>\;
  dpo(114) <= \<const0>\;
  dpo(113) <= \<const0>\;
  dpo(112) <= \<const0>\;
  dpo(111) <= \<const0>\;
  dpo(110) <= \<const0>\;
  dpo(109) <= \<const0>\;
  dpo(108) <= \<const0>\;
  dpo(107) <= \<const0>\;
  dpo(106) <= \<const0>\;
  dpo(105) <= \<const0>\;
  dpo(104) <= \<const0>\;
  dpo(103) <= \<const0>\;
  dpo(102) <= \<const0>\;
  dpo(101) <= \<const0>\;
  dpo(100) <= \<const0>\;
  dpo(99) <= \<const0>\;
  dpo(98) <= \<const0>\;
  dpo(97) <= \<const0>\;
  dpo(96) <= \<const0>\;
  dpo(95) <= \<const0>\;
  dpo(94) <= \<const0>\;
  dpo(93) <= \<const0>\;
  dpo(92) <= \<const0>\;
  dpo(91) <= \<const0>\;
  dpo(90) <= \<const0>\;
  dpo(89) <= \<const0>\;
  dpo(88) <= \<const0>\;
  dpo(87) <= \<const0>\;
  dpo(86) <= \<const0>\;
  dpo(85) <= \<const0>\;
  dpo(84) <= \<const0>\;
  dpo(83) <= \<const0>\;
  dpo(82) <= \<const0>\;
  dpo(81) <= \<const0>\;
  dpo(80) <= \<const0>\;
  dpo(79) <= \<const0>\;
  dpo(78) <= \<const0>\;
  dpo(77) <= \<const0>\;
  dpo(76) <= \<const0>\;
  dpo(75) <= \<const0>\;
  dpo(74) <= \<const0>\;
  dpo(73) <= \<const0>\;
  dpo(72) <= \<const0>\;
  dpo(71) <= \<const0>\;
  dpo(70) <= \<const0>\;
  dpo(69) <= \<const0>\;
  dpo(68) <= \<const0>\;
  dpo(67) <= \<const0>\;
  dpo(66) <= \<const0>\;
  dpo(65) <= \<const0>\;
  dpo(64) <= \<const0>\;
  dpo(63) <= \<const0>\;
  dpo(62) <= \<const0>\;
  dpo(61) <= \<const0>\;
  dpo(60) <= \<const0>\;
  dpo(59) <= \<const0>\;
  dpo(58) <= \<const0>\;
  dpo(57) <= \<const0>\;
  dpo(56) <= \<const0>\;
  dpo(55) <= \<const0>\;
  dpo(54) <= \<const0>\;
  dpo(53) <= \<const0>\;
  dpo(52) <= \<const0>\;
  dpo(51) <= \<const0>\;
  dpo(50) <= \<const0>\;
  dpo(49) <= \<const0>\;
  dpo(48) <= \<const0>\;
  dpo(47) <= \<const0>\;
  dpo(46) <= \<const0>\;
  dpo(45) <= \<const0>\;
  dpo(44) <= \<const0>\;
  dpo(43) <= \<const0>\;
  dpo(42) <= \<const0>\;
  dpo(41) <= \<const0>\;
  dpo(40) <= \<const0>\;
  dpo(39) <= \<const0>\;
  dpo(38) <= \<const0>\;
  dpo(37) <= \<const0>\;
  dpo(36) <= \<const0>\;
  dpo(35) <= \<const0>\;
  dpo(34) <= \<const0>\;
  dpo(33) <= \<const0>\;
  dpo(32) <= \<const0>\;
  dpo(31) <= \<const0>\;
  dpo(30) <= \<const0>\;
  dpo(29) <= \<const0>\;
  dpo(28) <= \<const0>\;
  dpo(27) <= \<const0>\;
  dpo(26) <= \<const0>\;
  dpo(25) <= \<const0>\;
  dpo(24) <= \<const0>\;
  dpo(23) <= \<const0>\;
  dpo(22) <= \<const0>\;
  dpo(21) <= \<const0>\;
  dpo(20) <= \<const0>\;
  dpo(19) <= \<const0>\;
  dpo(18) <= \<const0>\;
  dpo(17) <= \<const0>\;
  dpo(16) <= \<const0>\;
  dpo(15) <= \<const0>\;
  dpo(14) <= \<const0>\;
  dpo(13) <= \<const0>\;
  dpo(12) <= \<const0>\;
  dpo(11) <= \<const0>\;
  dpo(10) <= \<const0>\;
  dpo(9) <= \<const0>\;
  dpo(8) <= \<const0>\;
  dpo(7) <= \<const0>\;
  dpo(6) <= \<const0>\;
  dpo(5) <= \<const0>\;
  dpo(4) <= \<const0>\;
  dpo(3) <= \<const0>\;
  dpo(2) <= \<const0>\;
  dpo(1) <= \<const0>\;
  dpo(0) <= \<const0>\;
  qdpo(167) <= \<const0>\;
  qdpo(166) <= \<const0>\;
  qdpo(165) <= \<const0>\;
  qdpo(164) <= \<const0>\;
  qdpo(163) <= \<const0>\;
  qdpo(162) <= \<const0>\;
  qdpo(161) <= \<const0>\;
  qdpo(160) <= \<const0>\;
  qdpo(159) <= \<const0>\;
  qdpo(158) <= \<const0>\;
  qdpo(157) <= \<const0>\;
  qdpo(156) <= \<const0>\;
  qdpo(155) <= \<const0>\;
  qdpo(154) <= \<const0>\;
  qdpo(153) <= \<const0>\;
  qdpo(152) <= \<const0>\;
  qdpo(151) <= \<const0>\;
  qdpo(150) <= \<const0>\;
  qdpo(149) <= \<const0>\;
  qdpo(148) <= \<const0>\;
  qdpo(147) <= \<const0>\;
  qdpo(146) <= \<const0>\;
  qdpo(145) <= \<const0>\;
  qdpo(144) <= \<const0>\;
  qdpo(143) <= \<const0>\;
  qdpo(142) <= \<const0>\;
  qdpo(141) <= \<const0>\;
  qdpo(140) <= \<const0>\;
  qdpo(139) <= \<const0>\;
  qdpo(138) <= \<const0>\;
  qdpo(137) <= \<const0>\;
  qdpo(136) <= \<const0>\;
  qdpo(135) <= \<const0>\;
  qdpo(134) <= \<const0>\;
  qdpo(133) <= \<const0>\;
  qdpo(132) <= \<const0>\;
  qdpo(131) <= \<const0>\;
  qdpo(130) <= \<const0>\;
  qdpo(129) <= \<const0>\;
  qdpo(128) <= \<const0>\;
  qdpo(127) <= \<const0>\;
  qdpo(126) <= \<const0>\;
  qdpo(125) <= \<const0>\;
  qdpo(124) <= \<const0>\;
  qdpo(123) <= \<const0>\;
  qdpo(122) <= \<const0>\;
  qdpo(121) <= \<const0>\;
  qdpo(120) <= \<const0>\;
  qdpo(119) <= \<const0>\;
  qdpo(118) <= \<const0>\;
  qdpo(117) <= \<const0>\;
  qdpo(116) <= \<const0>\;
  qdpo(115) <= \<const0>\;
  qdpo(114) <= \<const0>\;
  qdpo(113) <= \<const0>\;
  qdpo(112) <= \<const0>\;
  qdpo(111) <= \<const0>\;
  qdpo(110) <= \<const0>\;
  qdpo(109) <= \<const0>\;
  qdpo(108) <= \<const0>\;
  qdpo(107) <= \<const0>\;
  qdpo(106) <= \<const0>\;
  qdpo(105) <= \<const0>\;
  qdpo(104) <= \<const0>\;
  qdpo(103) <= \<const0>\;
  qdpo(102) <= \<const0>\;
  qdpo(101) <= \<const0>\;
  qdpo(100) <= \<const0>\;
  qdpo(99) <= \<const0>\;
  qdpo(98) <= \<const0>\;
  qdpo(97) <= \<const0>\;
  qdpo(96) <= \<const0>\;
  qdpo(95) <= \<const0>\;
  qdpo(94) <= \<const0>\;
  qdpo(93) <= \<const0>\;
  qdpo(92) <= \<const0>\;
  qdpo(91) <= \<const0>\;
  qdpo(90) <= \<const0>\;
  qdpo(89) <= \<const0>\;
  qdpo(88) <= \<const0>\;
  qdpo(87) <= \<const0>\;
  qdpo(86) <= \<const0>\;
  qdpo(85) <= \<const0>\;
  qdpo(84) <= \<const0>\;
  qdpo(83) <= \<const0>\;
  qdpo(82) <= \<const0>\;
  qdpo(81) <= \<const0>\;
  qdpo(80) <= \<const0>\;
  qdpo(79) <= \<const0>\;
  qdpo(78) <= \<const0>\;
  qdpo(77) <= \<const0>\;
  qdpo(76) <= \<const0>\;
  qdpo(75) <= \<const0>\;
  qdpo(74) <= \<const0>\;
  qdpo(73) <= \<const0>\;
  qdpo(72) <= \<const0>\;
  qdpo(71) <= \<const0>\;
  qdpo(70) <= \<const0>\;
  qdpo(69) <= \<const0>\;
  qdpo(68) <= \<const0>\;
  qdpo(67) <= \<const0>\;
  qdpo(66) <= \<const0>\;
  qdpo(65) <= \<const0>\;
  qdpo(64) <= \<const0>\;
  qdpo(63) <= \<const0>\;
  qdpo(62) <= \<const0>\;
  qdpo(61) <= \<const0>\;
  qdpo(60) <= \<const0>\;
  qdpo(59) <= \<const0>\;
  qdpo(58) <= \<const0>\;
  qdpo(57) <= \<const0>\;
  qdpo(56) <= \<const0>\;
  qdpo(55) <= \<const0>\;
  qdpo(54) <= \<const0>\;
  qdpo(53) <= \<const0>\;
  qdpo(52) <= \<const0>\;
  qdpo(51) <= \<const0>\;
  qdpo(50) <= \<const0>\;
  qdpo(49) <= \<const0>\;
  qdpo(48) <= \<const0>\;
  qdpo(47) <= \<const0>\;
  qdpo(46) <= \<const0>\;
  qdpo(45) <= \<const0>\;
  qdpo(44) <= \<const0>\;
  qdpo(43) <= \<const0>\;
  qdpo(42) <= \<const0>\;
  qdpo(41) <= \<const0>\;
  qdpo(40) <= \<const0>\;
  qdpo(39) <= \<const0>\;
  qdpo(38) <= \<const0>\;
  qdpo(37) <= \<const0>\;
  qdpo(36) <= \<const0>\;
  qdpo(35) <= \<const0>\;
  qdpo(34) <= \<const0>\;
  qdpo(33) <= \<const0>\;
  qdpo(32) <= \<const0>\;
  qdpo(31) <= \<const0>\;
  qdpo(30) <= \<const0>\;
  qdpo(29) <= \<const0>\;
  qdpo(28) <= \<const0>\;
  qdpo(27) <= \<const0>\;
  qdpo(26) <= \<const0>\;
  qdpo(25) <= \<const0>\;
  qdpo(24) <= \<const0>\;
  qdpo(23) <= \<const0>\;
  qdpo(22) <= \<const0>\;
  qdpo(21) <= \<const0>\;
  qdpo(20) <= \<const0>\;
  qdpo(19) <= \<const0>\;
  qdpo(18) <= \<const0>\;
  qdpo(17) <= \<const0>\;
  qdpo(16) <= \<const0>\;
  qdpo(15) <= \<const0>\;
  qdpo(14) <= \<const0>\;
  qdpo(13) <= \<const0>\;
  qdpo(12) <= \<const0>\;
  qdpo(11) <= \<const0>\;
  qdpo(10) <= \<const0>\;
  qdpo(9) <= \<const0>\;
  qdpo(8) <= \<const0>\;
  qdpo(7) <= \<const0>\;
  qdpo(6) <= \<const0>\;
  qdpo(5) <= \<const0>\;
  qdpo(4) <= \<const0>\;
  qdpo(3) <= \<const0>\;
  qdpo(2) <= \<const0>\;
  qdpo(1) <= \<const0>\;
  qdpo(0) <= \<const0>\;
  qspo(167) <= \<const0>\;
  qspo(166) <= \<const0>\;
  qspo(165) <= \<const0>\;
  qspo(164) <= \<const0>\;
  qspo(163) <= \<const0>\;
  qspo(162) <= \<const0>\;
  qspo(161) <= \<const0>\;
  qspo(160) <= \<const0>\;
  qspo(159) <= \<const0>\;
  qspo(158) <= \<const0>\;
  qspo(157) <= \<const0>\;
  qspo(156) <= \<const0>\;
  qspo(155) <= \<const0>\;
  qspo(154) <= \<const0>\;
  qspo(153) <= \<const0>\;
  qspo(152) <= \<const0>\;
  qspo(151) <= \<const0>\;
  qspo(150) <= \<const0>\;
  qspo(149) <= \<const0>\;
  qspo(148) <= \<const0>\;
  qspo(147) <= \<const0>\;
  qspo(146) <= \<const0>\;
  qspo(145) <= \<const0>\;
  qspo(144) <= \<const0>\;
  qspo(143) <= \<const0>\;
  qspo(142) <= \<const0>\;
  qspo(141) <= \<const0>\;
  qspo(140) <= \<const0>\;
  qspo(139) <= \<const0>\;
  qspo(138) <= \<const0>\;
  qspo(137) <= \<const0>\;
  qspo(136) <= \<const0>\;
  qspo(135) <= \<const0>\;
  qspo(134) <= \<const0>\;
  qspo(133) <= \<const0>\;
  qspo(132) <= \<const0>\;
  qspo(131) <= \<const0>\;
  qspo(130) <= \<const0>\;
  qspo(129) <= \<const0>\;
  qspo(128) <= \<const0>\;
  qspo(127) <= \<const0>\;
  qspo(126) <= \<const0>\;
  qspo(125) <= \<const0>\;
  qspo(124) <= \<const0>\;
  qspo(123) <= \<const0>\;
  qspo(122) <= \<const0>\;
  qspo(121) <= \<const0>\;
  qspo(120) <= \<const0>\;
  qspo(119) <= \<const0>\;
  qspo(118) <= \<const0>\;
  qspo(117) <= \<const0>\;
  qspo(116) <= \<const0>\;
  qspo(115) <= \<const0>\;
  qspo(114) <= \<const0>\;
  qspo(113) <= \<const0>\;
  qspo(112) <= \<const0>\;
  qspo(111) <= \<const0>\;
  qspo(110) <= \<const0>\;
  qspo(109) <= \<const0>\;
  qspo(108) <= \<const0>\;
  qspo(107) <= \<const0>\;
  qspo(106) <= \<const0>\;
  qspo(105) <= \<const0>\;
  qspo(104) <= \<const0>\;
  qspo(103) <= \<const0>\;
  qspo(102) <= \<const0>\;
  qspo(101) <= \<const0>\;
  qspo(100) <= \<const0>\;
  qspo(99) <= \<const0>\;
  qspo(98) <= \<const0>\;
  qspo(97) <= \<const0>\;
  qspo(96) <= \<const0>\;
  qspo(95) <= \<const0>\;
  qspo(94) <= \<const0>\;
  qspo(93) <= \<const0>\;
  qspo(92) <= \<const0>\;
  qspo(91) <= \<const0>\;
  qspo(90) <= \<const0>\;
  qspo(89) <= \<const0>\;
  qspo(88) <= \<const0>\;
  qspo(87) <= \<const0>\;
  qspo(86) <= \<const0>\;
  qspo(85) <= \<const0>\;
  qspo(84) <= \<const0>\;
  qspo(83) <= \<const0>\;
  qspo(82) <= \<const0>\;
  qspo(81) <= \<const0>\;
  qspo(80) <= \<const0>\;
  qspo(79) <= \<const0>\;
  qspo(78) <= \<const0>\;
  qspo(77) <= \<const0>\;
  qspo(76) <= \<const0>\;
  qspo(75) <= \<const0>\;
  qspo(74) <= \<const0>\;
  qspo(73) <= \<const0>\;
  qspo(72) <= \<const0>\;
  qspo(71) <= \<const0>\;
  qspo(70) <= \<const0>\;
  qspo(69) <= \<const0>\;
  qspo(68) <= \<const0>\;
  qspo(67) <= \<const0>\;
  qspo(66) <= \<const0>\;
  qspo(65) <= \<const0>\;
  qspo(64) <= \<const0>\;
  qspo(63) <= \<const0>\;
  qspo(62) <= \<const0>\;
  qspo(61) <= \<const0>\;
  qspo(60) <= \<const0>\;
  qspo(59) <= \<const0>\;
  qspo(58) <= \<const0>\;
  qspo(57) <= \<const0>\;
  qspo(56) <= \<const0>\;
  qspo(55) <= \<const0>\;
  qspo(54) <= \<const0>\;
  qspo(53) <= \<const0>\;
  qspo(52) <= \<const0>\;
  qspo(51) <= \<const0>\;
  qspo(50) <= \<const0>\;
  qspo(49) <= \<const0>\;
  qspo(48) <= \<const0>\;
  qspo(47) <= \<const0>\;
  qspo(46) <= \<const0>\;
  qspo(45) <= \<const0>\;
  qspo(44) <= \<const0>\;
  qspo(43) <= \<const0>\;
  qspo(42) <= \<const0>\;
  qspo(41) <= \<const0>\;
  qspo(40) <= \<const0>\;
  qspo(39) <= \<const0>\;
  qspo(38) <= \<const0>\;
  qspo(37) <= \<const0>\;
  qspo(36) <= \<const0>\;
  qspo(35) <= \<const0>\;
  qspo(34) <= \<const0>\;
  qspo(33) <= \<const0>\;
  qspo(32) <= \<const0>\;
  qspo(31) <= \<const0>\;
  qspo(30) <= \<const0>\;
  qspo(29) <= \<const0>\;
  qspo(28) <= \<const0>\;
  qspo(27) <= \<const0>\;
  qspo(26) <= \<const0>\;
  qspo(25) <= \<const0>\;
  qspo(24) <= \<const0>\;
  qspo(23) <= \<const0>\;
  qspo(22) <= \<const0>\;
  qspo(21) <= \<const0>\;
  qspo(20) <= \<const0>\;
  qspo(19) <= \<const0>\;
  qspo(18) <= \<const0>\;
  qspo(17) <= \<const0>\;
  qspo(16) <= \<const0>\;
  qspo(15) <= \<const0>\;
  qspo(14) <= \<const0>\;
  qspo(13) <= \<const0>\;
  qspo(12) <= \<const0>\;
  qspo(11) <= \<const0>\;
  qspo(10) <= \<const0>\;
  qspo(9) <= \<const0>\;
  qspo(8) <= \<const0>\;
  qspo(7) <= \<const0>\;
  qspo(6) <= \<const0>\;
  qspo(5) <= \<const0>\;
  qspo(4) <= \<const0>\;
  qspo(3) <= \<const0>\;
  qspo(2) <= \<const0>\;
  qspo(1) <= \<const0>\;
  qspo(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
\synth_options.dist_mem_inst\: entity work.mem_s2_buffer_dist_mem_gen_v8_0_12_synth
     port map (
      a(3 downto 0) => a(3 downto 0),
      clk => clk,
      d(167 downto 0) => d(167 downto 0),
      spo(167 downto 0) => spo(167 downto 0),
      we => we
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mem_s2_buffer is
  port (
    a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    d : in STD_LOGIC_VECTOR ( 167 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    spo : out STD_LOGIC_VECTOR ( 167 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of mem_s2_buffer : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of mem_s2_buffer : entity is "mem_s2_buffer,dist_mem_gen_v8_0_12,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of mem_s2_buffer : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of mem_s2_buffer : entity is "dist_mem_gen_v8_0_12,Vivado 2018.3";
end mem_s2_buffer;

architecture STRUCTURE of mem_s2_buffer is
  signal NLW_U0_dpo_UNCONNECTED : STD_LOGIC_VECTOR ( 167 downto 0 );
  signal NLW_U0_qdpo_UNCONNECTED : STD_LOGIC_VECTOR ( 167 downto 0 );
  signal NLW_U0_qspo_UNCONNECTED : STD_LOGIC_VECTOR ( 167 downto 0 );
  attribute C_FAMILY : string;
  attribute C_FAMILY of U0 : label is "zynq";
  attribute C_HAS_CLK : integer;
  attribute C_HAS_CLK of U0 : label is 1;
  attribute C_HAS_D : integer;
  attribute C_HAS_D of U0 : label is 1;
  attribute C_HAS_DPO : integer;
  attribute C_HAS_DPO of U0 : label is 0;
  attribute C_HAS_DPRA : integer;
  attribute C_HAS_DPRA of U0 : label is 0;
  attribute C_HAS_QDPO : integer;
  attribute C_HAS_QDPO of U0 : label is 0;
  attribute C_HAS_QDPO_CE : integer;
  attribute C_HAS_QDPO_CE of U0 : label is 0;
  attribute C_HAS_QDPO_CLK : integer;
  attribute C_HAS_QDPO_CLK of U0 : label is 0;
  attribute C_HAS_QDPO_RST : integer;
  attribute C_HAS_QDPO_RST of U0 : label is 0;
  attribute C_HAS_QDPO_SRST : integer;
  attribute C_HAS_QDPO_SRST of U0 : label is 0;
  attribute C_HAS_WE : integer;
  attribute C_HAS_WE of U0 : label is 1;
  attribute C_MEM_TYPE : integer;
  attribute C_MEM_TYPE of U0 : label is 1;
  attribute C_QCE_JOINED : integer;
  attribute C_QCE_JOINED of U0 : label is 0;
  attribute C_REG_DPRA_INPUT : integer;
  attribute C_REG_DPRA_INPUT of U0 : label is 0;
  attribute c_addr_width : integer;
  attribute c_addr_width of U0 : label is 4;
  attribute c_default_data : string;
  attribute c_default_data of U0 : label is "0";
  attribute c_depth : integer;
  attribute c_depth of U0 : label is 16;
  attribute c_elaboration_dir : string;
  attribute c_elaboration_dir of U0 : label is "./";
  attribute c_has_i_ce : integer;
  attribute c_has_i_ce of U0 : label is 0;
  attribute c_has_qspo : integer;
  attribute c_has_qspo of U0 : label is 0;
  attribute c_has_qspo_ce : integer;
  attribute c_has_qspo_ce of U0 : label is 0;
  attribute c_has_qspo_rst : integer;
  attribute c_has_qspo_rst of U0 : label is 0;
  attribute c_has_qspo_srst : integer;
  attribute c_has_qspo_srst of U0 : label is 0;
  attribute c_has_spo : integer;
  attribute c_has_spo of U0 : label is 1;
  attribute c_mem_init_file : string;
  attribute c_mem_init_file of U0 : label is "no_coe_file_loaded";
  attribute c_parser_type : integer;
  attribute c_parser_type of U0 : label is 1;
  attribute c_pipeline_stages : integer;
  attribute c_pipeline_stages of U0 : label is 0;
  attribute c_qualify_we : integer;
  attribute c_qualify_we of U0 : label is 0;
  attribute c_read_mif : integer;
  attribute c_read_mif of U0 : label is 0;
  attribute c_reg_a_d_inputs : integer;
  attribute c_reg_a_d_inputs of U0 : label is 0;
  attribute c_sync_enable : integer;
  attribute c_sync_enable of U0 : label is 1;
  attribute c_width : integer;
  attribute c_width of U0 : label is 168;
begin
U0: entity work.mem_s2_buffer_dist_mem_gen_v8_0_12
     port map (
      a(3 downto 0) => a(3 downto 0),
      clk => clk,
      d(167 downto 0) => d(167 downto 0),
      dpo(167 downto 0) => NLW_U0_dpo_UNCONNECTED(167 downto 0),
      dpra(3 downto 0) => B"0000",
      i_ce => '1',
      qdpo(167 downto 0) => NLW_U0_qdpo_UNCONNECTED(167 downto 0),
      qdpo_ce => '1',
      qdpo_clk => '0',
      qdpo_rst => '0',
      qdpo_srst => '0',
      qspo(167 downto 0) => NLW_U0_qspo_UNCONNECTED(167 downto 0),
      qspo_ce => '1',
      qspo_rst => '0',
      qspo_srst => '0',
      spo(167 downto 0) => spo(167 downto 0),
      we => we
    );
end STRUCTURE;

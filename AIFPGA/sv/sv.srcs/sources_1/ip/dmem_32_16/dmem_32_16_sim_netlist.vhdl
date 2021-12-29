-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Sat Dec 14 06:53:29 2019
-- Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode funcsim
--               C:/AI/AIFPGA/sv/sv.srcs/sources_1/ip/dmem_32_16/dmem_32_16_sim_netlist.vhdl
-- Design      : dmem_32_16
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z100ffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity dmem_32_16_sdpram is
  port (
    dpo : out STD_LOGIC_VECTOR ( 19 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    d : in STD_LOGIC_VECTOR ( 19 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 3 downto 0 );
    a : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of dmem_32_16_sdpram : entity is "sdpram";
end dmem_32_16_sdpram;

architecture STRUCTURE of dmem_32_16_sdpram is
  signal \^dpo\ : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal qsdpo_int : STD_LOGIC_VECTOR ( 19 downto 0 );
  attribute RTL_KEEP : string;
  attribute RTL_KEEP of qsdpo_int : signal is "true";
  signal NLW_ram_reg_0_15_0_5_DOD_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_ram_reg_0_15_12_17_DOD_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_ram_reg_0_15_18_19_DOB_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_ram_reg_0_15_18_19_DOC_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_ram_reg_0_15_18_19_DOD_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_ram_reg_0_15_6_11_DOD_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute KEEP : string;
  attribute KEEP of \qsdpo_int_reg[0]\ : label is "yes";
  attribute equivalent_register_removal : string;
  attribute equivalent_register_removal of \qsdpo_int_reg[0]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[10]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[10]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[11]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[11]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[12]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[12]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[13]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[13]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[14]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[14]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[15]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[15]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[16]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[16]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[17]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[17]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[18]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[18]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[19]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[19]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[1]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[1]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[2]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[2]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[3]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[3]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[4]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[4]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[5]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[5]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[6]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[6]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[7]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[7]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[8]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[8]\ : label is "no";
  attribute KEEP of \qsdpo_int_reg[9]\ : label is "yes";
  attribute equivalent_register_removal of \qsdpo_int_reg[9]\ : label is "no";
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of ram_reg_0_15_0_5 : label is "";
  attribute ram_addr_begin : integer;
  attribute ram_addr_begin of ram_reg_0_15_0_5 : label is 0;
  attribute ram_addr_end : integer;
  attribute ram_addr_end of ram_reg_0_15_0_5 : label is 15;
  attribute ram_slice_begin : integer;
  attribute ram_slice_begin of ram_reg_0_15_0_5 : label is 0;
  attribute ram_slice_end : integer;
  attribute ram_slice_end of ram_reg_0_15_0_5 : label is 5;
  attribute METHODOLOGY_DRC_VIOS of ram_reg_0_15_12_17 : label is "";
  attribute ram_addr_begin of ram_reg_0_15_12_17 : label is 0;
  attribute ram_addr_end of ram_reg_0_15_12_17 : label is 15;
  attribute ram_slice_begin of ram_reg_0_15_12_17 : label is 12;
  attribute ram_slice_end of ram_reg_0_15_12_17 : label is 17;
  attribute METHODOLOGY_DRC_VIOS of ram_reg_0_15_18_19 : label is "";
  attribute ram_addr_begin of ram_reg_0_15_18_19 : label is 0;
  attribute ram_addr_end of ram_reg_0_15_18_19 : label is 15;
  attribute ram_slice_begin of ram_reg_0_15_18_19 : label is 18;
  attribute ram_slice_end of ram_reg_0_15_18_19 : label is 19;
  attribute METHODOLOGY_DRC_VIOS of ram_reg_0_15_6_11 : label is "";
  attribute ram_addr_begin of ram_reg_0_15_6_11 : label is 0;
  attribute ram_addr_end of ram_reg_0_15_6_11 : label is 15;
  attribute ram_slice_begin of ram_reg_0_15_6_11 : label is 6;
  attribute ram_slice_end of ram_reg_0_15_6_11 : label is 11;
begin
  dpo(19 downto 0) <= \^dpo\(19 downto 0);
\qsdpo_int_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(0),
      Q => qsdpo_int(0),
      R => '0'
    );
\qsdpo_int_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(10),
      Q => qsdpo_int(10),
      R => '0'
    );
\qsdpo_int_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(11),
      Q => qsdpo_int(11),
      R => '0'
    );
\qsdpo_int_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(12),
      Q => qsdpo_int(12),
      R => '0'
    );
\qsdpo_int_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(13),
      Q => qsdpo_int(13),
      R => '0'
    );
\qsdpo_int_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(14),
      Q => qsdpo_int(14),
      R => '0'
    );
\qsdpo_int_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(15),
      Q => qsdpo_int(15),
      R => '0'
    );
\qsdpo_int_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(16),
      Q => qsdpo_int(16),
      R => '0'
    );
\qsdpo_int_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(17),
      Q => qsdpo_int(17),
      R => '0'
    );
\qsdpo_int_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(18),
      Q => qsdpo_int(18),
      R => '0'
    );
\qsdpo_int_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(19),
      Q => qsdpo_int(19),
      R => '0'
    );
\qsdpo_int_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(1),
      Q => qsdpo_int(1),
      R => '0'
    );
\qsdpo_int_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(2),
      Q => qsdpo_int(2),
      R => '0'
    );
\qsdpo_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(3),
      Q => qsdpo_int(3),
      R => '0'
    );
\qsdpo_int_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(4),
      Q => qsdpo_int(4),
      R => '0'
    );
\qsdpo_int_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(5),
      Q => qsdpo_int(5),
      R => '0'
    );
\qsdpo_int_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(6),
      Q => qsdpo_int(6),
      R => '0'
    );
\qsdpo_int_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(7),
      Q => qsdpo_int(7),
      R => '0'
    );
\qsdpo_int_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(8),
      Q => qsdpo_int(8),
      R => '0'
    );
\qsdpo_int_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \^dpo\(9),
      Q => qsdpo_int(9),
      R => '0'
    );
ram_reg_0_15_0_5: unisim.vcomponents.RAM32M
    generic map(
      INIT_A => X"0000000000000000",
      INIT_B => X"0000000000000000",
      INIT_C => X"0000000000000000",
      INIT_D => X"0000000000000000"
    )
        port map (
      ADDRA(4) => '0',
      ADDRA(3 downto 0) => dpra(3 downto 0),
      ADDRB(4) => '0',
      ADDRB(3 downto 0) => dpra(3 downto 0),
      ADDRC(4) => '0',
      ADDRC(3 downto 0) => dpra(3 downto 0),
      ADDRD(4) => '0',
      ADDRD(3 downto 0) => a(3 downto 0),
      DIA(1 downto 0) => d(1 downto 0),
      DIB(1 downto 0) => d(3 downto 2),
      DIC(1 downto 0) => d(5 downto 4),
      DID(1 downto 0) => B"00",
      DOA(1 downto 0) => \^dpo\(1 downto 0),
      DOB(1 downto 0) => \^dpo\(3 downto 2),
      DOC(1 downto 0) => \^dpo\(5 downto 4),
      DOD(1 downto 0) => NLW_ram_reg_0_15_0_5_DOD_UNCONNECTED(1 downto 0),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_12_17: unisim.vcomponents.RAM32M
    generic map(
      INIT_A => X"0000000000000000",
      INIT_B => X"0000000000000000",
      INIT_C => X"0000000000000000",
      INIT_D => X"0000000000000000"
    )
        port map (
      ADDRA(4) => '0',
      ADDRA(3 downto 0) => dpra(3 downto 0),
      ADDRB(4) => '0',
      ADDRB(3 downto 0) => dpra(3 downto 0),
      ADDRC(4) => '0',
      ADDRC(3 downto 0) => dpra(3 downto 0),
      ADDRD(4) => '0',
      ADDRD(3 downto 0) => a(3 downto 0),
      DIA(1 downto 0) => d(13 downto 12),
      DIB(1 downto 0) => d(15 downto 14),
      DIC(1 downto 0) => d(17 downto 16),
      DID(1 downto 0) => B"00",
      DOA(1 downto 0) => \^dpo\(13 downto 12),
      DOB(1 downto 0) => \^dpo\(15 downto 14),
      DOC(1 downto 0) => \^dpo\(17 downto 16),
      DOD(1 downto 0) => NLW_ram_reg_0_15_12_17_DOD_UNCONNECTED(1 downto 0),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_18_19: unisim.vcomponents.RAM32M
    generic map(
      INIT_A => X"0000000000000000",
      INIT_B => X"0000000000000000",
      INIT_C => X"0000000000000000",
      INIT_D => X"0000000000000000"
    )
        port map (
      ADDRA(4) => '0',
      ADDRA(3 downto 0) => dpra(3 downto 0),
      ADDRB(4) => '0',
      ADDRB(3 downto 0) => dpra(3 downto 0),
      ADDRC(4) => '0',
      ADDRC(3 downto 0) => dpra(3 downto 0),
      ADDRD(4) => '0',
      ADDRD(3 downto 0) => a(3 downto 0),
      DIA(1 downto 0) => d(19 downto 18),
      DIB(1 downto 0) => B"00",
      DIC(1 downto 0) => B"00",
      DID(1 downto 0) => B"00",
      DOA(1 downto 0) => \^dpo\(19 downto 18),
      DOB(1 downto 0) => NLW_ram_reg_0_15_18_19_DOB_UNCONNECTED(1 downto 0),
      DOC(1 downto 0) => NLW_ram_reg_0_15_18_19_DOC_UNCONNECTED(1 downto 0),
      DOD(1 downto 0) => NLW_ram_reg_0_15_18_19_DOD_UNCONNECTED(1 downto 0),
      WCLK => clk,
      WE => we
    );
ram_reg_0_15_6_11: unisim.vcomponents.RAM32M
    generic map(
      INIT_A => X"0000000000000000",
      INIT_B => X"0000000000000000",
      INIT_C => X"0000000000000000",
      INIT_D => X"0000000000000000"
    )
        port map (
      ADDRA(4) => '0',
      ADDRA(3 downto 0) => dpra(3 downto 0),
      ADDRB(4) => '0',
      ADDRB(3 downto 0) => dpra(3 downto 0),
      ADDRC(4) => '0',
      ADDRC(3 downto 0) => dpra(3 downto 0),
      ADDRD(4) => '0',
      ADDRD(3 downto 0) => a(3 downto 0),
      DIA(1 downto 0) => d(7 downto 6),
      DIB(1 downto 0) => d(9 downto 8),
      DIC(1 downto 0) => d(11 downto 10),
      DID(1 downto 0) => B"00",
      DOA(1 downto 0) => \^dpo\(7 downto 6),
      DOB(1 downto 0) => \^dpo\(9 downto 8),
      DOC(1 downto 0) => \^dpo\(11 downto 10),
      DOD(1 downto 0) => NLW_ram_reg_0_15_6_11_DOD_UNCONNECTED(1 downto 0),
      WCLK => clk,
      WE => we
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity dmem_32_16_dist_mem_gen_v8_0_12_synth is
  port (
    dpo : out STD_LOGIC_VECTOR ( 19 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    d : in STD_LOGIC_VECTOR ( 19 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 3 downto 0 );
    a : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of dmem_32_16_dist_mem_gen_v8_0_12_synth : entity is "dist_mem_gen_v8_0_12_synth";
end dmem_32_16_dist_mem_gen_v8_0_12_synth;

architecture STRUCTURE of dmem_32_16_dist_mem_gen_v8_0_12_synth is
begin
\gen_sdp_ram.sdpram_inst\: entity work.dmem_32_16_sdpram
     port map (
      a(3 downto 0) => a(3 downto 0),
      clk => clk,
      d(19 downto 0) => d(19 downto 0),
      dpo(19 downto 0) => dpo(19 downto 0),
      dpra(3 downto 0) => dpra(3 downto 0),
      we => we
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity dmem_32_16_dist_mem_gen_v8_0_12 is
  port (
    a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    d : in STD_LOGIC_VECTOR ( 19 downto 0 );
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
    spo : out STD_LOGIC_VECTOR ( 19 downto 0 );
    dpo : out STD_LOGIC_VECTOR ( 19 downto 0 );
    qspo : out STD_LOGIC_VECTOR ( 19 downto 0 );
    qdpo : out STD_LOGIC_VECTOR ( 19 downto 0 )
  );
  attribute C_ADDR_WIDTH : integer;
  attribute C_ADDR_WIDTH of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 4;
  attribute C_DEFAULT_DATA : string;
  attribute C_DEFAULT_DATA of dmem_32_16_dist_mem_gen_v8_0_12 : entity is "0";
  attribute C_DEPTH : integer;
  attribute C_DEPTH of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 16;
  attribute C_ELABORATION_DIR : string;
  attribute C_ELABORATION_DIR of dmem_32_16_dist_mem_gen_v8_0_12 : entity is "./";
  attribute C_FAMILY : string;
  attribute C_FAMILY of dmem_32_16_dist_mem_gen_v8_0_12 : entity is "zynq";
  attribute C_HAS_CLK : integer;
  attribute C_HAS_CLK of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_HAS_D : integer;
  attribute C_HAS_D of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_HAS_DPO : integer;
  attribute C_HAS_DPO of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_HAS_DPRA : integer;
  attribute C_HAS_DPRA of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_HAS_I_CE : integer;
  attribute C_HAS_I_CE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO : integer;
  attribute C_HAS_QDPO of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO_CE : integer;
  attribute C_HAS_QDPO_CE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO_CLK : integer;
  attribute C_HAS_QDPO_CLK of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO_RST : integer;
  attribute C_HAS_QDPO_RST of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QDPO_SRST : integer;
  attribute C_HAS_QDPO_SRST of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QSPO : integer;
  attribute C_HAS_QSPO of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QSPO_CE : integer;
  attribute C_HAS_QSPO_CE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QSPO_RST : integer;
  attribute C_HAS_QSPO_RST of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_QSPO_SRST : integer;
  attribute C_HAS_QSPO_SRST of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_SPO : integer;
  attribute C_HAS_SPO of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_HAS_WE : integer;
  attribute C_HAS_WE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_MEM_INIT_FILE : string;
  attribute C_MEM_INIT_FILE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is "no_coe_file_loaded";
  attribute C_MEM_TYPE : integer;
  attribute C_MEM_TYPE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 4;
  attribute C_PARSER_TYPE : integer;
  attribute C_PARSER_TYPE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_PIPELINE_STAGES : integer;
  attribute C_PIPELINE_STAGES of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_QCE_JOINED : integer;
  attribute C_QCE_JOINED of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_QUALIFY_WE : integer;
  attribute C_QUALIFY_WE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_READ_MIF : integer;
  attribute C_READ_MIF of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_REG_A_D_INPUTS : integer;
  attribute C_REG_A_D_INPUTS of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_REG_DPRA_INPUT : integer;
  attribute C_REG_DPRA_INPUT of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 0;
  attribute C_SYNC_ENABLE : integer;
  attribute C_SYNC_ENABLE of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 1;
  attribute C_WIDTH : integer;
  attribute C_WIDTH of dmem_32_16_dist_mem_gen_v8_0_12 : entity is 20;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of dmem_32_16_dist_mem_gen_v8_0_12 : entity is "dist_mem_gen_v8_0_12";
end dmem_32_16_dist_mem_gen_v8_0_12;

architecture STRUCTURE of dmem_32_16_dist_mem_gen_v8_0_12 is
  signal \<const0>\ : STD_LOGIC;
begin
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
  spo(19) <= \<const0>\;
  spo(18) <= \<const0>\;
  spo(17) <= \<const0>\;
  spo(16) <= \<const0>\;
  spo(15) <= \<const0>\;
  spo(14) <= \<const0>\;
  spo(13) <= \<const0>\;
  spo(12) <= \<const0>\;
  spo(11) <= \<const0>\;
  spo(10) <= \<const0>\;
  spo(9) <= \<const0>\;
  spo(8) <= \<const0>\;
  spo(7) <= \<const0>\;
  spo(6) <= \<const0>\;
  spo(5) <= \<const0>\;
  spo(4) <= \<const0>\;
  spo(3) <= \<const0>\;
  spo(2) <= \<const0>\;
  spo(1) <= \<const0>\;
  spo(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
\synth_options.dist_mem_inst\: entity work.dmem_32_16_dist_mem_gen_v8_0_12_synth
     port map (
      a(3 downto 0) => a(3 downto 0),
      clk => clk,
      d(19 downto 0) => d(19 downto 0),
      dpo(19 downto 0) => dpo(19 downto 0),
      dpra(3 downto 0) => dpra(3 downto 0),
      we => we
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity dmem_32_16 is
  port (
    a : in STD_LOGIC_VECTOR ( 3 downto 0 );
    d : in STD_LOGIC_VECTOR ( 19 downto 0 );
    dpra : in STD_LOGIC_VECTOR ( 3 downto 0 );
    clk : in STD_LOGIC;
    we : in STD_LOGIC;
    dpo : out STD_LOGIC_VECTOR ( 19 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of dmem_32_16 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of dmem_32_16 : entity is "dmem_32_16,dist_mem_gen_v8_0_12,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of dmem_32_16 : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of dmem_32_16 : entity is "dist_mem_gen_v8_0_12,Vivado 2018.3";
end dmem_32_16;

architecture STRUCTURE of dmem_32_16 is
  signal NLW_U0_qdpo_UNCONNECTED : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal NLW_U0_qspo_UNCONNECTED : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal NLW_U0_spo_UNCONNECTED : STD_LOGIC_VECTOR ( 19 downto 0 );
  attribute C_FAMILY : string;
  attribute C_FAMILY of U0 : label is "zynq";
  attribute C_HAS_CLK : integer;
  attribute C_HAS_CLK of U0 : label is 1;
  attribute C_HAS_D : integer;
  attribute C_HAS_D of U0 : label is 1;
  attribute C_HAS_DPO : integer;
  attribute C_HAS_DPO of U0 : label is 1;
  attribute C_HAS_DPRA : integer;
  attribute C_HAS_DPRA of U0 : label is 1;
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
  attribute C_HAS_QSPO : integer;
  attribute C_HAS_QSPO of U0 : label is 0;
  attribute C_HAS_QSPO_RST : integer;
  attribute C_HAS_QSPO_RST of U0 : label is 0;
  attribute C_HAS_QSPO_SRST : integer;
  attribute C_HAS_QSPO_SRST of U0 : label is 0;
  attribute C_HAS_SPO : integer;
  attribute C_HAS_SPO of U0 : label is 0;
  attribute C_HAS_WE : integer;
  attribute C_HAS_WE of U0 : label is 1;
  attribute C_MEM_TYPE : integer;
  attribute C_MEM_TYPE of U0 : label is 4;
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
  attribute c_has_qspo_ce : integer;
  attribute c_has_qspo_ce of U0 : label is 0;
  attribute c_mem_init_file : string;
  attribute c_mem_init_file of U0 : label is "no_coe_file_loaded";
  attribute c_parser_type : integer;
  attribute c_parser_type of U0 : label is 1;
  attribute c_pipeline_stages : integer;
  attribute c_pipeline_stages of U0 : label is 0;
  attribute c_qce_joined : integer;
  attribute c_qce_joined of U0 : label is 0;
  attribute c_qualify_we : integer;
  attribute c_qualify_we of U0 : label is 0;
  attribute c_read_mif : integer;
  attribute c_read_mif of U0 : label is 0;
  attribute c_reg_a_d_inputs : integer;
  attribute c_reg_a_d_inputs of U0 : label is 0;
  attribute c_sync_enable : integer;
  attribute c_sync_enable of U0 : label is 1;
  attribute c_width : integer;
  attribute c_width of U0 : label is 20;
begin
U0: entity work.dmem_32_16_dist_mem_gen_v8_0_12
     port map (
      a(3 downto 0) => a(3 downto 0),
      clk => clk,
      d(19 downto 0) => d(19 downto 0),
      dpo(19 downto 0) => dpo(19 downto 0),
      dpra(3 downto 0) => dpra(3 downto 0),
      i_ce => '1',
      qdpo(19 downto 0) => NLW_U0_qdpo_UNCONNECTED(19 downto 0),
      qdpo_ce => '1',
      qdpo_clk => '0',
      qdpo_rst => '0',
      qdpo_srst => '0',
      qspo(19 downto 0) => NLW_U0_qspo_UNCONNECTED(19 downto 0),
      qspo_ce => '1',
      qspo_rst => '0',
      qspo_srst => '0',
      spo(19 downto 0) => NLW_U0_spo_UNCONNECTED(19 downto 0),
      we => we
    );
end STRUCTURE;

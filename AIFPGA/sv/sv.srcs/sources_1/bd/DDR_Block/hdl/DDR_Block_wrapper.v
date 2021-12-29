//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Sat Dec 14 10:31:10 2019
//Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target DDR_Block_wrapper.bd
//Design      : DDR_Block_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module DDR_Block_wrapper
   (ACLK_PS,
    DDR3_addr,
    DDR3_ba,
    DDR3_cas_n,
    DDR3_ck_n,
    DDR3_ck_p,
    DDR3_cke,
    DDR3_cs_n,
    DDR3_dm,
    DDR3_dq,
    DDR3_dqs_n,
    DDR3_dqs_p,
    DDR3_odt,
    DDR3_ras_n,
    DDR3_reset_n,
    DDR3_we_n,
    DDR_PS_addr,
    DDR_PS_ba,
    DDR_PS_cas_n,
    DDR_PS_ck_n,
    DDR_PS_ck_p,
    DDR_PS_cke,
    DDR_PS_cs_n,
    DDR_PS_dm,
    DDR_PS_dq,
    DDR_PS_dqs_n,
    DDR_PS_dqs_p,
    DDR_PS_odt,
    DDR_PS_ras_n,
    DDR_PS_reset_n,
    DDR_PS_we_n,
    FCLK_CLK,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    PS_AXI_araddr,
    PS_AXI_arburst,
    PS_AXI_arcache,
    PS_AXI_arlen,
    PS_AXI_arlock,
    PS_AXI_arprot,
    PS_AXI_arqos,
    PS_AXI_arready,
    PS_AXI_arregion,
    PS_AXI_arsize,
    PS_AXI_arvalid,
    PS_AXI_awaddr,
    PS_AXI_awburst,
    PS_AXI_awcache,
    PS_AXI_awlen,
    PS_AXI_awlock,
    PS_AXI_awprot,
    PS_AXI_awqos,
    PS_AXI_awready,
    PS_AXI_awregion,
    PS_AXI_awsize,
    PS_AXI_awvalid,
    PS_AXI_bready,
    PS_AXI_bresp,
    PS_AXI_bvalid,
    PS_AXI_rdata,
    PS_AXI_rlast,
    PS_AXI_rready,
    PS_AXI_rresp,
    PS_AXI_rvalid,
    PS_AXI_wdata,
    PS_AXI_wlast,
    PS_AXI_wready,
    PS_AXI_wstrb,
    PS_AXI_wvalid,
    S0_AXI_araddr,
    S0_AXI_arburst,
    S0_AXI_arcache,
    S0_AXI_arlen,
    S0_AXI_arlock,
    S0_AXI_arprot,
    S0_AXI_arqos,
    S0_AXI_arready,
    S0_AXI_arregion,
    S0_AXI_arsize,
    S0_AXI_arvalid,
    S0_AXI_awaddr,
    S0_AXI_awburst,
    S0_AXI_awcache,
    S0_AXI_awlen,
    S0_AXI_awlock,
    S0_AXI_awprot,
    S0_AXI_awqos,
    S0_AXI_awready,
    S0_AXI_awregion,
    S0_AXI_awsize,
    S0_AXI_awvalid,
    S0_AXI_bready,
    S0_AXI_bresp,
    S0_AXI_bvalid,
    S0_AXI_rdata,
    S0_AXI_rlast,
    S0_AXI_rready,
    S0_AXI_rresp,
    S0_AXI_rvalid,
    S0_AXI_wdata,
    S0_AXI_wlast,
    S0_AXI_wready,
    S0_AXI_wstrb,
    S0_AXI_wvalid,
    S1_AXI_araddr,
    S1_AXI_arburst,
    S1_AXI_arcache,
    S1_AXI_arlen,
    S1_AXI_arlock,
    S1_AXI_arprot,
    S1_AXI_arqos,
    S1_AXI_arready,
    S1_AXI_arregion,
    S1_AXI_arsize,
    S1_AXI_arvalid,
    S1_AXI_awaddr,
    S1_AXI_awburst,
    S1_AXI_awcache,
    S1_AXI_awlen,
    S1_AXI_awlock,
    S1_AXI_awprot,
    S1_AXI_awqos,
    S1_AXI_awready,
    S1_AXI_awregion,
    S1_AXI_awsize,
    S1_AXI_awvalid,
    S1_AXI_bready,
    S1_AXI_bresp,
    S1_AXI_bvalid,
    S1_AXI_rdata,
    S1_AXI_rlast,
    S1_AXI_rready,
    S1_AXI_rresp,
    S1_AXI_rvalid,
    S1_AXI_wdata,
    S1_AXI_wlast,
    S1_AXI_wready,
    S1_AXI_wstrb,
    S1_AXI_wvalid,
    clock_clk_n,
    clock_clk_p,
    init_calib_complete,
    resetN,
    ui_clk,
    ui_clk_sync_rst);
  input ACLK_PS;
  output [14:0]DDR3_addr;
  output [2:0]DDR3_ba;
  output DDR3_cas_n;
  output [0:0]DDR3_ck_n;
  output [0:0]DDR3_ck_p;
  output [0:0]DDR3_cke;
  output [0:0]DDR3_cs_n;
  output [3:0]DDR3_dm;
  inout [31:0]DDR3_dq;
  inout [3:0]DDR3_dqs_n;
  inout [3:0]DDR3_dqs_p;
  output [0:0]DDR3_odt;
  output DDR3_ras_n;
  output DDR3_reset_n;
  output DDR3_we_n;
  inout [14:0]DDR_PS_addr;
  inout [2:0]DDR_PS_ba;
  inout DDR_PS_cas_n;
  inout DDR_PS_ck_n;
  inout DDR_PS_ck_p;
  inout DDR_PS_cke;
  inout DDR_PS_cs_n;
  inout [3:0]DDR_PS_dm;
  inout [31:0]DDR_PS_dq;
  inout [3:0]DDR_PS_dqs_n;
  inout [3:0]DDR_PS_dqs_p;
  inout DDR_PS_odt;
  inout DDR_PS_ras_n;
  inout DDR_PS_reset_n;
  inout DDR_PS_we_n;
  output FCLK_CLK;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input [31:0]PS_AXI_araddr;
  input [1:0]PS_AXI_arburst;
  input [3:0]PS_AXI_arcache;
  input [7:0]PS_AXI_arlen;
  input [0:0]PS_AXI_arlock;
  input [2:0]PS_AXI_arprot;
  input [3:0]PS_AXI_arqos;
  output PS_AXI_arready;
  input [3:0]PS_AXI_arregion;
  input [2:0]PS_AXI_arsize;
  input PS_AXI_arvalid;
  input [31:0]PS_AXI_awaddr;
  input [1:0]PS_AXI_awburst;
  input [3:0]PS_AXI_awcache;
  input [7:0]PS_AXI_awlen;
  input [0:0]PS_AXI_awlock;
  input [2:0]PS_AXI_awprot;
  input [3:0]PS_AXI_awqos;
  output PS_AXI_awready;
  input [3:0]PS_AXI_awregion;
  input [2:0]PS_AXI_awsize;
  input PS_AXI_awvalid;
  input PS_AXI_bready;
  output [1:0]PS_AXI_bresp;
  output PS_AXI_bvalid;
  output [63:0]PS_AXI_rdata;
  output PS_AXI_rlast;
  input PS_AXI_rready;
  output [1:0]PS_AXI_rresp;
  output PS_AXI_rvalid;
  input [63:0]PS_AXI_wdata;
  input PS_AXI_wlast;
  output PS_AXI_wready;
  input [7:0]PS_AXI_wstrb;
  input PS_AXI_wvalid;
  input [31:0]S0_AXI_araddr;
  input [1:0]S0_AXI_arburst;
  input [3:0]S0_AXI_arcache;
  input [7:0]S0_AXI_arlen;
  input [0:0]S0_AXI_arlock;
  input [2:0]S0_AXI_arprot;
  input [3:0]S0_AXI_arqos;
  output S0_AXI_arready;
  input [3:0]S0_AXI_arregion;
  input [2:0]S0_AXI_arsize;
  input S0_AXI_arvalid;
  input [31:0]S0_AXI_awaddr;
  input [1:0]S0_AXI_awburst;
  input [3:0]S0_AXI_awcache;
  input [7:0]S0_AXI_awlen;
  input [0:0]S0_AXI_awlock;
  input [2:0]S0_AXI_awprot;
  input [3:0]S0_AXI_awqos;
  output S0_AXI_awready;
  input [3:0]S0_AXI_awregion;
  input [2:0]S0_AXI_awsize;
  input S0_AXI_awvalid;
  input S0_AXI_bready;
  output [1:0]S0_AXI_bresp;
  output S0_AXI_bvalid;
  output [255:0]S0_AXI_rdata;
  output S0_AXI_rlast;
  input S0_AXI_rready;
  output [1:0]S0_AXI_rresp;
  output S0_AXI_rvalid;
  input [255:0]S0_AXI_wdata;
  input S0_AXI_wlast;
  output S0_AXI_wready;
  input [31:0]S0_AXI_wstrb;
  input S0_AXI_wvalid;
  input [31:0]S1_AXI_araddr;
  input [1:0]S1_AXI_arburst;
  input [3:0]S1_AXI_arcache;
  input [7:0]S1_AXI_arlen;
  input [0:0]S1_AXI_arlock;
  input [2:0]S1_AXI_arprot;
  input [3:0]S1_AXI_arqos;
  output S1_AXI_arready;
  input [3:0]S1_AXI_arregion;
  input [2:0]S1_AXI_arsize;
  input S1_AXI_arvalid;
  input [31:0]S1_AXI_awaddr;
  input [1:0]S1_AXI_awburst;
  input [3:0]S1_AXI_awcache;
  input [7:0]S1_AXI_awlen;
  input [0:0]S1_AXI_awlock;
  input [2:0]S1_AXI_awprot;
  input [3:0]S1_AXI_awqos;
  output S1_AXI_awready;
  input [3:0]S1_AXI_awregion;
  input [2:0]S1_AXI_awsize;
  input S1_AXI_awvalid;
  input S1_AXI_bready;
  output [1:0]S1_AXI_bresp;
  output S1_AXI_bvalid;
  output [255:0]S1_AXI_rdata;
  output S1_AXI_rlast;
  input S1_AXI_rready;
  output [1:0]S1_AXI_rresp;
  output S1_AXI_rvalid;
  input [255:0]S1_AXI_wdata;
  input S1_AXI_wlast;
  output S1_AXI_wready;
  input [31:0]S1_AXI_wstrb;
  input S1_AXI_wvalid;
  input clock_clk_n;
  input clock_clk_p;
  output init_calib_complete;
  input resetN;
  output ui_clk;
  output ui_clk_sync_rst;

  wire ACLK_PS;
  wire [14:0]DDR3_addr;
  wire [2:0]DDR3_ba;
  wire DDR3_cas_n;
  wire [0:0]DDR3_ck_n;
  wire [0:0]DDR3_ck_p;
  wire [0:0]DDR3_cke;
  wire [0:0]DDR3_cs_n;
  wire [3:0]DDR3_dm;
  wire [31:0]DDR3_dq;
  wire [3:0]DDR3_dqs_n;
  wire [3:0]DDR3_dqs_p;
  wire [0:0]DDR3_odt;
  wire DDR3_ras_n;
  wire DDR3_reset_n;
  wire DDR3_we_n;
  wire [14:0]DDR_PS_addr;
  wire [2:0]DDR_PS_ba;
  wire DDR_PS_cas_n;
  wire DDR_PS_ck_n;
  wire DDR_PS_ck_p;
  wire DDR_PS_cke;
  wire DDR_PS_cs_n;
  wire [3:0]DDR_PS_dm;
  wire [31:0]DDR_PS_dq;
  wire [3:0]DDR_PS_dqs_n;
  wire [3:0]DDR_PS_dqs_p;
  wire DDR_PS_odt;
  wire DDR_PS_ras_n;
  wire DDR_PS_reset_n;
  wire DDR_PS_we_n;
  wire FCLK_CLK;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [31:0]PS_AXI_araddr;
  wire [1:0]PS_AXI_arburst;
  wire [3:0]PS_AXI_arcache;
  wire [7:0]PS_AXI_arlen;
  wire [0:0]PS_AXI_arlock;
  wire [2:0]PS_AXI_arprot;
  wire [3:0]PS_AXI_arqos;
  wire PS_AXI_arready;
  wire [3:0]PS_AXI_arregion;
  wire [2:0]PS_AXI_arsize;
  wire PS_AXI_arvalid;
  wire [31:0]PS_AXI_awaddr;
  wire [1:0]PS_AXI_awburst;
  wire [3:0]PS_AXI_awcache;
  wire [7:0]PS_AXI_awlen;
  wire [0:0]PS_AXI_awlock;
  wire [2:0]PS_AXI_awprot;
  wire [3:0]PS_AXI_awqos;
  wire PS_AXI_awready;
  wire [3:0]PS_AXI_awregion;
  wire [2:0]PS_AXI_awsize;
  wire PS_AXI_awvalid;
  wire PS_AXI_bready;
  wire [1:0]PS_AXI_bresp;
  wire PS_AXI_bvalid;
  wire [63:0]PS_AXI_rdata;
  wire PS_AXI_rlast;
  wire PS_AXI_rready;
  wire [1:0]PS_AXI_rresp;
  wire PS_AXI_rvalid;
  wire [63:0]PS_AXI_wdata;
  wire PS_AXI_wlast;
  wire PS_AXI_wready;
  wire [7:0]PS_AXI_wstrb;
  wire PS_AXI_wvalid;
  wire [31:0]S0_AXI_araddr;
  wire [1:0]S0_AXI_arburst;
  wire [3:0]S0_AXI_arcache;
  wire [7:0]S0_AXI_arlen;
  wire [0:0]S0_AXI_arlock;
  wire [2:0]S0_AXI_arprot;
  wire [3:0]S0_AXI_arqos;
  wire S0_AXI_arready;
  wire [3:0]S0_AXI_arregion;
  wire [2:0]S0_AXI_arsize;
  wire S0_AXI_arvalid;
  wire [31:0]S0_AXI_awaddr;
  wire [1:0]S0_AXI_awburst;
  wire [3:0]S0_AXI_awcache;
  wire [7:0]S0_AXI_awlen;
  wire [0:0]S0_AXI_awlock;
  wire [2:0]S0_AXI_awprot;
  wire [3:0]S0_AXI_awqos;
  wire S0_AXI_awready;
  wire [3:0]S0_AXI_awregion;
  wire [2:0]S0_AXI_awsize;
  wire S0_AXI_awvalid;
  wire S0_AXI_bready;
  wire [1:0]S0_AXI_bresp;
  wire S0_AXI_bvalid;
  wire [255:0]S0_AXI_rdata;
  wire S0_AXI_rlast;
  wire S0_AXI_rready;
  wire [1:0]S0_AXI_rresp;
  wire S0_AXI_rvalid;
  wire [255:0]S0_AXI_wdata;
  wire S0_AXI_wlast;
  wire S0_AXI_wready;
  wire [31:0]S0_AXI_wstrb;
  wire S0_AXI_wvalid;
  wire [31:0]S1_AXI_araddr;
  wire [1:0]S1_AXI_arburst;
  wire [3:0]S1_AXI_arcache;
  wire [7:0]S1_AXI_arlen;
  wire [0:0]S1_AXI_arlock;
  wire [2:0]S1_AXI_arprot;
  wire [3:0]S1_AXI_arqos;
  wire S1_AXI_arready;
  wire [3:0]S1_AXI_arregion;
  wire [2:0]S1_AXI_arsize;
  wire S1_AXI_arvalid;
  wire [31:0]S1_AXI_awaddr;
  wire [1:0]S1_AXI_awburst;
  wire [3:0]S1_AXI_awcache;
  wire [7:0]S1_AXI_awlen;
  wire [0:0]S1_AXI_awlock;
  wire [2:0]S1_AXI_awprot;
  wire [3:0]S1_AXI_awqos;
  wire S1_AXI_awready;
  wire [3:0]S1_AXI_awregion;
  wire [2:0]S1_AXI_awsize;
  wire S1_AXI_awvalid;
  wire S1_AXI_bready;
  wire [1:0]S1_AXI_bresp;
  wire S1_AXI_bvalid;
  wire [255:0]S1_AXI_rdata;
  wire S1_AXI_rlast;
  wire S1_AXI_rready;
  wire [1:0]S1_AXI_rresp;
  wire S1_AXI_rvalid;
  wire [255:0]S1_AXI_wdata;
  wire S1_AXI_wlast;
  wire S1_AXI_wready;
  wire [31:0]S1_AXI_wstrb;
  wire S1_AXI_wvalid;
  wire clock_clk_n;
  wire clock_clk_p;
  wire init_calib_complete;
  wire resetN;
  wire ui_clk;
  wire ui_clk_sync_rst;

  DDR_Block DDR_Block_i
       (.ACLK_PS(ACLK_PS),
        .DDR3_addr(DDR3_addr),
        .DDR3_ba(DDR3_ba),
        .DDR3_cas_n(DDR3_cas_n),
        .DDR3_ck_n(DDR3_ck_n),
        .DDR3_ck_p(DDR3_ck_p),
        .DDR3_cke(DDR3_cke),
        .DDR3_cs_n(DDR3_cs_n),
        .DDR3_dm(DDR3_dm),
        .DDR3_dq(DDR3_dq),
        .DDR3_dqs_n(DDR3_dqs_n),
        .DDR3_dqs_p(DDR3_dqs_p),
        .DDR3_odt(DDR3_odt),
        .DDR3_ras_n(DDR3_ras_n),
        .DDR3_reset_n(DDR3_reset_n),
        .DDR3_we_n(DDR3_we_n),
        .DDR_PS_addr(DDR_PS_addr),
        .DDR_PS_ba(DDR_PS_ba),
        .DDR_PS_cas_n(DDR_PS_cas_n),
        .DDR_PS_ck_n(DDR_PS_ck_n),
        .DDR_PS_ck_p(DDR_PS_ck_p),
        .DDR_PS_cke(DDR_PS_cke),
        .DDR_PS_cs_n(DDR_PS_cs_n),
        .DDR_PS_dm(DDR_PS_dm),
        .DDR_PS_dq(DDR_PS_dq),
        .DDR_PS_dqs_n(DDR_PS_dqs_n),
        .DDR_PS_dqs_p(DDR_PS_dqs_p),
        .DDR_PS_odt(DDR_PS_odt),
        .DDR_PS_ras_n(DDR_PS_ras_n),
        .DDR_PS_reset_n(DDR_PS_reset_n),
        .DDR_PS_we_n(DDR_PS_we_n),
        .FCLK_CLK(FCLK_CLK),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .PS_AXI_araddr(PS_AXI_araddr),
        .PS_AXI_arburst(PS_AXI_arburst),
        .PS_AXI_arcache(PS_AXI_arcache),
        .PS_AXI_arlen(PS_AXI_arlen),
        .PS_AXI_arlock(PS_AXI_arlock),
        .PS_AXI_arprot(PS_AXI_arprot),
        .PS_AXI_arqos(PS_AXI_arqos),
        .PS_AXI_arready(PS_AXI_arready),
        .PS_AXI_arregion(PS_AXI_arregion),
        .PS_AXI_arsize(PS_AXI_arsize),
        .PS_AXI_arvalid(PS_AXI_arvalid),
        .PS_AXI_awaddr(PS_AXI_awaddr),
        .PS_AXI_awburst(PS_AXI_awburst),
        .PS_AXI_awcache(PS_AXI_awcache),
        .PS_AXI_awlen(PS_AXI_awlen),
        .PS_AXI_awlock(PS_AXI_awlock),
        .PS_AXI_awprot(PS_AXI_awprot),
        .PS_AXI_awqos(PS_AXI_awqos),
        .PS_AXI_awready(PS_AXI_awready),
        .PS_AXI_awregion(PS_AXI_awregion),
        .PS_AXI_awsize(PS_AXI_awsize),
        .PS_AXI_awvalid(PS_AXI_awvalid),
        .PS_AXI_bready(PS_AXI_bready),
        .PS_AXI_bresp(PS_AXI_bresp),
        .PS_AXI_bvalid(PS_AXI_bvalid),
        .PS_AXI_rdata(PS_AXI_rdata),
        .PS_AXI_rlast(PS_AXI_rlast),
        .PS_AXI_rready(PS_AXI_rready),
        .PS_AXI_rresp(PS_AXI_rresp),
        .PS_AXI_rvalid(PS_AXI_rvalid),
        .PS_AXI_wdata(PS_AXI_wdata),
        .PS_AXI_wlast(PS_AXI_wlast),
        .PS_AXI_wready(PS_AXI_wready),
        .PS_AXI_wstrb(PS_AXI_wstrb),
        .PS_AXI_wvalid(PS_AXI_wvalid),
        .S0_AXI_araddr(S0_AXI_araddr),
        .S0_AXI_arburst(S0_AXI_arburst),
        .S0_AXI_arcache(S0_AXI_arcache),
        .S0_AXI_arlen(S0_AXI_arlen),
        .S0_AXI_arlock(S0_AXI_arlock),
        .S0_AXI_arprot(S0_AXI_arprot),
        .S0_AXI_arqos(S0_AXI_arqos),
        .S0_AXI_arready(S0_AXI_arready),
        .S0_AXI_arregion(S0_AXI_arregion),
        .S0_AXI_arsize(S0_AXI_arsize),
        .S0_AXI_arvalid(S0_AXI_arvalid),
        .S0_AXI_awaddr(S0_AXI_awaddr),
        .S0_AXI_awburst(S0_AXI_awburst),
        .S0_AXI_awcache(S0_AXI_awcache),
        .S0_AXI_awlen(S0_AXI_awlen),
        .S0_AXI_awlock(S0_AXI_awlock),
        .S0_AXI_awprot(S0_AXI_awprot),
        .S0_AXI_awqos(S0_AXI_awqos),
        .S0_AXI_awready(S0_AXI_awready),
        .S0_AXI_awregion(S0_AXI_awregion),
        .S0_AXI_awsize(S0_AXI_awsize),
        .S0_AXI_awvalid(S0_AXI_awvalid),
        .S0_AXI_bready(S0_AXI_bready),
        .S0_AXI_bresp(S0_AXI_bresp),
        .S0_AXI_bvalid(S0_AXI_bvalid),
        .S0_AXI_rdata(S0_AXI_rdata),
        .S0_AXI_rlast(S0_AXI_rlast),
        .S0_AXI_rready(S0_AXI_rready),
        .S0_AXI_rresp(S0_AXI_rresp),
        .S0_AXI_rvalid(S0_AXI_rvalid),
        .S0_AXI_wdata(S0_AXI_wdata),
        .S0_AXI_wlast(S0_AXI_wlast),
        .S0_AXI_wready(S0_AXI_wready),
        .S0_AXI_wstrb(S0_AXI_wstrb),
        .S0_AXI_wvalid(S0_AXI_wvalid),
        .S1_AXI_araddr(S1_AXI_araddr),
        .S1_AXI_arburst(S1_AXI_arburst),
        .S1_AXI_arcache(S1_AXI_arcache),
        .S1_AXI_arlen(S1_AXI_arlen),
        .S1_AXI_arlock(S1_AXI_arlock),
        .S1_AXI_arprot(S1_AXI_arprot),
        .S1_AXI_arqos(S1_AXI_arqos),
        .S1_AXI_arready(S1_AXI_arready),
        .S1_AXI_arregion(S1_AXI_arregion),
        .S1_AXI_arsize(S1_AXI_arsize),
        .S1_AXI_arvalid(S1_AXI_arvalid),
        .S1_AXI_awaddr(S1_AXI_awaddr),
        .S1_AXI_awburst(S1_AXI_awburst),
        .S1_AXI_awcache(S1_AXI_awcache),
        .S1_AXI_awlen(S1_AXI_awlen),
        .S1_AXI_awlock(S1_AXI_awlock),
        .S1_AXI_awprot(S1_AXI_awprot),
        .S1_AXI_awqos(S1_AXI_awqos),
        .S1_AXI_awready(S1_AXI_awready),
        .S1_AXI_awregion(S1_AXI_awregion),
        .S1_AXI_awsize(S1_AXI_awsize),
        .S1_AXI_awvalid(S1_AXI_awvalid),
        .S1_AXI_bready(S1_AXI_bready),
        .S1_AXI_bresp(S1_AXI_bresp),
        .S1_AXI_bvalid(S1_AXI_bvalid),
        .S1_AXI_rdata(S1_AXI_rdata),
        .S1_AXI_rlast(S1_AXI_rlast),
        .S1_AXI_rready(S1_AXI_rready),
        .S1_AXI_rresp(S1_AXI_rresp),
        .S1_AXI_rvalid(S1_AXI_rvalid),
        .S1_AXI_wdata(S1_AXI_wdata),
        .S1_AXI_wlast(S1_AXI_wlast),
        .S1_AXI_wready(S1_AXI_wready),
        .S1_AXI_wstrb(S1_AXI_wstrb),
        .S1_AXI_wvalid(S1_AXI_wvalid),
        .clock_clk_n(clock_clk_n),
        .clock_clk_p(clock_clk_p),
        .init_calib_complete(init_calib_complete),
        .resetN(resetN),
        .ui_clk(ui_clk),
        .ui_clk_sync_rst(ui_clk_sync_rst));
endmodule

//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Wed Oct 30 10:05:58 2019
//Host        : lei-home-6700k running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target Block_test.bd
//Design      : Block_test
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "Block_test,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=Block_test,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=7,numReposBlks=7,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "Block_test.hwdef" *) 
module Block_test
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
    FCLK_CLK,
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK_PS CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK_PS, CLK_DOMAIN Block_test_ACLK_PS, FREQ_HZ 150000000, INSERT_VIP 0, PHASE 0.000" *) input ACLK_PS;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DDR3, AXI_ARBITRATION_SCHEME TDM, BURST_LENGTH 8, CAN_DEBUG false, CAS_LATENCY 11, CAS_WRITE_LATENCY 11, CS_ENABLED true, DATA_MASK_ENABLED true, DATA_WIDTH 8, MEMORY_TYPE COMPONENTS, MEM_ADDR_MAP ROW_COLUMN_BANK, SLOT Single, TIMEPERIOD_PS 1250" *) output [14:0]DDR3_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 BA" *) output [2:0]DDR3_ba;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CAS_N" *) output DDR3_cas_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CK_N" *) output [0:0]DDR3_ck_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CK_P" *) output [0:0]DDR3_ck_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CKE" *) output [0:0]DDR3_cke;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 CS_N" *) output [0:0]DDR3_cs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 DM" *) output [3:0]DDR3_dm;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 DQ" *) inout [31:0]DDR3_dq;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 DQS_N" *) inout [3:0]DDR3_dqs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 DQS_P" *) inout [3:0]DDR3_dqs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 ODT" *) output [0:0]DDR3_odt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 RAS_N" *) output DDR3_ras_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 RESET_N" *) output DDR3_reset_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR3 WE_N" *) output DDR3_we_n;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.FCLK_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.FCLK_CLK, FREQ_HZ 150000000, INSERT_VIP 0, PHASE 0.000" *) output FCLK_CLK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME PS_AXI, ADDR_WIDTH 32, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN Block_test_mig_7series_0_0_ui_clk, DATA_WIDTH 64, FREQ_HZ 50000000, HAS_BRESP 1, HAS_BURST 1, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 2, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 2, NUM_WRITE_THREADS 1, PHASE 0, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 1, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [31:0]PS_AXI_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARBURST" *) input [1:0]PS_AXI_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARCACHE" *) input [3:0]PS_AXI_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARLEN" *) input [7:0]PS_AXI_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARLOCK" *) input [0:0]PS_AXI_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARPROT" *) input [2:0]PS_AXI_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARQOS" *) input [3:0]PS_AXI_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARREADY" *) output PS_AXI_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARREGION" *) input [3:0]PS_AXI_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARSIZE" *) input [2:0]PS_AXI_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI ARVALID" *) input PS_AXI_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWADDR" *) input [31:0]PS_AXI_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWBURST" *) input [1:0]PS_AXI_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWCACHE" *) input [3:0]PS_AXI_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWLEN" *) input [7:0]PS_AXI_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWLOCK" *) input [0:0]PS_AXI_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWPROT" *) input [2:0]PS_AXI_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWQOS" *) input [3:0]PS_AXI_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWREADY" *) output PS_AXI_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWREGION" *) input [3:0]PS_AXI_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWSIZE" *) input [2:0]PS_AXI_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI AWVALID" *) input PS_AXI_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI BREADY" *) input PS_AXI_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI BRESP" *) output [1:0]PS_AXI_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI BVALID" *) output PS_AXI_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI RDATA" *) output [63:0]PS_AXI_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI RLAST" *) output PS_AXI_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI RREADY" *) input PS_AXI_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI RRESP" *) output [1:0]PS_AXI_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI RVALID" *) output PS_AXI_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI WDATA" *) input [63:0]PS_AXI_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI WLAST" *) input PS_AXI_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI WREADY" *) output PS_AXI_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI WSTRB" *) input [7:0]PS_AXI_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 PS_AXI WVALID" *) input PS_AXI_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S0_AXI, ADDR_WIDTH 32, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN Block_test_mig_7series_0_0_ui_clk, DATA_WIDTH 256, FREQ_HZ 50000000, HAS_BRESP 1, HAS_BURST 1, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 1, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 1, NUM_WRITE_THREADS 1, PHASE 0, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 1, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [31:0]S0_AXI_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARBURST" *) input [1:0]S0_AXI_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARCACHE" *) input [3:0]S0_AXI_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARLEN" *) input [7:0]S0_AXI_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARLOCK" *) input [0:0]S0_AXI_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARPROT" *) input [2:0]S0_AXI_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARQOS" *) input [3:0]S0_AXI_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARREADY" *) output S0_AXI_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARREGION" *) input [3:0]S0_AXI_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARSIZE" *) input [2:0]S0_AXI_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI ARVALID" *) input S0_AXI_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWADDR" *) input [31:0]S0_AXI_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWBURST" *) input [1:0]S0_AXI_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWCACHE" *) input [3:0]S0_AXI_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWLEN" *) input [7:0]S0_AXI_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWLOCK" *) input [0:0]S0_AXI_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWPROT" *) input [2:0]S0_AXI_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWQOS" *) input [3:0]S0_AXI_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWREADY" *) output S0_AXI_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWREGION" *) input [3:0]S0_AXI_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWSIZE" *) input [2:0]S0_AXI_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI AWVALID" *) input S0_AXI_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI BREADY" *) input S0_AXI_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI BRESP" *) output [1:0]S0_AXI_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI BVALID" *) output S0_AXI_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI RDATA" *) output [255:0]S0_AXI_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI RLAST" *) output S0_AXI_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI RREADY" *) input S0_AXI_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI RRESP" *) output [1:0]S0_AXI_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI RVALID" *) output S0_AXI_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI WDATA" *) input [255:0]S0_AXI_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI WLAST" *) input S0_AXI_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI WREADY" *) output S0_AXI_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI WSTRB" *) input [31:0]S0_AXI_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S0_AXI WVALID" *) input S0_AXI_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S1_AXI, ADDR_WIDTH 32, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN Block_test_mig_7series_0_0_ui_clk, DATA_WIDTH 256, FREQ_HZ 50000000, HAS_BRESP 1, HAS_BURST 1, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 1, HAS_REGION 1, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 0, INSERT_VIP 0, MAX_BURST_LENGTH 256, NUM_READ_OUTSTANDING 1, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 1, NUM_WRITE_THREADS 1, PHASE 0, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 1, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) input [31:0]S1_AXI_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARBURST" *) input [1:0]S1_AXI_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARCACHE" *) input [3:0]S1_AXI_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARLEN" *) input [7:0]S1_AXI_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARLOCK" *) input [0:0]S1_AXI_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARPROT" *) input [2:0]S1_AXI_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARQOS" *) input [3:0]S1_AXI_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARREADY" *) output S1_AXI_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARREGION" *) input [3:0]S1_AXI_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARSIZE" *) input [2:0]S1_AXI_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI ARVALID" *) input S1_AXI_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWADDR" *) input [31:0]S1_AXI_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWBURST" *) input [1:0]S1_AXI_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWCACHE" *) input [3:0]S1_AXI_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWLEN" *) input [7:0]S1_AXI_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWLOCK" *) input [0:0]S1_AXI_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWPROT" *) input [2:0]S1_AXI_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWQOS" *) input [3:0]S1_AXI_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWREADY" *) output S1_AXI_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWREGION" *) input [3:0]S1_AXI_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWSIZE" *) input [2:0]S1_AXI_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI AWVALID" *) input S1_AXI_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI BREADY" *) input S1_AXI_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI BRESP" *) output [1:0]S1_AXI_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI BVALID" *) output S1_AXI_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI RDATA" *) output [255:0]S1_AXI_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI RLAST" *) output S1_AXI_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI RREADY" *) input S1_AXI_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI RRESP" *) output [1:0]S1_AXI_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI RVALID" *) output S1_AXI_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI WDATA" *) input [255:0]S1_AXI_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI WLAST" *) input S1_AXI_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI WREADY" *) output S1_AXI_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI WSTRB" *) input [31:0]S1_AXI_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S1_AXI WVALID" *) input S1_AXI_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 clock CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clock, CAN_DEBUG false, FREQ_HZ 200000000" *) input clock_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 clock CLK_P" *) input clock_clk_p;
  output init_calib_complete;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input resetN;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.UI_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.UI_CLK, ASSOCIATED_BUSIF S1_AXI:PS_AXI:S0_AXI, CLK_DOMAIN Block_test_mig_7series_0_0_ui_clk, FREQ_HZ 50000000, INSERT_VIP 0, PHASE 0" *) output ui_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.UI_CLK_SYNC_RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.UI_CLK_SYNC_RST, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) output ui_clk_sync_rst;

  wire [31:0]PS_AXI_1_ARADDR;
  wire [1:0]PS_AXI_1_ARBURST;
  wire [3:0]PS_AXI_1_ARCACHE;
  wire [7:0]PS_AXI_1_ARLEN;
  wire [0:0]PS_AXI_1_ARLOCK;
  wire [2:0]PS_AXI_1_ARPROT;
  wire [3:0]PS_AXI_1_ARQOS;
  wire PS_AXI_1_ARREADY;
  wire [3:0]PS_AXI_1_ARREGION;
  wire [2:0]PS_AXI_1_ARSIZE;
  wire PS_AXI_1_ARVALID;
  wire [31:0]PS_AXI_1_AWADDR;
  wire [1:0]PS_AXI_1_AWBURST;
  wire [3:0]PS_AXI_1_AWCACHE;
  wire [7:0]PS_AXI_1_AWLEN;
  wire [0:0]PS_AXI_1_AWLOCK;
  wire [2:0]PS_AXI_1_AWPROT;
  wire [3:0]PS_AXI_1_AWQOS;
  wire PS_AXI_1_AWREADY;
  wire [3:0]PS_AXI_1_AWREGION;
  wire [2:0]PS_AXI_1_AWSIZE;
  wire PS_AXI_1_AWVALID;
  wire PS_AXI_1_BREADY;
  wire [1:0]PS_AXI_1_BRESP;
  wire PS_AXI_1_BVALID;
  wire [63:0]PS_AXI_1_RDATA;
  wire PS_AXI_1_RLAST;
  wire PS_AXI_1_RREADY;
  wire [1:0]PS_AXI_1_RRESP;
  wire PS_AXI_1_RVALID;
  wire [63:0]PS_AXI_1_WDATA;
  wire PS_AXI_1_WLAST;
  wire PS_AXI_1_WREADY;
  wire [7:0]PS_AXI_1_WSTRB;
  wire PS_AXI_1_WVALID;
  wire [31:0]S0_AXI_1_ARADDR;
  wire [1:0]S0_AXI_1_ARBURST;
  wire [3:0]S0_AXI_1_ARCACHE;
  wire [7:0]S0_AXI_1_ARLEN;
  wire [0:0]S0_AXI_1_ARLOCK;
  wire [2:0]S0_AXI_1_ARPROT;
  wire [3:0]S0_AXI_1_ARQOS;
  wire S0_AXI_1_ARREADY;
  wire [3:0]S0_AXI_1_ARREGION;
  wire [2:0]S0_AXI_1_ARSIZE;
  wire S0_AXI_1_ARVALID;
  wire [31:0]S0_AXI_1_AWADDR;
  wire [1:0]S0_AXI_1_AWBURST;
  wire [3:0]S0_AXI_1_AWCACHE;
  wire [7:0]S0_AXI_1_AWLEN;
  wire [0:0]S0_AXI_1_AWLOCK;
  wire [2:0]S0_AXI_1_AWPROT;
  wire [3:0]S0_AXI_1_AWQOS;
  wire S0_AXI_1_AWREADY;
  wire [3:0]S0_AXI_1_AWREGION;
  wire [2:0]S0_AXI_1_AWSIZE;
  wire S0_AXI_1_AWVALID;
  wire S0_AXI_1_BREADY;
  wire [1:0]S0_AXI_1_BRESP;
  wire S0_AXI_1_BVALID;
  wire [255:0]S0_AXI_1_RDATA;
  wire S0_AXI_1_RLAST;
  wire S0_AXI_1_RREADY;
  wire [1:0]S0_AXI_1_RRESP;
  wire S0_AXI_1_RVALID;
  wire [255:0]S0_AXI_1_WDATA;
  wire S0_AXI_1_WLAST;
  wire S0_AXI_1_WREADY;
  wire [31:0]S0_AXI_1_WSTRB;
  wire S0_AXI_1_WVALID;
  wire [31:0]S1_AXI_1_ARADDR;
  wire [1:0]S1_AXI_1_ARBURST;
  wire [3:0]S1_AXI_1_ARCACHE;
  wire [7:0]S1_AXI_1_ARLEN;
  wire [0:0]S1_AXI_1_ARLOCK;
  wire [2:0]S1_AXI_1_ARPROT;
  wire [3:0]S1_AXI_1_ARQOS;
  wire S1_AXI_1_ARREADY;
  wire [3:0]S1_AXI_1_ARREGION;
  wire [2:0]S1_AXI_1_ARSIZE;
  wire S1_AXI_1_ARVALID;
  wire [31:0]S1_AXI_1_AWADDR;
  wire [1:0]S1_AXI_1_AWBURST;
  wire [3:0]S1_AXI_1_AWCACHE;
  wire [7:0]S1_AXI_1_AWLEN;
  wire [0:0]S1_AXI_1_AWLOCK;
  wire [2:0]S1_AXI_1_AWPROT;
  wire [3:0]S1_AXI_1_AWQOS;
  wire S1_AXI_1_AWREADY;
  wire [3:0]S1_AXI_1_AWREGION;
  wire [2:0]S1_AXI_1_AWSIZE;
  wire S1_AXI_1_AWVALID;
  wire S1_AXI_1_BREADY;
  wire [1:0]S1_AXI_1_BRESP;
  wire S1_AXI_1_BVALID;
  wire [255:0]S1_AXI_1_RDATA;
  wire S1_AXI_1_RLAST;
  wire S1_AXI_1_RREADY;
  wire [1:0]S1_AXI_1_RRESP;
  wire S1_AXI_1_RVALID;
  wire [255:0]S1_AXI_1_WDATA;
  wire S1_AXI_1_WLAST;
  wire S1_AXI_1_WREADY;
  wire [31:0]S1_AXI_1_WSTRB;
  wire S1_AXI_1_WVALID;
  wire [31:0]axi_clock_converter_0_M_AXI_ARADDR;
  wire [1:0]axi_clock_converter_0_M_AXI_ARBURST;
  wire [3:0]axi_clock_converter_0_M_AXI_ARCACHE;
  wire [7:0]axi_clock_converter_0_M_AXI_ARLEN;
  wire [0:0]axi_clock_converter_0_M_AXI_ARLOCK;
  wire [2:0]axi_clock_converter_0_M_AXI_ARPROT;
  wire [3:0]axi_clock_converter_0_M_AXI_ARQOS;
  wire axi_clock_converter_0_M_AXI_ARREADY;
  wire [2:0]axi_clock_converter_0_M_AXI_ARSIZE;
  wire axi_clock_converter_0_M_AXI_ARVALID;
  wire [31:0]axi_clock_converter_0_M_AXI_AWADDR;
  wire [1:0]axi_clock_converter_0_M_AXI_AWBURST;
  wire [3:0]axi_clock_converter_0_M_AXI_AWCACHE;
  wire [7:0]axi_clock_converter_0_M_AXI_AWLEN;
  wire [0:0]axi_clock_converter_0_M_AXI_AWLOCK;
  wire [2:0]axi_clock_converter_0_M_AXI_AWPROT;
  wire [3:0]axi_clock_converter_0_M_AXI_AWQOS;
  wire axi_clock_converter_0_M_AXI_AWREADY;
  wire [2:0]axi_clock_converter_0_M_AXI_AWSIZE;
  wire axi_clock_converter_0_M_AXI_AWVALID;
  wire axi_clock_converter_0_M_AXI_BREADY;
  wire [1:0]axi_clock_converter_0_M_AXI_BRESP;
  wire axi_clock_converter_0_M_AXI_BVALID;
  wire [255:0]axi_clock_converter_0_M_AXI_RDATA;
  wire axi_clock_converter_0_M_AXI_RLAST;
  wire axi_clock_converter_0_M_AXI_RREADY;
  wire [1:0]axi_clock_converter_0_M_AXI_RRESP;
  wire axi_clock_converter_0_M_AXI_RVALID;
  wire [255:0]axi_clock_converter_0_M_AXI_WDATA;
  wire axi_clock_converter_0_M_AXI_WLAST;
  wire axi_clock_converter_0_M_AXI_WREADY;
  wire [31:0]axi_clock_converter_0_M_AXI_WSTRB;
  wire axi_clock_converter_0_M_AXI_WVALID;
  wire [31:0]axi_clock_converter_1_M_AXI_ARADDR;
  wire [1:0]axi_clock_converter_1_M_AXI_ARBURST;
  wire [3:0]axi_clock_converter_1_M_AXI_ARCACHE;
  wire [7:0]axi_clock_converter_1_M_AXI_ARLEN;
  wire [0:0]axi_clock_converter_1_M_AXI_ARLOCK;
  wire [2:0]axi_clock_converter_1_M_AXI_ARPROT;
  wire [3:0]axi_clock_converter_1_M_AXI_ARQOS;
  wire axi_clock_converter_1_M_AXI_ARREADY;
  wire [2:0]axi_clock_converter_1_M_AXI_ARSIZE;
  wire axi_clock_converter_1_M_AXI_ARVALID;
  wire [31:0]axi_clock_converter_1_M_AXI_AWADDR;
  wire [1:0]axi_clock_converter_1_M_AXI_AWBURST;
  wire [3:0]axi_clock_converter_1_M_AXI_AWCACHE;
  wire [7:0]axi_clock_converter_1_M_AXI_AWLEN;
  wire [0:0]axi_clock_converter_1_M_AXI_AWLOCK;
  wire [2:0]axi_clock_converter_1_M_AXI_AWPROT;
  wire [3:0]axi_clock_converter_1_M_AXI_AWQOS;
  wire axi_clock_converter_1_M_AXI_AWREADY;
  wire [2:0]axi_clock_converter_1_M_AXI_AWSIZE;
  wire axi_clock_converter_1_M_AXI_AWVALID;
  wire axi_clock_converter_1_M_AXI_BREADY;
  wire [1:0]axi_clock_converter_1_M_AXI_BRESP;
  wire axi_clock_converter_1_M_AXI_BVALID;
  wire [255:0]axi_clock_converter_1_M_AXI_RDATA;
  wire axi_clock_converter_1_M_AXI_RLAST;
  wire axi_clock_converter_1_M_AXI_RREADY;
  wire [1:0]axi_clock_converter_1_M_AXI_RRESP;
  wire axi_clock_converter_1_M_AXI_RVALID;
  wire [255:0]axi_clock_converter_1_M_AXI_WDATA;
  wire axi_clock_converter_1_M_AXI_WLAST;
  wire axi_clock_converter_1_M_AXI_WREADY;
  wire [31:0]axi_clock_converter_1_M_AXI_WSTRB;
  wire axi_clock_converter_1_M_AXI_WVALID;
  wire [31:0]axi_clock_converter_2_M_AXI_ARADDR;
  wire [1:0]axi_clock_converter_2_M_AXI_ARBURST;
  wire [3:0]axi_clock_converter_2_M_AXI_ARCACHE;
  wire [7:0]axi_clock_converter_2_M_AXI_ARLEN;
  wire [0:0]axi_clock_converter_2_M_AXI_ARLOCK;
  wire [2:0]axi_clock_converter_2_M_AXI_ARPROT;
  wire [3:0]axi_clock_converter_2_M_AXI_ARQOS;
  wire axi_clock_converter_2_M_AXI_ARREADY;
  wire [2:0]axi_clock_converter_2_M_AXI_ARSIZE;
  wire axi_clock_converter_2_M_AXI_ARVALID;
  wire [31:0]axi_clock_converter_2_M_AXI_AWADDR;
  wire [1:0]axi_clock_converter_2_M_AXI_AWBURST;
  wire [3:0]axi_clock_converter_2_M_AXI_AWCACHE;
  wire [7:0]axi_clock_converter_2_M_AXI_AWLEN;
  wire [0:0]axi_clock_converter_2_M_AXI_AWLOCK;
  wire [2:0]axi_clock_converter_2_M_AXI_AWPROT;
  wire [3:0]axi_clock_converter_2_M_AXI_AWQOS;
  wire axi_clock_converter_2_M_AXI_AWREADY;
  wire [2:0]axi_clock_converter_2_M_AXI_AWSIZE;
  wire axi_clock_converter_2_M_AXI_AWVALID;
  wire axi_clock_converter_2_M_AXI_BREADY;
  wire [1:0]axi_clock_converter_2_M_AXI_BRESP;
  wire axi_clock_converter_2_M_AXI_BVALID;
  wire [255:0]axi_clock_converter_2_M_AXI_RDATA;
  wire axi_clock_converter_2_M_AXI_RLAST;
  wire axi_clock_converter_2_M_AXI_RREADY;
  wire [1:0]axi_clock_converter_2_M_AXI_RRESP;
  wire axi_clock_converter_2_M_AXI_RVALID;
  wire [255:0]axi_clock_converter_2_M_AXI_WDATA;
  wire axi_clock_converter_2_M_AXI_WLAST;
  wire axi_clock_converter_2_M_AXI_WREADY;
  wire [31:0]axi_clock_converter_2_M_AXI_WSTRB;
  wire axi_clock_converter_2_M_AXI_WVALID;
  wire [31:0]axi_dwidth_converter_0_M_AXI_ARADDR;
  wire [1:0]axi_dwidth_converter_0_M_AXI_ARBURST;
  wire [3:0]axi_dwidth_converter_0_M_AXI_ARCACHE;
  wire [7:0]axi_dwidth_converter_0_M_AXI_ARLEN;
  wire [0:0]axi_dwidth_converter_0_M_AXI_ARLOCK;
  wire [2:0]axi_dwidth_converter_0_M_AXI_ARPROT;
  wire [3:0]axi_dwidth_converter_0_M_AXI_ARQOS;
  wire axi_dwidth_converter_0_M_AXI_ARREADY;
  wire [3:0]axi_dwidth_converter_0_M_AXI_ARREGION;
  wire [2:0]axi_dwidth_converter_0_M_AXI_ARSIZE;
  wire axi_dwidth_converter_0_M_AXI_ARVALID;
  wire [31:0]axi_dwidth_converter_0_M_AXI_AWADDR;
  wire [1:0]axi_dwidth_converter_0_M_AXI_AWBURST;
  wire [3:0]axi_dwidth_converter_0_M_AXI_AWCACHE;
  wire [7:0]axi_dwidth_converter_0_M_AXI_AWLEN;
  wire [0:0]axi_dwidth_converter_0_M_AXI_AWLOCK;
  wire [2:0]axi_dwidth_converter_0_M_AXI_AWPROT;
  wire [3:0]axi_dwidth_converter_0_M_AXI_AWQOS;
  wire axi_dwidth_converter_0_M_AXI_AWREADY;
  wire [3:0]axi_dwidth_converter_0_M_AXI_AWREGION;
  wire [2:0]axi_dwidth_converter_0_M_AXI_AWSIZE;
  wire axi_dwidth_converter_0_M_AXI_AWVALID;
  wire axi_dwidth_converter_0_M_AXI_BREADY;
  wire [1:0]axi_dwidth_converter_0_M_AXI_BRESP;
  wire axi_dwidth_converter_0_M_AXI_BVALID;
  wire [255:0]axi_dwidth_converter_0_M_AXI_RDATA;
  wire axi_dwidth_converter_0_M_AXI_RLAST;
  wire axi_dwidth_converter_0_M_AXI_RREADY;
  wire [1:0]axi_dwidth_converter_0_M_AXI_RRESP;
  wire axi_dwidth_converter_0_M_AXI_RVALID;
  wire [255:0]axi_dwidth_converter_0_M_AXI_WDATA;
  wire axi_dwidth_converter_0_M_AXI_WLAST;
  wire axi_dwidth_converter_0_M_AXI_WREADY;
  wire [31:0]axi_dwidth_converter_0_M_AXI_WSTRB;
  wire axi_dwidth_converter_0_M_AXI_WVALID;
  wire clock_1_CLK_N;
  wire clock_1_CLK_P;
  wire [14:0]mig_7series_0_DDR3_ADDR;
  wire [2:0]mig_7series_0_DDR3_BA;
  wire mig_7series_0_DDR3_CAS_N;
  wire [0:0]mig_7series_0_DDR3_CKE;
  wire [0:0]mig_7series_0_DDR3_CK_N;
  wire [0:0]mig_7series_0_DDR3_CK_P;
  wire [0:0]mig_7series_0_DDR3_CS_N;
  wire [3:0]mig_7series_0_DDR3_DM;
  wire [31:0]mig_7series_0_DDR3_DQ;
  wire [3:0]mig_7series_0_DDR3_DQS_N;
  wire [3:0]mig_7series_0_DDR3_DQS_P;
  wire [0:0]mig_7series_0_DDR3_ODT;
  wire mig_7series_0_DDR3_RAS_N;
  wire mig_7series_0_DDR3_RESET_N;
  wire mig_7series_0_DDR3_WE_N;
  wire mig_7series_0_init_calib_complete;
  wire mig_7series_0_mmcm_locked;
  wire mig_7series_0_ui_addn_clk_0;
  wire mig_7series_0_ui_clk;
  wire mig_7series_0_ui_clk_sync_rst;
  wire [0:0]proc_sys_reset_0_interconnect_aresetn;
  wire [0:0]proc_sys_reset_0_peripheral_aresetn;
  wire resetn_0_1;
  wire [29:0]smartconnect_0_M00_AXI_ARADDR;
  wire [1:0]smartconnect_0_M00_AXI_ARBURST;
  wire [3:0]smartconnect_0_M00_AXI_ARCACHE;
  wire [7:0]smartconnect_0_M00_AXI_ARLEN;
  wire [0:0]smartconnect_0_M00_AXI_ARLOCK;
  wire [2:0]smartconnect_0_M00_AXI_ARPROT;
  wire [3:0]smartconnect_0_M00_AXI_ARQOS;
  wire smartconnect_0_M00_AXI_ARREADY;
  wire [2:0]smartconnect_0_M00_AXI_ARSIZE;
  wire smartconnect_0_M00_AXI_ARVALID;
  wire [29:0]smartconnect_0_M00_AXI_AWADDR;
  wire [1:0]smartconnect_0_M00_AXI_AWBURST;
  wire [3:0]smartconnect_0_M00_AXI_AWCACHE;
  wire [7:0]smartconnect_0_M00_AXI_AWLEN;
  wire [0:0]smartconnect_0_M00_AXI_AWLOCK;
  wire [2:0]smartconnect_0_M00_AXI_AWPROT;
  wire [3:0]smartconnect_0_M00_AXI_AWQOS;
  wire smartconnect_0_M00_AXI_AWREADY;
  wire [2:0]smartconnect_0_M00_AXI_AWSIZE;
  wire smartconnect_0_M00_AXI_AWVALID;
  wire smartconnect_0_M00_AXI_BREADY;
  wire [1:0]smartconnect_0_M00_AXI_BRESP;
  wire smartconnect_0_M00_AXI_BVALID;
  wire [255:0]smartconnect_0_M00_AXI_RDATA;
  wire smartconnect_0_M00_AXI_RLAST;
  wire smartconnect_0_M00_AXI_RREADY;
  wire [1:0]smartconnect_0_M00_AXI_RRESP;
  wire smartconnect_0_M00_AXI_RVALID;
  wire [255:0]smartconnect_0_M00_AXI_WDATA;
  wire smartconnect_0_M00_AXI_WLAST;
  wire smartconnect_0_M00_AXI_WREADY;
  wire [31:0]smartconnect_0_M00_AXI_WSTRB;
  wire smartconnect_0_M00_AXI_WVALID;

  assign DDR3_addr[14:0] = mig_7series_0_DDR3_ADDR;
  assign DDR3_ba[2:0] = mig_7series_0_DDR3_BA;
  assign DDR3_cas_n = mig_7series_0_DDR3_CAS_N;
  assign DDR3_ck_n[0] = mig_7series_0_DDR3_CK_N;
  assign DDR3_ck_p[0] = mig_7series_0_DDR3_CK_P;
  assign DDR3_cke[0] = mig_7series_0_DDR3_CKE;
  assign DDR3_cs_n[0] = mig_7series_0_DDR3_CS_N;
  assign DDR3_dm[3:0] = mig_7series_0_DDR3_DM;
  assign DDR3_odt[0] = mig_7series_0_DDR3_ODT;
  assign DDR3_ras_n = mig_7series_0_DDR3_RAS_N;
  assign DDR3_reset_n = mig_7series_0_DDR3_RESET_N;
  assign DDR3_we_n = mig_7series_0_DDR3_WE_N;
  assign PS_AXI_1_ARADDR = PS_AXI_araddr[31:0];
  assign PS_AXI_1_ARBURST = PS_AXI_arburst[1:0];
  assign PS_AXI_1_ARCACHE = PS_AXI_arcache[3:0];
  assign PS_AXI_1_ARLEN = PS_AXI_arlen[7:0];
  assign PS_AXI_1_ARLOCK = PS_AXI_arlock[0];
  assign PS_AXI_1_ARPROT = PS_AXI_arprot[2:0];
  assign PS_AXI_1_ARQOS = PS_AXI_arqos[3:0];
  assign PS_AXI_1_ARREGION = PS_AXI_arregion[3:0];
  assign PS_AXI_1_ARSIZE = PS_AXI_arsize[2:0];
  assign PS_AXI_1_ARVALID = PS_AXI_arvalid;
  assign PS_AXI_1_AWADDR = PS_AXI_awaddr[31:0];
  assign PS_AXI_1_AWBURST = PS_AXI_awburst[1:0];
  assign PS_AXI_1_AWCACHE = PS_AXI_awcache[3:0];
  assign PS_AXI_1_AWLEN = PS_AXI_awlen[7:0];
  assign PS_AXI_1_AWLOCK = PS_AXI_awlock[0];
  assign PS_AXI_1_AWPROT = PS_AXI_awprot[2:0];
  assign PS_AXI_1_AWQOS = PS_AXI_awqos[3:0];
  assign PS_AXI_1_AWREGION = PS_AXI_awregion[3:0];
  assign PS_AXI_1_AWSIZE = PS_AXI_awsize[2:0];
  assign PS_AXI_1_AWVALID = PS_AXI_awvalid;
  assign PS_AXI_1_BREADY = PS_AXI_bready;
  assign PS_AXI_1_RREADY = PS_AXI_rready;
  assign PS_AXI_1_WDATA = PS_AXI_wdata[63:0];
  assign PS_AXI_1_WLAST = PS_AXI_wlast;
  assign PS_AXI_1_WSTRB = PS_AXI_wstrb[7:0];
  assign PS_AXI_1_WVALID = PS_AXI_wvalid;
  assign PS_AXI_arready = PS_AXI_1_ARREADY;
  assign PS_AXI_awready = PS_AXI_1_AWREADY;
  assign PS_AXI_bresp[1:0] = PS_AXI_1_BRESP;
  assign PS_AXI_bvalid = PS_AXI_1_BVALID;
  assign PS_AXI_rdata[63:0] = PS_AXI_1_RDATA;
  assign PS_AXI_rlast = PS_AXI_1_RLAST;
  assign PS_AXI_rresp[1:0] = PS_AXI_1_RRESP;
  assign PS_AXI_rvalid = PS_AXI_1_RVALID;
  assign PS_AXI_wready = PS_AXI_1_WREADY;
  assign S0_AXI_1_ARADDR = S0_AXI_araddr[31:0];
  assign S0_AXI_1_ARBURST = S0_AXI_arburst[1:0];
  assign S0_AXI_1_ARCACHE = S0_AXI_arcache[3:0];
  assign S0_AXI_1_ARLEN = S0_AXI_arlen[7:0];
  assign S0_AXI_1_ARLOCK = S0_AXI_arlock[0];
  assign S0_AXI_1_ARPROT = S0_AXI_arprot[2:0];
  assign S0_AXI_1_ARQOS = S0_AXI_arqos[3:0];
  assign S0_AXI_1_ARREGION = S0_AXI_arregion[3:0];
  assign S0_AXI_1_ARSIZE = S0_AXI_arsize[2:0];
  assign S0_AXI_1_ARVALID = S0_AXI_arvalid;
  assign S0_AXI_1_AWADDR = S0_AXI_awaddr[31:0];
  assign S0_AXI_1_AWBURST = S0_AXI_awburst[1:0];
  assign S0_AXI_1_AWCACHE = S0_AXI_awcache[3:0];
  assign S0_AXI_1_AWLEN = S0_AXI_awlen[7:0];
  assign S0_AXI_1_AWLOCK = S0_AXI_awlock[0];
  assign S0_AXI_1_AWPROT = S0_AXI_awprot[2:0];
  assign S0_AXI_1_AWQOS = S0_AXI_awqos[3:0];
  assign S0_AXI_1_AWREGION = S0_AXI_awregion[3:0];
  assign S0_AXI_1_AWSIZE = S0_AXI_awsize[2:0];
  assign S0_AXI_1_AWVALID = S0_AXI_awvalid;
  assign S0_AXI_1_BREADY = S0_AXI_bready;
  assign S0_AXI_1_RREADY = S0_AXI_rready;
  assign S0_AXI_1_WDATA = S0_AXI_wdata[255:0];
  assign S0_AXI_1_WLAST = S0_AXI_wlast;
  assign S0_AXI_1_WSTRB = S0_AXI_wstrb[31:0];
  assign S0_AXI_1_WVALID = S0_AXI_wvalid;
  assign S0_AXI_arready = S0_AXI_1_ARREADY;
  assign S0_AXI_awready = S0_AXI_1_AWREADY;
  assign S0_AXI_bresp[1:0] = S0_AXI_1_BRESP;
  assign S0_AXI_bvalid = S0_AXI_1_BVALID;
  assign S0_AXI_rdata[255:0] = S0_AXI_1_RDATA;
  assign S0_AXI_rlast = S0_AXI_1_RLAST;
  assign S0_AXI_rresp[1:0] = S0_AXI_1_RRESP;
  assign S0_AXI_rvalid = S0_AXI_1_RVALID;
  assign S0_AXI_wready = S0_AXI_1_WREADY;
  assign S1_AXI_1_ARADDR = S1_AXI_araddr[31:0];
  assign S1_AXI_1_ARBURST = S1_AXI_arburst[1:0];
  assign S1_AXI_1_ARCACHE = S1_AXI_arcache[3:0];
  assign S1_AXI_1_ARLEN = S1_AXI_arlen[7:0];
  assign S1_AXI_1_ARLOCK = S1_AXI_arlock[0];
  assign S1_AXI_1_ARPROT = S1_AXI_arprot[2:0];
  assign S1_AXI_1_ARQOS = S1_AXI_arqos[3:0];
  assign S1_AXI_1_ARREGION = S1_AXI_arregion[3:0];
  assign S1_AXI_1_ARSIZE = S1_AXI_arsize[2:0];
  assign S1_AXI_1_ARVALID = S1_AXI_arvalid;
  assign S1_AXI_1_AWADDR = S1_AXI_awaddr[31:0];
  assign S1_AXI_1_AWBURST = S1_AXI_awburst[1:0];
  assign S1_AXI_1_AWCACHE = S1_AXI_awcache[3:0];
  assign S1_AXI_1_AWLEN = S1_AXI_awlen[7:0];
  assign S1_AXI_1_AWLOCK = S1_AXI_awlock[0];
  assign S1_AXI_1_AWPROT = S1_AXI_awprot[2:0];
  assign S1_AXI_1_AWQOS = S1_AXI_awqos[3:0];
  assign S1_AXI_1_AWREGION = S1_AXI_awregion[3:0];
  assign S1_AXI_1_AWSIZE = S1_AXI_awsize[2:0];
  assign S1_AXI_1_AWVALID = S1_AXI_awvalid;
  assign S1_AXI_1_BREADY = S1_AXI_bready;
  assign S1_AXI_1_RREADY = S1_AXI_rready;
  assign S1_AXI_1_WDATA = S1_AXI_wdata[255:0];
  assign S1_AXI_1_WLAST = S1_AXI_wlast;
  assign S1_AXI_1_WSTRB = S1_AXI_wstrb[31:0];
  assign S1_AXI_1_WVALID = S1_AXI_wvalid;
  assign S1_AXI_arready = S1_AXI_1_ARREADY;
  assign S1_AXI_awready = S1_AXI_1_AWREADY;
  assign S1_AXI_bresp[1:0] = S1_AXI_1_BRESP;
  assign S1_AXI_bvalid = S1_AXI_1_BVALID;
  assign S1_AXI_rdata[255:0] = S1_AXI_1_RDATA;
  assign S1_AXI_rlast = S1_AXI_1_RLAST;
  assign S1_AXI_rresp[1:0] = S1_AXI_1_RRESP;
  assign S1_AXI_rvalid = S1_AXI_1_RVALID;
  assign S1_AXI_wready = S1_AXI_1_WREADY;
  assign clock_1_CLK_N = clock_clk_n;
  assign clock_1_CLK_P = clock_clk_p;
  assign init_calib_complete = mig_7series_0_init_calib_complete;
  assign resetn_0_1 = resetN;
  assign ui_clk = mig_7series_0_ui_addn_clk_0;
  assign ui_clk_sync_rst = mig_7series_0_ui_clk_sync_rst;
  Block_test_axi_clock_converter_0_0 axi_clock_converter_0
       (.m_axi_aclk(mig_7series_0_ui_clk),
        .m_axi_araddr(axi_clock_converter_0_M_AXI_ARADDR),
        .m_axi_arburst(axi_clock_converter_0_M_AXI_ARBURST),
        .m_axi_arcache(axi_clock_converter_0_M_AXI_ARCACHE),
        .m_axi_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .m_axi_arlen(axi_clock_converter_0_M_AXI_ARLEN),
        .m_axi_arlock(axi_clock_converter_0_M_AXI_ARLOCK),
        .m_axi_arprot(axi_clock_converter_0_M_AXI_ARPROT),
        .m_axi_arqos(axi_clock_converter_0_M_AXI_ARQOS),
        .m_axi_arready(axi_clock_converter_0_M_AXI_ARREADY),
        .m_axi_arsize(axi_clock_converter_0_M_AXI_ARSIZE),
        .m_axi_arvalid(axi_clock_converter_0_M_AXI_ARVALID),
        .m_axi_awaddr(axi_clock_converter_0_M_AXI_AWADDR),
        .m_axi_awburst(axi_clock_converter_0_M_AXI_AWBURST),
        .m_axi_awcache(axi_clock_converter_0_M_AXI_AWCACHE),
        .m_axi_awlen(axi_clock_converter_0_M_AXI_AWLEN),
        .m_axi_awlock(axi_clock_converter_0_M_AXI_AWLOCK),
        .m_axi_awprot(axi_clock_converter_0_M_AXI_AWPROT),
        .m_axi_awqos(axi_clock_converter_0_M_AXI_AWQOS),
        .m_axi_awready(axi_clock_converter_0_M_AXI_AWREADY),
        .m_axi_awsize(axi_clock_converter_0_M_AXI_AWSIZE),
        .m_axi_awvalid(axi_clock_converter_0_M_AXI_AWVALID),
        .m_axi_bready(axi_clock_converter_0_M_AXI_BREADY),
        .m_axi_bresp(axi_clock_converter_0_M_AXI_BRESP),
        .m_axi_bvalid(axi_clock_converter_0_M_AXI_BVALID),
        .m_axi_rdata(axi_clock_converter_0_M_AXI_RDATA),
        .m_axi_rlast(axi_clock_converter_0_M_AXI_RLAST),
        .m_axi_rready(axi_clock_converter_0_M_AXI_RREADY),
        .m_axi_rresp(axi_clock_converter_0_M_AXI_RRESP),
        .m_axi_rvalid(axi_clock_converter_0_M_AXI_RVALID),
        .m_axi_wdata(axi_clock_converter_0_M_AXI_WDATA),
        .m_axi_wlast(axi_clock_converter_0_M_AXI_WLAST),
        .m_axi_wready(axi_clock_converter_0_M_AXI_WREADY),
        .m_axi_wstrb(axi_clock_converter_0_M_AXI_WSTRB),
        .m_axi_wvalid(axi_clock_converter_0_M_AXI_WVALID),
        .s_axi_aclk(mig_7series_0_ui_addn_clk_0),
        .s_axi_araddr(S0_AXI_1_ARADDR),
        .s_axi_arburst(S0_AXI_1_ARBURST),
        .s_axi_arcache(S0_AXI_1_ARCACHE),
        .s_axi_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .s_axi_arlen(S0_AXI_1_ARLEN),
        .s_axi_arlock(S0_AXI_1_ARLOCK),
        .s_axi_arprot(S0_AXI_1_ARPROT),
        .s_axi_arqos(S0_AXI_1_ARQOS),
        .s_axi_arready(S0_AXI_1_ARREADY),
        .s_axi_arregion(S0_AXI_1_ARREGION),
        .s_axi_arsize(S0_AXI_1_ARSIZE),
        .s_axi_arvalid(S0_AXI_1_ARVALID),
        .s_axi_awaddr(S0_AXI_1_AWADDR),
        .s_axi_awburst(S0_AXI_1_AWBURST),
        .s_axi_awcache(S0_AXI_1_AWCACHE),
        .s_axi_awlen(S0_AXI_1_AWLEN),
        .s_axi_awlock(S0_AXI_1_AWLOCK),
        .s_axi_awprot(S0_AXI_1_AWPROT),
        .s_axi_awqos(S0_AXI_1_AWQOS),
        .s_axi_awready(S0_AXI_1_AWREADY),
        .s_axi_awregion(S0_AXI_1_AWREGION),
        .s_axi_awsize(S0_AXI_1_AWSIZE),
        .s_axi_awvalid(S0_AXI_1_AWVALID),
        .s_axi_bready(S0_AXI_1_BREADY),
        .s_axi_bresp(S0_AXI_1_BRESP),
        .s_axi_bvalid(S0_AXI_1_BVALID),
        .s_axi_rdata(S0_AXI_1_RDATA),
        .s_axi_rlast(S0_AXI_1_RLAST),
        .s_axi_rready(S0_AXI_1_RREADY),
        .s_axi_rresp(S0_AXI_1_RRESP),
        .s_axi_rvalid(S0_AXI_1_RVALID),
        .s_axi_wdata(S0_AXI_1_WDATA),
        .s_axi_wlast(S0_AXI_1_WLAST),
        .s_axi_wready(S0_AXI_1_WREADY),
        .s_axi_wstrb(S0_AXI_1_WSTRB),
        .s_axi_wvalid(S0_AXI_1_WVALID));
  Block_test_axi_clock_converter_1_0 axi_clock_converter_1
       (.m_axi_aclk(mig_7series_0_ui_clk),
        .m_axi_araddr(axi_clock_converter_1_M_AXI_ARADDR),
        .m_axi_arburst(axi_clock_converter_1_M_AXI_ARBURST),
        .m_axi_arcache(axi_clock_converter_1_M_AXI_ARCACHE),
        .m_axi_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .m_axi_arlen(axi_clock_converter_1_M_AXI_ARLEN),
        .m_axi_arlock(axi_clock_converter_1_M_AXI_ARLOCK),
        .m_axi_arprot(axi_clock_converter_1_M_AXI_ARPROT),
        .m_axi_arqos(axi_clock_converter_1_M_AXI_ARQOS),
        .m_axi_arready(axi_clock_converter_1_M_AXI_ARREADY),
        .m_axi_arsize(axi_clock_converter_1_M_AXI_ARSIZE),
        .m_axi_arvalid(axi_clock_converter_1_M_AXI_ARVALID),
        .m_axi_awaddr(axi_clock_converter_1_M_AXI_AWADDR),
        .m_axi_awburst(axi_clock_converter_1_M_AXI_AWBURST),
        .m_axi_awcache(axi_clock_converter_1_M_AXI_AWCACHE),
        .m_axi_awlen(axi_clock_converter_1_M_AXI_AWLEN),
        .m_axi_awlock(axi_clock_converter_1_M_AXI_AWLOCK),
        .m_axi_awprot(axi_clock_converter_1_M_AXI_AWPROT),
        .m_axi_awqos(axi_clock_converter_1_M_AXI_AWQOS),
        .m_axi_awready(axi_clock_converter_1_M_AXI_AWREADY),
        .m_axi_awsize(axi_clock_converter_1_M_AXI_AWSIZE),
        .m_axi_awvalid(axi_clock_converter_1_M_AXI_AWVALID),
        .m_axi_bready(axi_clock_converter_1_M_AXI_BREADY),
        .m_axi_bresp(axi_clock_converter_1_M_AXI_BRESP),
        .m_axi_bvalid(axi_clock_converter_1_M_AXI_BVALID),
        .m_axi_rdata(axi_clock_converter_1_M_AXI_RDATA),
        .m_axi_rlast(axi_clock_converter_1_M_AXI_RLAST),
        .m_axi_rready(axi_clock_converter_1_M_AXI_RREADY),
        .m_axi_rresp(axi_clock_converter_1_M_AXI_RRESP),
        .m_axi_rvalid(axi_clock_converter_1_M_AXI_RVALID),
        .m_axi_wdata(axi_clock_converter_1_M_AXI_WDATA),
        .m_axi_wlast(axi_clock_converter_1_M_AXI_WLAST),
        .m_axi_wready(axi_clock_converter_1_M_AXI_WREADY),
        .m_axi_wstrb(axi_clock_converter_1_M_AXI_WSTRB),
        .m_axi_wvalid(axi_clock_converter_1_M_AXI_WVALID),
        .s_axi_aclk(mig_7series_0_ui_addn_clk_0),
        .s_axi_araddr(S1_AXI_1_ARADDR),
        .s_axi_arburst(S1_AXI_1_ARBURST),
        .s_axi_arcache(S1_AXI_1_ARCACHE),
        .s_axi_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .s_axi_arlen(S1_AXI_1_ARLEN),
        .s_axi_arlock(S1_AXI_1_ARLOCK),
        .s_axi_arprot(S1_AXI_1_ARPROT),
        .s_axi_arqos(S1_AXI_1_ARQOS),
        .s_axi_arready(S1_AXI_1_ARREADY),
        .s_axi_arregion(S1_AXI_1_ARREGION),
        .s_axi_arsize(S1_AXI_1_ARSIZE),
        .s_axi_arvalid(S1_AXI_1_ARVALID),
        .s_axi_awaddr(S1_AXI_1_AWADDR),
        .s_axi_awburst(S1_AXI_1_AWBURST),
        .s_axi_awcache(S1_AXI_1_AWCACHE),
        .s_axi_awlen(S1_AXI_1_AWLEN),
        .s_axi_awlock(S1_AXI_1_AWLOCK),
        .s_axi_awprot(S1_AXI_1_AWPROT),
        .s_axi_awqos(S1_AXI_1_AWQOS),
        .s_axi_awready(S1_AXI_1_AWREADY),
        .s_axi_awregion(S1_AXI_1_AWREGION),
        .s_axi_awsize(S1_AXI_1_AWSIZE),
        .s_axi_awvalid(S1_AXI_1_AWVALID),
        .s_axi_bready(S1_AXI_1_BREADY),
        .s_axi_bresp(S1_AXI_1_BRESP),
        .s_axi_bvalid(S1_AXI_1_BVALID),
        .s_axi_rdata(S1_AXI_1_RDATA),
        .s_axi_rlast(S1_AXI_1_RLAST),
        .s_axi_rready(S1_AXI_1_RREADY),
        .s_axi_rresp(S1_AXI_1_RRESP),
        .s_axi_rvalid(S1_AXI_1_RVALID),
        .s_axi_wdata(S1_AXI_1_WDATA),
        .s_axi_wlast(S1_AXI_1_WLAST),
        .s_axi_wready(S1_AXI_1_WREADY),
        .s_axi_wstrb(S1_AXI_1_WSTRB),
        .s_axi_wvalid(S1_AXI_1_WVALID));
  Block_test_axi_clock_converter_0_1 axi_clock_converter_2
       (.m_axi_aclk(mig_7series_0_ui_clk),
        .m_axi_araddr(axi_clock_converter_2_M_AXI_ARADDR),
        .m_axi_arburst(axi_clock_converter_2_M_AXI_ARBURST),
        .m_axi_arcache(axi_clock_converter_2_M_AXI_ARCACHE),
        .m_axi_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .m_axi_arlen(axi_clock_converter_2_M_AXI_ARLEN),
        .m_axi_arlock(axi_clock_converter_2_M_AXI_ARLOCK),
        .m_axi_arprot(axi_clock_converter_2_M_AXI_ARPROT),
        .m_axi_arqos(axi_clock_converter_2_M_AXI_ARQOS),
        .m_axi_arready(axi_clock_converter_2_M_AXI_ARREADY),
        .m_axi_arsize(axi_clock_converter_2_M_AXI_ARSIZE),
        .m_axi_arvalid(axi_clock_converter_2_M_AXI_ARVALID),
        .m_axi_awaddr(axi_clock_converter_2_M_AXI_AWADDR),
        .m_axi_awburst(axi_clock_converter_2_M_AXI_AWBURST),
        .m_axi_awcache(axi_clock_converter_2_M_AXI_AWCACHE),
        .m_axi_awlen(axi_clock_converter_2_M_AXI_AWLEN),
        .m_axi_awlock(axi_clock_converter_2_M_AXI_AWLOCK),
        .m_axi_awprot(axi_clock_converter_2_M_AXI_AWPROT),
        .m_axi_awqos(axi_clock_converter_2_M_AXI_AWQOS),
        .m_axi_awready(axi_clock_converter_2_M_AXI_AWREADY),
        .m_axi_awsize(axi_clock_converter_2_M_AXI_AWSIZE),
        .m_axi_awvalid(axi_clock_converter_2_M_AXI_AWVALID),
        .m_axi_bready(axi_clock_converter_2_M_AXI_BREADY),
        .m_axi_bresp(axi_clock_converter_2_M_AXI_BRESP),
        .m_axi_bvalid(axi_clock_converter_2_M_AXI_BVALID),
        .m_axi_rdata(axi_clock_converter_2_M_AXI_RDATA),
        .m_axi_rlast(axi_clock_converter_2_M_AXI_RLAST),
        .m_axi_rready(axi_clock_converter_2_M_AXI_RREADY),
        .m_axi_rresp(axi_clock_converter_2_M_AXI_RRESP),
        .m_axi_rvalid(axi_clock_converter_2_M_AXI_RVALID),
        .m_axi_wdata(axi_clock_converter_2_M_AXI_WDATA),
        .m_axi_wlast(axi_clock_converter_2_M_AXI_WLAST),
        .m_axi_wready(axi_clock_converter_2_M_AXI_WREADY),
        .m_axi_wstrb(axi_clock_converter_2_M_AXI_WSTRB),
        .m_axi_wvalid(axi_clock_converter_2_M_AXI_WVALID),
        .s_axi_aclk(mig_7series_0_ui_addn_clk_0),
        .s_axi_araddr(axi_dwidth_converter_0_M_AXI_ARADDR),
        .s_axi_arburst(axi_dwidth_converter_0_M_AXI_ARBURST),
        .s_axi_arcache(axi_dwidth_converter_0_M_AXI_ARCACHE),
        .s_axi_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .s_axi_arlen(axi_dwidth_converter_0_M_AXI_ARLEN),
        .s_axi_arlock(axi_dwidth_converter_0_M_AXI_ARLOCK),
        .s_axi_arprot(axi_dwidth_converter_0_M_AXI_ARPROT),
        .s_axi_arqos(axi_dwidth_converter_0_M_AXI_ARQOS),
        .s_axi_arready(axi_dwidth_converter_0_M_AXI_ARREADY),
        .s_axi_arregion(axi_dwidth_converter_0_M_AXI_ARREGION),
        .s_axi_arsize(axi_dwidth_converter_0_M_AXI_ARSIZE),
        .s_axi_arvalid(axi_dwidth_converter_0_M_AXI_ARVALID),
        .s_axi_awaddr(axi_dwidth_converter_0_M_AXI_AWADDR),
        .s_axi_awburst(axi_dwidth_converter_0_M_AXI_AWBURST),
        .s_axi_awcache(axi_dwidth_converter_0_M_AXI_AWCACHE),
        .s_axi_awlen(axi_dwidth_converter_0_M_AXI_AWLEN),
        .s_axi_awlock(axi_dwidth_converter_0_M_AXI_AWLOCK),
        .s_axi_awprot(axi_dwidth_converter_0_M_AXI_AWPROT),
        .s_axi_awqos(axi_dwidth_converter_0_M_AXI_AWQOS),
        .s_axi_awready(axi_dwidth_converter_0_M_AXI_AWREADY),
        .s_axi_awregion(axi_dwidth_converter_0_M_AXI_AWREGION),
        .s_axi_awsize(axi_dwidth_converter_0_M_AXI_AWSIZE),
        .s_axi_awvalid(axi_dwidth_converter_0_M_AXI_AWVALID),
        .s_axi_bready(axi_dwidth_converter_0_M_AXI_BREADY),
        .s_axi_bresp(axi_dwidth_converter_0_M_AXI_BRESP),
        .s_axi_bvalid(axi_dwidth_converter_0_M_AXI_BVALID),
        .s_axi_rdata(axi_dwidth_converter_0_M_AXI_RDATA),
        .s_axi_rlast(axi_dwidth_converter_0_M_AXI_RLAST),
        .s_axi_rready(axi_dwidth_converter_0_M_AXI_RREADY),
        .s_axi_rresp(axi_dwidth_converter_0_M_AXI_RRESP),
        .s_axi_rvalid(axi_dwidth_converter_0_M_AXI_RVALID),
        .s_axi_wdata(axi_dwidth_converter_0_M_AXI_WDATA),
        .s_axi_wlast(axi_dwidth_converter_0_M_AXI_WLAST),
        .s_axi_wready(axi_dwidth_converter_0_M_AXI_WREADY),
        .s_axi_wstrb(axi_dwidth_converter_0_M_AXI_WSTRB),
        .s_axi_wvalid(axi_dwidth_converter_0_M_AXI_WVALID));
  Block_test_axi_dwidth_converter_0_0 axi_dwidth_converter_0
       (.m_axi_araddr(axi_dwidth_converter_0_M_AXI_ARADDR),
        .m_axi_arburst(axi_dwidth_converter_0_M_AXI_ARBURST),
        .m_axi_arcache(axi_dwidth_converter_0_M_AXI_ARCACHE),
        .m_axi_arlen(axi_dwidth_converter_0_M_AXI_ARLEN),
        .m_axi_arlock(axi_dwidth_converter_0_M_AXI_ARLOCK),
        .m_axi_arprot(axi_dwidth_converter_0_M_AXI_ARPROT),
        .m_axi_arqos(axi_dwidth_converter_0_M_AXI_ARQOS),
        .m_axi_arready(axi_dwidth_converter_0_M_AXI_ARREADY),
        .m_axi_arregion(axi_dwidth_converter_0_M_AXI_ARREGION),
        .m_axi_arsize(axi_dwidth_converter_0_M_AXI_ARSIZE),
        .m_axi_arvalid(axi_dwidth_converter_0_M_AXI_ARVALID),
        .m_axi_awaddr(axi_dwidth_converter_0_M_AXI_AWADDR),
        .m_axi_awburst(axi_dwidth_converter_0_M_AXI_AWBURST),
        .m_axi_awcache(axi_dwidth_converter_0_M_AXI_AWCACHE),
        .m_axi_awlen(axi_dwidth_converter_0_M_AXI_AWLEN),
        .m_axi_awlock(axi_dwidth_converter_0_M_AXI_AWLOCK),
        .m_axi_awprot(axi_dwidth_converter_0_M_AXI_AWPROT),
        .m_axi_awqos(axi_dwidth_converter_0_M_AXI_AWQOS),
        .m_axi_awready(axi_dwidth_converter_0_M_AXI_AWREADY),
        .m_axi_awregion(axi_dwidth_converter_0_M_AXI_AWREGION),
        .m_axi_awsize(axi_dwidth_converter_0_M_AXI_AWSIZE),
        .m_axi_awvalid(axi_dwidth_converter_0_M_AXI_AWVALID),
        .m_axi_bready(axi_dwidth_converter_0_M_AXI_BREADY),
        .m_axi_bresp(axi_dwidth_converter_0_M_AXI_BRESP),
        .m_axi_bvalid(axi_dwidth_converter_0_M_AXI_BVALID),
        .m_axi_rdata(axi_dwidth_converter_0_M_AXI_RDATA),
        .m_axi_rlast(axi_dwidth_converter_0_M_AXI_RLAST),
        .m_axi_rready(axi_dwidth_converter_0_M_AXI_RREADY),
        .m_axi_rresp(axi_dwidth_converter_0_M_AXI_RRESP),
        .m_axi_rvalid(axi_dwidth_converter_0_M_AXI_RVALID),
        .m_axi_wdata(axi_dwidth_converter_0_M_AXI_WDATA),
        .m_axi_wlast(axi_dwidth_converter_0_M_AXI_WLAST),
        .m_axi_wready(axi_dwidth_converter_0_M_AXI_WREADY),
        .m_axi_wstrb(axi_dwidth_converter_0_M_AXI_WSTRB),
        .m_axi_wvalid(axi_dwidth_converter_0_M_AXI_WVALID),
        .s_axi_aclk(mig_7series_0_ui_addn_clk_0),
        .s_axi_araddr(PS_AXI_1_ARADDR),
        .s_axi_arburst(PS_AXI_1_ARBURST),
        .s_axi_arcache(PS_AXI_1_ARCACHE),
        .s_axi_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .s_axi_arlen(PS_AXI_1_ARLEN),
        .s_axi_arlock(PS_AXI_1_ARLOCK),
        .s_axi_arprot(PS_AXI_1_ARPROT),
        .s_axi_arqos(PS_AXI_1_ARQOS),
        .s_axi_arready(PS_AXI_1_ARREADY),
        .s_axi_arregion(PS_AXI_1_ARREGION),
        .s_axi_arsize(PS_AXI_1_ARSIZE),
        .s_axi_arvalid(PS_AXI_1_ARVALID),
        .s_axi_awaddr(PS_AXI_1_AWADDR),
        .s_axi_awburst(PS_AXI_1_AWBURST),
        .s_axi_awcache(PS_AXI_1_AWCACHE),
        .s_axi_awlen(PS_AXI_1_AWLEN),
        .s_axi_awlock(PS_AXI_1_AWLOCK),
        .s_axi_awprot(PS_AXI_1_AWPROT),
        .s_axi_awqos(PS_AXI_1_AWQOS),
        .s_axi_awready(PS_AXI_1_AWREADY),
        .s_axi_awregion(PS_AXI_1_AWREGION),
        .s_axi_awsize(PS_AXI_1_AWSIZE),
        .s_axi_awvalid(PS_AXI_1_AWVALID),
        .s_axi_bready(PS_AXI_1_BREADY),
        .s_axi_bresp(PS_AXI_1_BRESP),
        .s_axi_bvalid(PS_AXI_1_BVALID),
        .s_axi_rdata(PS_AXI_1_RDATA),
        .s_axi_rlast(PS_AXI_1_RLAST),
        .s_axi_rready(PS_AXI_1_RREADY),
        .s_axi_rresp(PS_AXI_1_RRESP),
        .s_axi_rvalid(PS_AXI_1_RVALID),
        .s_axi_wdata(PS_AXI_1_WDATA),
        .s_axi_wlast(PS_AXI_1_WLAST),
        .s_axi_wready(PS_AXI_1_WREADY),
        .s_axi_wstrb(PS_AXI_1_WSTRB),
        .s_axi_wvalid(PS_AXI_1_WVALID));
  Block_test_mig_7series_0_0 mig_7series_0
       (.aresetn(proc_sys_reset_0_peripheral_aresetn),
        .ddr3_addr(mig_7series_0_DDR3_ADDR),
        .ddr3_ba(mig_7series_0_DDR3_BA),
        .ddr3_cas_n(mig_7series_0_DDR3_CAS_N),
        .ddr3_ck_n(mig_7series_0_DDR3_CK_N),
        .ddr3_ck_p(mig_7series_0_DDR3_CK_P),
        .ddr3_cke(mig_7series_0_DDR3_CKE),
        .ddr3_cs_n(mig_7series_0_DDR3_CS_N),
        .ddr3_dm(mig_7series_0_DDR3_DM),
        .ddr3_dq(DDR3_dq[31:0]),
        .ddr3_dqs_n(DDR3_dqs_n[3:0]),
        .ddr3_dqs_p(DDR3_dqs_p[3:0]),
        .ddr3_odt(mig_7series_0_DDR3_ODT),
        .ddr3_ras_n(mig_7series_0_DDR3_RAS_N),
        .ddr3_reset_n(mig_7series_0_DDR3_RESET_N),
        .ddr3_we_n(mig_7series_0_DDR3_WE_N),
        .init_calib_complete(mig_7series_0_init_calib_complete),
        .mmcm_locked(mig_7series_0_mmcm_locked),
        .s_axi_araddr(smartconnect_0_M00_AXI_ARADDR),
        .s_axi_arburst(smartconnect_0_M00_AXI_ARBURST),
        .s_axi_arcache(smartconnect_0_M00_AXI_ARCACHE),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen(smartconnect_0_M00_AXI_ARLEN),
        .s_axi_arlock(smartconnect_0_M00_AXI_ARLOCK),
        .s_axi_arprot(smartconnect_0_M00_AXI_ARPROT),
        .s_axi_arqos(smartconnect_0_M00_AXI_ARQOS),
        .s_axi_arready(smartconnect_0_M00_AXI_ARREADY),
        .s_axi_arsize(smartconnect_0_M00_AXI_ARSIZE),
        .s_axi_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .s_axi_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .s_axi_awburst(smartconnect_0_M00_AXI_AWBURST),
        .s_axi_awcache(smartconnect_0_M00_AXI_AWCACHE),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen(smartconnect_0_M00_AXI_AWLEN),
        .s_axi_awlock(smartconnect_0_M00_AXI_AWLOCK),
        .s_axi_awprot(smartconnect_0_M00_AXI_AWPROT),
        .s_axi_awqos(smartconnect_0_M00_AXI_AWQOS),
        .s_axi_awready(smartconnect_0_M00_AXI_AWREADY),
        .s_axi_awsize(smartconnect_0_M00_AXI_AWSIZE),
        .s_axi_awvalid(smartconnect_0_M00_AXI_AWVALID),
        .s_axi_bready(smartconnect_0_M00_AXI_BREADY),
        .s_axi_bresp(smartconnect_0_M00_AXI_BRESP),
        .s_axi_bvalid(smartconnect_0_M00_AXI_BVALID),
        .s_axi_rdata(smartconnect_0_M00_AXI_RDATA),
        .s_axi_rlast(smartconnect_0_M00_AXI_RLAST),
        .s_axi_rready(smartconnect_0_M00_AXI_RREADY),
        .s_axi_rresp(smartconnect_0_M00_AXI_RRESP),
        .s_axi_rvalid(smartconnect_0_M00_AXI_RVALID),
        .s_axi_wdata(smartconnect_0_M00_AXI_WDATA),
        .s_axi_wlast(smartconnect_0_M00_AXI_WLAST),
        .s_axi_wready(smartconnect_0_M00_AXI_WREADY),
        .s_axi_wstrb(smartconnect_0_M00_AXI_WSTRB),
        .s_axi_wvalid(smartconnect_0_M00_AXI_WVALID),
        .sys_clk_n(clock_1_CLK_N),
        .sys_clk_p(clock_1_CLK_P),
        .sys_rst(resetn_0_1),
        .ui_addn_clk_0(mig_7series_0_ui_addn_clk_0),
        .ui_clk(mig_7series_0_ui_clk),
        .ui_clk_sync_rst(mig_7series_0_ui_clk_sync_rst));
  Block_test_proc_sys_reset_0_0 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(mig_7series_0_mmcm_locked),
        .ext_reset_in(mig_7series_0_ui_clk_sync_rst),
        .interconnect_aresetn(proc_sys_reset_0_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_0_peripheral_aresetn),
        .slowest_sync_clk(mig_7series_0_ui_addn_clk_0));
  Block_test_smartconnect_0_0 smartconnect_0
       (.M00_AXI_araddr(smartconnect_0_M00_AXI_ARADDR),
        .M00_AXI_arburst(smartconnect_0_M00_AXI_ARBURST),
        .M00_AXI_arcache(smartconnect_0_M00_AXI_ARCACHE),
        .M00_AXI_arlen(smartconnect_0_M00_AXI_ARLEN),
        .M00_AXI_arlock(smartconnect_0_M00_AXI_ARLOCK),
        .M00_AXI_arprot(smartconnect_0_M00_AXI_ARPROT),
        .M00_AXI_arqos(smartconnect_0_M00_AXI_ARQOS),
        .M00_AXI_arready(smartconnect_0_M00_AXI_ARREADY),
        .M00_AXI_arsize(smartconnect_0_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .M00_AXI_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .M00_AXI_awburst(smartconnect_0_M00_AXI_AWBURST),
        .M00_AXI_awcache(smartconnect_0_M00_AXI_AWCACHE),
        .M00_AXI_awlen(smartconnect_0_M00_AXI_AWLEN),
        .M00_AXI_awlock(smartconnect_0_M00_AXI_AWLOCK),
        .M00_AXI_awprot(smartconnect_0_M00_AXI_AWPROT),
        .M00_AXI_awqos(smartconnect_0_M00_AXI_AWQOS),
        .M00_AXI_awready(smartconnect_0_M00_AXI_AWREADY),
        .M00_AXI_awsize(smartconnect_0_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(smartconnect_0_M00_AXI_AWVALID),
        .M00_AXI_bready(smartconnect_0_M00_AXI_BREADY),
        .M00_AXI_bresp(smartconnect_0_M00_AXI_BRESP),
        .M00_AXI_bvalid(smartconnect_0_M00_AXI_BVALID),
        .M00_AXI_rdata(smartconnect_0_M00_AXI_RDATA),
        .M00_AXI_rlast(smartconnect_0_M00_AXI_RLAST),
        .M00_AXI_rready(smartconnect_0_M00_AXI_RREADY),
        .M00_AXI_rresp(smartconnect_0_M00_AXI_RRESP),
        .M00_AXI_rvalid(smartconnect_0_M00_AXI_RVALID),
        .M00_AXI_wdata(smartconnect_0_M00_AXI_WDATA),
        .M00_AXI_wlast(smartconnect_0_M00_AXI_WLAST),
        .M00_AXI_wready(smartconnect_0_M00_AXI_WREADY),
        .M00_AXI_wstrb(smartconnect_0_M00_AXI_WSTRB),
        .M00_AXI_wvalid(smartconnect_0_M00_AXI_WVALID),
        .S00_AXI_araddr(axi_clock_converter_0_M_AXI_ARADDR),
        .S00_AXI_arburst(axi_clock_converter_0_M_AXI_ARBURST),
        .S00_AXI_arcache(axi_clock_converter_0_M_AXI_ARCACHE),
        .S00_AXI_arlen(axi_clock_converter_0_M_AXI_ARLEN),
        .S00_AXI_arlock(axi_clock_converter_0_M_AXI_ARLOCK),
        .S00_AXI_arprot(axi_clock_converter_0_M_AXI_ARPROT),
        .S00_AXI_arqos(axi_clock_converter_0_M_AXI_ARQOS),
        .S00_AXI_arready(axi_clock_converter_0_M_AXI_ARREADY),
        .S00_AXI_arsize(axi_clock_converter_0_M_AXI_ARSIZE),
        .S00_AXI_arvalid(axi_clock_converter_0_M_AXI_ARVALID),
        .S00_AXI_awaddr(axi_clock_converter_0_M_AXI_AWADDR),
        .S00_AXI_awburst(axi_clock_converter_0_M_AXI_AWBURST),
        .S00_AXI_awcache(axi_clock_converter_0_M_AXI_AWCACHE),
        .S00_AXI_awlen(axi_clock_converter_0_M_AXI_AWLEN),
        .S00_AXI_awlock(axi_clock_converter_0_M_AXI_AWLOCK),
        .S00_AXI_awprot(axi_clock_converter_0_M_AXI_AWPROT),
        .S00_AXI_awqos(axi_clock_converter_0_M_AXI_AWQOS),
        .S00_AXI_awready(axi_clock_converter_0_M_AXI_AWREADY),
        .S00_AXI_awsize(axi_clock_converter_0_M_AXI_AWSIZE),
        .S00_AXI_awvalid(axi_clock_converter_0_M_AXI_AWVALID),
        .S00_AXI_bready(axi_clock_converter_0_M_AXI_BREADY),
        .S00_AXI_bresp(axi_clock_converter_0_M_AXI_BRESP),
        .S00_AXI_bvalid(axi_clock_converter_0_M_AXI_BVALID),
        .S00_AXI_rdata(axi_clock_converter_0_M_AXI_RDATA),
        .S00_AXI_rlast(axi_clock_converter_0_M_AXI_RLAST),
        .S00_AXI_rready(axi_clock_converter_0_M_AXI_RREADY),
        .S00_AXI_rresp(axi_clock_converter_0_M_AXI_RRESP),
        .S00_AXI_rvalid(axi_clock_converter_0_M_AXI_RVALID),
        .S00_AXI_wdata(axi_clock_converter_0_M_AXI_WDATA),
        .S00_AXI_wlast(axi_clock_converter_0_M_AXI_WLAST),
        .S00_AXI_wready(axi_clock_converter_0_M_AXI_WREADY),
        .S00_AXI_wstrb(axi_clock_converter_0_M_AXI_WSTRB),
        .S00_AXI_wvalid(axi_clock_converter_0_M_AXI_WVALID),
        .S01_AXI_araddr(axi_clock_converter_1_M_AXI_ARADDR),
        .S01_AXI_arburst(axi_clock_converter_1_M_AXI_ARBURST),
        .S01_AXI_arcache(axi_clock_converter_1_M_AXI_ARCACHE),
        .S01_AXI_arlen(axi_clock_converter_1_M_AXI_ARLEN),
        .S01_AXI_arlock(axi_clock_converter_1_M_AXI_ARLOCK),
        .S01_AXI_arprot(axi_clock_converter_1_M_AXI_ARPROT),
        .S01_AXI_arqos(axi_clock_converter_1_M_AXI_ARQOS),
        .S01_AXI_arready(axi_clock_converter_1_M_AXI_ARREADY),
        .S01_AXI_arsize(axi_clock_converter_1_M_AXI_ARSIZE),
        .S01_AXI_arvalid(axi_clock_converter_1_M_AXI_ARVALID),
        .S01_AXI_awaddr(axi_clock_converter_1_M_AXI_AWADDR),
        .S01_AXI_awburst(axi_clock_converter_1_M_AXI_AWBURST),
        .S01_AXI_awcache(axi_clock_converter_1_M_AXI_AWCACHE),
        .S01_AXI_awlen(axi_clock_converter_1_M_AXI_AWLEN),
        .S01_AXI_awlock(axi_clock_converter_1_M_AXI_AWLOCK),
        .S01_AXI_awprot(axi_clock_converter_1_M_AXI_AWPROT),
        .S01_AXI_awqos(axi_clock_converter_1_M_AXI_AWQOS),
        .S01_AXI_awready(axi_clock_converter_1_M_AXI_AWREADY),
        .S01_AXI_awsize(axi_clock_converter_1_M_AXI_AWSIZE),
        .S01_AXI_awvalid(axi_clock_converter_1_M_AXI_AWVALID),
        .S01_AXI_bready(axi_clock_converter_1_M_AXI_BREADY),
        .S01_AXI_bresp(axi_clock_converter_1_M_AXI_BRESP),
        .S01_AXI_bvalid(axi_clock_converter_1_M_AXI_BVALID),
        .S01_AXI_rdata(axi_clock_converter_1_M_AXI_RDATA),
        .S01_AXI_rlast(axi_clock_converter_1_M_AXI_RLAST),
        .S01_AXI_rready(axi_clock_converter_1_M_AXI_RREADY),
        .S01_AXI_rresp(axi_clock_converter_1_M_AXI_RRESP),
        .S01_AXI_rvalid(axi_clock_converter_1_M_AXI_RVALID),
        .S01_AXI_wdata(axi_clock_converter_1_M_AXI_WDATA),
        .S01_AXI_wlast(axi_clock_converter_1_M_AXI_WLAST),
        .S01_AXI_wready(axi_clock_converter_1_M_AXI_WREADY),
        .S01_AXI_wstrb(axi_clock_converter_1_M_AXI_WSTRB),
        .S01_AXI_wvalid(axi_clock_converter_1_M_AXI_WVALID),
        .S02_AXI_araddr(axi_clock_converter_2_M_AXI_ARADDR),
        .S02_AXI_arburst(axi_clock_converter_2_M_AXI_ARBURST),
        .S02_AXI_arcache(axi_clock_converter_2_M_AXI_ARCACHE),
        .S02_AXI_arlen(axi_clock_converter_2_M_AXI_ARLEN),
        .S02_AXI_arlock(axi_clock_converter_2_M_AXI_ARLOCK),
        .S02_AXI_arprot(axi_clock_converter_2_M_AXI_ARPROT),
        .S02_AXI_arqos(axi_clock_converter_2_M_AXI_ARQOS),
        .S02_AXI_arready(axi_clock_converter_2_M_AXI_ARREADY),
        .S02_AXI_arsize(axi_clock_converter_2_M_AXI_ARSIZE),
        .S02_AXI_arvalid(axi_clock_converter_2_M_AXI_ARVALID),
        .S02_AXI_awaddr(axi_clock_converter_2_M_AXI_AWADDR),
        .S02_AXI_awburst(axi_clock_converter_2_M_AXI_AWBURST),
        .S02_AXI_awcache(axi_clock_converter_2_M_AXI_AWCACHE),
        .S02_AXI_awlen(axi_clock_converter_2_M_AXI_AWLEN),
        .S02_AXI_awlock(axi_clock_converter_2_M_AXI_AWLOCK),
        .S02_AXI_awprot(axi_clock_converter_2_M_AXI_AWPROT),
        .S02_AXI_awqos(axi_clock_converter_2_M_AXI_AWQOS),
        .S02_AXI_awready(axi_clock_converter_2_M_AXI_AWREADY),
        .S02_AXI_awsize(axi_clock_converter_2_M_AXI_AWSIZE),
        .S02_AXI_awvalid(axi_clock_converter_2_M_AXI_AWVALID),
        .S02_AXI_bready(axi_clock_converter_2_M_AXI_BREADY),
        .S02_AXI_bresp(axi_clock_converter_2_M_AXI_BRESP),
        .S02_AXI_bvalid(axi_clock_converter_2_M_AXI_BVALID),
        .S02_AXI_rdata(axi_clock_converter_2_M_AXI_RDATA),
        .S02_AXI_rlast(axi_clock_converter_2_M_AXI_RLAST),
        .S02_AXI_rready(axi_clock_converter_2_M_AXI_RREADY),
        .S02_AXI_rresp(axi_clock_converter_2_M_AXI_RRESP),
        .S02_AXI_rvalid(axi_clock_converter_2_M_AXI_RVALID),
        .S02_AXI_wdata(axi_clock_converter_2_M_AXI_WDATA),
        .S02_AXI_wlast(axi_clock_converter_2_M_AXI_WLAST),
        .S02_AXI_wready(axi_clock_converter_2_M_AXI_WREADY),
        .S02_AXI_wstrb(axi_clock_converter_2_M_AXI_WSTRB),
        .S02_AXI_wvalid(axi_clock_converter_2_M_AXI_WVALID),
        .aclk(mig_7series_0_ui_clk),
        .aresetn(proc_sys_reset_0_interconnect_aresetn));
endmodule

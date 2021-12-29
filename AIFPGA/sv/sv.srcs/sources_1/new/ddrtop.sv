`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2019 12:17:37 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ddrtop
import definitions_pkg::*;
(
    inout [31:0]                       ddr3_dq,
	inout [3:0]                        ddr3_dqs_n,
	inout [3:0]                        ddr3_dqs_p,
	output [14:0]                      ddr3_addr,
	output [2:0]                       ddr3_ba,
	output                             ddr3_ras_n,
	output                             ddr3_cas_n,
	output                             ddr3_we_n,
	output                             ddr3_reset_n,
	output [0:0]                       ddr3_ck_p,
	output [0:0]                       ddr3_ck_n,
	output [0:0]                       ddr3_cke,
	output [0:0]                       ddr3_cs_n,
	output [3:0]                       ddr3_dm,
	output [0:0]                       ddr3_odt,
    //PS
    output                          ps_clk,
//    output                          ps_rst_n,
    inout [14:0]                    DDR_PS_addr,
    inout [2:0]                     DDR_PS_ba,
    inout                           DDR_PS_cas_n,
    inout                           DDR_PS_ck_n,
    inout                           DDR_PS_ck_p,
    inout                           DDR_PS_cke,
    inout                           DDR_PS_cs_n,
    inout [3:0]                     DDR_PS_dm,
    inout [31:0]                    DDR_PS_dq,
    inout [3:0]                     DDR_PS_dqs_n,
    inout [3:0]                     DDR_PS_dqs_p,
    inout                           DDR_PS_odt,
    inout                           DDR_PS_ras_n,
    inout                           DDR_PS_reset_n,
    inout                           DDR_PS_we_n,
    inout                           FIXED_IO_ddr_vrn,
    inout                           FIXED_IO_ddr_vrp,
    inout [53:0]                    FIXED_IO_mio,
    inout                           FIXED_IO_ps_clk,
    inout                           FIXED_IO_ps_porb,
    inout                           FIXED_IO_ps_srstb,
    //read request
    input  ddr_id_t                 ps_axi_rid,
    input mem_addr_t                ps_axi_raddr,
    input ddr_width_t               ps_axi_len,
    input logic                     ps_read_request,
    input logic                     ps_read_freeze,
//    output logic                    ps_read_pending,

    output logic                    ps_axi_rready,
    output ddr_id_t                 ps_ddr_vid,
    output ubyte_t  [PS_DDR_DATAWIDTH-1 : 0] ps_ddr_data,
    output logic                    ps_ddr_isLast,

    //write request
    input  logic                    ps_write_request,
    input  mem_addr_t               ps_axi_waddr,
    input  logic    [PS_DDR_DATAWIDTH-1 : 0] ps_axi_wstrobe,
    input  ubyte_t  [PS_DDR_DATAWIDTH-1 : 0] ps_axi_wdata,
    output logic                    ps_axi_wready,

    //read request
    input  ddr_id_t                 axi2_rid,
    input mem_addr_t                axi2_raddr,
    input ddr_width_t               axi2_len,
    input logic                     read_request2,
    input logic                     read_freeze2,
//    output logic                    read_pending2,

    output logic                    axi2_rready,
    output ddr_id_t                 ddr_vid2,
    output ubyte_t  [DDR_DATAWIDTH-1 : 0] ddr_data2,
    output logic                    ddr_isLast2,

    //write request
    input  logic                    write_request2,
    input  mem_addr_t               axi2_waddr,
    input  logic    [DDR_DATAWIDTH-1 : 0] axi2_wstrobe,
    input  ubyte_t  [DDR_DATAWIDTH-1 : 0] axi2_wdata,
    output logic                    axi2_wready,
	
    
    //read request
    input  ddr_id_t                 axi1_rid,
    input mem_addr_t                axi1_raddr,
    input ddr_width_t               axi1_len,
    input logic                     read_request1,
    input logic                     read_freeze1,
//    output logic                    read_pending1,

    output logic                    axi1_rready,
    output ddr_id_t                 ddr_vid1,
    output ubyte_t  [DDR_DATAWIDTH-1 : 0] ddr_data1,
    output logic                    ddr_isLast1,

    //write request
    input  logic                    write_request1,
    input  mem_addr_t               axi1_waddr,
    input  logic    [DDR_DATAWIDTH-1 : 0] axi1_wstrobe,
    input  ubyte_t  [DDR_DATAWIDTH-1 : 0] axi1_wdata,
    output logic                    axi1_wready,
	
	//Differential system clocks
	input                              sys_clk_p,
	input                              sys_clk_n,
    output                  init_calib_complete,
	input                              sys_rst,
    output logic ui_clk,
    output logic ui_clk_sync_rst

    );
  logic [3:0]s_axi0_awid;
  logic [31:0]s_axi0_awaddr;
  logic [7:0]s_axi0_awlen;
  logic [2:0]s_axi0_awsize;
  logic [1:0]s_axi0_awburst;
  logic [0:0]s_axi0_awlock;
  logic [3:0]s_axi0_awcache;
  logic [2:0]s_axi0_awprot;
  logic [3:0]s_axi0_awqos;
  logic s_axi0_awvalid;
  logic s_axi0_awready;
  logic [255:0]s_axi0_wdata;
  logic [31:0]s_axi0_wstrb;
  logic s_axi0_wlast;
  logic s_axi0_wvalid;
  logic s_axi0_wready;
  logic s_axi0_bready;
  logic [3:0]s_axi0_bid;
  logic [1:0]s_axi0_bresp;
  logic s_axi0_bvalid;
  logic [3:0]s_axi0_arid;
  logic [31:0]s_axi0_araddr;
  logic [7:0]s_axi0_arlen;
  logic [2:0]s_axi0_arsize;
  logic [1:0]s_axi0_arburst;
  logic [0:0]s_axi0_arlock;
  logic [3:0]s_axi0_arcache;
  logic [2:0]s_axi0_arprot;
  logic [3:0]s_axi0_arqos;
  logic s_axi0_arvalid;
  logic s_axi0_arready;
  logic s_axi0_rready;
  logic [3:0]s_axi0_rid;
  logic [255:0]s_axi0_rdata;
  logic [1:0]s_axi0_rresp;
  logic s_axi0_rlast;
  logic s_axi0_rvalid;

  logic [3:0]s_axi1_awid;
  logic [31:0]s_axi1_awaddr;
  logic [7:0]s_axi1_awlen;
  logic [2:0]s_axi1_awsize;
  logic [1:0]s_axi1_awburst;
  logic [0:0]s_axi1_awlock;
  logic [3:0]s_axi1_awcache;
  logic [2:0]s_axi1_awprot;
  logic [3:0]s_axi1_awqos;
  logic s_axi1_awvalid;
  logic s_axi1_awready;
  logic [255:0]s_axi1_wdata;
  logic [31:0]s_axi1_wstrb;
  logic s_axi1_wlast;
  logic s_axi1_wvalid;
  logic s_axi1_wready;
  logic s_axi1_bready;
  logic [3:0]s_axi1_bid;
  logic [1:0]s_axi1_bresp;
  logic s_axi1_bvalid;
  logic [3:0]s_axi1_arid;
  logic [31:0]s_axi1_araddr;
  logic [7:0]s_axi1_arlen;
  logic [2:0]s_axi1_arsize;
  logic [1:0]s_axi1_arburst;
  logic [0:0]s_axi1_arlock;
  logic [3:0]s_axi1_arcache;
  logic [2:0]s_axi1_arprot;
  logic [3:0]s_axi1_arqos;
  logic s_axi1_arvalid;
  logic s_axi1_arready;
  logic s_axi1_rready;
  logic [3:0]s_axi1_rid;
  logic [255:0]s_axi1_rdata;
  logic [1:0]s_axi1_rresp;
  logic s_axi1_rlast;
  logic s_axi1_rvalid;
  logic aresetn;

  logic [31:0]PS_AXI_araddr;
  logic [1:0]PS_AXI_arburst;
  logic [3:0]PS_AXI_arcache;
  logic [5:0]PS_AXI_arid;
  logic [7:0]PS_AXI_arlen;
  logic [0:0]PS_AXI_arlock;
  logic [2:0]PS_AXI_arprot;
  logic [3:0]PS_AXI_arqos;
  logic PS_AXI_arready;
  logic [2:0]PS_AXI_arsize;
  logic PS_AXI_arvalid;
  logic [31:0]PS_AXI_awaddr;
  logic [1:0]PS_AXI_awburst;
  logic [3:0]PS_AXI_awcache;
  logic [5:0]PS_AXI_awid;
  logic [7:0]PS_AXI_awlen;
  logic [0:0]PS_AXI_awlock;
  logic [2:0]PS_AXI_awprot;
  logic [3:0]PS_AXI_awqos;
  logic PS_AXI_awready;
  logic [2:0]PS_AXI_awsize;
  logic PS_AXI_awvalid;
  logic [5:0]PS_AXI_bid;
  logic PS_AXI_bready;
  logic [1:0]PS_AXI_bresp;
  logic PS_AXI_bvalid;
  logic [63:0]PS_AXI_rdata;
  logic [5:0]PS_AXI_rid;
  logic PS_AXI_rlast;
  logic PS_AXI_rready;
  logic [1:0]PS_AXI_rresp;
  logic PS_AXI_rvalid;
  logic [63:0]PS_AXI_wdata;
  logic [5:0]PS_AXI_wid;
  logic PS_AXI_wlast;
  logic PS_AXI_wready;
  logic [7:0]PS_AXI_wstrb;
  logic PS_AXI_wvalid;

 always @(posedge ui_clk) begin
     aresetn <= ~ui_clk_sync_rst;
 end
 //assign ps_clk = ui_clk;
DDR_Block_wrapper ddr
//Block_test_wrapper ddr
(
    .ACLK_PS                        (ps_clk),
    //.aresetn                        (aresetn),
    .DDR3_addr                      (ddr3_addr),
    .DDR3_ba                        (ddr3_ba),
    .DDR3_cas_n                     (ddr3_cas_n),
    .DDR3_ck_n                      (ddr3_ck_n),
    .DDR3_ck_p                      (ddr3_ck_p),
    .DDR3_cke                       (ddr3_cke),
    .DDR3_cs_n                      (ddr3_cs_n),
    .DDR3_dm                        (ddr3_dm),
    .DDR3_dq                        (ddr3_dq),
    .DDR3_dqs_n                     (ddr3_dqs_n),
    .DDR3_dqs_p                     (ddr3_dqs_p),
    .DDR3_odt                       (ddr3_odt),
    .DDR3_ras_n                     (ddr3_ras_n),
    .DDR3_reset_n                   (ddr3_reset_n),
    .DDR3_we_n                      (ddr3_we_n),
    
`ifndef IN_SIMULATION
    .DDR_PS_addr,
    .DDR_PS_ba,
    .DDR_PS_cas_n,
    .DDR_PS_ck_n,
    .DDR_PS_ck_p,
    .DDR_PS_cke,
    .DDR_PS_cs_n,
    .DDR_PS_dm,
    .DDR_PS_dq,
    .DDR_PS_dqs_n,
    .DDR_PS_dqs_p,
    .DDR_PS_odt,
    .DDR_PS_ras_n,
    .DDR_PS_reset_n,
    .DDR_PS_we_n,
    
    .FIXED_IO_ddr_vrn,
    .FIXED_IO_ddr_vrp,
    .FIXED_IO_mio,
    .FIXED_IO_ps_clk,
    .FIXED_IO_ps_porb,
    .FIXED_IO_ps_srstb,
    .FCLK_CLK                       (ps_clk),
`endif

    .PS_AXI_araddr,
    .PS_AXI_arburst,
    .PS_AXI_arcache,
    //.PS_AXI_arid,
    .PS_AXI_arlen,
    .PS_AXI_arlock,
    .PS_AXI_arprot,
    .PS_AXI_arqos,
    .PS_AXI_arready,
    .PS_AXI_arsize,
    .PS_AXI_arvalid,
    .PS_AXI_awaddr,
    .PS_AXI_awburst,
    .PS_AXI_awcache,
   // .PS_AXI_awid,
    .PS_AXI_awlen,
    .PS_AXI_awlock,
    .PS_AXI_awprot,
    .PS_AXI_awqos,
    .PS_AXI_awready,
    .PS_AXI_awsize,
    .PS_AXI_awvalid,
   // .PS_AXI_bid,
    .PS_AXI_bready,
    .PS_AXI_bresp,
    .PS_AXI_bvalid,
    .PS_AXI_rdata,
   // .PS_AXI_rid,
    .PS_AXI_rlast,
    .PS_AXI_rready,
    .PS_AXI_rresp,
    .PS_AXI_rvalid,
    .PS_AXI_wdata,
   // .PS_AXI_wid,
    .PS_AXI_wlast,
    .PS_AXI_wready,
    .PS_AXI_wstrb,
    .PS_AXI_wvalid,
    .PS_AXI_awregion     (4'b0000               ),
    .PS_AXI_arregion     (4'b0000               ),

    .S0_AXI_araddr                  (s_axi0_araddr),
    .S0_AXI_arburst                 (s_axi0_arburst),
    .S0_AXI_arcache                 (s_axi0_arcache),
    //.S0_AXI_arid                    (s_axi0_arid),
    .S0_AXI_arlen                   (s_axi0_arlen),
    .S0_AXI_arlock                  (s_axi0_arlock),
    .S0_AXI_arprot                  (s_axi0_arprot),
    .S0_AXI_arqos                   (s_axi0_arqos),
    .S0_AXI_arready                 (s_axi0_arready),
    //.S0_AXI_arregion                (),
    .S0_AXI_arsize                  (s_axi0_arsize),
    .S0_AXI_arvalid                 (s_axi0_arvalid),
    .S0_AXI_awaddr                  (s_axi0_awaddr),
    .S0_AXI_awburst                 (s_axi0_awburst),
    .S0_AXI_awcache                 (s_axi0_awcache),
    //.S0_AXI_awid                    (s_axi0_awid),
    .S0_AXI_awlen                   (s_axi0_awlen),
    .S0_AXI_awlock                  (s_axi0_awlock),
    .S0_AXI_awprot                  (s_axi0_awprot),
    .S0_AXI_awqos                   (s_axi0_awqos),
    .S0_AXI_awready                 (s_axi0_awready),
    //.S0_AXI_awregion                (),
    .S0_AXI_awsize                  (s_axi0_awsize),
    .S0_AXI_awvalid                 (s_axi0_awvalid),
    //.S0_AXI_bid                     (s_axi0_bid),
    .S0_AXI_bready                  (s_axi0_bready),
    .S0_AXI_bresp                   (s_axi0_bresp),
    .S0_AXI_bvalid                  (s_axi0_bvalid),
    .S0_AXI_rdata                   (s_axi0_rdata),
    //.S0_AXI_rid                     (s_axi0_rid),
    .S0_AXI_rlast                   (s_axi0_rlast),
    .S0_AXI_rready                  (s_axi0_rready),
    .S0_AXI_rresp                   (s_axi0_rresp),
    .S0_AXI_rvalid                  (s_axi0_rvalid),
    .S0_AXI_wdata                   (s_axi0_wdata),
    .S0_AXI_wlast                   (s_axi0_wlast),
    .S0_AXI_wready                  (s_axi0_wready),
    .S0_AXI_wstrb                   (s_axi0_wstrb),
    .S0_AXI_wvalid                  (s_axi0_wvalid),
    .S1_AXI_araddr                  (s_axi1_araddr),
    .S1_AXI_arburst                 (s_axi1_arburst),
    .S1_AXI_arcache                 (s_axi1_arcache),
    //.S1_AXI_arid                    (s_axi1_arid),
    .S1_AXI_arlen                   (s_axi1_arlen),
    .S1_AXI_arlock                  (s_axi1_arlock),
    .S1_AXI_arprot                  (s_axi1_arprot),
    .S1_AXI_arqos                   (s_axi1_arqos),
    .S1_AXI_arready                 (s_axi1_arready),
    //.S1_AXI_arregion                (),
    .S1_AXI_arsize                  (s_axi1_arsize),
    .S1_AXI_arvalid                 (s_axi1_arvalid),
    .S1_AXI_awaddr                  (s_axi1_awaddr),
    .S1_AXI_awburst                 (s_axi1_awburst),
    .S1_AXI_awcache                 (s_axi1_awcache),
    //.S1_AXI_awid                    (s_axi1_awid),
    .S1_AXI_awlen                   (s_axi1_awlen),
    .S1_AXI_awlock                  (s_axi1_awlock),
    .S1_AXI_awprot                  (s_axi1_awprot),
    .S1_AXI_awqos                   (s_axi1_awqos),
    .S1_AXI_awready                 (s_axi1_awready),
    //.S1_AXI_awregion                (),
    .S1_AXI_awsize                  (s_axi1_awsize),
    .S1_AXI_awvalid                 (s_axi1_awvalid),
    //.S1_AXI_bid                     (s_axi1_bid),
    .S1_AXI_bready                  (s_axi1_bready),
    .S1_AXI_bresp                   (s_axi1_bresp),
    .S1_AXI_bvalid                  (s_axi1_bvalid),
    .S1_AXI_rdata                   (s_axi1_rdata),
    //.S1_AXI_rid                     (s_axi1_rid),
    .S1_AXI_rlast                   (s_axi1_rlast),
    .S1_AXI_rready                  (s_axi1_rready),
    .S1_AXI_rresp                   (s_axi1_rresp),
    .S1_AXI_rvalid                  (s_axi1_rvalid),
    .S1_AXI_wdata                   (s_axi1_wdata),
    .S1_AXI_wlast                   (s_axi1_wlast),
    .S1_AXI_wready                  (s_axi1_wready),
    .S1_AXI_wstrb                   (s_axi1_wstrb),
    .S1_AXI_wvalid                  (s_axi1_wvalid),
    .clock_clk_n                    (sys_clk_n),
    .clock_clk_p                    (sys_clk_p),
    .init_calib_complete            (init_calib_complete),
    //.ps_rst_n,
    .resetN                         (sys_rst),
    .ui_clk                         (ui_clk),
    .ui_clk_sync_rst                (ui_clk_sync_rst)
);

 DDRReadAssist_AXI 
 #(
     .RID(DDR_WEIGHT_ID), 
     .C_M_TARGET_SLAVE_BASE_ADDR(32'h00080000),
     .C_M_AXI_DATA_WIDTH(PS_DDR_DATAWIDTH*8)
 ) 
 ps_read_axi
(
    .clock                      (ui_clk),         
    //.resetN                     (ps_rst_n),
    .resetN                     (aresetn),
    .axi_rid                    (ps_axi_rid),
    .axi_raddr                  (ps_axi_raddr),
    .axi_len                    (ps_axi_len),
    .read_request               (ps_read_request),
    .read_freeze                (ps_read_freeze),
    //.pending_request            (ps_read_pending),

    .axi_ready                  (ps_axi_rready),
    .ddr_vid                    (ps_ddr_vid),
    .ddr_data                   (ps_ddr_data),
    .ddr_isLast                 (ps_ddr_isLast),

    .M_AXI_ARID                 (PS_AXI_arid),
    .M_AXI_ARADDR               (PS_AXI_araddr),
    .M_AXI_ARLEN                (PS_AXI_arlen),
    .M_AXI_ARSIZE               (PS_AXI_arsize),
    .M_AXI_ARBURST              (PS_AXI_arburst),
    .M_AXI_ARLOCK               (PS_AXI_arlock),
    .M_AXI_ARCACHE              (PS_AXI_arcache),
    .M_AXI_ARPROT               (PS_AXI_arprot),
    .M_AXI_ARQOS                (PS_AXI_arqos),
    .M_AXI_ARVALID              (PS_AXI_arvalid),
    .M_AXI_ARREADY              (PS_AXI_arready),
    .M_AXI_RID                  (PS_AXI_rid),
    .M_AXI_RDATA                (PS_AXI_rdata),
    .M_AXI_RRESP                (PS_AXI_rresp),
    .M_AXI_RLAST                (PS_AXI_rlast),
    .M_AXI_RVALID               (PS_AXI_rvalid),
    .M_AXI_RREADY               (PS_AXI_rready)
);

DDRWriteAssist_AXI
#(
    .WID(DDR_WEIGHT_ID),
    .C_M_TARGET_SLAVE_BASE_ADDR(32'h00080000),
    .C_M_AXI_DATA_WIDTH(PS_DDR_DATAWIDTH*8)
)
ps_write_axi
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),
    //.resetN                     (ps_rst_n),

    .write_request              (ps_write_request),
    .axi_waddr                  (ps_axi_waddr),
    .axi_wstrobe                (ps_axi_wstrobe),
    .axi_wdata                  (ps_axi_wdata),
    .axi_ready                  (ps_axi_wready),

    .M_AXI_AWID                 (PS_AXI_awid),
    .M_AXI_AWADDR               (PS_AXI_awaddr),
    .M_AXI_AWLEN                (PS_AXI_awlen),
    .M_AXI_AWSIZE               (PS_AXI_awsize),
    .M_AXI_AWBURST              (PS_AXI_awburst),
    .M_AXI_AWLOCK               (PS_AXI_awlock),
    .M_AXI_AWCACHE              (PS_AXI_awcache),
    .M_AXI_AWPROT               (PS_AXI_awprot),
    .M_AXI_AWQOS                (PS_AXI_awqos),
    .M_AXI_AWVALID              (PS_AXI_awvalid),
    .M_AXI_AWREADY              (PS_AXI_awready),
    .M_AXI_WDATA                (PS_AXI_wdata),
    .M_AXI_WSTRB                (PS_AXI_wstrb),
    .M_AXI_WLAST                (PS_AXI_wlast),
    .M_AXI_WVALID               (PS_AXI_wvalid),
    .M_AXI_WREADY               (PS_AXI_wready),
    .M_AXI_BID                  (PS_AXI_bid),
    .M_AXI_BRESP                (PS_AXI_bresp),
    .M_AXI_BVALID               (PS_AXI_bvalid),
    .M_AXI_BREADY               (PS_AXI_bready)
);

 DDRReadAssist_AXI 
 #(.RID(DDR_FEATURE_ID), .C_M_TARGET_SLAVE_BASE_ADDR(32'h80000000)) 
 read_axi1
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),
    .axi_rid                    (axi1_rid),
    .axi_raddr                  (axi1_raddr),
    .axi_len                    (axi1_len),
    .read_request               (read_request1),
    .read_freeze                (read_freeze1),
    //.pending_request            (read_pending1),

    .axi_ready                  (axi1_rready),
    .ddr_vid                    (ddr_vid1),
    .ddr_data                   (ddr_data1),
    .ddr_isLast                 (ddr_isLast1),

    .M_AXI_ARID                 (s_axi0_arid),
    .M_AXI_ARADDR               (s_axi0_araddr),
    .M_AXI_ARLEN                (s_axi0_arlen),
    .M_AXI_ARSIZE               (s_axi0_arsize),
    .M_AXI_ARBURST              (s_axi0_arburst),
    .M_AXI_ARLOCK               (s_axi0_arlock),
    .M_AXI_ARCACHE              (s_axi0_arcache),
    .M_AXI_ARPROT               (s_axi0_arprot),
    .M_AXI_ARQOS                (s_axi0_arqos),
    .M_AXI_ARVALID              (s_axi0_arvalid),
    .M_AXI_ARREADY              (s_axi0_arready),
    .M_AXI_RID                  (s_axi0_rid),
    .M_AXI_RDATA                (s_axi0_rdata),
    .M_AXI_RRESP                (s_axi0_rresp),
    .M_AXI_RLAST                (s_axi0_rlast),
    .M_AXI_RVALID               (s_axi0_rvalid),
    .M_AXI_RREADY               (s_axi0_rready)
);

DDRWriteAssist_AXI
#(
    .WID(DDR_FEATURE_ID),
    .C_M_TARGET_SLAVE_BASE_ADDR(32'h80000000)
)
write_axi1
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),

    .write_request              (write_request1),
    .axi_waddr                  (axi1_waddr),
    .axi_wstrobe                (axi1_wstrobe),
    .axi_wdata                  (axi1_wdata),
    .axi_ready                  (axi1_wready),

    .M_AXI_AWID                 (s_axi0_awid),
    .M_AXI_AWADDR               (s_axi0_awaddr),
    .M_AXI_AWLEN                (s_axi0_awlen),
    .M_AXI_AWSIZE               (s_axi0_awsize),
    .M_AXI_AWBURST              (s_axi0_awburst),
    .M_AXI_AWLOCK               (s_axi0_awlock),
    .M_AXI_AWCACHE              (s_axi0_awcache),
    .M_AXI_AWPROT               (s_axi0_awprot),
    .M_AXI_AWQOS                (s_axi0_awqos),
    .M_AXI_AWVALID              (s_axi0_awvalid),
    .M_AXI_AWREADY              (s_axi0_awready),
    .M_AXI_WDATA                (s_axi0_wdata),
    .M_AXI_WSTRB                (s_axi0_wstrb),
    .M_AXI_WLAST                (s_axi0_wlast),
    .M_AXI_WVALID               (s_axi0_wvalid),
    .M_AXI_WREADY               (s_axi0_wready),
    .M_AXI_BID                  (s_axi0_bid),
    .M_AXI_BRESP                (s_axi0_bresp),
    .M_AXI_BVALID               (s_axi0_bvalid),
    .M_AXI_BREADY               (s_axi0_bready)
);


 DDRReadAssist_AXI 
 #(.RID(DDR_NETIF_ID), .C_M_TARGET_SLAVE_BASE_ADDR(32'h80000000)) 
 read_axi2
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),
    .axi_rid                    (axi2_rid),
    .axi_raddr                  (axi2_raddr),
    .axi_len                    (axi2_len),
    .read_request               (read_request2),
    .read_freeze                (read_freeze2),
    //.pending_request            (read_pending2),

    .axi_ready                  (axi2_rready),
    .ddr_vid                    (ddr_vid2),
    .ddr_data                   (ddr_data2),
    .ddr_isLast                 (ddr_isLast2),

    .M_AXI_ARID                 (s_axi1_arid),
    .M_AXI_ARADDR               (s_axi1_araddr),
    .M_AXI_ARLEN                (s_axi1_arlen),
    .M_AXI_ARSIZE               (s_axi1_arsize),
    .M_AXI_ARBURST              (s_axi1_arburst),
    .M_AXI_ARLOCK               (s_axi1_arlock),
    .M_AXI_ARCACHE              (s_axi1_arcache),
    .M_AXI_ARPROT               (s_axi1_arprot),
    .M_AXI_ARQOS                (s_axi1_arqos),
    .M_AXI_ARVALID              (s_axi1_arvalid),
    .M_AXI_ARREADY              (s_axi1_arready),
    .M_AXI_RID                  (s_axi1_rid),
    .M_AXI_RDATA                (s_axi1_rdata),
    .M_AXI_RRESP                (s_axi1_rresp),
    .M_AXI_RLAST                (s_axi1_rlast),
    .M_AXI_RVALID               (s_axi1_rvalid),
    .M_AXI_RREADY               (s_axi1_rready)
);

DDRWriteAssist_AXI
#(
    .WID(DDR_NETIF_ID),
    .C_M_TARGET_SLAVE_BASE_ADDR(32'h80000000)
)
write_axi2
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),

    .write_request              (write_request2),
    .axi_waddr                  (axi2_waddr),
    .axi_wstrobe                (axi2_wstrobe),
    .axi_wdata                  (axi2_wdata),
    .axi_ready                  (axi2_wready),

    .M_AXI_AWID                 (s_axi1_awid),
    .M_AXI_AWADDR               (s_axi1_awaddr),
    .M_AXI_AWLEN                (s_axi1_awlen),
    .M_AXI_AWSIZE               (s_axi1_awsize),
    .M_AXI_AWBURST              (s_axi1_awburst),
    .M_AXI_AWLOCK               (s_axi1_awlock),
    .M_AXI_AWCACHE              (s_axi1_awcache),
    .M_AXI_AWPROT               (s_axi1_awprot),
    .M_AXI_AWQOS                (s_axi1_awqos),
    .M_AXI_AWVALID              (s_axi1_awvalid),
    .M_AXI_AWREADY              (s_axi1_awready),
    .M_AXI_WDATA                (s_axi1_wdata),
    .M_AXI_WSTRB                (s_axi1_wstrb),
    .M_AXI_WLAST                (s_axi1_wlast),
    .M_AXI_WVALID               (s_axi1_wvalid),
    .M_AXI_WREADY               (s_axi1_wready),
    .M_AXI_BID                  (s_axi1_bid),
    .M_AXI_BRESP                (s_axi1_bresp),
    .M_AXI_BVALID               (s_axi1_bvalid),
    .M_AXI_BREADY               (s_axi1_bready)
);
endmodule

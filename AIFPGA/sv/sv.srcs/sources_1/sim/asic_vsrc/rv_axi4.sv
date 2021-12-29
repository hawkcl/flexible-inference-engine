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


module rv_axi4
import definitions_pkg::*;
(
    input logic   [AXI4_ADDR_WIDTH-1:0]     base_feature_address,
    input logic   [AXI4_ADDR_WIDTH-1:0]     base_weight_address,
    //read request
    input  ddr_id_t                 wt_axi_rid,
    input mem_addr_t                wt_axi_raddr,
    input ddr_width_t               wt_axi_len,
    input logic                     wt_read_request,
    input logic                     wt_read_freeze,
//    output logic                    ps_read_pending,

    output logic                    wt_axi_rready,
    output ddr_id_t                 wt_ddr_vid,
    output ubyte_t  [PS_DDR_DATAWIDTH-1 : 0] wt_ddr_data,
    output logic                    wt_ddr_isLast,

    //write request
    input  logic                    wt_write_request,
    input  mem_addr_t               wt_axi_waddr,
    input  logic    [PS_DDR_DATAWIDTH-1 : 0] wt_axi_wstrobe,
    input  ubyte_t  [PS_DDR_DATAWIDTH-1 : 0] wt_axi_wdata,
    output logic                    wt_axi_wready,

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

    //axi0
    output logic [C_M_AXI_ID_WIDTH-1 : 0]s_axi0_awid,
    output logic [AXI4_ADDR_WIDTH-1:0]s_axi0_awaddr,
    output logic [AXI4_LEN_WIDTH-1:0]s_axi0_awlen,
    output logic [AXI4_SIZE_WIDTH-1:0]s_axi0_awsize,
    output logic [1:0]s_axi0_awburst,
    output logic [0:0]s_axi0_awlock,
    output logic [3:0]s_axi0_awcache,
    output logic [2:0]s_axi0_awprot,
    output logic [3:0]s_axi0_awqos,
    output logic s_axi0_awvalid,
    input  logic s_axi0_awready,
    output logic [DDR_DATAWIDTH*8 - 1:0]s_axi0_wdata,
    output logic [DDR_DATAWIDTH - 1:0]s_axi0_wstrb,
    output logic s_axi0_wlast,
    output logic s_axi0_wvalid,
    input  logic s_axi0_wready,
    output logic s_axi0_bready,
    input  logic [1:0]s_axi0_bresp,
    input  logic s_axi0_bvalid,
    output logic [C_M_AXI_ID_WIDTH-1 : 0] s_axi0_arid,
    output logic [AXI4_ADDR_WIDTH-1:0]s_axi0_araddr,
    output logic [AXI4_LEN_WIDTH-1:0]s_axi0_arlen,
    output logic [AXI4_SIZE_WIDTH-1:0]s_axi0_arsize,
    output logic [1:0]s_axi0_arburst,
    output logic [0:0]s_axi0_arlock,
    output logic [3:0]s_axi0_arcache,
    output logic [2:0]s_axi0_arprot,
    output logic [3:0]s_axi0_arqos,
    output logic s_axi0_arvalid,
    input  logic s_axi0_arready,
    output logic s_axi0_rready,
    input  logic [DDR_DATAWIDTH*8 - 1:0]s_axi0_rdata,
    input  logic [1:0]s_axi0_rresp,
    input  logic s_axi0_rlast,
    input  logic s_axi0_rvalid,
    output logic [3:0]s_axi0_arregion,
    output logic [3:0]s_axi0_awregion,

    //ps_axi
    output logic [C_M_AXI_ID_WIDTH-1 : 0]ps_axi_awid,
    output logic [AXI4_ADDR_WIDTH-1:0]ps_axi_awaddr,
    output logic [AXI4_LEN_WIDTH-1:0]ps_axi_awlen,
    output logic [AXI4_SIZE_WIDTH-1:0]ps_axi_awsize,
    output logic [1:0]ps_axi_awburst,
    output logic [0:0]ps_axi_awlock,
    output logic [3:0]ps_axi_awcache,
    output logic [2:0]ps_axi_awprot,
    output logic [3:0]ps_axi_awqos,
    output logic ps_axi_awvalid,
    input  logic ps_axi_awready,
    output logic [PS_DDR_DATAWIDTH*8 - 1:0]ps_axi_wdata,
    output logic [PS_DDR_DATAWIDTH - 1:0]ps_axi_wstrb,
    output logic ps_axi_wlast,
    output logic ps_axi_wvalid,
    input  logic ps_axi_wready,
    output logic ps_axi_bready,
    input  logic [1:0]ps_axi_bresp,
    input  logic ps_axi_bvalid,
    output logic [C_M_AXI_ID_WIDTH-1 : 0] ps_axi_arid,
    output logic [AXI4_ADDR_WIDTH-1:0]ps_axi_araddr,
    output logic [AXI4_LEN_WIDTH-1:0]ps_axi_arlen,
    output logic [AXI4_SIZE_WIDTH-1:0]ps_axi_arsize,
    output logic [1:0]ps_axi_arburst,
    output logic [0:0]ps_axi_arlock,
    output logic [3:0]ps_axi_arcache,
    output logic [2:0]ps_axi_arprot,
    output logic [3:0]ps_axi_arqos,
    output logic ps_axi_arvalid,
    input  logic ps_axi_arready,
    output logic ps_axi_rready,
    input  logic [PS_DDR_DATAWIDTH*8 - 1:0]ps_axi_rdata,
    input  logic [1:0]ps_axi_rresp,
    input  logic ps_axi_rlast,
    input  logic ps_axi_rvalid,
    output logic [3:0]ps_axi_arregion,
    output logic [3:0]ps_axi_awregion,
    
	//system clocks
	input logic             aresetn,
    input logic             ui_clk
    );
 
  //logic aresetn;
  assign s_axi0_arregion = 4'b0000;
  assign s_axi0_awregion = 4'b0000;
  assign ps_axi_arregion = 4'b0000;
  assign ps_axi_awregion = 4'b0000;

 DDRReadAssist_AXI 
 #(
     .RID(DDR_WEIGHT_ID), 
     .C_M_AXI_DATA_WIDTH(PS_DDR_DATAWIDTH*8)
 ) 
 ps_read_axi
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),
    .base_addr                  (base_weight_address),
    .axi_rid                    (wt_axi_rid),
    .axi_raddr                  (wt_axi_raddr),
    .axi_len                    (wt_axi_len),
    .read_request               (wt_read_request),
    .read_freeze                (wt_read_freeze),
    //.pending_request            (ps_read_pending),

    .axi_ready                  (wt_axi_rready),
    .ddr_vid                    (wt_ddr_vid),
    .ddr_data                   (wt_ddr_data),
    .ddr_isLast                 (wt_ddr_isLast),

    .M_AXI_ARID                 (ps_axi_arid),
    .M_AXI_ARADDR               (ps_axi_araddr),
    .M_AXI_ARLEN                (ps_axi_arlen),
    .M_AXI_ARSIZE               (ps_axi_arsize),
    .M_AXI_ARBURST              (ps_axi_arburst),
    .M_AXI_ARLOCK               (ps_axi_arlock),
    .M_AXI_ARCACHE              (ps_axi_arcache),
    .M_AXI_ARPROT               (ps_axi_arprot),
    .M_AXI_ARQOS                (ps_axi_arqos),
    .M_AXI_ARVALID              (ps_axi_arvalid),
    .M_AXI_ARREADY              (ps_axi_arready),
    .M_AXI_RDATA                (ps_axi_rdata),
    .M_AXI_RRESP                (ps_axi_rresp),
    .M_AXI_RLAST                (ps_axi_rlast),
    .M_AXI_RVALID               (ps_axi_rvalid),
    .M_AXI_RREADY               (ps_axi_rready)
);

DDRWriteAssist_AXI
#(
    .WID(DDR_WEIGHT_ID),
    .C_M_AXI_DATA_WIDTH(PS_DDR_DATAWIDTH*8)
)
ps_write_axi
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),
    .base_addr                  (base_weight_address),

    .write_request              (wt_write_request),
    .axi_waddr                  (wt_axi_waddr),
    .axi_wstrobe                (wt_axi_wstrobe),
    .axi_wdata                  (wt_axi_wdata),
    .axi_ready                  (wt_axi_wready),

    .M_AXI_AWID                 (ps_axi_awid),
    .M_AXI_AWADDR               (ps_axi_awaddr),
    .M_AXI_AWLEN                (ps_axi_awlen),
    .M_AXI_AWSIZE               (ps_axi_awsize),
    .M_AXI_AWBURST              (ps_axi_awburst),
    .M_AXI_AWLOCK               (ps_axi_awlock),
    .M_AXI_AWCACHE              (ps_axi_awcache),
    .M_AXI_AWPROT               (ps_axi_awprot),
    .M_AXI_AWQOS                (ps_axi_awqos),
    .M_AXI_AWVALID              (ps_axi_awvalid),
    .M_AXI_AWREADY              (ps_axi_awready),
    .M_AXI_WDATA                (ps_axi_wdata),
    .M_AXI_WSTRB                (ps_axi_wstrb),
    .M_AXI_WLAST                (ps_axi_wlast),
    .M_AXI_WVALID               (ps_axi_wvalid),
    .M_AXI_WREADY               (ps_axi_wready),
    .M_AXI_BRESP                (ps_axi_bresp),
    .M_AXI_BVALID               (ps_axi_bvalid),
    .M_AXI_BREADY               (ps_axi_bready)
);

 DDRReadAssist_AXI 
 #(.RID(DDR_FEATURE_ID), 
   .C_M_AXI_DATA_WIDTH(DDR_DATAWIDTH*8)
 ) 
 read_axi1
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),
    .base_addr                  (base_feature_address),
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
//    .M_AXI_RID                  (s_axi0_rid),
    .M_AXI_RDATA                (s_axi0_rdata),
    .M_AXI_RRESP                (s_axi0_rresp),
    .M_AXI_RLAST                (s_axi0_rlast),
    .M_AXI_RVALID               (s_axi0_rvalid),
    .M_AXI_RREADY               (s_axi0_rready)
);

DDRWriteAssist_AXI
#(
    .WID(DDR_FEATURE_ID),
    .C_M_AXI_DATA_WIDTH(DDR_DATAWIDTH*8)
)
write_axi1
(
    .clock                      (ui_clk),         
    .resetN                     (aresetn),
    .base_addr                  (base_feature_address),

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
    .M_AXI_BRESP                (s_axi0_bresp),
    .M_AXI_BVALID               (s_axi0_bvalid),
    .M_AXI_BREADY               (s_axi0_bready)
);

endmodule

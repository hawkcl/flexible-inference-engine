`ifndef AXI_PORTS_SV
`define AXI_PORTS_SV

`timescale 1ns / 1ns
interface axi_ports 
import definitions_pkg::*;
(
input logic                             ui_clk,
output logic                             aresetn,

output logic                             addrbuf_enable,
output mem_addr_t                        inst_address,

input logic                            add_output,
input logic   [DDR_ADDR_WIDTH-1:0]     add_output_address,
input logic   [DDR_ADDR_WIDTH-1:0]     add_output_size,

//axi0
input logic [C_M_AXI_ID_WIDTH-1 : 0]   s_axi0_awid,
input logic [AXI4_ADDR_WIDTH-1:0]      s_axi0_awaddr,
input logic [AXI4_LEN_WIDTH-1:0]       s_axi0_awlen,
input logic [AXI4_SIZE_WIDTH-1:0]      s_axi0_awsize,
input logic [1:0]                      s_axi0_awburst,
input logic [0:0]                      s_axi0_awlock,
input logic [3:0]                      s_axi0_awcache,
input logic [2:0]                      s_axi0_awprot,
input logic [3:0]                      s_axi0_awqos,
input logic                            s_axi0_awvalid,
output  logic                            s_axi0_awready,
input logic [DDR_DATAWIDTH*8 - 1:0]    s_axi0_wdata,
input logic [DDR_DATAWIDTH - 1:0]      s_axi0_wstrb,
input logic                            s_axi0_wlast,
input logic                            s_axi0_wvalid,
output  logic                            s_axi0_wready,
input logic                            s_axi0_bready,
output  logic [1:0]                      s_axi0_bresp,
output  logic                            s_axi0_bvalid,
input logic [C_M_AXI_ID_WIDTH-1 : 0]   s_axi0_arid,
input logic [AXI4_ADDR_WIDTH-1:0]      s_axi0_araddr,
input logic [AXI4_LEN_WIDTH-1:0]       s_axi0_arlen,
input logic [AXI4_SIZE_WIDTH-1:0]      s_axi0_arsize,
input logic [1:0]                      s_axi0_arburst,
input logic [0:0]                      s_axi0_arlock,
input logic [3:0]                      s_axi0_arcache,
input logic [2:0]                      s_axi0_arprot,
input logic [3:0]                      s_axi0_arqos,
input logic                            s_axi0_arvalid,
output  logic                            s_axi0_arready,
input logic                            s_axi0_rready,
output  logic [DDR_DATAWIDTH*8 - 1:0]    s_axi0_rdata,
output  logic [1:0]                      s_axi0_rresp,
output  logic                            s_axi0_rlast,
output  logic                            s_axi0_rvalid,
input logic [3:0]                      s_axi0_arregion,
input logic [3:0]                      s_axi0_awregion,

//ps_axi
input logic [C_M_AXI_ID_WIDTH-1 : 0]   ps_axi_awid,
input logic [AXI4_ADDR_WIDTH-1:0]      ps_axi_awaddr,
input logic [AXI4_LEN_WIDTH-1:0]       ps_axi_awlen,
input logic [AXI4_SIZE_WIDTH-1:0]      ps_axi_awsize,
input logic [1:0]                      ps_axi_awburst,
input logic [0:0]                      ps_axi_awlock,
input logic [3:0]                      ps_axi_awcache,
input logic [2:0]                      ps_axi_awprot,
input logic [3:0]                      ps_axi_awqos,
input logic                            ps_axi_awvalid,
output  logic                            ps_axi_awready,
input logic [DDR_DATAWIDTH*8 - 1:0]    ps_axi_wdata,
input logic [DDR_DATAWIDTH - 1:0]      ps_axi_wstrb,
input logic                            ps_axi_wlast,
input logic                            ps_axi_wvalid,
output  logic                            ps_axi_wready,
input logic                            ps_axi_bready,
output  logic [1:0]                      ps_axi_bresp,
output  logic                            ps_axi_bvalid,
input logic [C_M_AXI_ID_WIDTH-1 : 0]   ps_axi_arid,
input logic [AXI4_ADDR_WIDTH-1:0]      ps_axi_araddr,
input logic [AXI4_LEN_WIDTH-1:0]       ps_axi_arlen,
input logic [AXI4_SIZE_WIDTH-1:0]      ps_axi_arsize,
input logic [1:0]                      ps_axi_arburst,
input logic [0:0]                      ps_axi_arlock,
input logic [3:0]                      ps_axi_arcache,
input logic [2:0]                      ps_axi_arprot,
input logic [3:0]                      ps_axi_arqos,
input logic                            ps_axi_arvalid,
output  logic                            ps_axi_arready,
input logic                            ps_axi_rready,
output  logic [DDR_DATAWIDTH*8 - 1:0]    ps_axi_rdata,
output  logic [1:0]                      ps_axi_rresp,
output  logic                            ps_axi_rlast,
output  logic                            ps_axi_rvalid,
input logic [3:0]                      ps_axi_arregion,
input logic [3:0]                      ps_axi_awregion
);
endinterface



`endif

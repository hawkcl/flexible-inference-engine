//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 05:53:43
// Design Name: 
// Module Name: weightFifo
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

module DDRWriteAssist_AXI
import definitions_pkg::*;
#(
parameter  WID = 1,
parameter  C_M_AXI_DATA_WIDTH	= 256
)
(
    input logic 		clock, resetN,
    input logic   [AXI4_ADDR_WIDTH-1:0]     base_addr,

    input  logic                    write_request,
    input  mem_addr_t               axi_waddr,
    input  logic    [C_M_AXI_DATA_WIDTH/8-1 : 0] axi_wstrobe,
    input  ubyte_t  [C_M_AXI_DATA_WIDTH/8-1 : 0] axi_wdata,
    output logic                    axi_ready,

    output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
    output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
    output wire [7 : 0] M_AXI_AWLEN,
    output wire [2 : 0] M_AXI_AWSIZE,
    output wire [1 : 0] M_AXI_AWBURST,
    output wire  M_AXI_AWLOCK,
    output wire [3 : 0] M_AXI_AWCACHE,
    output wire [2 : 0] M_AXI_AWPROT,
    output wire [3 : 0] M_AXI_AWQOS,
    output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
    output wire  M_AXI_AWVALID,
    input wire  M_AXI_AWREADY,

    output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
    output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
    output wire  M_AXI_WLAST,
    output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
    output wire  M_AXI_WVALID,
    input wire  M_AXI_WREADY,

    input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
    input wire [1 : 0] M_AXI_BRESP,
    input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
    input wire  M_AXI_BVALID,
    output wire  M_AXI_BREADY
);
logic               write_request_reg;
mem_addr_t          axi_waddr_reg;
ubyte_t  [C_M_AXI_DATA_WIDTH/8-1 : 0]         axi_wdata_reg;
logic    [C_M_AXI_DATA_WIDTH/8-1 : 0]         axi_wstrobe_reg;

logic               pending_addr;
logic               pending_data;
mem_addr_t          pending_axi_waddr;
logic    [C_M_AXI_DATA_WIDTH/8-1 : 0]         pending_axi_wstrobe;
ubyte_t  [C_M_AXI_DATA_WIDTH/8-1 : 0]         pending_axi_wdata;

always_ff @(posedge clock)
if (!resetN)
    {write_request_reg, axi_waddr_reg, axi_wdata_reg, axi_wstrobe_reg} <= '0;
else if(axi_ready) begin
    write_request_reg   <= write_request;
    axi_waddr_reg       <= axi_waddr;
    axi_wdata_reg       <= axi_wdata;
    axi_wstrobe_reg     <= axi_wstrobe;
end

always_ff @(posedge clock)
if (!resetN)
    {pending_axi_waddr, pending_axi_wstrobe, pending_axi_wdata} <= '0;
else if(axi_ready)
    {pending_axi_waddr, pending_axi_wstrobe, pending_axi_wdata} <= {axi_waddr_reg, axi_wstrobe_reg, axi_wdata_reg};

always_ff @(posedge clock)
if (!resetN)
    pending_addr <= '0;
else if(M_AXI_AWVALID && ~M_AXI_AWREADY)
    pending_addr <= 1'b1;
else //if(M_AXI_ARVALID && M_AXI_ARREADY)
    pending_addr <= 1'b0;

assign axi_ready = (~pending_addr) && (~pending_data);
assign M_AXI_AWID	= WID;
assign M_AXI_AWADDR	= base_addr + (pending_addr ?pending_axi_waddr : axi_waddr_reg);
assign M_AXI_AWLEN	= 0;
assign M_AXI_AWSIZE	= $clog2((C_M_AXI_DATA_WIDTH/8)-1);
assign M_AXI_AWBURST	= 2'b01;
assign M_AXI_AWLOCK	= 1'b0;
assign M_AXI_AWCACHE	= 4'b0000;
assign M_AXI_AWPROT	= 3'h0;
assign M_AXI_AWQOS	= 4'h0;
assign M_AXI_AWUSER	= 'b1;
assign M_AXI_AWVALID	= (write_request_reg && !pending_data) || pending_addr; //data addr?

always_ff @(posedge clock)
if (!resetN)
    pending_data <= '0;
else if(M_AXI_WVALID && ~M_AXI_WREADY)
    pending_data <= 1'b1;
else //if(M_AXI_ARVALID && M_AXI_ARREADY)
    pending_data <= 1'b0;

assign M_AXI_WDATA	= pending_data ? pending_axi_wdata : axi_wdata_reg;
assign M_AXI_WSTRB	= pending_data ? pending_axi_wstrobe : axi_wstrobe_reg;
//assign M_AXI_WSTRB	= '1;
assign M_AXI_WLAST	= 1'b1;
assign M_AXI_WUSER	= 'b0;
assign M_AXI_WVALID	= (write_request_reg && !pending_addr) || pending_data; //data addr?

assign M_AXI_BREADY	= 1'b1;

//assert(M_AXI_BREADY & M_AXI_BVALID & ~M_AXI_BRESP[1])
//else $write("write respond error!\n");


always_comb
begin
    if(M_AXI_WVALID)
        $write("w_axi valid pending %d, rdy %d, data %x %x (%x)\n", pending_data
        , M_AXI_WREADY, M_AXI_WDATA[31:0], M_AXI_WDATA[63:32], M_AXI_WSTRB);
    if(M_AXI_AWVALID)
        $write("wa_axi valid pending %d, rdy %d, addr %x\n"
        , pending_addr, M_AXI_AWREADY, M_AXI_AWADDR);
end
endmodule

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

module DDRReadAssist_AXI
import definitions_pkg::*;
#(
    parameter  RID = 1,
    parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h00000000,
    parameter  C_M_AXI_DATA_WIDTH	= 256
)
(
    input logic 		clock, resetN,

    input  ddr_id_t                 axi_rid,
    input mem_addr_t                axi_raddr,
    input ddr_width_t               axi_len,
    input logic                     read_request,
    input logic                     read_freeze,

    output logic                    axi_ready,
    output ddr_id_t                 ddr_vid,
    output ubyte_t  [C_M_AXI_DATA_WIDTH/8-1 : 0] ddr_data,
    output logic                    ddr_isLast,

    output logic [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
    output logic [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
    output logic [7 : 0] M_AXI_ARLEN,
    output logic [2 : 0] M_AXI_ARSIZE,
    output logic [1 : 0] M_AXI_ARBURST,
    output logic  M_AXI_ARLOCK,
    output logic [3 : 0] M_AXI_ARCACHE,
    output logic [2 : 0] M_AXI_ARPROT,
    output logic [3 : 0] M_AXI_ARQOS,
    output logic [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
    output logic  M_AXI_ARVALID,
    input logic  M_AXI_ARREADY,
    //output logic               pending_request,

    input logic [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
    input logic [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
    input logic [1 : 0] M_AXI_RRESP,
    input logic  M_AXI_RLAST,
    input logic [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
    input logic  M_AXI_RVALID,
    output logic  M_AXI_RREADY
);
logic               read_request_reg;
ddr_id_t            axi_rid_reg;
mem_addr_t          axi_raddr_reg;
ddr_width_t         axi_len_reg;
logic               pending_request;
ddr_id_t            pending_axi_rid;
mem_addr_t          pending_axi_raddr;
ddr_width_t         pending_axi_len;

always_ff @(posedge clock)
if (!resetN)
    pending_request <= 1'b0;
else if(M_AXI_ARVALID && ~M_AXI_ARREADY)
    pending_request <= 1'b1;
else //if(M_AXI_ARVALID && M_AXI_ARREADY)
    pending_request <= 1'b0;

always_ff @(posedge clock)
if (!resetN)
    {read_request_reg, axi_rid_reg,axi_raddr_reg, axi_len_reg} <= '0;
else if(!pending_request) begin
    read_request_reg <= read_request;
    {axi_rid_reg,axi_raddr_reg, axi_len_reg} <= {axi_rid, axi_raddr, axi_len};
end

always_ff @(posedge clock)
if (!resetN)
    {pending_axi_rid, pending_axi_raddr,pending_axi_len} <= '0;
else if(/*read_request_reg &&*/ !pending_request)
    {pending_axi_rid, pending_axi_raddr,pending_axi_len} <= {axi_rid_reg, axi_raddr_reg, axi_len_reg};

assign axi_ready = ~pending_request;
assign M_AXI_ARID	= RID;//pending_request ? pending_axi_rid : axi_rid;
assign M_AXI_ARADDR	= C_M_TARGET_SLAVE_BASE_ADDR + (pending_request ?pending_axi_raddr : axi_raddr_reg);
assign M_AXI_ARLEN	= pending_request ? pending_axi_len : axi_len_reg;
assign M_AXI_ARSIZE	= $clog2((C_M_AXI_DATA_WIDTH/8)-1);
assign M_AXI_ARBURST	= 2'b01;
assign M_AXI_ARLOCK	= 1'b0;
	//Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
assign M_AXI_ARCACHE	= 4'b0010;
assign M_AXI_ARPROT	= 3'h0;
assign M_AXI_ARQOS	= 4'h0;
assign M_AXI_ARUSER	= '0;
assign M_AXI_ARVALID	= read_request_reg || pending_request;

// may need FF for one cycle delay
assign M_AXI_RREADY	= ~read_freeze;
//assign ddr_vid = (M_AXI_RVALID && M_AXI_RREADY)?M_AXI_RID:'0;
assign ddr_vid = (M_AXI_RVALID && M_AXI_RREADY)?RID:'0;
assign ddr_data = M_AXI_RDATA;
assign ddr_isLast = M_AXI_RLAST;

//assert(M_AXI_RREADY & M_AXI_RVALID & ~M_AXI_RRESP[1]) 
//else $write("AXI_error reading data\n");

endmodule

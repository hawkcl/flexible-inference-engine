`ifndef DDRWRITE_PORTS_SV
`define DDRWRITE_PORTS_SV

`timescale 1ns / 1ns
interface ddrwriteassist_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic         req_valid,
output mem_addr_t    req_addr,
output ddr_len_t     req_len,
output ubyte_t	[BRAM_BUS_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] req_data,
output logic         axi_ready,

input logic        write_ready,
input logic        write_request,
input ddr_id_t     axi_wid,
input mem_addr_t   axi_waddr,
//output ddr_width_t  axi_len,
input logic    [DDR_DATAWIDTH-1 : 0] axi_wstrobe,
input ubyte_t  [DDR_DATAWIDTH-1 : 0] axi_wdata
);
endinterface



`endif

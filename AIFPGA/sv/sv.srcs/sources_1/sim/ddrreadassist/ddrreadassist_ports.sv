`ifndef DDRREAD_PORTS_SV
`define DDRREAD_PORTS_SV

`timescale 1ns / 1ns
interface ddrreadassist_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output logic         req_valid,
output ddr_id_t      req_id,
output mem_addr_t    req_addr,
output ddr_len_t     req_len,
output logic         axi_ready,

output ddr_id_t      ddr_vid,
output ubyte_t  [DDR_DATAWIDTH-1 : 0] ddr_data,
output logic         ddr_isLast,

input logic        read_ready,
input ddr_id_t     valid_id,
input ubyte_t [MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] valid_data,

input ddr_id_t     axi_rid,
input mem_addr_t   axi_raddr,
input ddr_width_t  axi_len,
input logic        read_request,
input logic        read_freeze
);
endinterface



`endif

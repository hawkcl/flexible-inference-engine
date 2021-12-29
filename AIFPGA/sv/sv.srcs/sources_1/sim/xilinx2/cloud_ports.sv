`ifndef CLOUD_PORTS_SV
`define CLOUD_PORTS_SV

`timescale 1ns / 1ns
interface cloud_ports 
import definitions_pkg::*;
(
input logic clock, 
output logic resetN,
output  logic                   buf_received,
output  logic [7 : 0]            buffer[DDR_LEN_SIZE + 8], // 200 + 8

input logic                        output_enable,
input logic [DDR_ADDR_WIDTH-1:0]   output_addr,
input logic [DDR_DATA_WIDTH-1:0]   output_data[DDR_LEN_SIZE],
input logic [DDR_LEN_WIDTH-1 : 0]  output_len
);
endinterface



`endif

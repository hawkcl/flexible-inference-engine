`ifndef IF_PORTS_SV
`define IF_PORTS_SV

`timescale 1ns / 1ns
interface interface_ports 
import definitions_pkg::*;
(
    input logic clock, 
    output logic resetN,
    output logic                    buf_received,
    output logic [7 : 0]            buffer[DDR_LEN_SIZE + 8], // 200 + 8
    output logic                        add_output,
    output logic [DDR_ADDR_WIDTH-1:0]   add_output_address,
    output logic [DDR_ADDR_WIDTH-1:0]   add_output_size,
    output logic                        ren_weight,
    output logic [DDR_ADDR_WIDTH-1:0]   read_addr_weight,
    output logic [DDR_LEN_WIDTH-1 : 0]  read_len_weight,
    output logic                        ren_data1,
    output logic [DDR_ADDR_WIDTH-1:0]   read_addr_data1,
    output logic [DDR_LEN_WIDTH-1 : 0]  read_len_data1,

    output logic                        wen_data1,
    output logic [DDR_ADDR_WIDTH-1:0]   write_addr_data1,
    output logic [DDR_LEN_WIDTH-1 : 0]  write_len_data1,
    output logic [DDR_DATA_WIDTH-1:0]   write_data_data1[DDR_LEN_SIZE],

    input logic                        addrbuf_enable,
    input logic [DDR_ADDR_WIDTH-1:0]   inst_address,

    input logic                        output_enable,
    input logic [DDR_ADDR_WIDTH-1:0]   output_addr,
    input logic [DDR_DATA_WIDTH-1:0]   output_data[DDR_LEN_SIZE],
    input logic [DDR_LEN_WIDTH-1 : 0]  output_len,
    input logic [DDR_DATA_WIDTH-1:0]   read_data_weight[DDR_LEN_SIZE],
    input logic [DDR_DATA_WIDTH-1:0]   read_data_data1[DDR_LEN_SIZE]
);
endinterface



`endif

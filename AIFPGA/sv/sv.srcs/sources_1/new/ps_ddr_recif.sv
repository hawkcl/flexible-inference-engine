`timescale 1ps/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2019 12:17:37 AM
// Design Name: 
// Module Name: 
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


module ps_ddr_recif
import definitions_pkg::*;
#(
    parameter DATAWIDTH = 8
)
(
    input                   rst_n  ,
    input                   ddr_clk,
    input                   if_clk,

    //write request
    output  logic                    write_request,
    output  mem_addr_t               axi_waddr,
    output  logic    [DATAWIDTH-1 : 0] axi_wstrobe,
    output  ubyte_t  [DATAWIDTH-1 : 0] axi_wdata,
    input logic                    axi_wready,

    //rec_fifo
    output  logic					rec_fifo_almost_full_weight,
    input logic [(DATAWIDTH + 4)*8 : 0] 	rec_fifo_data_weight,
    input logic	    rec_fifo_en_weight

);

logic           fifo_empty;
logic           fifo_ren;
logic   [31:0]  addr;
logic           weight_mem;
logic [(DATAWIDTH + 4)*8 : 0] 	fifo_out_data;
logic [7:0]wr_data_count;
logic           wr_rst_busy;
logic           rd_rst_busy;
logic           fifo_full;

assign axi_wstrobe = '1;
assign {weight_mem, addr, axi_wdata} = fifo_out_data;
assign axi_waddr = addr;
assign fifo_ren = (~fifo_empty) && axi_wready;
assign write_request = fifo_ren;

ps_rec_data_fifo ps_rec_fifo
(
    .rst                 (~rst_n),
    .wr_clk              (if_clk),
    .rd_clk              (ddr_clk),
    .din                 (rec_fifo_data_weight),
    .wr_en               (rec_fifo_en_weight),
    .rd_en               (fifo_ren),
    .dout                (fifo_out_data),
    .full                (fifo_full),
    .empty               (fifo_empty),
    //.prog_full           (rec_fifo_almost_full),
    .wr_data_count
//    .wr_rst_busy,
 //   .rd_rst_busy
);
endmodule

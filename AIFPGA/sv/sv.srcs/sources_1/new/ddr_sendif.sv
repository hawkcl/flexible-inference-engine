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


module ddr_sendif
import definitions_pkg::*;
(
    input                   rst_n  ,
    input                   ddr_clk,
    input                   if_clk,
    input                   ui_clk,

  //read request
    output  ddr_id_t                 axi_rid,
    output mem_addr_t                axi_raddr,
    output ddr_width_t               axi_len,
    output logic                     read_request,
    output logic                     read_freeze,

    input logic                     axi_rready,
    input ddr_id_t                  ddr_vid,
    input ubyte_t  [DDR_DATAWIDTH-1 : 0] ddr_data,
    input logic                     ddr_isLast,

    //send_fifo
    output  logic [7:0]				send_fifo_cnt,
    output  logic					send_fifo_flash,
    output  logic                   send_fifo_empty,
    input logic					    send_fifo_en,
    output  logic [(DDR_DATAWIDTH)*8 - 1 : 0] 	send_fifo_data,

    input logic                     start_send,
    input logic unsigned [DDR_ADDR_WIDTH-1:0]             send_addr,
    input logic unsigned [DDR_ADDR_WIDTH-1:0]             send_len
);

parameter QUEUE_SIZE = 120;

logic                    data_fifo_empty;
logic                    clk_data_fifo_empty;
logic                    data_fifo_full;
logic                    addr_fifo_empty;
logic                    addr_fifo_full;
logic                    send_fifo_flash0;
logic                    addr_fifo_ren;
logic [DDR_ADDR_WIDTH*2 -1:0]             addr_fifo_data;
logic unsigned [31:0]             next_addr;
logic unsigned [DDR_ADDR_WIDTH-1:0]             asked_len;
logic unsigned [DDR_ADDR_WIDTH-1:0]             reced_len;
logic unsigned [DDR_ADDR_WIDTH-1:0]             total_len;
logic unsigned [DDR_ADDR_WIDTH-1:0]             used_size;
logic unsigned [DDR_ADDR_WIDTH-1:0]             used_size2;

logic                   is_sending;
logic                   data_wen;

assign send_fifo_empty = data_fifo_empty;
assign axi_len = 0;
assign addr_fifo_ren = !is_sending && !addr_fifo_empty;
assign axi_raddr = next_addr;
assign axi_rid = 1;
assign read_freeze = 0;
assign read_request =   is_sending && axi_rready && asked_len < total_len 
        &&(asked_len - used_size2 < QUEUE_SIZE * DDR_DATAWIDTH);

always_ff @(posedge if_clk)
if (!rst_n)
    used_size <= 0;
else if(addr_fifo_ren)
    used_size <= 0;
else if(send_fifo_en)
    used_size <= used_size + DDR_DATAWIDTH;
always_ff @(posedge ddr_clk)
if (!rst_n)
    used_size2 <= 0;
else
    used_size2 <= used_size;

always_ff @(posedge ddr_clk)
if (!rst_n)
    clk_data_fifo_empty <= 1;
else
    clk_data_fifo_empty <= data_fifo_empty;
always_ff @(posedge ddr_clk)
if (!rst_n)
    send_fifo_flash0 <= 0;
else
    send_fifo_flash0 <= is_sending && (reced_len >= total_len) && !clk_data_fifo_empty;

assign   data_wen = is_sending && (ddr_vid != 0); 

always_ff @(posedge if_clk)
if (!rst_n)
    send_fifo_flash <= 0;
else
    send_fifo_flash <= send_fifo_flash0;


always_ff @(posedge ddr_clk)
if (!rst_n)
    is_sending <= '0;
else if(addr_fifo_ren)
    is_sending <= 1;
else if(is_sending && reced_len >= total_len && clk_data_fifo_empty)
    is_sending <= 0;

always_ff @(posedge ddr_clk)
if (!rst_n)
    total_len <= '0;
else if(addr_fifo_ren)
    total_len <= addr_fifo_data[DDR_ADDR_WIDTH-1:0];

always_ff @(posedge ddr_clk)
if (!rst_n)
    next_addr <= '0;
else if(addr_fifo_ren)
    next_addr[DDR_ADDR_WIDTH-1:0] <= addr_fifo_data[DDR_ADDR_WIDTH*2-1 : DDR_ADDR_WIDTH];
else if(read_request)
    next_addr <= next_addr + DDR_DATAWIDTH;

always_ff @(posedge ddr_clk)
if (!rst_n)
    asked_len <= '0;
else if(addr_fifo_ren)
    asked_len <= '0;
else if(read_request)
    asked_len <= asked_len + DDR_DATAWIDTH;

always_ff @(posedge ddr_clk)
if (!rst_n)
    reced_len <= '0;
else if(addr_fifo_ren)
    reced_len <= '0;
else if (data_wen)
    reced_len = reced_len + DDR_DATAWIDTH;

//assert (~(data_fifo_full && data_wen))
  //             else $error("write full send data fifo");

addr_fifo send_addr_fifo
(
    .rst                            (~rst_n), 
    .wr_clk                         (ui_clk), 
    .rd_clk                         (ddr_clk), 
    .din                            ({send_addr, send_len}), 
    .wr_en                          (start_send),
    .rd_en                          (addr_fifo_ren), 
    .dout                           (addr_fifo_data), 
    .full                           (addr_fifo_full), 
    .empty                          (addr_fifo_empty)
);

send_data_fifo send_fifo
(
    .rst                            (~rst_n), 
    .wr_clk                         (ddr_clk), 
    .rd_clk                         (if_clk), 
    .din                            (ddr_data), 
    .wr_en                          (data_wen), 
    .rd_en                          (send_fifo_en), 
    .dout                           (send_fifo_data), 
    .full                           (data_fifo_full), 
    .empty                          (data_fifo_empty), 
    .rd_data_count                  (send_fifo_cnt), 
    .wr_rst_busy                    (), 
    .rd_rst_busy                    ()
);
endmodule

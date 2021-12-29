

module addr_fifo
import definitions_pkg::*;
(clk, rst, din, wr_en, rd_en, dout, full, empty, wr_rst_busy, rd_rst_busy);
parameter INPUT_WIDTH = 52;
  input clk;
  input srst;
  input [INPUT_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [INPUT_WIDTH - 1:0]dout;
  output full;
  output empty;
  output wr_rst_busy;
  output rd_rst_busy;
  syn_fifo #(INPUT_WIDTH, 4, 16) SFifo (
	  .clk        (clk), 
	  .rst        (srst), 
	  .wr_cs      (wr_en), 
	  .rd_cs      (rd_en),
	  .data_in    (din),
	  .rd_en      (rd_en),
	  .wr_en      (wr_en),
	  .data_out   (dout),
	  .empty      (empty),
	  .full       (full)
  );
  
endmodule


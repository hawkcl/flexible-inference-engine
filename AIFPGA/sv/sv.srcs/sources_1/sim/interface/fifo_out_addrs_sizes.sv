

module fifo_out_addrs_sizes
import definitions_pkg::*;
(clk, srst, din, wr_en, rd_en, dout, full, empty);
/* synthesis syn_black_box */
parameter INTERFACE_WIDTH = DDR_ADDR_WIDTH * 2;
parameter INTERFACE_DEPTH = 16;
parameter INTERFACE_ADDR_WIDTH = $clog2(INTERFACE_DEPTH);
  input clk;
  input srst;
  input [INTERFACE_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [INTERFACE_WIDTH - 1:0]dout;
  output full;
  output empty;
  syn_fifo #(INTERFACE_WIDTH, INTERFACE_ADDR_WIDTH, INTERFACE_DEPTH) SFifo (
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


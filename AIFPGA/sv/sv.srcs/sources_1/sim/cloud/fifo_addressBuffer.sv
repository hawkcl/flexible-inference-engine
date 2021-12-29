

module fifo_addressBuffer
import definitions_pkg::*;
(clk, srst, din, wr_en, rd_en, dout, full, empty);
/* synthesis syn_black_box */
parameter ADDR_BUFFER_WIDTH = MEM_BIT_SIZE;
parameter ADDR_BUFFER_DEPTH = 16;
parameter ADDR_BUFFER_ADDR_WIDTH = $clog2(ADDR_BUFFER_DEPTH);
  input clk;
  input srst;
  input [ADDR_BUFFER_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [ADDR_BUFFER_WIDTH - 1:0]dout;
  output full;
  output empty;
  syn_fifo #(ADDR_BUFFER_WIDTH, ADDR_BUFFER_ADDR_WIDTH, ADDR_BUFFER_DEPTH) SFifo (
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


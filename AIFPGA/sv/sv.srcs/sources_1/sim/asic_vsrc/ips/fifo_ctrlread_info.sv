

module fifo_ctrlread_info
import definitions_pkg::*;
(clk, srst, din, wr_en, rd_en, dout, full, empty);
/* synthesis syn_black_box */
parameter CTRLREAD_WIDTH = 2;
parameter CTRLREAD_DEPTH = MAX_INPUT_BUF_SIZE + 1;
parameter CTRLREAD_ADDR_WIDTH = $clog2(CTRLREAD_DEPTH);
  input clk;
  input srst;
  input [CTRLREAD_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [CTRLREAD_WIDTH - 1:0]dout;
  output full;
  output empty;
  syn_fifo #(CTRLREAD_WIDTH, CTRLREAD_ADDR_WIDTH, CTRLREAD_DEPTH, 2) SFifo (
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


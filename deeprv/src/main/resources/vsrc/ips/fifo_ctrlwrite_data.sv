

module fifo_ctrlwrite_data
import definitions_pkg::*;
(clk, srst, din, wr_en, rd_en, dout, full, empty, prog_full);
/* synthesis syn_black_box */
parameter CTRLWRITE_WIDTH = COMPUTING_GROUP_SIZE * FEATURE_BIT_SIZE;
parameter CTRLWRITE_DEPTH = WRITE_FIFO_SIZE + 1;
parameter CTRLWRITE_ADDR_WIDTH = $clog2(CTRLWRITE_DEPTH);
  input clk;
  input srst;
  input [CTRLWRITE_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [CTRLWRITE_WIDTH - 1:0]dout;
  output full;
  output empty;
  output prog_full;
  syn_fifo #(CTRLWRITE_WIDTH, CTRLWRITE_ADDR_WIDTH, CTRLWRITE_DEPTH, 2) SFifo (
	  .clk        (clk), 
	  .rst        (srst), 
	  .wr_cs      (wr_en), 
	  .rd_cs      (rd_en),
	  .data_in    (din),
	  .rd_en      (rd_en),
	  .wr_en      (wr_en),
	  .data_out   (dout),
	  .empty      (empty),
	  .full       (full),
	  .prog_full  (prog_full)
  );
endmodule




module fifo_ctrlweight_data
import definitions_pkg::*;
(clk, srst, din, wr_en, rd_en, dout, full, empty, prog_full);
/* synthesis syn_black_box */
parameter CTRLWEIGHT_WIDTH = WEIGHT_BRAM_WIDTH;
parameter CTRLWEIGHT_DEPTH = MAX_CTRL_BUF_SIZE + 1;
parameter CTRLWEIGHT_ADDR_WIDTH = $clog2(CTRLWEIGHT_DEPTH);
  input clk;
  input srst;
  input [CTRLWEIGHT_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [CTRLWEIGHT_WIDTH - 1:0]dout;
  output full;
  output empty;
  output prog_full;
  syn_fifo #(CTRLWEIGHT_WIDTH, CTRLWEIGHT_ADDR_WIDTH, CTRLWEIGHT_DEPTH, 4) SFifo (
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


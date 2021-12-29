
`timescale 1ns / 1ns
parameter BM_WIDTH = 128;
parameter BM_DEPTH = 44;
parameter BM_ADDR_WIDTH = $clog2(BM_DEPTH);

module fifo_bmweights(clk, srst, din, wr_en, rd_en, dout, full, empty, prog_full); //, wr_rst_busy, rd_rst_busy)
  input clk;
  input srst;
  input [BM_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [BM_WIDTH - 1:0]dout;
  output full;
  output empty;
  output prog_full;
  syn_fifo #(BM_WIDTH, BM_ADDR_WIDTH, BM_DEPTH, 3) SFifo (
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



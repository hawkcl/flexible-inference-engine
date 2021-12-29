

parameter WEIGHT_WIDTH = 96;
parameter WEIGHT_ADDR_WIDTH = 13;
parameter WEIGHT_DEPTH = 5001;

module fifo_weights(clk, rst, din, wr_en, rd_en, dout, full, empty, prog_full); //, wr_rst_busy, rd_rst_busy)
  input clk;
  input rst;
  input [WEIGHT_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [WEIGHT_WIDTH - 1:0]dout;
  output full;
  output empty;
  output prog_full;
  syn_fifo #(WEIGHT_WIDTH, WEIGHT_ADDR_WIDTH, WEIGHT_DEPTH) SFifo (
	  .clk        (clk), 
	  .rst        (rst), 
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



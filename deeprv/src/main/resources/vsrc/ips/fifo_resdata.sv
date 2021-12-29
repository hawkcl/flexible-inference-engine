

module fifo_resdata
import definitions_pkg::*;
(clk, rst, din, wr_en, rd_en, dout, full, empty, prog_full, wr_rst_busy, rd_rst_busy);
parameter INPUT_WIDTH = COMPUTING_GROUP_SIZE * FEATURE_BIT_SIZE;
parameter MEM_DEPTH = 48 * COMPUTING_UNIT_OUTPUT_SIZE;
parameter ADDR_WIDTH = $clog2(MEM_DEPTH);
  input clk;
  input rst;
  input [INPUT_WIDTH - 1:0]din;
  input wr_en;
  input rd_en;
  output [INPUT_WIDTH - 1:0]dout;
  output full;
  output empty;
  output prog_full;
  output wr_rst_busy;
  output rd_rst_busy;
  syn_fifo #(INPUT_WIDTH, ADDR_WIDTH, MEM_DEPTH, 3) SFifo (
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


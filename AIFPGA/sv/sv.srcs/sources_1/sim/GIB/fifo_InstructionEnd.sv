module fifo_InstructionEnd
import definitions_pkg::*;
(clk, srst, din, wr_en, rd_en, dout, full, empty, wr_rst_busy, rd_rst_busy);
/* synthesis syn_black_box */
parameter INPUT_WIDTH = $bits(InstructionEnd);
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
  syn_fifo #(INPUT_WIDTH, 3, 5) SFifo (
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

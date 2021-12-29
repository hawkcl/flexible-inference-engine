`timescale 1ns / 1ns
module weight_tb
import definitions_pkg::*;
();

  logic clock, resetN;
  logic fifo_srst;
  logic enSendWeights;
  logic enSendBMWeights;
  weight_bus_size_t len;
  weight_bus_size_t bm_len;
  logic isRunning, pcweight_busValid;
  logic  is_cycle_froze;
  seq_t pcweight_seq;
  logic new_weight_params;
  mem_bus_addr_t new_weightReadPos;
  weight_addr_t new_nextWeightRead;
  weight_addr_t new_endWeightRead;
  seq_t new_reqSeqW;
  s_weight_t  w_bus[WEIGHT_MEM_BUS_SIZE];
  logic new_conv_inst; //new_weight_params from ProcessInstruction

  s_weight_t weightsBus[WEIGHT_BUS_SIZE];
  logic enough_data;
  logic bm_enough_data;
  logic isReadingWeights;
  

  logic weights_empty, weights_full, weights_almost_full;
  logic weights_wen, weights_ren;
  s_weight_t [WEIGHT_BUFFER_SIZE-1:0] weights_wdata;
  s_weight_t [WEIGHT_BUFFER_SIZE-1:0] weights_rdata;

assign fifo_srst = !resetN;

weight_ports ports(.*);
weight_top top(ports);

fifo_weights weights(.clk(clock), .rst(fifo_srst), .din(weights_wdata), 
	.wr_en(weights_wen), .rd_en(weights_ren), .dout(weights_rdata), 
	.full(weights_full) , .empty(weights_empty),.prog_full(weights_almost_full));
    
ReadWeights readWeights(.clock, .resetN,.enable(isRunning), .pcweight_seq, 
	.pcweight_busValid, .new_params(new_weight_params),.new_weightReadPos,
	.new_nextWeightRead ,.new_endWeightRead,.new_reqSeqW,.w_bus,
	.writeFifo(weights_wen),.dataFifo(weights_wdata),.isReadingWeights);

SendWeights sendWeights(.clock, .resetN,.enSendWeights,.len, 
	.clearNumBuf(new_conv_inst),.empty_fifo(weights_empty), .is_cycle_froze, .dataFifo(weights_rdata),
	.ren_fifo(weights_ren),.weightsBus,.enough_data(w_enough_data),
    .*);
    
    
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

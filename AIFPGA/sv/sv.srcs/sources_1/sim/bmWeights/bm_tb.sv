`timescale 1ns / 1ns
module bm_tb
import definitions_pkg::*;
();

  logic clock, resetN;
  logic fifo_srst;
  logic enSendBMWeights;
  weight_bus_size_t len;
  logic pread_busValid, pread_isFeature;
  ReturnData_t data;
  logic unsigned [7 : 0] curSeq;
  token_t token;
  logic new_conv_inst; //new_bm_params from ProcessInstruction

  bm_size_t receivedBM;
  s_feature_t bmWeightBus[WEIGHT_BUS_SIZE];
  logic enough_data;
  

  logic extWeights_empty, extWeights_full, extWeights_almost_full;
  logic extWeights_wen, extWeights_ren;
  s_feature_t [BM_READ_WIDTH-1:0] extWeights_wdata;
  s_feature_t [BM_READ_WIDTH-1:0] extWeights_rdata;

assign fifo_srst = !resetN;

bm_ports ports(.*);
bm_top top(ports);

fifo_bmweights extWeights(
	.clk(clock), .srst(fifo_srst), .din(extWeights_wdata), 
	.wr_en(extWeights_wen), .rd_en(extWeights_ren), .dout(extWeights_rdata),
        .full(extWeights_full),.empty(extWeights_empty));

ReadBMWeights readBMWeights(
	.clock, .resetN,.pread_busValid, .pread_isFeature,
	.data,.curSeq(curSeq),.token,.clearReceivedBM(new_conv_inst),
        .writeFifo(extWeights_wen),.receivedBM,.dataFifo(extWeights_wdata));
            
SendBMWeights sendBMWeights(
	.clock, .resetN,.enSendBMWeights,.len, .clearNumBuf(new_conv_inst),
	.empty_fifo(extWeights_empty),.dataFifo(extWeights_rdata),
	.ren_fifo(extWeights_ren), .bmWeightBus,.enough_data); 
    
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

`timescale 1ns / 1ns
module startConvOut_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic enable;
logic isNextVolumeReady, isPrefetchNextVolume_next, isPrefetchNextVolume;
logic reset_isOnOutput;
layer_addr_t kt, ks;
cg_addr_t numGroups;
k_t k;
logic doRes;
logic doUpSample;
width_t outputBufW1;
outframe_addr_t outFrameSize;
out_width_t outW;
output_gap_t outputAddrGap;
pad_t maxpool_stride;
seq_t curSeq;
logic newWriteInst;
width_t outputBufH1Orig;
mem_addr_t  outputAddr, outputFrameStart;
logic new_params;
layer_addr_t new_kOut;
cg_addr_t usedCGLast;
cg_addr_t usedCG0;
layer_addr_t kCurLast;

logic isOnOutput;
logic waiting_out;
logic cgSwitchOutput;
logic doRes_out, doUpSample_out;
width_t outputBufW1_out;
outframe_addr_t outFrameSize_out;
out_width_t outW_out, outW_out2;
pad_t maxpool_stride_out;
output_gap_t outputAddrGap_out;
k_t k_out;
seq_t curSeq_out;
logic newWriteInst_out;
width_t outputBufH1_out;
logic set_out_params;
mem_addr_t outputAddr_out, outputFrameStart_out;
logic set_LastOutput;
cg_addr_t outputIdxMax;
layer_addr_t kOut;
 

startConvOut_ports ports(.*);
startConvOut_top top(ports);

StartConvOut startConvOut(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

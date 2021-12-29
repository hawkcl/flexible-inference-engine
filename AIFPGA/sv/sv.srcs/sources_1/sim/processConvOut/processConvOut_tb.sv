`timescale 1ns / 1ns
module processConvOut_tb
import definitions_pkg::*;
();

logic clock, resetN;
HCB_STATE state;
logic enable;
logic isOnOutput;
logic pwrite_isWritable;
logic resBuf_empty;
//logic waiting_out;
//logic doBatch3K1_out;
logic doRes_out, doUpSample_out;
width_t outputBufW1_out;
outframe_addr_t outFrameSize_out;
out_width_t outW_out, outW_out2;
pad_t maxpool_stride_out;
output_gap_t outputAddrGap_out;
k_t k_out;
seq_t curSeq_out; // for debug; unused now
logic newWriteInst_out;
width_t outputBufH1_out;
cg_addr_t outputIdxMax;
s_feature_t pre_output[CG_NUM][COMPUTING_GROUP_SIZE];
s_feature_t [COMPUTING_GROUP_SIZE-1:0] resBuf;
logic set_LastOutput;

logic new_params;
mem_addr_t new_outputAddr; 
mem_addr_t new_outputFrameStart;
logic set_out_params;
mem_addr_t new_outputAddr_out, new_outputFrameStart_out;

logic res_en;
s_feature_t [COMPUTING_GROUP_SIZE - 1 : 0]pwrite_data;
logic pwrite_enable;
mem_addr_t pwrite_addr;
logic pwrite_setNextInst;
output_addr_t out_row;
logic reset_state;    // TO IDLE
mem_addr_t outputAddr; 
mem_addr_t outputFrameStart;
logic reset_isOnOutput;
seq_t finishedSeq;
 

processConvOut_ports ports(.*);
processConvOut_top top(ports);

ProcessConvOut processConvOut(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

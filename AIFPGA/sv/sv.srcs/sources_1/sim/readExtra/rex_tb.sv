`timescale 1ns / 1ns
module rex_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic isReadingFeatures, pread_RequestFull;
logic isResMaster; 
token_t this_token, ptoken;
logic res_full;
logic doRes; 
`ifdef S2_OPTIMIZE	
 logic isStride2;
`endif
DATA_MODE mode;
width_t outputBufW1, outputBufH1Orig; 
out_width_t outW;
outframe_addr_t outFrameSize;
output_gap_t outputAddrGap, outFrameGapSize;
logic unsigned [7 : 0] curSeq;
layer_addr_t ks;
cg_addr_t numGroups;
layer_addr_t kCurLast;
res_size_t resSize0;
res_size_t resSizeLast;
res_len_t resLen0;
res_len_t resLenLast;
cg_addr_t usedGroupsLast;

logic setParam;
layer_addr_t new_kRes;    
logic new_isReadResA;
mem_addr_t new_nextResAddr;
mem_addr_t new_frameResAddr;
group_t new_resRowCount;
res_size_t new_resSize;
res_size_t new_resReadSize;
layer_addr_t new_resFrameCount;
layer_addr_t new_resFrameMax;
res_len_t new_resLen; 
output_gap_t new_outResGapSize; 
res_size_t totalRes;
layer_addr_t kCurLast_1;
logic resetRequestingRes;
logic extWeights_ren;
logic resBuf_ren;
	
logic enRequest;
RequestItem_t request;
 

rex_ports ports(.*);
rex_top top(ports);

ReadExtraWeights readExtra(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

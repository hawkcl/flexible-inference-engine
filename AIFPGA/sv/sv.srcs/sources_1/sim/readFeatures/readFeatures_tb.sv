`timescale 1ns / 1ns
module readFeatures_tb
import definitions_pkg::*;
();

logic clock, resetN;
 logic pread_busValid, pread_isFeature;
 logic isReadingFeatures, isLoadingFroze;
 logic isLoadingNextFeatures;
 seq_t pread_seqNum, reqSeqF;
 width_t writeWidth;

 logic new_params;
 mem_bus_addr_t readPos;
 input_addr_t volumeSize;

 input_addr_t usedWords;
 s_feature_t [MAX_READ_WIDTH - 1: 0] dataBus;
 logic setLoadingFroze, resetLoadingFroze;
 logic resetLoadingNextFeatures, resetReadingFeatures;
 logic wen;
 logic unsigned [13:0]addrOut;
 s_feature_t   [INPUT_MEM_WIDTH - 1 : 0] dataOut;
 

readFeatures_ports ports(.*);
readFeatures_top top(ports);

ReadFeatures readfeatures(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

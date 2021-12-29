`timescale 1ns / 1ns
module assembleInput_tb
import definitions_pkg::*;
();

logic clock, resetN;
 logic doAssemble;
 logic buffer_full;
 logic inputs_buffer_empty;
 width_t readWidth;
 s_feature_t [INPUT_MEM_WIDTH - 1 : 0] data_input;
 loc_frame_t prefetchFrameSize;

 logic new_param, reset_param;
 input_addr_t new_addrNextFrame;
 input_addr_t curVolumeSize;
 width1_t maxRowCount;
 width_t lastLen;

 logic buffer_wen;
 s_feature_t [INPUT_MEM_WIDTH - 1 : 0] buffer_data;
 logic ren;
 logic resetAssemble;
 

assembleInput_ports ports(.*);
assembleInput_top top(ports);

AssembleInput assembleInput(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

`timescale 1ns / 1ns
module buildInputFifo_tb
import definitions_pkg::*;
();

logic clock, resetN;
 HCB_STATE state;
 layer_addr_t readCLast;
`ifdef S2_OPTIMIZE	
 logic isStride2;
 s_row_addr_t new_nextRowStart;
 k_t new_kIter;
//s2_buffer
 logic [3:0] s2b_a;
 s_feature_t [INPUT_MEM_WIDTH - 1 : 0] s2b_data_out;
 logic s2b_we;
 s_feature_t [INPUT_MEM_WIDTH - 1 : 0] s2b_data;
`endif
 width_t outputBufH1;
 pad_t downPad, topPad;
 k_t k;
 pad_t stride;
 s_row_addr_t rowNum;

 logic reset_params; //prefetching
 logic new_params, reset_iLayers;
 s_row_addr_t new_rowAddr;

//assemble_buffer
 logic ab_rd_en;
 s_feature_t [INPUT_MEM_WIDTH - 1 : 0] ab_data;  
 //s_feature_t  ab_data[INPUT_MEM_WIDTH]; 
 logic ab_empty;

//input_fifo
 logic input_wr_en;
s_feature_t [INPUT_MEM_WIDTH - 1 : 0] input_data_out;
 //s_feature_t  input_data_out[INPUT_MEM_WIDTH];
 logic input_full;
 

buildInputFifo_ports ports(.*);
buildInputFifo_top top(ports);

BuildInputFifo buildInputFifo(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 05:53:43
// Design Name: 
// Module Name: weightFifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module AssembleInputBuffer
import definitions_pkg::*;
(
input logic clock, resetN,
input logic isLoadingNextFeatures, isReadingFeatures,
input logic doAssemble,
input logic inputs_buffer_progfull,
input logic unsigned [INPUT_ADDR_WIDTH - 1 :0]nextWritePos, // connect to  readFeatures.addr,
input s_feature_t [INPUT_MEM_WIDTH - 1 : 0] data_input,
input logic inputs_wen,

input logic new_param, reset_param,
input input_addr_t curVolumeSize,

output logic inputs_buffer_wen,
output s_feature_t [INPUT_MEM_WIDTH - 1 : 0] buffer_data,
output logic inputs_ren,
output logic unsigned [INPUT_ADDR_WIDTH - 1 :0]addrOut
);
    logic input_requested;
	logic unsigned [INPUT_ADDR_WIDTH - 1 :0] addrNextAssemble, addrNextAssemble_next;
	
	assign inputs_ren = doAssemble && !inputs_wen && ~inputs_buffer_progfull && addrNextAssemble_next * INPUT_MEM_WIDTH < curVolumeSize
        && ~ (~isLoadingNextFeatures && isReadingFeatures && addrNextAssemble_next >= nextWritePos);
	assign addrOut = addrNextAssemble_next;
    assign inputs_buffer_wen = input_requested;
    assign buffer_data = data_input;
	
	always_ff @(posedge clock)
      if (!resetN)
        {addrNextAssemble, input_requested} <= '0;
      else if(new_param || reset_param)
      begin
        {addrNextAssemble, input_requested} <= '0;
      end
      else
        {addrNextAssemble, input_requested} <= {addrNextAssemble_next, inputs_ren};
    
    always_comb
    begin
        addrNextAssemble_next = addrNextAssemble;
        if(input_requested & doAssemble)
            addrNextAssemble_next = addrNextAssemble + 1;
    end
    
   
endmodule

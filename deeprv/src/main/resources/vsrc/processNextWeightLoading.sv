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

module ProcessNextWeightLoading
import definitions_pkg::*;
(
input logic enable,
input logic isReadingWeights,
input logic pibw_empty,
input InstructionHCBWt inst,

output logic fifo_en,
output logic new_params,
output weight_addr_t new_nextWeightRead,
output weight_addr_t new_endWeightRead,
output mem_bus_addr_t new_weightReadPos,
output seq_t new_reqSeqW
);
   
    assign fifo_en = enable && ~isReadingWeights && ~pibw_empty;
    assign new_params = fifo_en;
    
    assign new_nextWeightRead = inst.Waddr;
	assign new_endWeightRead = inst.WEnd;
	assign new_weightReadPos = inst.weightPos;
	assign new_reqSeqW = inst.seqNum;
endmodule
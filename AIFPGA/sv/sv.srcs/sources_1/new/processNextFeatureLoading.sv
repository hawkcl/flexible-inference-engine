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

module ProcessNextFeatureLoading
import definitions_pkg::*;
(
input logic enable,
input logic isLoadingNextFeatures, hasNextFeatureParams,
input logic pib_empty,
input logic 		pwrite_isFetchNextInst,
input InstructionHCB inst,

output logic new_params_prefetch,
output mem_bus_addr_t new_readPos,
output width_t new_writeWidth,
output input_addr_t new_volumeSize,
output seq_t new_reqSeqF
);
   
    width_t rw;
	
    assign new_params_prefetch = (enable && isLoadingNextFeatures && ~hasNextFeatureParams && ~pwrite_isFetchNextInst && ~pib_empty) ? inst.itype == CONV : 1'b0;
    assign new_readPos = inst.ReadPos;
    assign new_writeWidth = rw;
    assign new_volumeSize = inst.volumeSize;
    assign new_reqSeqF = inst.seqNum;
    
    always_comb
    begin
        rw = inst.W1;
		if (inst.lPad > 0)
		begin
			if (inst.X > 0)
			begin
				rw = rw + inst.lPad;
			end
		end
		if (inst.rPad > 0)
			if (inst.X + inst.W1 != inst.W)
				rw = rw + inst.rPad;
		
	end
    
endmodule

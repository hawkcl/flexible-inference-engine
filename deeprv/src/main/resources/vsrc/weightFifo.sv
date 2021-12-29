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
module SendWeights
import definitions_pkg::*;
(
input logic clock, resetN,
input logic enSendWeights,
input logic enSendBMWeights,
input weight_bus_size_t len,
input weight_bus_size_t bm_len,
input logic clearNumBuf,
input logic  empty_fifo,
input logic  is_cycle_froze,
input s_weight_t [WEIGHT_BUFFER_SIZE-1:0] dataFifo,
output logic ren_fifo,
output s_weight_t weightsBus[WEIGHT_BUS_SIZE],
output logic bm_enough_data,
output logic enough_data
);
    weight_bus_size_t size; // TODO : split size into bm and weights
    s_weight_t buffer[WEIGHT_BUFFER_SIZE];
    logic unsigned [4:0] numBuf, numBuf_next;
    logic ren_fifo0;
	
    assign size = enSendWeights?len:(enSendBMWeights ? (bm_len * BM_SIZE):0);
	assign enough_data = ((~empty_fifo) || (numBuf >= len));
	assign bm_enough_data = ((~empty_fifo) || (numBuf >= (bm_len *BM_SIZE)));
    //assign ren_fifo = (enSendWeights | enSendBMWeights) && (numBuf < size);
    assign ren_fifo0 = (enSendBMWeights && (numBuf < bm_len * BM_SIZE))
                        | (enSendWeights && (numBuf < len));
    assign ren_fifo =  resetN ? ren_fifo0 : 0;
    
    always_ff @(posedge clock)
      if (!resetN || clearNumBuf)
        numBuf <= '0;
      else
        numBuf <= numBuf_next;
      
    always_comb
    begin
        if(enSendWeights | enSendBMWeights)
            if(ren_fifo)
                numBuf_next = numBuf + WEIGHT_BUFFER_SIZE - size;
            else
                numBuf_next = numBuf - size;
        else
            numBuf_next = numBuf;
    end
    
    //always_comb
    always_ff @(posedge clock)
    begin
        for(int i = 0; i < WEIGHT_BUS_SIZE; i++)
        if(!is_cycle_froze) begin
            if(ren_fifo)
                if(i < numBuf)
                    weightsBus[i] = buffer[i];
                else
                    weightsBus[i] = dataFifo[i - numBuf];
            else
                weightsBus[i] = buffer[i];
        end
    end
    
    always_ff @(posedge clock)
    begin
        for(int i = 0; i < WEIGHT_BUFFER_SIZE; i++)
            if(ren_fifo)
                if(size - numBuf + i < WEIGHT_BUFFER_SIZE) // TODO:check overflow
                    buffer[i] <= dataFifo[size - numBuf + i];
                else
                    buffer[i] <= '0;
            else
                if(i + size < WEIGHT_BUFFER_SIZE)
                    buffer[i] <= buffer[i + size];
                else
                    buffer[i] <= '0;
    end
endmodule

module ReadWeights
import definitions_pkg::*;
(
input logic clock, resetN,
input logic enable, pcweight_busValid,
input seq_t pcweight_seq,
input logic new_params,
input mem_bus_addr_t new_weightReadPos,
input weight_addr_t new_nextWeightRead,
input weight_addr_t new_endWeightRead,
input seq_t new_reqSeqW,
input s_weight_t  w_bus[WEIGHT_MEM_BUS_SIZE],
//output logic weightReadDone,
output logic writeFifo,
output s_weight_t [WEIGHT_BUFFER_SIZE-1:0] dataFifo,
output logic isReadingWeights,
output seq_t reqSeqW
);
    logic weightReadDone;
    mem_bus_addr_t weightReadPos;
	weight_addr_t nextWeightRead;
	weight_addr_t endWeightRead;
	logic isReadingWeights0, isReadingWeights_next;
    weight_addr_t nextWeightRead_next;
	//seq_t reqSeqW;
	logic doReading;
	
	assign isReadingWeights = isReadingWeights0;
	assign doReading = enable && isReadingWeights0 && pcweight_seq == reqSeqW && pcweight_busValid;
	assign weightReadDone = (nextWeightRead + WEIGHT_DATA_WIDTH >= endWeightRead) && doReading;
	assign writeFifo = doReading;
	
	always_ff @(posedge clock)
      if (!resetN)
          reqSeqW <= '0;
      else if(new_params)
          reqSeqW <= new_reqSeqW;
          
	always_comb
	begin
        for (int i = 0; i < WEIGHT_DATA_WIDTH; i++)
			dataFifo[i] = w_bus[weightReadPos + i];
	end
    
	always_ff @(posedge clock)
      if (!resetN)
        {weightReadPos, nextWeightRead, endWeightRead, isReadingWeights0} <= '0;
      else if(new_params)
      begin
        {weightReadPos, nextWeightRead, endWeightRead} <= {new_weightReadPos, new_nextWeightRead, new_endWeightRead};
        isReadingWeights0 <= 1;
      end
      else
      begin
        {nextWeightRead, isReadingWeights0} <= {nextWeightRead_next, isReadingWeights_next};
      end
        
        
    always_comb
        if(weightReadDone)
            isReadingWeights_next = 0;
        else
            isReadingWeights_next = isReadingWeights0;

    always_comb begin
        nextWeightRead_next = nextWeightRead + (doReading?WEIGHT_DATA_WIDTH:0);
    end        
endmodule

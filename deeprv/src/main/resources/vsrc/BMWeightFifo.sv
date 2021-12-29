//`timescale 1ns / 1ps
`timescale 1ns / 1ns
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
module SendBMWeights
import definitions_pkg::*;
(
input logic clock, resetN,
input logic enSendBMWeights,
input weight_bus_size_t len,
input logic  empty_fifo,
input logic clearNumBuf,
input s_weight_t [BM_READ_WIDTH-1:0] dataFifo,
output logic ren_fifo,
output s_weight_t bmWeightBus[WEIGHT_BUS_SIZE],
output logic enough_data
);
    weight_bus_size_t size;
    s_weight_t buffer[BM_READ_WIDTH];
    logic unsigned [4:0] numBuf, numBuf_next;
	
	assign size = enSendBMWeights ? (len * BM_SIZE):0;
	//assign size = (len << 1);
	assign enough_data = ((~empty_fifo) || (numBuf >= (len *BM_SIZE)));
    assign ren_fifo = resetN ? (enSendBMWeights && (numBuf < size)) : 0;
    
    always_ff @(posedge clock)
      if (!resetN || clearNumBuf)
        numBuf <= '0;
      else
        numBuf <= numBuf_next;
      
    always_comb
    begin
        if(enSendBMWeights)
            if(ren_fifo)
                numBuf_next = numBuf + BM_READ_WIDTH - size;
            else
                numBuf_next = numBuf - size;
        else
            numBuf_next = numBuf;
    end
    
    //always_comb
    always_ff @(posedge clock)
    begin
        for(int i = 0; i < WEIGHT_BUS_SIZE; i++)
            if(ren_fifo)
                if(i < numBuf)
                    bmWeightBus[i] <= buffer[i];
                else
                    bmWeightBus[i] <= dataFifo[i - numBuf];
            else
                bmWeightBus[i] <= buffer[i];
    end
    
    always_ff @(posedge clock)
    begin
        for(int i = 0; i < BM_READ_WIDTH; i++)
            if(ren_fifo)
                if(size - numBuf + i < BM_READ_WIDTH)
                    buffer[i] <= dataFifo[size - numBuf + i];
                else
                    buffer[i] <= '0;
            else
                if(i + size < BM_READ_WIDTH)
                    buffer[i] <= buffer[i + size];
                else
                    buffer[i] <= '0;
    end
endmodule
/*
module ReadBMWeights
import definitions_pkg::*;
(
input logic clock, resetN,
input logic pread_busValid, pread_isFeature,
input ReturnData_t data,
input logic unsigned [7 : 0] curSeq,
input token_t token,
input logic clearReceivedBM, //new_bm_params from ProcessInstruction
output logic resetRequestingBM,
output logic writeFifo,
output bm_size_t receivedBM,
output s_feature_t [BM_READ_WIDTH-1:0] dataFifo

);    
    bm_size_t received;
    assign writeFifo = resetN ? (pread_busValid && ~pread_isFeature && data.dtype == TYPE_BM && data.token == token && data.seq == curSeq) : 0;
    assign resetRequestingBM = writeFifo;
    //assign dataFifo = data.data;
    always_comb
        for(int i = 0; i < BM_READ_WIDTH; i++)
        if(writeFifo)
	        dataFifo[i] = data.data[i];
        else
	        dataFifo[i] = '0;
    assign receivedBM = received;
    always_ff @(posedge clock)
      if (~resetN || clearReceivedBM)
        received <= '0;
      else if(writeFifo)
        received <= received + data.len;
endmodule
*/

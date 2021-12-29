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


module ReceiveResData
import definitions_pkg::*;
(
input logic clock, resetN,
input logic pread_busValid, pread_isFeature,
input ReturnData_t data,
input logic unsigned [7 : 0] curSeq,
input token_t token,
input width_t outputBufW1,
input DATA_MODE mode,
input mem_bus_addr_t resPos,
//input clearReceivedRes, //new_conv_inst
output logic resetRequestingRes,
output logic writeFifo,
output res_size_t receivedRes,
output s_feature_t [COMPUTING_GROUP_SIZE-1:0] dataFifo
);    
    res_size_t received, received_next;
    logic new_data;
    bank_num_t idxRes, idxRes_next;
    bank_num_t idxResMax, idxResMax_next;
    width_t readPos, readPos_next;
    s_feature_t [COMPUTING_GROUP_SIZE * 3 - 1 : 0]resReceiveBuf;
    mem_bus_addr_t start;
    
    assign start = (mode == MODE_FOUR) ? outputBufW1 : (({1'b0,outputBufW1} << 1) + resPos);
    assign receivedRes = received;
    assign new_data = pread_busValid && ~pread_isFeature && data.dtype == TYPE_RES && data.token == token && data.seq == curSeq;
    assign writeFifo = new_data && (idxRes != 0);
    assign resetRequestingRes = writeFifo;
    always_ff @(posedge clock)
      if (~resetN)
        {received, idxRes, readPos, idxResMax} <= '0;
      else 
        {received, idxRes, readPos, idxResMax} <= {received_next, idxRes_next, readPos_next, idxResMax_next};
        
    always_ff @(posedge clock)
    begin
        if(new_data && (mode == MODE_FOUR || (mode == MODE_TWO && data.len == outputBufW1 << 2)))
        begin
            for(int i = 0; i < COMPUTING_GROUP_SIZE * 3; i++)
                if(i + start < WEIGHT_MEM_BUS_SIZE)
                    resReceiveBuf[i] <= data.data[i + start]; //TODO : improve
                else
                    resReceiveBuf[i] <= '0;
        end
    end
    
    always_comb
    begin
	    if(idxRes != 0)
            for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
                //dataFifo[i] = resReceiveBuf[outputBufW1 * (idxRes - 1) + i];  //TODO : improve
                dataFifo[i] = resReceiveBuf[readPos + i]; 
	    else
		    for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
                dataFifo[i] = data.data[i];
    end

    always_comb
    begin
	    if(writeFifo)
		    received_next = received + outputBufW1;
	    else
		    received_next = received;
    end
    
    always_comb
    begin
        idxResMax_next = idxResMax;
        if(idxRes != 0)
        begin
            if (mode == MODE_TWO || idxRes == idxResMax) begin
                    idxRes_next = 0;
                    readPos_next = 0;
            end else begin
                    idxRes_next = idxRes + 1;
                    readPos_next = readPos + outputBufW1;
            end
        end
        else if(new_data && ((mode == MODE_TWO && data.len>>2 == outputBufW1))) begin
            idxRes_next = 1;
            readPos_next = 0;
        end
        else if(new_data && (mode == MODE_FOUR )) begin
            if(data.len > outputBufW1) begin
                if((data.len>>1) == outputBufW1)
                    idxResMax_next = 1;
                else if((data.len>>2) == outputBufW1)
                    idxResMax_next = 3;
                else
                    idxResMax_next = 2;
                idxRes_next = 1;
            end
            else
                idxRes_next = 0;
            readPos_next = 0;
        end
        else begin
            idxRes_next = 0;
            readPos_next = 0;
        end
    end
endmodule

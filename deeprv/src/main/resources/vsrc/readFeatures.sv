//`timescale 1ns / 1ps
//`default_nettype none
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
module ReadFeatures
import definitions_pkg::*;
(
input logic clock, resetN,
input logic pread_busValid, pread_isFeature,
input logic isReadingFeatures, isLoadingFroze,
input logic isLoadingNextFeatures,
input seq_t pread_seqNum, reqSeqF,
input width_t writeWidth,

input logic new_params,
input mem_bus_addr_t readPos,
input input_addr_t volumeSize,

input input_addr_t usedWords,
input s_feature_t [MAX_READ_WIDTH-1:0] dataBus,
//input s_feature_t  dataBus[MAX_READ_WIDTH],
output logic setLoadingFroze, resetLoadingFroze,
output logic resetLoadingNextFeatures, resetReadingFeatures,
output logic wen,
output logic unsigned [INPUT_ADDR_WIDTH - 1 :0]addrOut,
output s_feature_t [INPUT_MEM_WIDTH - 1 : 0] dataOut
);
    input_addr_t nextWritePos, nextWritePos_next;
    logic unsigned [4:0] ibSize, ibSize_next;
    logic unsigned [INPUT_ADDR_WIDTH - 1 :0]addr;
    logic unsigned [INPUT_ADDR_WIDTH - 1 :0]addr_next;
    s_feature_t input_buffer[INPUT_MEM_WIDTH];
    s_feature_t [INPUT_MEM_WIDTH - 1 : 0] data;
    logic enable, enable_old;
    logic setFroze, resetFroze;
    logic ibfull, readDone;
    logic lwen;
    mem_bus_addr_t readStart, bufPos;
    
    assign wen = lwen;
    assign readDone = (~ibfull) && ((nextWritePos + ibSize + writeWidth) >= volumeSize);
    assign setLoadingFroze = setFroze;
    assign resetLoadingFroze = resetFroze;
    assign ibfull = (ibSize + writeWidth) >= INPUT_MEM_WIDTH;
    assign enable_old = isReadingFeatures && (~pread_busValid || ~pread_isFeature) && (nextWritePos + ibSize>= volumeSize);
    assign enable = isReadingFeatures && pread_busValid && pread_isFeature && pread_seqNum == reqSeqF;
    assign addrOut = addr;
    assign dataOut = data;
    //assign nextWritePos_o = nextWritePos;
    
	always_ff @(posedge clock)
      if (!resetN)
        {nextWritePos, ibSize, addr} <= '0;
      else if(new_params)
      begin
        {nextWritePos, ibSize, addr} <= '0;
      end
      else
        {nextWritePos, ibSize, addr} <= {nextWritePos_next, ibSize_next, addr_next};
    
    always_ff @(posedge clock)
    begin
        if(enable && ~readDone)
            for(int i = 0; i < INPUT_MEM_WIDTH; i++)
                if(i < bufPos)
                    input_buffer[i] <= input_buffer[i];
                else if(readStart + i - bufPos < MAX_READ_WIDTH)
                    input_buffer[i] <= dataBus[readStart + i - bufPos];
                else
                    input_buffer[i] <= input_buffer[i]; 
    end 
    //input_buffer.SetValue(pread->dataBus + readPos.GetValue() + INPUT_MEM_WIDTH - ibSize.GetValue(), 0, ibSize.GetNextValue());
    //input_buffer.SetValue(pread->dataBus + readPos.GetValue(), ibSize.GetValue(), writeWidth.GetValue());
    always_comb
    begin
        if(enable && ibfull)
        begin
            readStart = readPos + INPUT_MEM_WIDTH - ibSize;
            bufPos = 0;
        end
        else begin
            readStart = readPos;
            bufPos = ibSize;
        end
    end
    
    always_comb
    begin
        if(enable && (ibfull || readDone))
        /*begin
            for(int i = 0; i < INPUT_MEM_WIDTH; i++)
			     if(i < ibSize)
    			     data[i] = input_buffer[i];
    			 else
    			     data[i] = dataBus[readPos + i - ibSize];
        end
        else if(enable && readDone)*/
        begin
			for(int i = 0; i < INPUT_MEM_WIDTH; i++)
			     if(i < ibSize)
    			     data[i] = input_buffer[i];
    			 else if(readPos + i - ibSize < MAX_READ_WIDTH)
    			     data[i] = dataBus[readPos + i - ibSize];
    			 else
    			     data[i] = input_buffer[i];
        end
        else begin
			for(int i = 0; i < INPUT_MEM_WIDTH; i++)
			     data[i] = input_buffer[i];
        end
    end
    
    always_comb
    begin
        ibSize_next = ibSize;
        nextWritePos_next = nextWritePos;
        addr_next = addr;
        lwen = '0;
        if(enable_old)
        begin
            nextWritePos_next = nextWritePos + INPUT_MEM_WIDTH;
			ibSize_next = 0;
			addr_next = addr + 1;
			lwen = '1;
        end
        else if(enable)
            if (ibfull)
            begin
                nextWritePos_next = nextWritePos + INPUT_MEM_WIDTH;
                addr_next = addr + 1;
                ibSize_next = ibSize + writeWidth - INPUT_MEM_WIDTH;
                lwen = '1;
            end
            else if (readDone)
            begin
                nextWritePos_next = nextWritePos + INPUT_MEM_WIDTH;
                addr_next = addr + 1;
                ibSize_next = 0;
                lwen = '1;
            end
            else
                ibSize_next = ibSize + writeWidth;
        begin
        end
    end
 
    always_comb
    begin
        resetLoadingNextFeatures = '0;
        resetReadingFeatures = '0;
        if ((enable || enable_old) && nextWritePos_next >= volumeSize)
        begin
            resetReadingFeatures = 1;
            if (isLoadingNextFeatures)
                resetLoadingNextFeatures = 1;
		end
    end
    
    always_comb
    begin 
        setFroze = '0;
        resetFroze = '0;
        if(enable)
        begin
            if (isLoadingNextFeatures && nextWritePos_next + INPUT_MEM_WIDTH >= usedWords)
                setFroze = '1;
            else
    			resetFroze = '1;
        end
        else begin
            if (isReadingFeatures && isLoadingFroze &&
		          ~(isLoadingNextFeatures && nextWritePos + INPUT_MEM_WIDTH >= usedWords))
			     resetFroze = '1;
        end
    end    
endmodule

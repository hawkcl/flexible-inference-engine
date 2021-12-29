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
module AssembleInput
import definitions_pkg::*;
(
input logic clock, resetN,
input logic doAssemble,
input logic buffer_full,
input logic inputs_buffer_empty,
input width_t readWidth,
input s_feature_t [INPUT_MEM_WIDTH - 1 : 0] data_input,
input loc_frame_t prefetchFrameSize,

input logic new_param, reset_param,
input input_addr_t new_addrNextFrame,
input input_addr_t curVolumeSize,
input width1_t maxRowCount,
input width_t lastLen,

output logic buffer_wen,
output s_feature_t [INPUT_MEM_WIDTH - 1 : 0] buffer_data,
output logic ren,
output logic resetAssemble
);
    width_t atmpSize, atmpSize_next; //5 bit of width_t, atmpSize upto 29
    width1_t curRowCount, curRowCount_next;
	input_addr_t addrNextFrame, addrNextFrame_next;
	input_addr_t addrCurAssemble, addrCurAssemble_next;
	s_feature_t assemble_tmp[INPUT_MEM_WIDTH];
	s_feature_t assemble_tmp_next[INPUT_MEM_WIDTH];
	s_feature_t [INPUT_MEM_WIDTH - 1 : 0] data;
	logic enable, enable_loc, enable_input;
	logic lastRow, lastRow2;
	width_t len;
	
	assign buffer_data = data;
	assign enable = doAssemble && ~buffer_full;
	assign enable_loc = enable && ((atmpSize >= readWidth) || lastRow);
	assign enable_input = enable && ~enable_loc && ~inputs_buffer_empty;
	assign lastRow = (curRowCount == maxRowCount) && (atmpSize >= lastLen);
	assign lastRow2 = (curRowCount == maxRowCount);
	assign resetAssemble = enable && (addrCurAssemble_next >= curVolumeSize);
	assign ren = enable_input;
	assign buffer_wen = enable_loc || enable_input;
	
	always_ff @(posedge clock)
      if (!resetN)
         curRowCount <= '0;
      else
         curRowCount <= curRowCount_next;
         
	always_ff @(posedge clock)
	   assemble_tmp <= assemble_tmp_next;
	always_ff @(posedge clock)
      if (!resetN)
        {addrNextFrame, addrCurAssemble, atmpSize} <= '0;
      else if(new_param)
      begin
        {addrNextFrame} <= {new_addrNextFrame};
        {addrCurAssemble, atmpSize} <= '0;
      end
      else if(reset_param)
      begin
        addrNextFrame <= prefetchFrameSize;
        {addrCurAssemble, atmpSize} <=  '0;
      end
      else
        {addrNextFrame, addrCurAssemble, atmpSize} <= {addrNextFrame_next, addrCurAssemble_next, atmpSize_next};
    
    always_comb
    begin
        if(enable_input)
            for(int i = 0; i < INPUT_MEM_WIDTH; i++)
                if(i < atmpSize)
                    data[i] = assemble_tmp[i];
                else
                    data[i] = data_input[i - atmpSize];
        else
            for (int i = 0; i < INPUT_MEM_WIDTH; i++)
			    data[i] = assemble_tmp[i];
    end
    
    always_comb
    begin
        
        if(enable_loc)
            for(int i = 0; i < INPUT_MEM_WIDTH; i++)
                if(i + len < INPUT_MEM_WIDTH)
                    assemble_tmp_next[i] = assemble_tmp[i + len];
                else
                    assemble_tmp_next[i] = '0;
        else if(enable_input)
            for(int i = 0; i < INPUT_MEM_WIDTH; i++)
                if(i + len - atmpSize < INPUT_MEM_WIDTH)
                    assemble_tmp_next[i] = data_input[i + len - atmpSize];
                else
                    assemble_tmp_next[i] = '0;
        else
            assemble_tmp_next = assemble_tmp;
    end
  
    always_comb
        if(enable_loc)
            len = lastRow ? lastLen : readWidth;
        else
            len = lastRow2 ? lastLen : readWidth;
            
    always_comb
    begin
        {addrCurAssemble_next, atmpSize_next} = {addrCurAssemble, atmpSize};
        curRowCount_next = curRowCount;
        if(enable_loc)
        begin
            addrCurAssemble_next = addrCurAssemble + len;
		    atmpSize_next = atmpSize - len;
		    if (lastRow)
                curRowCount_next = 0;
            else
                curRowCount_next = curRowCount + 1;
        end
        else if(enable_input)
        begin
            atmpSize_next = INPUT_MEM_WIDTH + atmpSize - len;
            addrCurAssemble_next = addrCurAssemble + len;
            if (lastRow2)
                curRowCount_next = 0;
            else
                curRowCount_next = curRowCount + 1;
        end
    end
    
    always_comb 
        if (enable && addrCurAssemble_next >= addrNextFrame)
    		addrNextFrame_next = addrNextFrame + prefetchFrameSize;
        else
            addrNextFrame_next = addrNextFrame;
endmodule

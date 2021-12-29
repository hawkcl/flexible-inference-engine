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
module SetupShiftInputs
import definitions_pkg::*;
(
input logic clock, resetN,
input INPUT_SOURCE input_src,
input k_t k,
input s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE],
output s_feature_t shiftInputs[MAX_K]
);
    s_feature_t shiftBuf[MAX_K][MAX_SHIFT_SIZE];
    s_feature_t shiftBufShift[MAX_K][MAX_SHIFT_SIZE];
    
    always_comb
	   for (int i = 0; i < MAX_K; i++)
	       shiftInputs[i] = shiftBuf[i][0];
	
	always_ff @(posedge clock)
	begin
        if(~resetN)
        begin
           for (int i = 0; i < MAX_K; i++)
                for (int j = 0; j < MAX_SHIFT_SIZE; j++)
                begin
                   shiftBuf[i][j] <= '{default:0};
                   shiftBufShift[i][j] <= '{default:0};
                end
        end
        else
        if (input_src == INPUT_BACKUP)
        begin
            for (int i = 0; i < MAX_K; i++)
                for (int j = 0; j < MAX_SHIFT_SIZE; j++)
                begin
                    shiftBuf[i][j] <= shiftBufBackup[i][j];
                    shiftBufShift[i][j] <= shiftBufBackup[i][j];
                end
        end
        else if (input_src == INPUT_S)
        begin
            for (int i = 0; i < MAX_K - 1; i++)
                for (int j = 0; j < MAX_SHIFT_SIZE; j++)
                begin
                    if(i == k - 1)
                    begin
                        shiftBuf[i][j] <= shiftBufBackup[i][j];
                        shiftBufShift[i][j] <= shiftBufBackup[i][j];
                    end
                    else
                    begin
                        shiftBuf[i][j] <= shiftBufShift[i + 1][j];
                        shiftBufShift[i][j] <= shiftBufShift[i + 1][j];
                    end
                end
        end
        else if (input_src == INPUT_E)
        begin
            for (int i = 0; i < MAX_K; i++)
                for (int j = 0; j < MAX_SHIFT_SIZE - 1; j++)
                    shiftBuf[i][j] <= shiftBuf[i][j + 1]; 
        end
	end
	
endmodule

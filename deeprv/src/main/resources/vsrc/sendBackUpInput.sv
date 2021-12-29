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
module SendBackUpInput
import definitions_pkg::*;
(
input logic clock, resetN,
input logic sendBackUpInput_valid,
input k_t backupId,
input s_feature_t [INPUT_MEM_WIDTH-1:0] fifo_data,
input logic fifo_empty,
`ifdef S2_OPTIMIZE
input logic isStride2,
`endif
input width_t readWidth,
input pad_t leftPad,

output logic rd_en,
output s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE],
`ifdef S2_OPTIMIZE  
output s_feature_t backupBus[COMPUTING_GROUP_SIZE*2],
`else
output s_feature_t backupBus[COMPUTING_GROUP_SIZE],
`endif
output logic isBackupValid
);
    width_t arraySize;
    width_t len, limit;
    s_feature_t shiftBackup[MAX_K][MAX_SHIFT_SIZE];
    s_feature_t backup[COMPUTING_GROUP_SIZE];
	logic fit;
	
	assign isBackupValid = (sendBackUpInput_valid && ~fifo_empty);
	assign shiftBufBackup = shiftBackup;	
	assign backupBus = backup;	
	assign rd_en = isBackupValid;
	assign fit = (readWidth + leftPad) <= arraySize; 
	assign len = fit ? (readWidth + leftPad) : arraySize;
	assign limit = fit ? 0 :(readWidth + leftPad - arraySize);
	
	always_comb
	begin
`ifdef S2_OPTIMIZE	
	        if(isStride2)
                arraySize = 2 * COMPUTING_GROUP_SIZE;
            else
`endif            
                arraySize = COMPUTING_GROUP_SIZE;
	end

    always_comb
    begin
        for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
            if (i < len && i >= leftPad)
                backup[i] = fifo_data[i - leftPad];
            else 
                backup[i] = '0;
    end    
    
	
	always_ff @(posedge clock)
	begin
	if(~resetN)
	   for(int j = 0; j < MAX_K; j++)
            for (int i = 0; i < MAX_SHIFT_SIZE; i++)
               shiftBackup[j][i] <= '{default:0};
	else if(isBackupValid)
        for(int j = 0; j < MAX_K; j++)
            for (int i = 0; i < MAX_SHIFT_SIZE; i++)
                if(j == backupId)
                begin
                    if (i < limit)
                        shiftBackup[j][i] <= fifo_data[i + arraySize - leftPad];
                    else
                        shiftBackup[j][i] <= 0;
                end
                else
                    shiftBackup[j][i] <= shiftBackup[j][i]; 
    end
    
endmodule

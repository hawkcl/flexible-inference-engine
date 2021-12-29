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

module PushHCBInst
import definitions_pkg::*;
(
input logic enable,
input InstructionHCB inst_in,

output logic wen,
output InstructionHCB inst_h,
output InstructionHCBWt inst2
);
    assign wen = enable;
    assign inst_h = inst_in;
    assign inst2.seqNum = inst_in.seqNum;
	assign inst2.itype = inst_in.itype;
	assign inst2.Waddr = inst_in.Waddr;
	assign inst2.weightPos = inst_in.weightPos;
	assign inst2.WEnd = inst_in.WEnd;
endmodule
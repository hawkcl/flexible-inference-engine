//`timescale 1ns / 1ps
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/13 03:18:27
// Design Name: 
// Module Name: UCL
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


module Token
import definitions_pkg::*;
(
input logic         clock, resetN,
input logic         token_set,
input  token_t 		max_token,
output token_t      token
);
token_t     maxToken;
always_ff @(posedge clock)
    if (!resetN)
        token <= '0;
    else if(token_set)
        token <= '0;
    else if(token == maxToken)
        token <= '0;
    else
        token <= token + 1;
        
	
always_ff @(posedge clock)
    if (!resetN)
        maxToken <= '0;
    else if(token_set)
        maxToken <= max_token;
	
endmodule

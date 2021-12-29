`timescale 1ns / 1ns
module token_tb
import definitions_pkg::*;
();

logic           clock, resetN;
logic           token_set;
token_t 		max_token;
token_t         token;
 

Token tkn(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
  resetN = 0;
  token_set = 0;
  #20 resetN = 1;
  #100 token_set = 1;
  max_token = 3;
  #15 token_set = 0;
  #105 token_set = 1;
  max_token = 1;
  #15 token_set = 0;
  #105 token_set = 1;
  max_token = 0;
  #15 token_set = 0;
  #105 token_set = 1;
  max_token = 3;
  #15 token_set = 0;
end

always #10 clock  = ~clock;

endmodule

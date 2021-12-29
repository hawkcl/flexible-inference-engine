`timescale 1ns / 1ns
module shiftinput_tb
import definitions_pkg::*;
();

logic clock, resetN;
INPUT_SOURCE input_src;
k_t k;
s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE];
s_feature_t shiftInputs[MAX_K];
 

shiftinput_ports ports(.*);
shiftinput_top top(ports);

SetupShiftInputs shiftinput(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

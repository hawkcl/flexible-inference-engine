
module inputs_mem
import definitions_pkg::*;
(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb);
  parameter INPUT_WIDTH = INPUT_MEM_WIDTH * FEATURE_BIT_SIZE;
  input clka;
  input ena;
  input [0:0]wea;
  input [INPUT_ADDR_WIDTH - 1:0]addra;
  input [INPUT_WIDTH - 1:0]dina;
  input clkb;
  input enb;
  input [INPUT_ADDR_WIDTH - 1:0]addrb;
  output [INPUT_WIDTH - 1:0]doutb;
  logic [INPUT_WIDTH - 1:0]doutram;


  //assign doutb = enb ? doutram : 'x;
  assign doutb = doutram;

   ram_dp_sr_sw1 #(.DATA_WIDTH(INPUT_WIDTH), .ADDR_WIDTH(INPUT_ADDR_WIDTH), .RAM_DEPTH(INPUT_MEM_DEPTH)) ram (
.clk(clka)       , // Clock Input
.address_0(addra) , // address_0 Input
.data_0(dina)    , // data_0 bi-directional
.we_0(wea)      , // Write Enable/Read Enable
.address_1(addrb) , // address_1 Input
.oe_1(enb),
.data_1(doutram)     // data_1 bi-directional
); 
endmodule


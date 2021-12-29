
module ctrlweight_mem
import definitions_pkg::*;
(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb);
/* synthesis syn_black_box */
parameter WEIGHT_ADDR_WIDTH = $clog2(WEIGHT_BRAM_DEPTH);
  input clka;
  input ena;
  input [0:0]wea;
  input [WEIGHT_ADDR_WIDTH - 1:0]addra;
  input [WEIGHT_BRAM_WIDTH - 1:0]dina;
  input clkb;
  input enb;
  input [WEIGHT_ADDR_WIDTH - 1:0]addrb;
  output [WEIGHT_BRAM_WIDTH - 1:0]doutb;
  logic [WEIGHT_BRAM_WIDTH - 1:0]doutram;


  //assign doutb = enb ? doutram : 'x;
  assign doutb = doutram;

   ram_dp_sr_sw1 #(.DATA_WIDTH(WEIGHT_BRAM_WIDTH), .ADDR_WIDTH(WEIGHT_ADDR_WIDTH), .RAM_DEPTH(WEIGHT_BRAM_DEPTH)) ram (
.clk(clka)       , // Clock Input
.address_0(addra) , // address_0 Input
.data_0(dina)    , // data_0 bi-directional
.we_0(wea)      , // Write Enable/Read Enable
.address_1(addrb) , // address_1 Input
.oe_1(enb),
.data_1(doutram)     // data_1 bi-directional
); 
endmodule

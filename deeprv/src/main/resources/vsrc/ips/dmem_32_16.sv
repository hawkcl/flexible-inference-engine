
`timescale 1ns / 1ns

module dmem_32_16(a, d, dpra, clk, we, dpo)
/* synthesis syn_black_box black_box_pad_pin="a[3:0],d[31:0],dpra[3:0],clk,we,dpo[31:0]" */;
  input [3:0]a;
  input [31:0]d;
  input [3:0]dpra;
  input clk;
  input we;
  output [31:0]dpo;

 ram_dp_sr_sw #(.DATA_WIDTH(32), .ADDR_WIDTH(4)) ram (
.clk(clk)       , // Clock Input
.address_0(a) , // address_0 Input
.data_0(d)    , // data_0 bi-directional
.we_0(we)      , // Write Enable/Read Enable
.address_1(dpra) , // address_1 Input
.oe_1(1'b1),
.data_1(dpo)     // data_1 bi-directional
); 
endmodule

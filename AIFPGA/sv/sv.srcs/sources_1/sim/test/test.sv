`timescale  1 ns / 1 ns
module tb();

logic clk, WE;
logic [3:0]dpra;
logic [27:0]d;
logic [3:0]a;
logic [27:0]dpo;
logic [1:0]NLW_ram_reg_0_15_0_5_DOD_UNCONNECTED;



/*FDSE #(
    .INIT(1'b1)) 
    empty_fwft_i_reg
       (.C(clk),
        .CE(1'b1),
        .D(empty_fwft_i),
        .Q(empty_fwft_i),
        .S(srst));*/

RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    ram_reg_0_15_0_5
       (.ADDRA({1'b0,dpra}),
        .ADDRB({1'b0,dpra}),
        .ADDRC({1'b0,dpra}),
        .ADDRD({1'b0,a}),
        .DIA(d[1:0]),
        .DIB(d[3:2]),
        .DIC(d[5:4]),
        .DID({1'b0,1'b0}),
        .DOA(dpo[1:0]),
        .DOB(dpo[3:2]),
        .DOC(dpo[5:4]),
        .DOD(NLW_ram_reg_0_15_0_5_DOD_UNCONNECTED[1:0]),
        .WCLK(clk),
        .WE(WE));

initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clk = 0;
  WE  = 0;
  #110
  a = 0;
  d = 32;
  dpra = 15;
  WE  = 1;
  #20 dpra = 0;
  WE = 0;
end

always #10 clk  = ~clk;

endmodule

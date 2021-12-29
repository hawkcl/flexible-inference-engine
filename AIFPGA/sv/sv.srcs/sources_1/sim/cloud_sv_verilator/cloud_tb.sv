`timescale 1ns / 1ns
module cloud_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic                    buf_received;
logic [7 : 0]            buffer[DDR_LEN_SIZE + 8]; // 200 + 8

logic                        output_enable;
logic [DDR_ADDR_WIDTH-1:0]   output_addr;
logic [DDR_DATA_WIDTH-1:0]   output_data[DDR_LEN_SIZE];
logic [DDR_LEN_WIDTH-1 : 0]  output_len;
 

cloud_ports ports(.*);
cloud_top top(ports);

Cloud cloud(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

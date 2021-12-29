`timescale 1ns / 1ns
module interface_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic                    buf_received;
logic [7 : 0]            buffer[DDR_LEN_SIZE + 8]; // 200 + 8
logic                    add_output;
logic [DDR_ADDR_WIDTH-1:0]   add_output_address;
logic [DDR_ADDR_WIDTH-1:0]   add_output_size;

logic                        addrbuf_enable;
logic [DDR_ADDR_WIDTH-1:0]   inst_address;

logic                        output_enable;
logic [DDR_ADDR_WIDTH-1:0]   output_addr;
logic [DDR_DATA_WIDTH-1:0]   output_data[DDR_LEN_SIZE];
logic [DDR_LEN_WIDTH-1 : 0]  output_len;

logic [DDR_DATA_WIDTH-1:0]   read_data_weight[DDR_LEN_SIZE];
logic                        ren_weight;
logic [DDR_ADDR_WIDTH-1:0]   read_addr_weight;
logic [DDR_LEN_WIDTH-1 : 0]  read_len_weight;

logic [DDR_DATA_WIDTH-1:0]   read_data_data1[DDR_LEN_SIZE];
logic                        ren_data1;
logic [DDR_ADDR_WIDTH-1:0]   read_addr_data1;
logic [DDR_LEN_WIDTH-1 : 0]  read_len_data1;

logic                        wen_data1;
logic [DDR_ADDR_WIDTH-1:0]   write_addr_data1;
logic [DDR_LEN_WIDTH-1 : 0]  write_len_data1;
logic [DDR_DATA_WIDTH-1:0]   write_data_data1[DDR_LEN_SIZE];


logic [DDR_DATA_WIDTH-1:0]   read_data_data[DDR_LEN_SIZE];
logic                        ren_data;
logic [DDR_ADDR_WIDTH-1:0]   read_addr_data;
logic [DDR_LEN_WIDTH-1 : 0]  read_len_data;

logic                        wen_data;
logic [DDR_ADDR_WIDTH-1:0]   write_addr_data;
logic [DDR_LEN_WIDTH-1 : 0]  write_len_data;
logic [DDR_DATA_WIDTH-1:0]   write_data_data[DDR_LEN_SIZE];

logic                        wen_weight;
logic [DDR_ADDR_WIDTH-1:0]   write_addr_weight;
logic [DDR_LEN_WIDTH-1 : 0]  write_len_weight;
logic [DDR_DATA_WIDTH-1:0]   write_data_weight[DDR_LEN_SIZE];

interface_ports ports(.*);
interface_top top(ports);

if_test iftest(.clk(clock), .*);

DDR ddr_weight (.clk(clock)
    , .ren1(ren_weight)                 , .read_len1(read_len_weight)
    , .read_addr1(read_addr_weight)     , .read_data1(read_data_weight)
    , .wen1(wen_weight)                 , .write_len1(write_len_weight)
    , .write_addr1(write_addr_weight)   , .write_data1(write_data_weight)
    , .ren2(1'b0)                       , .wen2(1'b0));

DDR     ddr_data (.clk(clock)
    , .ren1(ren_data1)                 , .read_len1(read_len_data1)
    , .read_addr1(read_addr_data1)     , .read_data1(read_data_data1)
    , .wen1(wen_data1)                 , .write_len1(write_len_data1)
    , .write_addr1(write_addr_data1)   , .write_data1(write_data_data1)
    , .ren2(ren_data)                 , .read_len2(read_len_data)
    , .read_addr2(read_addr_data)     , .read_data2(read_data_data)
    , .wen2(wen_data)                 , .write_len2(write_len_data)
    , .write_addr2(write_addr_data)   , .write_data2(write_data_data));
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

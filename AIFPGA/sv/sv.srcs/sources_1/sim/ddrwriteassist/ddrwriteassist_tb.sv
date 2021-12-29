`timescale 1ns / 1ns
module ddrwriteassist_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic         req_valid;
mem_addr_t    req_addr;
ddr_len_t     req_len;
ubyte_t	[BRAM_BUS_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] req_data;
logic         axi_ready; 

logic        write_ready;
logic        write_request;
ddr_id_t     axi_wid;
mem_addr_t   axi_waddr;
logic    [DDR_DATAWIDTH-1 : 0] axi_wstrobe;
ubyte_t  [DDR_DATAWIDTH-1 : 0] axi_wdata;



ddrwriteassist_ports ports(.*);
ddrwriteassist_top top(ports);

DDRWriteAssist #(.cid(1)) ddrwriteassist(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

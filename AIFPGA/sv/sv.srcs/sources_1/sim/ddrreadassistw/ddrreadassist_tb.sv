`timescale 1ns / 1ns
module ddrreadassist_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic         req_valid;
ddr_id_t      req_id;
mem_addr_t    req_addr;
ddr_len_t     req_len;

ddr_id_t      ddr_vid;
//ubyte_t  [DDR_DATAWIDTH-1 : 0] ddr_data;
ubyte_t  [PS_DDR_DATAWIDTH-1 : 0] ddr_data;
logic         ddr_isLast;

logic         axi_ready;
logic        read_ready;
ddr_id_t     valid_id;
ubyte_t [MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE - 1 : 0] valid_data;

ddr_id_t     axi_rid;
mem_addr_t   axi_raddr;
ddr_width_t  axi_len;
logic        read_request;
logic        read_freeze;



ddrreadassist_ports ports(.*);
ddrreadassist_top top(ports);

DDRReadAssist #(.cid(1), .DATAWIDTH(PS_DDR_DATAWIDTH)) ddrreadassist(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

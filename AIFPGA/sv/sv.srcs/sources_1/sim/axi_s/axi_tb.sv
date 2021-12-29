`timescale 1ns / 1ns
module axi_tb
import definitions_pkg::*;
();

logic                             ui_clk;
logic                             aresetn;

logic                             addrbuf_enable;
mem_addr_t                        inst_address;

logic                            add_output;
logic   [DDR_ADDR_WIDTH-1:0]     add_output_address;
logic   [DDR_ADDR_WIDTH-1:0]     add_output_size;

//axi0
logic [C_M_AXI_ID_WIDTH-1 : 0]   s_axi0_awid;
logic [AXI4_ADDR_WIDTH-1:0]      s_axi0_awaddr;
logic [AXI4_LEN_WIDTH-1:0]       s_axi0_awlen;
logic [AXI4_SIZE_WIDTH-1:0]      s_axi0_awsize;
logic [1:0]                      s_axi0_awburst;
logic [0:0]                      s_axi0_awlock;
logic [3:0]                      s_axi0_awcache;
logic [2:0]                      s_axi0_awprot;
logic [3:0]                      s_axi0_awqos;
logic                            s_axi0_awvalid;
logic                            s_axi0_awready;
logic [DDR_DATAWIDTH*8 - 1:0]    s_axi0_wdata;
logic [DDR_DATAWIDTH - 1:0]      s_axi0_wstrb;
logic                            s_axi0_wlast;
logic                            s_axi0_wvalid;
logic                            s_axi0_wready;
logic                            s_axi0_bready;
logic [1:0]                      s_axi0_bresp;
logic                            s_axi0_bvalid;
logic [C_M_AXI_ID_WIDTH-1 : 0]   s_axi0_arid;
logic [AXI4_ADDR_WIDTH-1:0]      s_axi0_araddr;
logic [AXI4_LEN_WIDTH-1:0]       s_axi0_arlen;
logic [AXI4_SIZE_WIDTH-1:0]      s_axi0_arsize;
logic [1:0]                      s_axi0_arburst;
logic [0:0]                      s_axi0_arlock;
logic [3:0]                      s_axi0_arcache;
logic [2:0]                      s_axi0_arprot;
logic [3:0]                      s_axi0_arqos;
logic                            s_axi0_arvalid;
logic                            s_axi0_arready;
logic                            s_axi0_rready;
logic [DDR_DATAWIDTH*8 - 1:0]    s_axi0_rdata;
logic [1:0]                      s_axi0_rresp;
logic                            s_axi0_rlast;
logic                            s_axi0_rvalid;
logic [3:0]                      s_axi0_arregion;
logic [3:0]                      s_axi0_awregion;

//ps_axi
logic [C_M_AXI_ID_WIDTH-1 : 0]   ps_axi_awid;
logic [AXI4_ADDR_WIDTH-1:0]      ps_axi_awaddr;
logic [AXI4_LEN_WIDTH-1:0]       ps_axi_awlen;
logic [AXI4_SIZE_WIDTH-1:0]      ps_axi_awsize;
logic [1:0]                      ps_axi_awburst;
logic [0:0]                      ps_axi_awlock;
logic [3:0]                      ps_axi_awcache;
logic [2:0]                      ps_axi_awprot;
logic [3:0]                      ps_axi_awqos;
logic                            ps_axi_awvalid;
logic                            ps_axi_awready;
logic [DDR_DATAWIDTH*8 - 1:0]    ps_axi_wdata;
logic [DDR_DATAWIDTH - 1:0]      ps_axi_wstrb;
logic                            ps_axi_wlast;
logic                            ps_axi_wvalid;
logic                            ps_axi_wready;
logic                            ps_axi_bready;
logic [1:0]                      ps_axi_bresp;
logic                            ps_axi_bvalid;
logic [C_M_AXI_ID_WIDTH-1 : 0]   ps_axi_arid;
logic [AXI4_ADDR_WIDTH-1:0]      ps_axi_araddr;
logic [AXI4_LEN_WIDTH-1:0]       ps_axi_arlen;
logic [AXI4_SIZE_WIDTH-1:0]      ps_axi_arsize;
logic [1:0]                      ps_axi_arburst;
logic [0:0]                      ps_axi_arlock;
logic [3:0]                      ps_axi_arcache;
logic [2:0]                      ps_axi_arprot;
logic [3:0]                      ps_axi_arqos;
logic                            ps_axi_arvalid;
logic                            ps_axi_arready;
logic                            ps_axi_rready;
logic [DDR_DATAWIDTH*8 - 1:0]    ps_axi_rdata;
logic [1:0]                      ps_axi_rresp;
logic                            ps_axi_rlast;
logic                            ps_axi_rvalid;
logic [3:0]                      ps_axi_arregion;
logic [3:0]                      ps_axi_awregion;

axi_ports ports(.*);
axi_top top(ports);

rv_top axi(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  ui_clk = 0;
end

always #10 ui_clk  = ~ui_clk;

endmodule

//`timescale 1ns / 1ps
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/13 03:18:27
// Design Name: 
// Module Name: UCL
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DDR 
import definitions_pkg::*;                  
#(
            parameter DATA_WIDTH = DDR_DATA_WIDTH,
            parameter RAM_DEPTH = DDR_RAM_DEPTH,
            parameter LEN_SIZE  = DDR_LEN_SIZE,
            parameter LEN_WIDTH = DDR_LEN_WIDTH,
            parameter DDR_DELAYS = 20,
            parameter ADDR_WIDTH = DDR_ADDR_WIDTH
)
(
input  logic                    clk       , // Clock Input
input  logic                    resetN       , 
input  ddr_id_t                 axi_rid,
input mem_addr_t                axi_raddr,
input ddr_width_t               axi_len,
input logic                     read_request,
input logic                     read_freeze,
output ddr_id_t                 ddr_vid,
output ubyte_t  [DDR_DATAWIDTH-1 : 0] ddr_data,
output logic                    ddr_isLast,
output logic                    axi_ready,

input  logic                    write_request,
input  mem_addr_t               axi_waddr,
input  logic    [DDR_DATAWIDTH-1 : 0] axi_wstrobe,
input  ubyte_t  [DDR_DATAWIDTH-1 : 0] axi_wdata,

input  logic                    ren2,
input  logic [LEN_WIDTH-1 : 0]  read_len2,
input  logic [ADDR_WIDTH-1:0]   read_addr2,

input  logic                    wen2,
input  logic [LEN_WIDTH-1 : 0]  write_len2,
input  logic [ADDR_WIDTH-1:0]   write_addr2,
input  logic [DATA_WIDTH-1:0]   write_data2[LEN_SIZE],

output logic [DATA_WIDTH-1:0]   read_data2[LEN_SIZE]

); 
/* synthesis syn_black_box */
logic [DATA_WIDTH-1:0] mem [RAM_DEPTH];
DDR_Load_Data_t         delayData[DDR_DELAYS];
logic   [4:0]           loadHolding;
ddr_id_t                load_id;
mem_addr_t              next_load_addr;

logic           fifo_srst;
logic 			info_fifo_ren;
logic 			info_fifo_wen;
logic 			info_fifo_empty;
logic 			info_fifo_full;
DDR_Load_Info_t  info_fifo_wdata;
DDR_Load_Info_t 	info_fifo_rdata;

assign axi_ready = 1;
assign ddr_vid = delayData[DDR_DELAYS - 1].id;
assign ddr_isLast = delayData[DDR_DELAYS - 1].isLast;
assign ddr_data = delayData[DDR_DELAYS - 1].data;

always_ff @ (posedge clk)
begin : MEM_WRITE
  if ( write_request ) begin
      for(int i = 0; i < DDR_DATAWIDTH; i++)
        if(axi_wstrobe[i])
            mem[axi_waddr + i] <= axi_wdata[i];
  end
  else if ( wen2 ) begin
      for(int i = 0; i < write_len2; i++)
         mem[write_addr2 + i] <= write_data2[i];
  end
end

always_ff @ (posedge clk)
if(!resetN) begin
    //for(int i = 0; i < DDR_DELAYS; i++)
    delayData <= '{default:0};
    {loadHolding, load_id, next_load_addr} <= '0;
end
else if(!read_freeze) begin
    for(int i = 0; i < DDR_DELAYS - 1; i++) begin
        delayData[i+1] <= delayData[i];
    end
    if (loadHolding > 0) begin
        if (loadHolding == 1)
            delayData[0].isLast <= 1'b1;
        else
            delayData[0].isLast <= 1'b0;
        loadHolding <= loadHolding - 1;
        delayData[0].id <= load_id;
        for (int i = 0; i < DDR_DATAWIDTH; i++) begin
            delayData[0].data[i] <= mem[next_load_addr + i];
        end
        next_load_addr <= next_load_addr + DDR_DATAWIDTH;
    end
    else if(!info_fifo_empty) begin
        //loadQueue.pop();
        delayData[0].id <= info_fifo_rdata.id;
        load_id <= info_fifo_rdata.id;
        next_load_addr <= info_fifo_rdata.addr + DDR_DATAWIDTH;
        loadHolding <= info_fifo_rdata.len;
        if (info_fifo_rdata.len == 0)
            delayData[0].isLast <= 1'b1;
        else
            delayData[0].isLast <= 1'b0;
        for (int i = 0; i < DDR_DATAWIDTH; i++) begin
            delayData[0].data[i] <= mem[info_fifo_rdata.addr + i];
        end
    end
    else begin
        delayData[0] <= '{default:0};
    end
end

assign info_fifo_ren = (!read_freeze) && (loadHolding  == 0) && (~info_fifo_empty);
assign fifo_srst = ~resetN;
assign info_fifo_wen = read_request;
assign info_fifo_wdata.id = axi_rid;
assign info_fifo_wdata.addr = axi_raddr;
assign info_fifo_wdata.len = axi_len;
fifo_DDR_Load_Info fifo_loadQueue(
	    .clk	, 		    .srst(fifo_srst), 
	    .din(info_fifo_wdata),  .wr_en(info_fifo_wen), 
	    .rd_en(info_fifo_ren), 	.dout(info_fifo_rdata), 
	    .full(info_fifo_full), 	.empty(info_fifo_empty));


always_comb
begin
    if(ren2) begin
        for(int i = 0; i < read_len2; i++)
            read_data2[i] = mem[read_addr2 + i];
    end
    else
        read_data2 = '{default:0};
end

endmodule 


module DDR_delay 
import definitions_pkg::*;                  
#(
            parameter DATA_WIDTH = DDR_DATA_WIDTH,
            parameter RAM_DEPTH = DDR_RAM_DEPTH,
            parameter LEN_SIZE  = DDR_LEN_SIZE,
            parameter LEN_WIDTH = DDR_LEN_WIDTH,
            parameter DDR_DELAYS = 20,
            parameter ADDR_WIDTH = DDR_ADDR_WIDTH
)
(
input  logic                    clk       , // Clock Input
input  logic                    resetN,
input  ddr_id_t                 axi_rid,
input mem_addr_t                axi_raddr,
input ddr_width_t               axi_len,
input logic                     read_request,
input logic                     read_freeze,
output ddr_id_t                 ddr_vid,
output ubyte_t  [PS_DDR_DATAWIDTH-1 : 0] ddr_data,
output logic                    ddr_isLast,
output logic                    axi_ready,

input  logic                    wen,
input  logic [LEN_WIDTH-1 : 0]  write_len,
input  logic [ADDR_WIDTH-1:0]   write_addr,
input  logic [DATA_WIDTH-1:0]   write_data[LEN_SIZE]

); 
/* synthesis syn_black_box */
logic [DATA_WIDTH-1:0] mem [RAM_DEPTH];
DDR_Load_Data_t         delayData[DDR_DELAYS];
logic   [4:0]           loadHolding;
ddr_id_t                load_id;
mem_addr_t              next_load_addr;

logic           fifo_srst;
logic 			info_fifo_ren;
logic 			info_fifo_wen;
logic 			info_fifo_empty;
logic 			info_fifo_full;
DDR_Load_Info_t  info_fifo_wdata;
DDR_Load_Info_t 	info_fifo_rdata;

assign axi_ready = 1;
assign ddr_vid = delayData[DDR_DELAYS - 1].id;
assign ddr_isLast = delayData[DDR_DELAYS - 1].isLast;
assign ddr_data = delayData[DDR_DELAYS - 1].data;

always_ff @ (posedge clk)
begin : MEM_WRITE
  if ( wen ) begin
      for(int i = 0; i < write_len; i++)
         mem[write_addr + i] <= write_data[i];
  end
end

always_ff @ (posedge clk)
if(!resetN) begin
    //for(int i = 0; i < DDR_DELAYS; i++)
    delayData <= '{default:0};
    {loadHolding, load_id, next_load_addr} <= '0;
end
else if(!read_freeze) begin
    for(int i = 0; i < DDR_DELAYS - 1; i++) begin
        delayData[i+1] <= delayData[i];
    end
    if (loadHolding > 0) begin
        if (loadHolding == 1)
            delayData[0].isLast <= 1'b1;
        else
            delayData[0].isLast <= 1'b0;
        loadHolding <= loadHolding - 1;
        delayData[0].id <= load_id;
        for (int i = 0; i < PS_DDR_DATAWIDTH; i++) begin
            delayData[0].data[i] <= mem[next_load_addr + i];
        end
        next_load_addr <= next_load_addr + PS_DDR_DATAWIDTH;
    end
    else if(!info_fifo_empty) begin
        //loadQueue.pop();
        delayData[0].id <= info_fifo_rdata.id;
        load_id <= info_fifo_rdata.id;
        next_load_addr <= info_fifo_rdata.addr + PS_DDR_DATAWIDTH;
        loadHolding <= info_fifo_rdata.len;
        if (info_fifo_rdata.len == 0)
            delayData[0].isLast <= 1'b1;
        else
            delayData[0].isLast <= 1'b0;
        for (int i = 0; i < PS_DDR_DATAWIDTH; i++) begin
            delayData[0].data[i] <= mem[info_fifo_rdata.addr + i];
        end
    end
    else begin
        delayData[0] <= '{default:0};
    end
end

assign info_fifo_ren = (!read_freeze) && (loadHolding  == 0) && (~info_fifo_empty);
assign fifo_srst = ~resetN;
assign info_fifo_wen = read_request;
assign info_fifo_wdata.id = axi_rid;
assign info_fifo_wdata.addr = axi_raddr;
assign info_fifo_wdata.len = axi_len;
fifo_DDR_Load_Info fifo_loadQueue(
	    .clk	, 		    .srst(fifo_srst), 
	    .din(info_fifo_wdata),  .wr_en(info_fifo_wen), 
	    .rd_en(info_fifo_ren), 	.dout(info_fifo_rdata), 
	    .full(info_fifo_full), 	.empty(info_fifo_empty));


endmodule 

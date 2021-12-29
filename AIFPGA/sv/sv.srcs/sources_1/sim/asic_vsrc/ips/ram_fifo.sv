//===========================================
// Function : Synchronous read write RAM
// Coder    : Deepak Kumar Tala
// Date     : 1-Nov-2005
//===========================================
`timescale 1ns / 1ns
module ram_dp_sr_sw #(parameter DATA_WIDTH = 8,
                  parameter ADDR_WIDTH = 8,
                  parameter RAM_DEPTH = (1 << ADDR_WIDTH))(
input  logic                  clk       , // Clock Input
input  logic [ADDR_WIDTH-1:0] address_0 , // address_0 Input
input  logic [DATA_WIDTH-1:0] data_0    , // data_0 bi-directional
input  logic                  we_0      , // Write Enable/Read Enable
input  logic                  oe_1      , // Write Enable/Read Enable
input  logic [ADDR_WIDTH-1:0] address_1 , // address_1 Input
output  logic [DATA_WIDTH-1:0] data_1     // data_1 bi-directional
); 
typedef logic [ADDR_WIDTH-1:0] mem_addr;
logic [DATA_WIDTH-1:0] mem [0:((1<<ADDR_WIDTH)-1)];

assign data_1 = oe_1 ? mem[address_1] : 'x;  
always @ (posedge clk)
begin : MEM_WRITE
  if ( we_0 ) begin
     mem[address_0] = data_0;
  end
end
endmodule // End of Module ram_dp_sr_sw

module ram_dp_sr_sw1 #(parameter DATA_WIDTH = 8,
                  parameter ADDR_WIDTH = 8,
                  parameter RAM_DEPTH = (1 << ADDR_WIDTH))(
input  logic                  clk       , // Clock Input
input  logic [ADDR_WIDTH-1:0] address_0 , // address_0 Input
input  logic [DATA_WIDTH-1:0] data_0    , // data_0 bi-directional
input  logic                  we_0      , // Write Enable/Read Enable
input  logic                  oe_1      , // Write Enable/Read Enable
input  logic [ADDR_WIDTH-1:0] address_1 , // address_1 Input
output  logic [DATA_WIDTH-1:0] data_1     // data_1 bi-directional
); 
typedef logic [ADDR_WIDTH-1:0] mem_addr;
logic [DATA_WIDTH-1:0] mem [0:((1<<ADDR_WIDTH)-1)];

always @ (posedge clk)
    data_1 <= oe_1 ? mem[address_1] : 'x;  
always @ (posedge clk)
begin : MEM_WRITE
  if ( we_0 ) begin
     mem[address_0] = data_0;
  end
end
endmodule // End of Module ram_dp_sr_sw1

module syn_fifo #(parameter DATA_WIDTH = 8,
                  parameter ADDR_WIDTH = 8,
                  parameter RAM_DEPTH = (1 << ADDR_WIDTH), parameter PROG_COUNT = 2)(
input   logic                  clk      , // Clock input
input   logic                  rst      , // Active high reset
input   logic                  wr_cs    , // Write chip select
input   logic                  rd_cs    , // Read chipe select
input   logic [DATA_WIDTH-1:0] data_in  , // Data input
input   logic                  rd_en    , // Read enable
input   logic                  wr_en    , // Write Enable
output  logic  [DATA_WIDTH-1:0] data_out , // Data Output
output  logic                  empty    , // FIFO empty
output  logic                  full     , // FIFO full
output  logic                  prog_full  // FIFO full
);    
//-----------Internal variables-------------------
logic [ADDR_WIDTH-1:0] wr_pointer;
logic [ADDR_WIDTH-1:0] rd_pointer;
logic [ADDR_WIDTH :0] status_cnt;
logic [DATA_WIDTH-1:0] data_ram ;
//-----------Variable assignments---------------
assign full = (status_cnt == (RAM_DEPTH-1));
assign prog_full = (status_cnt >= (RAM_DEPTH-PROG_COUNT));
assign empty = (status_cnt == 0);
//-----------Code Start---------------------------
always_ff @ (posedge clk , posedge rst)
begin : WRITE_POINTER
  if (rst) begin
    wr_pointer <= 0;
  end else if (wr_cs && wr_en ) begin
    wr_pointer <= wr_pointer + 1;
  end
end

always_ff @ (posedge clk , posedge rst)
begin : READ_POINTER
  if (rst) begin
    rd_pointer <= 0;
  end else if (rd_cs && rd_en ) begin
    rd_pointer <= rd_pointer + 1;
  end
end

assign data_out = data_ram;
//always_ff  @ (posedge clk iff rst == 0 , posedge rst)
//begin : READ_DATA
//  if (rst) begin
//    data_out <= 0;
//  end else if (rd_cs && rd_en ) begin
//    data_out <= data_ram;
//  end
//end

always_ff @ (posedge clk , posedge rst)
begin : STATUS_COUNTER
  if (rst) begin
    status_cnt <= 0;
  // Read but no write.
  end else if ((rd_cs && rd_en) && !(wr_cs && wr_en) 
                && (status_cnt != 0)) begin
    status_cnt <= status_cnt - 1;
  // Write but no read.
  end else if ((wr_cs && wr_en) && !(rd_cs && rd_en) 
               && (status_cnt != RAM_DEPTH)) begin
    status_cnt <= status_cnt + 1;
  end
end 
   
ram_dp_sr_sw #(DATA_WIDTH,ADDR_WIDTH,RAM_DEPTH) DP_RAM (
.clk       (clk),
.address_0 (wr_pointer) , // address_0 input 
.data_0    (data_in)    , // data_0 bi-directional
//.cs_0      (wr_cs)      , // chip select
.we_0      (wr_en)      , // write enable
.address_1 (rd_pointer) , // address_q input
.data_1    (data_ram),    // data_1 bi-directional
//.cs_1      (rd_cs)      , // chip select
.oe_1      (1'b1)        // output enable
);     

endmodule



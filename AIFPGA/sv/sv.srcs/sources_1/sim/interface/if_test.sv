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


module if_test 
import definitions_pkg::*;                  
(
input  logic                    clk       , // Clock Input
input  logic                    resetN ,
input  logic                    buf_received,
input  logic [7 : 0]            buffer[DDR_LEN_SIZE + 8], // 200 + 8
input  logic [DDR_DATA_WIDTH-1:0]   read_data_data[DDR_LEN_SIZE],
input  logic                    add_output,
input  logic [DDR_ADDR_WIDTH-1:0]   add_output_address,
input  logic [DDR_ADDR_WIDTH-1:0]   add_output_size,

output logic                    addrbuf_enable,
output mem_addr_t               inst_address,

output logic                    output_enable,
output logic [DDR_ADDR_WIDTH-1:0]   output_addr,
output logic [DDR_DATA_WIDTH-1:0]   output_data[DDR_LEN_SIZE],
output logic [DDR_LEN_WIDTH-1 : 0]  output_len,

output logic                    ren_data,
output logic [DDR_ADDR_WIDTH-1:0]   read_addr_data,
output logic [DDR_LEN_WIDTH-1 : 0]  read_len_data,

output logic                    wen_data,
output logic [DDR_ADDR_WIDTH-1:0]   write_addr_data,
output logic [DDR_LEN_WIDTH-1 : 0]  write_len_data,
output logic [DDR_DATA_WIDTH-1:0]   write_data_data[DDR_LEN_SIZE],

output logic                    wen_weight,
output logic [DDR_ADDR_WIDTH-1:0]   write_addr_weight,
output logic [DDR_LEN_WIDTH-1 : 0]  write_len_weight,
output logic [DDR_DATA_WIDTH-1:0]   write_data_weight[DDR_LEN_SIZE]
); 
/* synthesis syn_black_box */
logic           output_state, output_state_next;
logic [DDR_ADDR_WIDTH-1:0]   out_addr, out_addr_next;
logic [DDR_ADDR_WIDTH-1:0]   out_len, out_len_next;
logic [DDR_ADDR_WIDTH-1:0]   out_size, out_size_next;


logic 			data_fifo_ren;
logic 			data_fifo_wen;
logic 			data_fifo_empty;
logic 			data_fifo_full;
logic  	[DDR_ADDR_WIDTH * 2 - 1 : 0] data_fifo_wdata;
logic  	[DDR_ADDR_WIDTH * 2 - 1 : 0] data_fifo_rdata;

always_ff @(posedge clk)
if (!resetN) 
    {output_state, out_addr, out_len, out_size} <= '0;
else 
    {output_state, out_addr, out_len, out_size} <= 
    {output_state_next, out_addr_next, out_len_next, out_size_next};

always_comb
begin
    output_state_next = output_state;
    out_addr_next = out_addr;
    out_len_next  = out_len;
    out_size_next = out_size;
    output_enable = 0;
    output_addr = 0;
    output_len  = 0;
    output_data = '{default:0};
    ren_data = 0;
    read_addr_data = 0;
    read_len_data  = 0;
    data_fifo_ren = 0;
    if(!output_state) begin
        if(!data_fifo_empty) begin
            output_state_next = 1;
            data_fifo_ren = 1;
            {out_addr_next, out_size_next} = data_fifo_rdata;
            out_len_next = 0;
        end
    end
    else begin
        if(out_len + INTERFACE_LEN >= out_size)
            output_state_next = 0;
        ren_data = 1;
        read_addr_data = out_addr + out_len;
        read_len_data  = INTERFACE_LEN;
        if(out_len + INTERFACE_LEN >= out_size) begin
            output_len = out_size - out_len;
            out_len_next = 0;
        end
        else begin
            output_len = INTERFACE_LEN;
            out_len_next = out_len + INTERFACE_LEN;
        end
        output_addr = out_addr + out_len;
        output_data = read_data_data;
        output_enable = 1;
    end
end

always_comb
begin
    data_fifo_wen = 0;
    data_fifo_wdata = '0;
    if(add_output) begin
        data_fifo_wen = 1;
        data_fifo_wdata = {add_output_address, add_output_size};
    end
end

always_comb
begin
    wen_data = 0;
    write_addr_data = 0;
    write_len_data = 0;
    write_data_data = '{default:0};
    wen_weight = 0;
    write_addr_weight = 0;
    write_len_weight = 0;
    write_data_weight = '{default:0};
    addrbuf_enable = 0;
    inst_address = 0;
    if(buf_received) begin
        if(buffer[0] == SEND_ADDRESS) begin
            addrbuf_enable = 1;
            inst_address[7:0] = buffer[3];
            inst_address[15:8] = buffer[4];
            inst_address[23:16] = buffer[5];
            inst_address[DDR_ADDR_WIDTH-1:24] = buffer[6];
        end
        else if(buffer[0] == SEND_WEIGHT) begin
            wen_weight = 1;
            write_len_weight[7:0] = buffer[1];
            write_len_weight[DDR_LEN_WIDTH-1:8] = buffer[2];
            write_addr_weight[7:0] = buffer[3];
            write_addr_weight[15:8] = buffer[4];
            write_addr_weight[23:16] = buffer[5];
            write_addr_weight[DDR_ADDR_WIDTH-1:24] = buffer[6];
            for(int i = 0; i < DDR_LEN_SIZE; i++)
                write_data_weight[i] = buffer[i + 7];
        end
        else if(buffer[0] == SEND_FEATURE ||buffer[0] == SEND_INSTRUCTION) begin
            wen_data = 1;
            write_len_data[7:0] = buffer[1];
            write_len_data[DDR_LEN_WIDTH-1:8] = buffer[2];
            write_addr_data[7:0] = buffer[3];
            write_addr_data[15:8] = buffer[4];
            write_addr_data[23:16] = buffer[5];
            write_addr_data[DDR_ADDR_WIDTH-1:24] = buffer[6];
            for(int i = 0; i < DDR_LEN_SIZE; i++)
                write_data_data[i] = buffer[i + 7];
        end
    end
end

fifo_out_addrs_sizes fifo_data(
	    .clk(clk), 		        .srst(~resetN), 
	    .din(data_fifo_wdata), 	.wr_en(data_fifo_wen), 
	    .rd_en(data_fifo_ren), 	.dout(data_fifo_rdata),
        .full(data_fifo_full),	.empty(data_fifo_empty));

endmodule 

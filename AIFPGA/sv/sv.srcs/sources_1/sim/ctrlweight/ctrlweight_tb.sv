`timescale 1ns / 1ns
module ctrlweight_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic 		    cwinst_enable;
InstructionWeight 	cwinst;
logic           ddr_read_ready;
ddr_id_t        valid_id;
s_weight_t  	[WEIGHT_READ_WIDTH - 1 : 0]weight_data;
logic           cb_isReadingWeights[BANK_NUM];
logic           cb_isWeightFull[BANK_NUM];
seq_t           cb_ReqWeight[BANK_NUM];


logic           weight_ram_enable;
ddr_id_t        weight_ddr_id;
mem_addr_t      weight_ram_addr;
logic   [DDR_LEN_WIDTH-1 : 0]   weight_write_len;
logic 		    pcweight_busValid;
logic           wt_inst_fifo_full;
seq_t 		    pcweight_seq;
s_weight_t  	w_bus[WEIGHT_READ_WIDTH];
logic           isStopable;

 

ctrlweight_ports ports(.*);
ctrlweight_top top(ports);

CtrlWeight ctrlweight(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

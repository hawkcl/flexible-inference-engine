`timescale 1ns / 1ns
module ctrlread_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic 		crinst_enable;
InstructionRead 	crinst;

logic         cb_isRunning[BANK_NUM];
logic         cb_isReadingFeatures[BANK_NUM];
logic         cb_isLoadingFroze[BANK_NUM];
seq_t         cb_ReqFeature[BANK_NUM];
seq_t         cb_FinishedSeq[BANK_NUM];
seq_t         cb_WorkingSeq[BANK_NUM];
seq_t         cb_WorkingProgress[BANK_NUM];

logic         [BANK_NUM - 1:0]requestValid;
RequestItem_t ritem[BANK_NUM];
logic         reqGIBValid;
RequestItem_t reqGIB;
logic           rd_inst_fifo_full;

logic         ddr_read_ready;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ddr_data;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]rama_data;
s_feature_t  	[MAX_LOAD_WIDTH - 1 : 0]ramb_data;
ddr_id_t                              ddr_data_id;
ddr_id_t                              ddr_id;

logic        ddr_enable;
mem_addr_t   ddr_addr;
ctrl_width_t ddr_len;
logic        rama_ren;
logic        ramb_ren;
mem_addr_t   ram_addr;
ctrl_width_t ram_len;

logic        pcread_RequestGIBValid;
logic        pread_waitForSeq;
logic 		pread_busValid;
logic 		pread_isFeature;
logic        pread_RequestFull;
seq_t        pread_SeqNum;
s_feature_t 	[MAX_LOAD_WIDTH - 1 : 0]data_bus;
ReturnData_t        data_bus_ret;
logic       isStopable;

assign data_bus_ret = data_bus;

ctrlread_ports ports(.*);
ctrlread_top top(ports);

CtrlRead ctrlread(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

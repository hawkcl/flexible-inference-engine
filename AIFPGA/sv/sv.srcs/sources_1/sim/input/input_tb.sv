`timescale 1ns / 1ns
module input_tb
import definitions_pkg::*;
();
`ifdef S2_OPTIMIZE	
	logic isStride2;
	s_row_addr_t new_nextRowStart;
	k_t new_kIter;
	logic [3:0] s2b_a;
	s_feature_t [INPUT_MEM_WIDTH - 1 : 0] s2b_data_out;
	logic s2b_we;
	s_feature_t [INPUT_MEM_WIDTH - 1 : 0] s2b_data;
	logic isStride2;
`endif

//ReadFeatures
logic 		clock, resetN;
logic 		pread_busValid, pread_isFeature;
logic 		isReadingFeatures, isLoadingFroze;
logic 		isLoadingNextFeatures;
seq_t 		pread_seqNum, reqSeqF;
width_t 	writeWidth;

logic 		new_params_readFeatures;
mem_bus_addr_t 	readPos;
input_addr_t 	volumeSize;

input_addr_t 	usedWords;
s_feature_t  	[MAX_READ_WIDTH-1:0]dataBus;

logic 		setLoadingFroze, resetLoadingFroze;
logic 		resetLoadingNextFeatures, resetReadingFeatures;

//AssembleInput
logic 		doAssemble;
width_t 	readWidth;
loc_frame_t 	prefetchFrameSize;
logic 		new_conv_inst, startPrefetching;
input_addr_t 	new_addrNextFrame;
input_addr_t 	curVolumeSize;
width1_t 	maxRowCount;
width_t 	lastLen;

logic 		resetAssemble;

//BuildInputFifo
HCB_STATE 	state;
layer_addr_t 	readCLast;
width_t 	outputBufH1;
pad_t 		downPad, topPad;
k_t 		k;
pad_t 		stride;
s_row_addr_t 	rowNum;

logic 		reset_iLayers;
s_row_addr_t 	new_rowAddr;

//SendBackUpInput
logic 		sendBackUpInput_valid;
k_t 		backupId;
pad_t 		leftPad;

`ifdef S2_OPTIMIZE  
	s_feature_t backupBus[COMPUTING_GROUP_SIZE*2];
`else
	s_feature_t backupBus[COMPUTING_GROUP_SIZE];
`endif
logic 		isBackupValid;

//SetupShiftInputs
INPUT_SOURCE 	input_src;
s_feature_t 	shiftInputs[MAX_K];

//internal
logic 					inputs_wen;
logic unsigned [INPUT_ADDR_WIDTH - 1 :0]			inputs_waddr;
s_feature_t [INPUT_MEM_WIDTH - 1 : 0] 	inputs_wdata;
logic 					inputs_ren;
logic unsigned [INPUT_ADDR_WIDTH - 1 :0]			inputs_raddr;
s_feature_t [INPUT_MEM_WIDTH - 1 : 0] 	inputs_rdata;
logic 					assemble_buffer_full, assemble_buffer_empty;
logic 					assemble_buffer_wen, assemble_buffer_ren;
s_feature_t [INPUT_MEM_WIDTH - 1 : 0] 	assemble_buffer_wdata, assemble_buffer_rdata;
logic 					input_fifo_wen, input_fifo_ren;
s_feature_t [INPUT_MEM_WIDTH - 1 : 0] 	input_fifo_wdata, input_fifo_rdata;
logic 					input_fifo_full, input_fifo_empty;
s_feature_t 				shiftBufBackup[MAX_K][MAX_SHIFT_SIZE];

logic inputs_buffer_full, inputs_buffer_empty;
logic inputs_buffer_wen, inputs_buffer_ren;
logic inputs_buffer_progfull;
s_feature_t [INPUT_MEM_WIDTH - 1 : 0] inputs_buffer_wdata, inputs_buffer_rdata;

logic fifo_srst;
assign fifo_srst = ~resetN;

input_ports ports(.*);
input_top top(ports);

inputs_mem inputs (.clka(clock), .ena('x), .wea(inputs_wen), 
	.addra(inputs_waddr), .dina(inputs_wdata), .clkb(clock), 
	.enb(inputs_ren), .addrb(inputs_raddr), .doutb(inputs_rdata));

fifo_assemble_buffer assemble_buffer(.clk(clock), .srst(fifo_srst), 
	.din(assemble_buffer_wdata), .wr_en(assemble_buffer_wen), 
	.rd_en(assemble_buffer_ren), .dout(assemble_buffer_rdata),
	.full(assemble_buffer_full), .empty(assemble_buffer_empty)); 

fifo_assemble_buffer input_fifo(.clk(clock), .srst(fifo_srst), 
	.din(input_fifo_wdata), .wr_en(input_fifo_wen), 
	.rd_en(input_fifo_ren), .dout(input_fifo_rdata),
	.full(input_fifo_full), .empty(input_fifo_empty)); 

ReadFeatures readfeatures(.new_params(new_params_readFeatures ), 
	.addrOut(inputs_waddr), .wen(inputs_wen),
	.dataOut(inputs_wdata), .*);

AssembleInputBuffer assembleInputBuffer    (
	    .clock,                         .resetN,		
        .isLoadingNextFeatures,         .isReadingFeatures,
        .doAssemble,                    .inputs_buffer_progfull,
        .nextWritePos (inputs_waddr),   .data_input (inputs_rdata),
        .new_param (new_conv_inst),     .reset_param (startPrefetching),
        .curVolumeSize,                 .inputs_buffer_wen,
        .buffer_data (inputs_buffer_wdata),     .inputs_ren,
        .addrOut(inputs_raddr)
        );
            
fifo_assemble_buffer inputs_buffer(
    .clk(clock), 			.srst(fifo_srst), 
    .din(inputs_buffer_wdata), 	.wr_en(inputs_buffer_wen), 
    .rd_en(inputs_buffer_ren), 	.dout(inputs_buffer_rdata), 
    .full(inputs_buffer_full), 	.empty(inputs_buffer_empty),
    .prog_full(inputs_buffer_progfull)); 
                

AssembleInput assembleInput(.buffer_full(assemble_buffer_full),
	.new_param(new_conv_inst),.reset_param(startPrefetching),
	.buffer_wen(assemble_buffer_wen),.buffer_data(assemble_buffer_wdata),
	.ren(inputs_buffer_ren),
	.data_input(inputs_buffer_rdata), .*);

BuildInputFifo buildInputFifo(.reset_params(startPrefetching), .new_params(new_conv_inst), 
	.ab_rd_en(assemble_buffer_ren), .ab_data(assemble_buffer_rdata), .ab_empty(assemble_buffer_empty), 
	.input_wr_en(input_fifo_wen),.input_data_out(input_fifo_wdata),.input_full(input_fifo_full), .*);

SendBackUpInput sendBackUpInput(.fifo_data(input_fifo_rdata),.fifo_empty(input_fifo_empty), 
	.rd_en(input_fifo_ren), .*);

SetupShiftInputs shiftinput(.*);

initial begin
	//$dumpfile("fifo.vcd");
	//$dumpvars();
	clock = 0;
end

always #10 clock  = ~clock;

endmodule

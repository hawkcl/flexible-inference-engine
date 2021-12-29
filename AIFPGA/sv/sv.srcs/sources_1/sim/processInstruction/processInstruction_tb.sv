`timescale 1ns / 1ns
module processInstruction_tb
import definitions_pkg::*;
();

logic clock, resetN;
logic		enable;
logic		pwrite_isFetchNextInst;
logic		pib_empty;
InstructionHCB		inst;
logic		hasNextFeatureParams;
logic		new_params_prefetch;
mem_bus_addr_t		new_readPos;
width_t		new_writeWidth;
input_addr_t		new_volumeSize;
seq_t		new_reqSeqF;

logic		pib_en;
logic		new_conv_inst;
k_t		inst_k;
seq_t		curSeq,		reqSeq;
seq_t		reqProgress;
logic		isProgressMaster;
logic		token_set;
token_t		max_token;
k_t		k;
pad_t		stride;
`ifdef		S2_OPTIMIZE
logic		isStride2;
s_row_addr_t		new_nextRowStart;
k_t		new_kIter;
`endif
out_width_t		outW;
width_t		new_outputBufH1;
width_t		outputBufH1Orig;
width_t		outputBufW1;
loc_frame_t		outBufFrameSize;
outframe_addr_t		outFrameSize;
output_gap_t		outputAddrGap;
output_gap_t		outFrameGapSize;
pad_t		maxpool_stride;
mem_addr_t		new_outputAddr;		
mem_addr_t		new_outputFrameStart;
cg_addr_t		numGroups;
token_t		token;
logic		isResMaster;
mem_bus_addr_t		readPos;
mem_bus_addr_t		resPos;
pad_t		leftPad;
width_t		new_readWidth;
width_t		writeWidth;
layer_addr_t		readCLast;
pad_t		topPad,		downPad;
s_row_addr_t		new_rowAddr;
s_row_addr_t		new_rowNum;
seq_t		reqSeqF;
layer_addr_t		new_kCur;
layer_addr_t		new_kOut;
layer_addr_t		Ks,		kt;
cg_addr_t		new_usedGroups;
res_size_t		new_resSize;
res_size_t		new_resReadSize;
layer_addr_t		new_resFrameMax;
logic		doRes;
logic		doRelu;
logic		doLRelu;
logic		doBM;
logic		doUpSample;
logic		newWriteInst;
s_feature_t		wLRelu;
cg_addr_t		new_wtotal;
layer_addr_t		new_resFrameCount;
group_t		new_resRowCount;
logic		new_isReadResA;
mem_addr_t		new_nextResAddr;
mem_addr_t		new_frameResAddr;
res_len_t		new_resLen;
output_gap_t		new_outResGapSize;
layer_addr_t		new_kRes;				
loc_frame_t		prefetchFrameSize;
input_addr_t		volumeSize;
input_addr_t		curVolumeSize;
DATA_MODE		mode;
scale_t		fScale;
scale_t		wScale;
input_addr_t		new_addrNextFrame;
res_size_t		totalRes;
cg_addr_t		usedGroupsLast;
cg_addr_t		usedCGLast;
cg_addr_t		usedCG0;
layer_addr_t		kCurLast;
res_size_t		resSize0;
res_size_t		resSizeLast;
res_len_t		resLen0;
res_len_t		resLenLast;
cg_addr_t		wtotal_n;
weight_bus_size_t		wlenk_nLast;
cg_addr_t		wtotalLast;
weight_bus_size_t		wlenk_nLast2;
weight_bus_size_t		wlenk_regular;
weight_bus_size_t		wlen_regular;
weight_bus_size_t		new_wlenk;
weight_bus_size_t		new_wlenk_last;
layer_addr_t		kCurLast_1;
width1_t		new_maxRowCount;
width_t		new_lastLen;

 

processInstruction_ports ports(.*);
processInstruction_top top(ports);

ProcessInstruction processInstruction(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

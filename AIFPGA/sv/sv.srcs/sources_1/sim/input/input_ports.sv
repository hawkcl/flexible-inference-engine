`ifndef INPUT_PORTS_SV
`define INPUT_PORTS_SV

`timescale 1ns / 1ns
interface input_ports 
import definitions_pkg::*;
(
input logic 		clock, 
output logic 		resetN,
output logic 		pread_busValid, pread_isFeature,
output logic 		isReadingFeatures, isLoadingFroze,
output logic 		isLoadingNextFeatures,
output seq_t 		pread_seqNum, reqSeqF,
output width_t 		writeWidth,

output logic 		new_params_readFeatures,
output mem_bus_addr_t 	readPos,
output input_addr_t 	volumeSize,

output input_addr_t 	usedWords,
output s_feature_t  	[MAX_READ_WIDTH-1:0]dataBus,
//AssembleInput
output logic 		doAssemble,
output width_t 		readWidth,
output loc_frame_t 	prefetchFrameSize,
output logic 		new_conv_inst, startPrefetching,
output input_addr_t 	new_addrNextFrame,
output input_addr_t 	curVolumeSize,
output width1_t 	maxRowCount,
output width_t 		lastLen,
//BuildInputFifo
output HCB_STATE 	state,
output layer_addr_t 	readCLast,
output width_t 		outputBufH1,
output pad_t 		downPad, topPad,
output k_t 		k,
output pad_t 		stride,
output s_row_addr_t 	rowNum,
output logic 		reset_iLayers,
output s_row_addr_t 	new_rowAddr,
//SendBackUpInput
output logic 		sendBackUpInput_valid,
output k_t 		backupId,
output pad_t 		leftPad,
//SetupShiftInputs
output INPUT_SOURCE 	input_src,

input logic 		setLoadingFroze,
input logic 		resetLoadingFroze,
input logic 		resetLoadingNextFeatures,
input logic 		resetReadingFeatures,
input logic 		resetAssemble,
`ifdef S2_OPTIMIZE  
input 	s_feature_t backupBus[COMPUTING_GROUP_SIZE*2],
`else
input 	s_feature_t backupBus[COMPUTING_GROUP_SIZE],
`endif
input logic 		isBackupValid,
input s_feature_t 	shiftInputs[MAX_K]
);
endinterface



`endif

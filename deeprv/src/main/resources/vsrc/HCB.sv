//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/18 05:53:43
// Design Name: 
// Module Name: weightFifo
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

module HCB
import definitions_pkg::*;
#(parameter id = 0)
(
input logic 		clock, resetN,
input logic 		inst_enable,
input logic 		start, 
input logic 		stop,
input logic 		pwrite_isFetchNextInst,
input InstructionHCB 	inst,
input logic 		pread_busValid,
input logic 		pread_isFeature,
input seq_t 		pread_seqNum,
input s_feature_t  	[MAX_READ_WIDTH - 1 : 0]dataBus,
input seq_t 		pcweight_seq,
input logic 		pcweight_busValid,
input s_weight_t 	pcweight_dataBus[WEIGHT_MEM_BUS_SIZE],
input logic 		pread_RequestFull,
input token_t 		ptoken,
input ReturnData_t 	pread_dataBus,
input logic 		pwrite_isWritable, 

output logic 		weights_almost_full,
output logic 		instfifo_full,
output logic 		token_set,
output token_t 		max_token,
output logic 		pread_RequestValid,
output RequestItem_t 	pread_request,
output s_feature_t 	[COMPUTING_GROUP_SIZE - 1 : 0]pwrite_data,
output logic 		pwrite_enable,
output mem_addr_t 	pwrite_addr,
output logic 		pwrite_setNextInst,
output logic 		isFetchNextInst,
output layer_addr_t 	workingProgress,

output logic            isRunning,
output logic            isReadingFeatures,
output seq_t            reqFeature,
output seq_t            finishedSeq,
output seq_t            workingSeq,
output logic            isReadingWeights,
output seq_t            reqWeight,
output logic            isStopable,
output logic            isLoadingFroze
);
	//logic clock;
    logic fifo_srst;
    HCB_STATE state, state_next;
    logic startPrefetching, startConvOut;
    logic hasNextFeatureParams, isLoadingNextFeatures;
    logic new_params_prefetch;
    InstructionHCB inst_i;
    InstructionHCB inst_o;
    InstructionHCBWt instw_i;
    InstructionHCBWt instw_o;
    logic inst_fifo_empty;
    logic inst_fifo_wen, inst_fifo_ren;
    logic instw_fifo_ren, instw_fifo_empty;
    mem_bus_addr_t new_readPos;
    width_t new_writeWidth;
    input_addr_t new_volumeSize;
    seq_t new_reqSeqF;
    logic new_conv_inst;
    k_t inst_k, k;
    seq_t curSeq, reqSeq;
    seq_t reqProgress;
    logic isProgressMaster;
    pad_t stride;
`ifdef S2_OPTIMIZE
    logic isStride2;
    s_row_addr_t new_nextRowStart;
    k_t new_kIter;
`endif
    out_width_t outW;
    width_t new_outputBufH1;
    width_t outputBufH1Orig;
    width_t outputBufW1;
    loc_frame_t outBufFrameSize;
    outframe_addr_t outFrameSize;
    output_gap_t outputAddrGap, outFrameGapSize;
    mem_addr_t new_outputAddr;
    mem_addr_t new_outputFrameStart;
   // mem_addr_t batchAddr;
    cg_addr_t numGroups;
    token_t token;
    logic isResMaster;
    mem_bus_addr_t readPos;
    mem_bus_addr_t resPos;
    pad_t leftPad;
    width_t new_readWidth;
    width_t writeWidth;
    layer_addr_t readCLast;
    pad_t topPad, downPad;
    s_row_addr_t new_rowAddr;
    s_row_addr_t new_rowNum;
    seq_t reqSeqF;
    layer_addr_t new_kCur;
    layer_addr_t new_kOut;
    layer_addr_t Ks, kt;
    cg_addr_t new_usedGroups;
    res_size_t new_resSize;
    res_size_t new_resReadSize;
    layer_addr_t new_resFrameMax;
    logic doRes, doRelu, doLRelu, doBM, doUpSample, newWriteInst;
    s_feature_t wLRelu;
    //mem_addr_t new_bmLastAddr;
    //mem_addr_t new_bmNextAddr;
    //mem_addr_t new_bmEndAddr;
    //mem_addr_t new_bmBatchStart;
    //mem_addr_t new_bmBatchEnd;
    //bm_size_t new_bmBlockSize;
    //bm_size_t new_bmSkipSize;
    res_len_t new_resLen;
    output_gap_t new_outResGapSize;
    layer_addr_t new_resFrameCount;
    group_t new_resRowCount;
    logic new_isReadResA;
    mem_addr_t new_nextResAddr;
    mem_addr_t new_frameResAddr;
    //mem_addr_t new_resBatchStart;
    layer_addr_t new_kRes;
    loc_frame_t prefetchFrameSize;
    input_addr_t volumeSize;
    input_addr_t curVolumeSize;
    DATA_MODE mode;
    scale_t fScale, wScale;
    input_addr_t new_addrNextFrame;
  
    
    //bm_size_t totalBM;
    res_size_t totalRes;
    cg_addr_t usedGroupsLast;
    cg_addr_t usedCGLast;
    cg_addr_t usedCG0;
    layer_addr_t kCurLast;
    res_size_t resSize0;
    res_size_t resSizeLast;
    res_len_t resLen0;
    res_len_t resLenLast;
    logic new_paramsw;
    weight_addr_t new_nextWeightRead;
    weight_addr_t new_endWeightRead;
    mem_bus_addr_t new_weightReadPos;
    seq_t new_reqSeqW;
    s_row_addr_t rowNum;
    cg_addr_t new_wtotal;
    cg_addr_t wtotal_n;
    weight_bus_size_t wlenk_nLast;
    cg_addr_t wtotalLast;
    weight_bus_size_t wlenk_nLast2;
    //logic batch_only_1group;
   // cg_addr_t wtotal_bn;
   // cg_addr_t wtotalbLast;
    weight_bus_size_t wlenk_regular;
    weight_bus_size_t wlen_regular;
    weight_bus_size_t new_wlenk;
    weight_bus_size_t new_wlenk_last;
    layer_addr_t kCurLast_1;
   // layer_addr_t kbe_1;
    width1_t new_maxRowCount;
    width_t new_lastLen;
    width1_t maxRowCount;
    width_t lastLen;
    logic is_cycle_froze; 
    logic setLoadingFroze, resetLoadingFroze;
    logic resetLoadingNextFeatures, resetReadingFeatures;
    logic inputs_wen;
    logic unsigned [INPUT_ADDR_WIDTH - 1 :0]inputs_waddr;
    s_feature_t [INPUT_MEM_WIDTH - 1 : 0] inputs_wdata;
    logic inputs_ren;
    logic unsigned [INPUT_ADDR_WIDTH - 1 :0]inputs_raddr;
    s_feature_t [INPUT_MEM_WIDTH - 1 : 0] inputs_rdata;
    logic resetAssemble;
    logic inputs_buffer_full, inputs_buffer_empty;
    logic inputs_buffer_wen, inputs_buffer_ren;
    logic inputs_buffer_progfull;
    s_feature_t [INPUT_MEM_WIDTH - 1 : 0] inputs_buffer_wdata, inputs_buffer_rdata;
    logic assemble_buffer_full, assemble_buffer_empty;
    logic assemble_buffer_wen, assemble_buffer_ren;
    s_feature_t [INPUT_MEM_WIDTH - 1 : 0] assemble_buffer_wdata, assemble_buffer_rdata;
`ifdef S2_OPTIMIZE     
    logic [3:0] s2b_addr;
    s_feature_t [INPUT_MEM_WIDTH - 1 : 0] s2b_wdata;
    logic s2b_wen;
    s_feature_t [INPUT_MEM_WIDTH - 1 : 0] s2b_rdata;
`endif    
    logic input_fifo_wen, input_fifo_ren;
    s_feature_t [INPUT_MEM_WIDTH - 1 : 0] input_fifo_wdata, input_fifo_rdata;
    logic input_fifo_full, input_fifo_empty;
    logic sendBackUpInput_valid;
    k_t backupId;
    s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE];
`ifdef S2_OPTIMIZE    
    s_feature_t backupBus[COMPUTING_GROUP_SIZE*2];
`else
    s_feature_t backupBus[COMPUTING_GROUP_SIZE];
`endif    
    logic isBackupValid;
    INPUT_SOURCE input_src;
    s_feature_t shiftInputs[MAX_K];
    logic weights_wen, weights_ren;
    s_weight_t [WEIGHT_BUFFER_SIZE-1:0] weights_wdata, weights_rdata;
    logic weights_full, weights_empty;
    weight_bus_size_t BMlen;
    weight_bus_size_t wlenk;
    logic enSendBMWeights, enSendWeights, isBMWeightValid, isWeightValid;
    s_weight_t weightsBus[WEIGHT_BUS_SIZE];
    //s_weight_t bmWeightBus[WEIGHT_BUS_SIZE];
    logic BM_enough_data, w_enough_data;
    //logic extWeights_empty, extWeights_full, extWeights_almost_full;
    //logic extWeights_wen, extWeights_ren;
    //s_feature_t [BM_READ_WIDTH-1:0] extWeights_wdata, extWeights_rdata;
    logic resBuf_almost_full, resBuf_full, resBuf_empty;
    logic resBuf_wen, resBuf_ren;
    s_feature_t [COMPUTING_GROUP_SIZE-1:0] resBuf_wdata, resBuf_rdata;
    res_size_t receivedRes;
    logic isPrefetchNextVolume_next, isPrefetchNextVolume;
    logic reset_isOnOutput;
    mem_addr_t outputAddr;
    mem_addr_t outputFrameStart;
    logic isOnOutput;
    logic waiting_out;
    logic cgSwitchOutput;
    logic doRes_out, doUpSample_out;
    width_t outputBufW1_out;
    outframe_addr_t outFrameSize_out;
    out_width_t outW_out, outW_out2;
    pad_t maxpool_stride_out;
    output_gap_t outputAddrGap_out;
    pad_t maxpool_stride;
    k_t k_out;
    seq_t curSeq_out;
    logic newWriteInst_out;
    width_t outputBufH1_out;
    logic set_out_params;
    mem_addr_t outputAddr_out, outputFrameStart_out;
    logic set_LastOutput;
    cg_addr_t outputIdxMax;
    layer_addr_t kOut;
    s_feature_t pre_output[CG_NUM][COMPUTING_GROUP_SIZE];
    output_addr_t out_row;
    logic reset_state;
    cg_addr_t weightId;
    logic isOutputReady;
    logic nextWeight;
    width_t readWidth;
    logic doAssemble;
    input_addr_t usedWords;
    logic isInitLayer;
    logic isLReluWeight;
    k_t iterCountDown;
    width_t outputReadPos, outputWritePos;
    width_t outputBufH1;
    logic reset_iLayers;
    logic isNextVolumeReady;
    logic bmPhase;
    logic new_params_readFeatures;
    s_feature_t shift_n[CG_NUM][COMPUTING_GROUP_SIZE];
    s_feature_t shift_s[CG_NUM][COMPUTING_GROUP_SIZE];
    s_mult_t psum_up[CG_NUM][COMPUTING_GROUP_SIZE];
    s_mult_t psum_low[CG_NUM][COMPUTING_GROUP_SIZE];
    logic resetRequestingRes;
    seq_t   reqSeqW;
    logic  loadNextInst;
    
    genvar geni;
    
    assign isStopable = inst_fifo_empty && (state == IDLE);
    assign fifo_srst = ~resetN;
    assign reqFeature = curSeq;
    assign workingSeq = curSeq;
    assign reqWeight  = reqSeqW;

    assign isFetchNextInst = (state == IDLE) || 
			loadNextInst && (!doRes || receivedRes >= totalRes) && ~inst_fifo_empty;
    
    //IBUFG (.O(clock),.I(clock_in));
    
    PushHCBInst pushHCBInst (
	    .enable(inst_enable), 	.inst_in(inst), 
	    .wen(inst_fifo_wen), 	.inst_h(inst_i), 
	    .inst2(instw_i));

    fifo_InstructionHCB fifo_instHCB(
	    .clk(clock)	, 		.srst(fifo_srst), 
	    .din(inst_i), 		.wr_en(inst_fifo_wen), 
	    .rd_en(inst_fifo_ren), 	.dout(inst_o), 
	    .full(instfifo_full), 	.empty(inst_fifo_empty));
            //.wr_rst_busy('x), 		.rd_rst_busy('x));
    fifo_InstructionHCBWt fifo_instHCBWt(
	    .clk(clock), 		.srst(fifo_srst), 
	    .din(instw_i), 		.wr_en(inst_fifo_wen), 
	    .rd_en(instw_fifo_ren), 	.dout(instw_o), 
	    .empty(instw_fifo_empty)); 
    
    ProcessNextWeightLoading processNextWeightLoading(
	    .enable(isRunning), 		.isReadingWeights, 
	    .pibw_empty(instw_fifo_empty), 	.inst(instw_o), 
	    .fifo_en(instw_fifo_ren) , 		.new_params(new_paramsw), 
	    .new_nextWeightRead, 		.new_endWeightRead, 
	    .new_weightReadPos, 		.new_reqSeqW);
    
    ProcessNextFeatureLoading processNextFeatureLoading(
	    .enable(isRunning), 		.isLoadingNextFeatures, 
	    .hasNextFeatureParams, 		.pib_empty(inst_fifo_empty), 
        .pwrite_isFetchNextInst,
	    .inst(inst_o), 			.new_params_prefetch, 
	    .new_readPos, 			.new_writeWidth, 
	    .new_volumeSize, 			.new_reqSeqF);
    
    ProcessInstruction processInstruction (.clock, .resetN, 
	    .enable(isRunning), 		.pwrite_isFetchNextInst, 
	    .pib_empty(inst_fifo_empty), 	.inst(inst_o), 
	    .pib_en(inst_fifo_ren), 		.*);

    inputs_mem inputs (
        .clka(clock), 		.ena(1'b1), 
	    .wea(inputs_wen), 		.addra(inputs_waddr), 
	    .dina(inputs_wdata), 	.clkb(clock), 
	    .enb(inputs_ren), 		.addrb(inputs_raddr), 
	    .doutb(inputs_rdata));
    
    assign new_params_readFeatures = new_params_prefetch || new_conv_inst && ~hasNextFeatureParams;

    ReadFeatures readFeatures (
	    .clock, .resetN, 
	    .pread_busValid, 				.pread_isFeature, 
	    .isReadingFeatures, 			.isLoadingFroze, 
	    .isLoadingNextFeatures, 			.pread_seqNum, 
	    .reqSeqF,					.writeWidth ,
	    .new_params(new_params_readFeatures ),	.readPos,
	    .volumeSize,				.usedWords,
	    .dataBus,					.setLoadingFroze, 
	    .resetLoadingFroze,				.resetLoadingNextFeatures, 
	    .resetReadingFeatures ,			.wen(inputs_wen),
	    .addrOut(inputs_waddr),			.dataOut(inputs_wdata));

    AssembleInputBuffer assembleInputBuffer    (
	    .clock,                         .resetN,		
        .isLoadingNextFeatures,         .isReadingFeatures,
        .doAssemble,                    .inputs_buffer_progfull,
        .nextWritePos (inputs_waddr),   .data_input (inputs_rdata),
        .inputs_wen(inputs_wen),
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
            
    AssembleInput assembleInput(
	    .clock, .resetN,		
	    .doAssemble,                            .inputs_buffer_empty,
	    .buffer_full (assemble_buffer_full),	.readWidth,
	   	.data_input (inputs_buffer_rdata) ,
	    .prefetchFrameSize, 			        .new_param (new_conv_inst),
	    .reset_param (startPrefetching),		.new_addrNextFrame,
	    .curVolumeSize,				            .maxRowCount, 
	    .lastLen,					            .buffer_wen (assemble_buffer_wen),
	    .buffer_data (assemble_buffer_wdata),	.ren (inputs_buffer_ren),
	    .resetAssemble);

    fifo_assemble_buffer assemble_buffer(
	    .clk(clock), 			.srst(fifo_srst), 
	    .din(assemble_buffer_wdata), 	.wr_en(assemble_buffer_wen), 
	    .rd_en(assemble_buffer_ren), 	.dout(assemble_buffer_rdata), 
	    .full(assemble_buffer_full), 	.empty(assemble_buffer_empty)); 
            
    BuildInputFifo buildInputFifo(
	    .clock, .resetN,
	    .state,.readCLast,
 `ifdef S2_OPTIMIZE    
	    .isStride2,			.new_nextRowStart,
	    .new_kIter,			.s2b_a(s2b_addr),
	    .s2b_data_out(s2b_wdata),	.s2b_we(s2b_wen),
	    .s2b_data(s2b_rdata),
`endif    
    
            .outputBufH1,		.downPad, 
	    .topPad,			.k,
	    .stride,			.rowNum,
	    .reset_params(startPrefetching),	.new_params(new_conv_inst), 
	    .reset_iLayers,		.new_rowAddr, 
	    .ab_rd_en(assemble_buffer_ren), 	.ab_data(assemble_buffer_rdata), 
	    .ab_empty(assemble_buffer_empty),	.input_wr_en(input_fifo_wen),
	    .input_data_out(input_fifo_wdata),	.input_full(input_fifo_full));
 
`ifdef S2_OPTIMIZE                
    mem_s2_buffer s2_buffer (
	    .a(s2b_addr), 		.d(s2b_wdata), 
	    .clk(clock), .we(s2b_wen), .spo(s2b_rdata));
`endif 
   
    fifo_assemble_buffer input_fifo(
	    .clk(clock), 		.srst(fifo_srst), 
	    .din(input_fifo_wdata), 	.wr_en(input_fifo_wen), 
	    .rd_en(input_fifo_ren), 	.dout(input_fifo_rdata),
            .full(input_fifo_full), 	.empty(input_fifo_empty)); 
    
    SendBackUpInput sendBackUpInput(
        .clock, .resetN,	.sendBackUpInput_valid(sendBackUpInput_valid && ~is_cycle_froze), 
	    .backupId,		.fifo_data(input_fifo_rdata),
	    .fifo_empty(input_fifo_empty),
`ifdef S2_OPTIMIZE    
    	    .isStride2,

`endif    
            .readWidth,			.leftPad,
	    .rd_en(input_fifo_ren),	.shiftBufBackup, 
	    .backupBus,			.isBackupValid);
    
    SetupShiftInputs setupShiftInputs(
	    .clock, .resetN,	.input_src,
	    .k,			.shiftBufBackup,
	    .shiftInputs);

    fifo_weights weights(
	    .clk(clock), 		.rst(fifo_srst), 
	    .din(weights_wdata), 	.wr_en(weights_wen), 
	    .rd_en(weights_ren), 	.dout(weights_rdata), 
	    .full(weights_full), 	.empty(weights_empty),
	    .prog_full(weights_almost_full));//, wr_rst_busy, rd_rst_busy)
    
    ReadWeights readWeights(
	    .clock, .resetN,		.enable(isRunning), 
	    .pcweight_busValid,		.pcweight_seq,  
	    .new_params(new_paramsw),	.new_weightReadPos,
	    .new_nextWeightRead,	.new_endWeightRead,
	    .new_reqSeqW,		.w_bus(pcweight_dataBus),
	    .writeFifo(weights_wen),	.dataFifo(weights_wdata),
	    .isReadingWeights,          .reqSeqW);

    SendWeights sendWeights(
	    .clock, .resetN,		
        .enSendWeights,     .enSendBMWeights,
        .len(wlenk), 		.bm_len(BMlen),  
        .clearNumBuf(new_conv_inst),
	    .empty_fifo(weights_empty),	.dataFifo(weights_rdata),
        .is_cycle_froze,
	    .ren_fifo(weights_ren),	.weightsBus,
        .bm_enough_data(BM_enough_data),  .enough_data(w_enough_data));
    
    /*SendBMWeights sendBMWeights(
	    .clock, .resetN,			.enSendBMWeights,
	    .len(BMlen),			.empty_fifo(extWeights_empty), 
	    .clearNumBuf(new_conv_inst),	.dataFifo(extWeights_rdata),
	    .ren_fifo(extWeights_ren),		.bmWeightBus,
	    .enough_data(BM_enough_data)); 
    
   
    fifo_bmweights extWeights(
	    .clk(clock), 		.srst(fifo_srst), 
	    .din(extWeights_wdata), 	.wr_en(extWeights_wen), 
	    .rd_en(extWeights_ren), 	.dout(extWeights_rdata),
            .full(extWeights_full),	.empty(extWeights_empty),
	    .prog_full(extWeights_almost_full)); //, wr_rst_busy, rd_rst_busy)
    */
    fifo_resdata resBuf(
	    .clk(clock), 		.rst(fifo_srst), 
	    .din(resBuf_wdata), 	.wr_en(resBuf_wen), 
	    .rd_en(resBuf_ren), 	.dout(resBuf_rdata),
            .full(resBuf_full), 	.empty(resBuf_empty),
	    .prog_full(resBuf_almost_full));//, wr_rst_busy, rd_rst_busy)

    ReadExtraWeights readExtraWeights(
	    .clock, .resetN,			.isReadingFeatures, 
	    .pread_RequestFull,			.isResMaster,
	    .this_token(token), 		.ptoken,
	    .res_full(resBuf_almost_full), 	.doRes,
 `ifdef S2_OPTIMIZE            
            .isStride2,
`endif            
            .mode,				.outputBufW1, 
	    .outputBufH1Orig, 			.outW, 
	    .outFrameSize,			.outputAddrGap, 
	    .outFrameGapSize,			.curSeq(curSeq), 
	    .ks(Ks),				.numGroups,
            .kCurLast, 				.resSize0, 
	    .resSizeLast, 			.resLen0, 
	    .resLenLast, 			.usedGroupsLast,
            .setParam(new_conv_inst),		.new_kRes,
	    .new_isReadResA,			.new_nextResAddr,
	    .new_frameResAddr,			.new_resRowCount,
	    .new_resSize,			.new_resReadSize,
	    .new_resFrameCount,			.new_resFrameMax,
            .new_resLen, 			.new_outResGapSize ,
	    .totalRes, 				.kCurLast_1, 
	    .resetRequestingRes, 
        .resBuf_ren,
	    .enRequest(pread_RequestValid),	.request(pread_request));

    /*ReadBMWeights readBMWeights(
	    .clock, 	.resetN,		.pread_busValid, 
	    .pread_isFeature,			.data(pread_dataBus),
	    .curSeq(curSeq),			.token,
	    .clearReceivedBM(new_conv_inst),	.resetRequestingBM, 
	    .writeFifo(extWeights_wen),		
	    .dataFifo(extWeights_wdata));
      */      
    ReceiveResData receiveResData(
	    .clock, .resetN,			.pread_busValid, 
	    .pread_isFeature,			.data(pread_dataBus),
	    .curSeq(curSeq),			.token,
	    .outputBufW1,			.mode,
	    .resPos,				.resetRequestingRes, 
	    .writeFifo(resBuf_wen), 		.receivedRes,
	    .dataFifo(resBuf_wdata));    
    
    //fifo_bool outBatch3(.clk(clock), .srst(fifo_srst), .din(outBatch3_wdata), .wr_en(outBatch3_wen), .rd_en(outBatch3_ren), .dout(outBatch3_rdata), .full(outBatch3_full), .empty(outBatch3_empty)); 

    StartConvOut start_ConvOut(
	    .clock, .resetN,			.enable(startConvOut),
	    .isNextVolumeReady, 		.isPrefetchNextVolume_next, 
	    .isPrefetchNextVolume,		.reset_isOnOutput, 
	    .kt, 				.ks(Ks),
	    .numGroups,				.k,
            .doRes,				.doUpSample,
	    .outputBufW1,			.outFrameSize,
	    .outW,				.outputAddrGap,
	    .maxpool_stride,			.curSeq, 
	    .newWriteInst,			.outputBufH1Orig, 
	    .outputAddr, 			.outputFrameStart,
            .new_params(new_conv_inst),		.new_kOut, 
	    .usedCGLast, 			.usedCG0, 
	    .kCurLast ,				.isOnOutput,
	    .waiting_out,			.cgSwitchOutput,
	    .doRes_out, 			.doUpSample_out,
	    .outputBufW1_out,			.outFrameSize_out,
	    .outW_out,				.outW_out2, 
	    .maxpool_stride_out,		.outputAddrGap_out,
	    .k_out,				.curSeq_out,
	    .newWriteInst_out,			.outputBufH1_out,
	    .set_out_params,			.outputAddr_out, 
	    .outputFrameStart_out,		.set_LastOutput,
	    .outputIdxMax,			.kOut);
            
    ProcessConvOut processConvOut(
	    .clock, .resetN,			.state,
	    .enable(isRunning),			.isOnOutput,
	    .pwrite_isWritable,			.resBuf_empty,
	    .doRes_out, 			.doUpSample_out,
	    .outputBufW1_out,			.outFrameSize_out,
	    .outW_out,				.outW_out2, 
	    .maxpool_stride_out,		.outputAddrGap_out,
	    .k_out,				.curSeq_out,
	    .newWriteInst_out,			.outputBufH1_out,
	    .outputIdxMax,			.pre_output,
	    .resBuf(resBuf_rdata),		.set_LastOutput,
            .new_params(new_conv_inst),		.new_outputAddr, 
	    .new_outputFrameStart,		.set_out_params,
	    .new_outputAddr_out(outputAddr_out), 	.new_outputFrameStart_out(outputFrameStart_out),
            .res_en(resBuf_ren),		.pwrite_data,
	    .pwrite_enable,			.pwrite_addr,
	    .pwrite_setNextInst,		.out_row,
	    .reset_state,			.outputAddr,
	    .outputFrameStart,			.reset_isOnOutput,
        .finishedSeq );
            
    HCBCtrl #(.id(id)) hcbCtrl(
	    .clock, .resetN,			.enable(start),
	    .stop(stop),			.waiting_out,
	    .k,					.stride,
	    .doBM, 				.doRelu, 
	    .doLRelu, 				.doRes,
	    .isOnOutput, 			.reset_isOnOutput,
            .BM_enough_data, 			.w_enough_data,
	    .receivedRes, 			.totalRes,
	    .input_fifo_empty,			.readCLast,
	    .new_conv_inst,			.Ks, 
	    .kt,				.new_wtotal,
	    .numGroups,				.reset_state,
            .resetLoadingNextFeatures, 		.resetReadingFeatures,
	    .new_params_prefetch,		.setLoadingFroze, 
	    .resetLoadingFroze,			.writeWidth,
	    .resetAssemble,			.new_readWidth,
	    .new_outputBufH1,			.new_rowNum,
	    .prefetchFrameSize,			.new_kCur,
	    .new_usedGroups, 			.inst_k,
	    .kOut, 				.kCurLast, 
	    .usedGroupsLast, 			.wtotal_n, 
	    .wlenk_nLast, 			.wtotalLast, 
	    .wlenk_nLast2, 			.wlenk_regular, 
	    .wlen_regular, 			.new_wlenk, 
	    .new_wlenk_last, 			.kCurLast_1 , 
	    .new_maxRowCount, 			.new_lastLen,
            .startPrefetching,			.startConvOut,
	    .BMlen, 				.wlenk,
	    .enSendBMWeights, 			.enSendWeights, 
	    .isBMWeightValid, 			.isWeightValid,
	    .weightId,				.sendBackUpInput_valid,
	    .backupId,				.isOutputReady,
	    .nextWeight,			.readWidth,
	    .rowNum, 				.reset_iLayers,
	    .loadNextInst, 			.isPrefetchNextVolume_next, 
	    .isPrefetchNextVolume,		.workingProgress_o(workingProgress),
	    .doAssemble_o(doAssemble),
	    .usedWords_o(usedWords),		.isInitLayer_o(isInitLayer), 
	    .isReadingFeatures_o(isReadingFeatures), 		.isLoadingFroze_o(isLoadingFroze),
            .hasNextFeatureParams_o(hasNextFeatureParams), 	.isLoadingNextFeatures_o(isLoadingNextFeatures),
	    .isLReluWeight_o(isLReluWeight), 			.iterCountDown_o(iterCountDown),
            .outputReadPos_o(outputReadPos), 			.outputWritePos_o(outputWritePos), 
	    .state_o(state), 					.state_next_o(state_next), 
	    .outputBufH1_o(outputBufH1), 			.isNextVolumeReady_o(isNextVolumeReady),
            .bmPhase_o(bmPhase), 				.isRunning_o(isRunning), 
	    .maxRowCount, 					.lastLen, 
        .input_src,                     .is_cycle_froze);
            
    always_comb begin
        for(int i = 0; i < CG_NUM-1; i++) begin
        for(int j = 0; j < COMPUTING_GROUP_SIZE; j++) begin
            shift_s[i][j]  = shift_n[i + 1][j];
            psum_low[i][j] = psum_up[i + 1][j];
        end
        end
        for(int j = 0; j < COMPUTING_GROUP_SIZE; j++) begin
            shift_s[CG_NUM-1][j]  = '{default:'0};
            psum_low[CG_NUM-1][j] = '{default:'0};
        end
        /*
        for(int i = 0; i < CG_NUM-1; i++) begin
            shift_s[i]  = shift_n[i + 1];
            psum_low[i] = psum_up[i + 1];
        end
        shift_s[CG_NUM-1]  = '{default:'0};
        psum_low[CG_NUM-1] = '{default:'0};
        */
    end 
    generate
        for (geni=0; geni< CG_NUM; geni = geni + 1) begin : scg
            SCG #(.bid(id), .id(geni),.isBottom(geni == (CG_NUM - 1))) g
            (
                .clock, .resetN,		.state, 
                .isRunning,
		.state_next,			 
		.wscale(wScale),		.k,
		.isInitLayer, 			.doLRelu, 
		.doRelu, 			.bmPhase,
		.isLReluWeight,			.cgSwitchOutput,
		.nextWeight, 			.setConvIndex(new_conv_inst),
`ifdef S2_OPTIMIZE                
                .isStride2,
`else
   		.stride,   
`endif                
                .isBMWeightValid, 		.isWeightValid,
		.wLRelu,			.phcg_weightId(weightId),
		.inst_k, 			.iterCountDown,
        .weightBus(weightsBus),	
		.input_src,			.phcg_backupBus(backupBus),
		.shiftInputs,			.shift_s(shift_s[geni]),
		.psum_low(psum_low[geni]),	.output_ready(isOutputReady), 
		.phcg_backupId(backupId),
		.isBackupValid,			.read_pos(outputReadPos), 
		.write_pos(outputWritePos),	.out_row, 
        .is_cycle_froze,
		.shift_n(shift_n[geni]),	.psum_up(psum_up[geni]),
		.pre_output(pre_output[geni])
            );
        end 
    endgenerate 
/*
    always_comb
    begin
        if(pwrite_enable)
        $write("HCB%d write %x, data %x %x %x %x %x %x %x\n", id, pwrite_addr, pwrite_data[0]
        , pwrite_data[1], pwrite_data[2], pwrite_data[3]
        , pwrite_data[4], pwrite_data[5], pwrite_data[6]);
        if(id == 0) begin
            if(isRunning)
                $write("state %d, layer %d\n", state, hcbCtrl.layerCount);
            if(pcweight_busValid)
            $write("HCB input weight %x %x %x %x %x %x %x %x seq(%d %d), run %d, read %d\n", pcweight_dataBus[0]
                , pcweight_dataBus[1], pcweight_dataBus[2], pcweight_dataBus[3]
                , pcweight_dataBus[4], pcweight_dataBus[5], pcweight_dataBus[6]
                , pcweight_dataBus[7], pcweight_seq, reqSeqW, isRunning, readWeights.isReadingWeights0);
            if(~is_cycle_froze) begin
                if(isBackupValid)
                    $write("HCB backup data id %d, %x %x %x %x %x %x %x\n", backupId
                    , backupBus[0]
                    , backupBus[1], backupBus[2], backupBus[3]
                    , backupBus[4], backupBus[5], backupBus[6]);
                if(isWeightValid)
                $write("HCB weight data id %d, %x %x %x %x %x %x (nb %d)\n", weightId
                    , weightsBus[0]
                    , weightsBus[1], weightsBus[2], weightsBus[3]
                    , weightsBus[4], weightsBus[5], sendWeights.numBuf);
            end
            if(weights_wen)
                $write("weight_fifo write %x %x %x %x\n", weights_wdata[0]
                , weights_wdata[1], weights_wdata[2], weights_wdata[3]);
            if(weights_ren)
                $write("weight_fifo read %x %x %x %x\n", weights_rdata[0]
                , weights_rdata[1], weights_rdata[2], weights_rdata[3]);
            if(input_src == INPUT_E)
                $write("shift %x %x %x %x\n", shiftInputs[0]
                , shiftInputs[1], shiftInputs[2], shiftInputs[3]);
        end
    end*/
endmodule

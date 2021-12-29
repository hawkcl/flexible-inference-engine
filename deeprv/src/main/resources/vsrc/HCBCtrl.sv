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

module GenSendBackUpInput
import definitions_pkg::*;
(
input logic convInit, convStart, convCompute_K1_free, convCompute_K_free, convCompute_S2_free,
input logic input_fifo_empty,
input k_t k,
input k_t initFSteps,
input pad_t stride,
input width_t outputReadPos, outputBufH1,
input logic isLastLayer,
//input logic  wait_k1_feature,
input layer_addr_t readCLast, layerCount,
input k_t iterCountDown,
input logic isPrefetchNext,
output logic sendBackUpInput_valid,
output k_t backupId
);
always_comb
    begin
        sendBackUpInput_valid = 0;
        backupId = 0;
        if(convInit)
        begin
            if(initFSteps < k &&  ~input_fifo_empty)
            begin
                sendBackUpInput_valid = 1;
                backupId = initFSteps;
            end
        end
        else if(convStart)
        begin
            sendBackUpInput_valid = 1;
            if (stride == 1)
                backupId = k - 1;
            else
                backupId = 0;
        end
        else if(convCompute_K1_free)
        begin
            if (outputReadPos < outputBufH1 - 1)
            begin
                if (!isLastLayer && (layerCount != readCLast || outputReadPos < outputBufH1 - 2)) 
                begin
                    sendBackUpInput_valid = 1;
                    backupId = 0;
                end
            end
            else if(outputReadPos == outputBufH1 - 1)
            begin
                if (layerCount < readCLast)
                begin
                    sendBackUpInput_valid = 1;
                    backupId = 0;
                end
            end
            else if (outputReadPos == outputBufH1)
            begin
                if (~isLastLayer)
                begin
                    sendBackUpInput_valid = 1;
                    backupId = 0;
                end
            end
        end
        else if(convCompute_K_free)
        begin
            if (iterCountDown == 0)
            begin
                if (outputReadPos == outputBufH1 - 1)
                begin
                    if (layerCount < readCLast)
                    begin
                        sendBackUpInput_valid = 1;
                        backupId = 0;
                    end
                end
                else if (outputReadPos == outputBufH1)
                begin
                    if (layerCount < readCLast)
                    begin
                        sendBackUpInput_valid = 1;
                        backupId = k - 1;
                    end
                end
                else begin
                    if (~isLastLayer)
                    begin
                        sendBackUpInput_valid = 1;
                        backupId = k - 1;
                    end
                end
            end
            else begin
                if (isPrefetchNext)
                begin
                    sendBackUpInput_valid = 1;
                    backupId = k - iterCountDown;
                end
            end
        end
        else if(convCompute_S2_free)
        begin
            if (iterCountDown == 0)
            begin
                 if (outputReadPos == outputBufH1 - 1)
                 begin
                    if (layerCount < readCLast)
                    begin
                        sendBackUpInput_valid = 1;
                        backupId = 0;
                    end
                end
                else if (outputReadPos == outputBufH1)
                begin
                    if (layerCount < readCLast)
                    begin
                        sendBackUpInput_valid = 1;
                        backupId = 0;
                    end
                end
                else begin
                    if (~isLastLayer)
                    begin
                        sendBackUpInput_valid = 1;
                        backupId = 0;
                    end
                end
            end
            else begin
                 if (~isLastLayer)
                 begin
                     sendBackUpInput_valid = 1;
                     backupId = k - iterCountDown;
                 end
            end
        end
    end
endmodule



module HCBCtrl
import definitions_pkg::*;
#(parameter id = 0)
(
input logic clock, resetN,
input logic enable, stop,
input logic waiting_out,
input k_t k,
input pad_t stride,
input logic doBM, doRelu, doLRelu, doRes,
input logic isOnOutput, reset_isOnOutput, // finished one output
input logic BM_enough_data, w_enough_data,
input res_size_t receivedRes, totalRes,
input logic input_fifo_empty,
input layer_addr_t readCLast,
input logic new_conv_inst,
input layer_addr_t Ks, kt,
input cg_addr_t new_wtotal,
input cg_addr_t numGroups,
//input logic doBatch3K1,
input logic reset_state, resetLoadingNextFeatures, resetReadingFeatures,
input logic new_params_prefetch,
input logic setLoadingFroze, resetLoadingFroze,
input width_t writeWidth,
input logic resetAssemble,
input width_t new_readWidth,
input width_t new_outputBufH1,
input s_row_addr_t new_rowNum,
//input batch_t batchSize,
input loc_frame_t prefetchFrameSize,
input layer_addr_t new_kCur,
input cg_addr_t new_usedGroups,
input k_t inst_k,
input layer_addr_t kOut,
input layer_addr_t kCurLast,
input cg_addr_t usedGroupsLast,
input cg_addr_t wtotal_n,
input weight_bus_size_t wlenk_nLast,
input cg_addr_t wtotalLast,
input weight_bus_size_t wlenk_nLast2,
//input logic batch_only_1group,
//input cg_addr_t wtotal_bn,
//input weight_bus_size_t wlenk_bLast,
//input cg_addr_t wtotalbLast,
//input weight_bus_size_t wlenk_bLast2,
input weight_bus_size_t wlenk_regular,
input weight_bus_size_t wlen_regular,
input weight_bus_size_t new_wlenk,
input weight_bus_size_t new_wlenk_last,
input layer_addr_t kCurLast_1,
//input layer_addr_t kbe_1,
input width1_t new_maxRowCount,
input width_t new_lastLen,

output logic startPrefetching, startConvOut, 
output weight_bus_size_t BMlen, 
output weight_bus_size_t wlenk,
output logic enSendBMWeights, enSendWeights, isBMWeightValid, isWeightValid,
output cg_addr_t weightId,
output logic sendBackUpInput_valid,
output k_t backupId,
output logic isOutputReady,
output logic nextWeight,
output width_t readWidth,
output s_row_addr_t rowNum,
//output logic doBatch3K1_cur_o, 
output logic reset_iLayers,
output logic loadNextInst,
output logic isPrefetchNextVolume_next, isPrefetchNextVolume,
output layer_addr_t workingProgress_o,
output logic doAssemble_o,
output input_addr_t usedWords_o,
output logic isInitLayer_o, isReadingFeatures_o, isLoadingFroze_o,
output logic hasNextFeatureParams_o, isLoadingNextFeatures_o,
output logic isLReluWeight_o,
output k_t iterCountDown_o,
output width_t outputReadPos_o, outputWritePos_o,
output HCB_STATE state_o, state_next_o,
output width_t outputBufH1_o,
output logic isNextVolumeReady_o,
output logic bmPhase_o,
output logic isRunning_o,
output logic is_cycle_froze,
output width1_t maxRowCount,
output width_t lastLen,
output INPUT_SOURCE input_src
//output int flag
);


    logic doAssemble, doAssemble_next;
    layer_addr_t outLayerCount, outLayerCount_next;
    layer_addr_t workingProgress, workingProgress_next; 
    width_t outputBufH1, outputBufH1_next;
    width_t outputBufH1Relu, outputBufH1Relu_next;
    width_t frameCountDown, frameCountDown_next;
    logic unsigned [1:0] outBufferUseCount, outBufferUseCount_next;
    layer_addr_t kCur, kCur_next; 
    input_addr_t usedWords, usedWords_next;
    input_addr_t usedWords_inc, usedWords_inc_next;
    logic usedWords_reset, usedWords_reset_next;
    k_t initFSteps, initFSteps_next;
    cg_addr_t initWSteps, initWSteps_next; 
    cg_addr_t initBMWSteps, initBMWSteps_next;
    width_t outputCountDown, outputCountDown_next;  // max 2 * k + 1
    width_t outputReadPos, outputReadPos_next;
    width_t outputWritePos, outputWritePos_next;
    k_t iterCountDown, iterCountDown_next;
(* MARK_DEBUG="true" *)    layer_addr_t layerCount; 
    layer_addr_t layerCount_next; 
    //cg_addr_t usedCG, usedCG_next; 
    cg_addr_t usedGroups, usedGroups_next;
//    logic doBatch3K1_cur, doBatch3K1_cur_next;
    logic bmPhase, bmPhase_next;
    //logic isWeightMaster, isWeightMaster_next;
    logic isRunning, isRunning_next;
    logic isInitLayer, isInitLayer_next;
    logic isLastLayer, isLastLayer_next;
    logic isPrefetchNext, isPrefetchNext_next;
    logic isReadingFeatures, isReadingFeatures_next;
    logic isPrefetchWeight, isPrefetchWeight_next;
    logic isPrefetchBMWeight, isPrefetchBMWeight_next;
    logic isLReluInit, isLReluInit_next;
    logic isLoadingNextFeatures, isLoadingNextFeatures_next;
    //logic isLoadingNextWeights, isLoadingNextWeights_next;
    logic hasNextFeatureParams, hasNextFeatureParams_next;
    logic isLoadingFroze, isLoadingFroze_next;
    logic loadNextInst0, loadNextInst_next;
    logic isLReluWeight, isLReluWeight_next;
    logic isPrefetchNextVolume0, isPrefetchNextVolume0_next;
    logic isNextVolumeReady, isNextVolumeReady_next;
    HCB_STATE state;
    HCB_STATE state_next;
    width_t readWidth0, readWidth0_next;
    width_t lastLen0, lastLen0_next;
    width1_t maxRowCount0, maxRowCount0_next;
    s_row_addr_t rowNum0, rowNum0_next;
    weight_bus_size_t wlenk_last, wlenk_last_next;
    
    logic convInit, convStart, convCompute, convBM, convRelu;
    logic convCompute_K1, convCompute_K, convCompute_S2;
    logic convCompute_K1_free, convCompute_K_free, convCompute_S2_free;
    logic convCompute_done, convCompute_lastLayer;
    weight_bus_size_t BMlen0, wlen, wlen0;
    weight_bus_size_t wlenk0;
    cg_addr_t wtotal, wtotal0;
    logic convInitDone;
    logic FDone;
    logic is_cycle_froze_weight;
    logic is_cycle_froze_feature;
    //logic wait_k1_feature;
    
    //assign wait_k1_feature = (/*k == 1 && */isReadingFeatures && !isLoadingNextFeatures);
    //assign wait_k1_feature = (isReadingFeatures && !isLoadingNextFeatures);
    assign iterCountDown_o = iterCountDown;
    assign isRunning_o = isRunning;
    assign bmPhase_o = bmPhase;
    assign isNextVolumeReady_o = isNextVolumeReady;
    assign outputBufH1_o = outputBufH1;
    assign state_o = state;
    assign state_next_o = state_next;
    assign outputReadPos_o = outputReadPos;
    assign outputWritePos_o = outputWritePos;
    assign isLReluWeight_o = isLReluWeight;
    assign isLoadingNextFeatures_o = isLoadingNextFeatures;
    assign hasNextFeatureParams_o = hasNextFeatureParams;
    assign isReadingFeatures_o = isReadingFeatures;
    assign isLoadingFroze_o = isLoadingFroze;
    assign isInitLayer_o = isInitLayer;
    assign usedWords_o = usedWords;
    assign doAssemble_o = doAssemble;
    assign workingProgress_o = workingProgress;
    assign readWidth = readWidth0;
    assign maxRowCount = maxRowCount0;
    assign lastLen = lastLen0;
    assign rowNum = rowNum0;
//    assign doBatch3K1_cur_o = doBatch3K1_cur;
    assign loadNextInst = loadNextInst0;
    assign isPrefetchNextVolume = isPrefetchNextVolume0;
    assign isPrefetchNextVolume_next = isPrefetchNextVolume0_next;
    assign convInit =  isRunning && (state == CONV_INIT || isPrefetchNextVolume0); 
    //assign convInitDone = convInit && (initFSteps_next == k) && (initWSteps_next == wtotal);
    assign convInitDone = convInit && FDone && (initWSteps == wtotal);// && !(initFSteps < k && wait_k1_feature && input_fifo_empty);
    assign FDone = (initFSteps == k) || (initFSteps == (k - 1)) && ~input_fifo_empty ; 
		// && !(wait_k1_feature);
    assign convStart =  isRunning && (state == CONV_START && outBufferUseCount < OUT_BUFFER_COUNT && ~input_fifo_empty);
    assign convCompute =  isRunning && (state == CONV_MULT && ~waiting_out) && ~is_cycle_froze;
    assign convBM =  isRunning && (state == CONV_BM && ~waiting_out) && ~isPrefetchBMWeight && ~isLReluInit;
    assign convRelu =  isRunning && (state == CONV_RELU && ~waiting_out) && ~isLReluInit;
    assign convCompute_K1_free = isRunning && (state == CONV_MULT && ~waiting_out) && (k == 1);
    assign convCompute_K_free = isRunning && (state == CONV_MULT && ~waiting_out) && (k != 1) && (stride == 1);
    assign convCompute_S2_free = isRunning && (state == CONV_MULT && ~waiting_out) && (k != 1) && (stride == 2);
    assign convCompute_K1 = convCompute && (k == 1);
    assign convCompute_K = convCompute && (k != 1) && (stride == 1);
    assign convCompute_S2 = convCompute && (k != 1) && (stride == 2);
    assign convCompute_lastLayer = convCompute && (outputCountDown == 0) && isLastLayer;
    assign convCompute_done = convCompute_lastLayer && (outputWritePos == outputBufH1);
    assign startPrefetching = (convCompute_done && ~doBM) || (isRunning && (state == CONV_BM && ~waiting_out) && ~isPrefetchBMWeight && isLReluInit);
    //assign startPrefetching = convCompute_done;
    assign startConvOut = (convCompute_done && ~doBM && ~doRelu && ~doLRelu) 
                           || (convBM && ~bmPhase && (outputReadPos != 0 || outputWritePos != 0) && (outputWritePos == outputBufH1) && ~doRelu && ~doLRelu)
                           || (convRelu && (outputWritePos == outputBufH1Relu)) || isRunning && ~isOnOutput && waiting_out;
    assign isOutputReady = (convCompute && (outputCountDown == 0)) || (convBM && ~bmPhase && (outputReadPos != 0 || outputWritePos != 0)) || (convRelu && (outputReadPos != 0));
    assign nextWeight = convStart || (isRunning && isPrefetchBMWeight && ~is_cycle_froze && (initBMWSteps >= usedGroups) && (state == CONV_BM || state_next == CONV_BM))
                    || (convCompute && (outputCountDown == 0) && isLastLayer && (outputWritePos == outputBufH1) && doBM && ~isPrefetchBMWeight)
                    || (convCompute_K1 && (outputReadPos == outputBufH1 - 1) && (layerCount < readCLast))
                    || (convCompute_K && (iterCountDown == 0) && (outputReadPos == outputBufH1) && (layerCount < readCLast))
                    || (convCompute_S2 && (iterCountDown == 0) && (outputReadPos == outputBufH1) && (layerCount < readCLast));
    assign is_cycle_froze = isRunning && (state == CONV_MULT && ~waiting_out) &&
                            (is_cycle_froze_weight || is_cycle_froze_feature);
    assign is_cycle_froze_weight = isPrefetchWeight && (initWSteps != wtotal) && !w_enough_data; ;
    assign is_cycle_froze_feature = sendBackUpInput_valid && input_fifo_empty;
    
    always_ff @(posedge clock)
    if(!is_cycle_froze)
        weightId <= enSendBMWeights ? initBMWSteps : initWSteps;
    //processBMWeights
    //assign BMlen = BMlen0;
    always_ff @(posedge clock)
       if (!resetN)
           BMlen <= '0;
       else
           BMlen <= BMlen0;
    assign enSendBMWeights = isRunning && isPrefetchBMWeight && ~is_cycle_froze && (initBMWSteps < usedGroups) && BM_enough_data;
    //assign isBMWeightValid = enSendBMWeights;
    always_ff @(posedge clock)
        if(!is_cycle_froze)
        isBMWeightValid <= enSendBMWeights;
    
    //sendWeights
    //assign wlen = wlen0;
    always_ff @(posedge clock)
       if (!resetN)
           {wlen, wtotal, wlenk, wlenk_last} <= '0;
       else
          {wlen, wtotal, wlenk, wlenk_last} <= {wlen0, wtotal0, wlenk0, wlenk_last_next};
    assign enSendWeights = convInit && (initWSteps < wtotal) && !(initFSteps < k && input_fifo_empty) && w_enough_data 
    || convCompute && isPrefetchWeight && (initWSteps < wtotal) && (initFSteps >= k || ~input_fifo_empty) && w_enough_data;
    //assign isWeightValid = enSendWeights;
    always_ff @(posedge clock)
        if(!is_cycle_froze)
        isWeightValid <= enSendWeights;
    
    //sendBackUpInput
    GenSendBackUpInput sendBkpInput(.*);
    
    always_comb
    begin
        initFSteps_next = initFSteps;
        if(new_conv_inst || startPrefetching)
            initFSteps_next = 0;
        else if(convInit)
        begin
            if (initFSteps < k &&  ~input_fifo_empty)
            begin
                initFSteps_next = initFSteps + 1;
            end
       end
    end
    
    
    always_comb
    begin
       wlenk_last_next = wlenk_last;
       wlen0 = wlen;
       wtotal0 = wtotal;
       wlenk0 = wlenk;
       initWSteps_next = initWSteps;
       if(new_conv_inst)
       begin
           wtotal0 = new_wtotal;
           wlen0 = GetWLen(new_wtotal, 0, inst_k);
           wlenk0 = new_wlenk;
           wlenk_last_next = new_wlenk_last;
           initWSteps_next = 0;
       end
       else if(startPrefetching) begin
            initWSteps_next = 0;
            if (kCur < kCurLast) begin
                if (kCur == kCurLast_1) begin
                    wtotal0 = wtotalLast;
                    wlen0 = GetWLen(wtotalLast, 0, k);
                    wlenk_last_next = wlenk_nLast2;
                    if (wlen0 == wlen_regular)
                        wlenk0 = wlenk_regular;
                    else
                        wlenk0 = wlenk_nLast2;
                    //wlenk0 = wlenkLast;
                end
                else begin
                    wtotal0 = wtotal_n;
                    wlen0 = GetWLen(wtotal_n, 0, k);
                    //wlenk0 = wlenk_n;
                    wlenk_last_next = wlenk_nLast;
                    if (wlen0 == wlen_regular)
                        wlenk0 = wlenk_regular;
                    else
                        wlenk0 = wlenk_nLast;
                end
            end
//            else if(doBatch3K1) begin
//                if (batch_only_1group && !doBatch3K1_cur || !batch_only_1group && kCur <= kbe_1)
//                begin
//                    if (batch_only_1group || kCur == kbe_1) begin
//                        wtotal0 = wtotalbLast;
//                        wlen0 = GetWLen(wtotalbLast, 0, k);
//                        //wlenk0 = wlenkbLast;
//                        wlenk_last_next = wlenk_bLast2;
//                        if (wlen0 == wlen_regular)
//                            wlenk0 = wlenk_regular;
//                        else
//                            wlenk0 = wlenk_bLast2;
//                    end
//                    else begin
//                        wtotal0 = wtotal_bn;
//                        wlen0 = GetWLen(wtotal_bn, 0, k);
//                        //wlenk0 = wlenk_bn;
//                        wlenk_last_next = wlenk_bLast;
//                        if (wlen0 == wlen_regular)
//                            wlenk0 = wlenk_regular;
//                        else
//                            wlenk0 = wlenk_bLast;
//                    end
//                end
//            end
        end
        else if(convStart || (convCompute_K1 && (outputReadPos == outputBufH1 - 1) && (layerCount < readCLast))
            || (convCompute_K && (iterCountDown == 0) && (outputReadPos == outputBufH1) && (layerCount < readCLast))
            || (convCompute_S2 && (iterCountDown == 0) && (outputReadPos == outputBufH1) && (layerCount < readCLast)))
        begin
            initWSteps_next = 0;
                if(convStart || layerCount < readCLast - 1) begin
                    wlen0 = GetWLen(wtotal, 0, k);
                    if (wlen0 == wlen_regular)
                    wlenk0 = wlenk_regular;
                    else
                    wlenk0 = wlenk_last;
                end
        end
        else if(convInit && !((initFSteps < k && input_fifo_empty)) || isPrefetchWeight && convCompute)
        begin
            if (initWSteps < wtotal && w_enough_data)
            begin
                initWSteps_next = initWSteps + wlen;
                wlen0 = GetWLen(wtotal, initWSteps_next, k);
                //wlenk0 = wlen0 * k;
		if (wlen0 == 0) begin
			wlenk0 = 0; end
		else if (wlen0 == wlen_regular) begin
			wlenk0 = wlenk_regular; end
		else begin
			wlenk0 = wlenk_last; end
            end
       end
    end
    
    always_comb
    begin
        BMlen0 = BMlen;
        initBMWSteps_next = initBMWSteps;
        isPrefetchBMWeight_next = isPrefetchBMWeight;
        if(convCompute_K1 && (outputReadPos == outputBufH1 - 1) && (layerCount < readCLast)
           || (convCompute_K && (iterCountDown == 0) && (outputReadPos == outputBufH1) && (layerCount < readCLast))
           || (convCompute_S2 && (iterCountDown == 0) && (outputReadPos == outputBufH1) && (layerCount < readCLast)))
        begin
            initBMWSteps_next = 0;
            if (layerCount == readCLast - 1 && doBM)
                isPrefetchBMWeight_next = 1;
            BMlen0 = GetBMWLen(usedGroups, 0);
        end
        else if(isRunning && isPrefetchBMWeight&& ~is_cycle_froze)
        begin
            if(initBMWSteps >= usedGroups)
                isPrefetchBMWeight_next = 0;
            else
            begin
               if(BM_enough_data) begin
                    initBMWSteps_next = initBMWSteps + BMlen;
                    BMlen0 = GetBMWLen(usedGroups, initBMWSteps_next);
               end
            end
        end
    end
    
    always_comb
    begin
        isPrefetchNextVolume0_next = isPrefetchNextVolume0;
        if(convInitDone && isPrefetchNextVolume0)
            isPrefetchNextVolume0_next = 0;
        else if(startPrefetching)
        begin
            if (kCur < kCurLast)
                isPrefetchNextVolume0_next = 1;
//            else if(doBatch3K1) begin
//                 if (batch_only_1group && !doBatch3K1_cur || !batch_only_1group && kCur <= kbe_1)
//                    isPrefetchNextVolume0_next = 1;
//            end
        end
    end
    
    always_comb
    begin
        doAssemble_next = doAssemble;
        if(resetAssemble)
            doAssemble_next = 0;
        else if(new_conv_inst)
            doAssemble_next = 1;
        else if(startPrefetching)
        begin
            if (kCur < kCurLast)
                doAssemble_next = 1;
//            else if(doBatch3K1) begin
//                if (batch_only_1group && !doBatch3K1_cur || !batch_only_1group && kCur <= kbe_1)
//                    doAssemble_next = 1;
//            end
        end
    end
    
    always_comb
    begin
        isNextVolumeReady_next = isNextVolumeReady;
        if(convInitDone && isPrefetchNextVolume0)
            isNextVolumeReady_next = 1;
        else if(convStart)
            isNextVolumeReady_next = 0;
    end
    
    always_comb
    begin
        usedWords_next = usedWords + usedWords_inc;
        usedWords_inc_next = 0;
        usedWords_reset_next = 0;
        if((convCompute_K1 && (outputReadPos < outputBufH1 - 1) && (frameCountDown == 0) && isLoadingNextFeatures)
            || (convCompute_K1 && (outputReadPos == outputBufH1) && ~isLastLayer&& (frameCountDown == 0) && isLoadingNextFeatures)
            || (convCompute_K && (iterCountDown == 0) && (outputReadPos == outputBufH1) && isLoadingNextFeatures)
            || (convCompute_S2 && (iterCountDown == 0) && (outputReadPos == outputBufH1) && isLoadingNextFeatures))
            //usedWords_next = usedWords + prefetchFrameSize;
            usedWords_inc_next = prefetchFrameSize;
        else if(startPrefetching) begin
            if (kCur < kCurLast) begin
                if (kCur == kCurLast_1)
                    //if (~doBatch3K1)
                        usedWords_reset_next = 1;
            end
//            else if(doBatch3K1) begin
//                 if (batch_only_1group && !doBatch3K1_cur || !batch_only_1group && kCur <= kbe_1)
//                    if (batch_only_1group || kCur == kbe_1)
//                        usedWords_reset_next = 1;
//            end
        end
    end
    
    always_comb
    begin
        isLoadingNextFeatures_next = isLoadingNextFeatures;
        if(new_conv_inst)
            isLoadingNextFeatures_next = 0;
        else if(resetLoadingNextFeatures)
            isLoadingNextFeatures_next = 0;
        else if(startPrefetching) begin
            if (kCur < kCurLast) begin
                if (kCur == kCurLast_1)
                   // if (~doBatch3K1)
                        isLoadingNextFeatures_next = 1;
            end
//            else if(doBatch3K1) begin
//                if (batch_only_1group && !doBatch3K1_cur || !batch_only_1group && kCur <= kbe_1)
//                    if (batch_only_1group || kCur == kbe_1)
//                        isLoadingNextFeatures_next = 1;
//            end
        end
    end
    
    always_comb
    begin
        isReadingFeatures_next = isReadingFeatures;
        if(resetReadingFeatures)
            isReadingFeatures_next = 0;
        else if (isLoadingNextFeatures_next && hasNextFeatureParams && (
            (!doRes || receivedRes >= totalRes)))
            isReadingFeatures_next = 1;
        else if (new_params_prefetch && (
            (!doRes || receivedRes >= totalRes)))
            isReadingFeatures_next = 1;
        else if(new_conv_inst) begin
            if (hasNextFeatureParams) begin
                if (isLoadingNextFeatures && ~isReadingFeatures)
                    isReadingFeatures_next = 1;
            end
            else
                isReadingFeatures_next = 1;
        end
    end
    
    always_comb
    begin
        isLoadingFroze_next = isLoadingFroze;
        if(setLoadingFroze)
            isLoadingFroze_next = 1;
        else if(resetLoadingFroze) 
            isLoadingFroze_next = 0;
        else if (new_params_prefetch && (
            (!doRes || receivedRes >= totalRes))) 
        begin
            if (usedWords < writeWidth) 
                isLoadingFroze_next = 1;
            else
                isLoadingFroze_next = 0;
        end
        else if(startPrefetching) begin
            if (kCur  < kCurLast) begin
                if (kCur == kCurLast_1)
                    //if (~doBatch3K1)
                        isLoadingFroze_next = 1;
            end
//            else if(doBatch3K1) begin
//                 if (batch_only_1group && !doBatch3K1_cur || !batch_only_1group && kCur <= kbe_1)
//                    if (batch_only_1group || kCur == kbe_1)
//                        isLoadingFroze_next = 1;
//            end
        end
    end
    
    always_comb
    begin
//        doBatch3K1_cur_next = doBatch3K1_cur;
        readWidth0_next = readWidth0;
        outputBufH1_next = outputBufH1;
        rowNum0_next = rowNum0;
        maxRowCount0_next = maxRowCount0;
        lastLen0_next = lastLen0;
        if(new_conv_inst)
        begin
//           doBatch3K1_cur_next = 0;
           readWidth0_next = new_readWidth;
           outputBufH1_next = new_outputBufH1;
           rowNum0_next = new_rowNum;
           maxRowCount0_next = new_maxRowCount;
           lastLen0_next = new_lastLen;
        end
//        else if(startPrefetching)
//           if((kCur >= kCurLast) && doBatch3K1)
//           begin
//               if (~doBatch3K1_cur) begin
//                    doBatch3K1_cur_next = 1;
//                    readWidth0_next = readWidth0 * 3;
//                end
//                outputBufH1_next = batchSize;
//                rowNum0_next = batchSize;
//           end
    end
    
    always_comb
    begin
       kCur_next = kCur;
       usedGroups_next = usedGroups;
       if(new_conv_inst)
       begin
           kCur_next = new_kCur;
           usedGroups_next = new_usedGroups;
       end
       else if(startPrefetching) begin
            if (kCur < kCurLast) begin
                kCur_next = kCur + numGroups + Ks;
                if (kCur == kCurLast_1)
                    usedGroups_next = usedGroupsLast;
                else
                    usedGroups_next = numGroups;
            end
//            else if(doBatch3K1) begin
//                if (~doBatch3K1_cur)
//                    kCur_next = kbh;
//                else
//                    kCur_next = kCur + numGroups / 3;
//                if (batch_only_1group && !doBatch3K1_cur || !batch_only_1group && kCur <= kbe_1)
//                begin
//                    if (batch_only_1group || kCur == kbe_1)
//                        usedGroups_next = wtotalbLast;
//                    else
//                        usedGroups_next = wtotal_bn;
//                end
//            end
        end
    end
    
    always_comb
    begin
       reset_iLayers = 0;
       if(startPrefetching) begin
            if (kCur  < kCurLast) begin
                reset_iLayers = 1;
            end
//            else if(doBatch3K1) begin
//                if (batch_only_1group && !doBatch3K1_cur || !batch_only_1group && kCur <= kbe_1)
//                begin
//                    reset_iLayers = 1;
//                end
//            end
        end
    end
    
    always_comb
    begin
       outputBufH1Relu_next = outputBufH1Relu;
       if(startPrefetching)
           outputBufH1Relu_next = outputBufH1;
    end
    
    always_comb
    begin
       isRunning_next = isRunning;
       if(enable)
           isRunning_next = 1;
       if(stop)
           isRunning_next = 0;
    end
    
    always_comb
    begin
        workingProgress_next = workingProgress;
        //if(new_conv_inst)
        //    workingProgress_next = 0;
        //else 
        if(reset_isOnOutput)
            workingProgress_next = kOut;
    end
    
    always_comb
    begin
        loadNextInst_next = loadNextInst0;
        if(new_conv_inst)
            loadNextInst_next = 0;
        else if(startConvOut && ~isOnOutput && ~isNextVolumeReady && ~isPrefetchNextVolume0 && ~isPrefetchNextVolume0_next)
            loadNextInst_next = 1;
    end
    
    always_comb
    begin
        hasNextFeatureParams_next = hasNextFeatureParams;
        if(new_conv_inst)
            hasNextFeatureParams_next = 0;
        else if(new_params_prefetch)
            hasNextFeatureParams_next = 1;
    end
    
    always_comb
    begin
        outBufferUseCount_next = outBufferUseCount;
        if(convStart)
        begin
            if(~reset_isOnOutput)
                outBufferUseCount_next = outBufferUseCount + 1;
        end
        else if(reset_isOnOutput)
            outBufferUseCount_next = outBufferUseCount - 1;
    end
    
    always_comb
    begin
        state_next = state;
        if(new_conv_inst)
            state_next = CONV_INIT;
        else if(startConvOut && ~isOnOutput && isNextVolumeReady && (state != CONV_START)) //startConvOut conflict with convCompute_done, process it first
            state_next = CONV_START;
        else if(startConvOut && ~isOnOutput && ~isNextVolumeReady)
            state_next = CONV_OUT;
        else if(isRunning && isOnOutput && isNextVolumeReady && state == CONV_OUT)
            state_next = CONV_START;
        else if(isRunning && isOnOutput && reset_state) 
            state_next = IDLE;
        else if(convInitDone && (state == CONV_INIT || state == CONV_OUT))
            state_next = CONV_START;
        else if(convStart)
            state_next = CONV_MULT;
        else if(convCompute_done) begin
            if (doBM)
                state_next = CONV_BM;
            else if(doRelu || doLRelu)
                state_next = CONV_RELU;
        end
        else if(convBM &&  ~bmPhase && (!outputReadPos || !outputWritePos) && (outputWritePos == outputBufH1) && (doRelu || doLRelu))
            state_next = CONV_RELU;
    end
    
    always_comb
    begin
        {frameCountDown_next,iterCountDown_next,layerCount_next,outLayerCount_next,outputCountDown_next} = {frameCountDown,iterCountDown,layerCount,outLayerCount,outputCountDown};
        {outputReadPos_next,outputWritePos_next,bmPhase_next,isInitLayer_next,isLastLayer_next} = {outputReadPos,outputWritePos,bmPhase,isInitLayer,isLastLayer};
        {isPrefetchNext_next,isPrefetchWeight_next,isLReluInit_next,isLReluWeight_next} = {isPrefetchNext,isPrefetchWeight,isLReluInit,isLReluWeight};
	input_src = INPUT_NON;
           
           if (state == CONV_START && outBufferUseCount < OUT_BUFFER_COUNT && ~input_fifo_empty)
        begin
            if (k == 1)
                outputCountDown_next = 2;
            else
                outputCountDown_next = k + k + 1;
	    input_src = INPUT_BACKUP;
            outputWritePos_next = 0;
            outputReadPos_next = 0;
            layerCount_next = 0;
            isInitLayer_next = 1;
            isLastLayer_next = 0;//assume more than one layer
            isPrefetchWeight_next = 1;
            outLayerCount_next = 0;
            iterCountDown_next = k - 1;
            frameCountDown_next = outputBufH1 - 2;
        end
        else if (state == CONV_MULT&& ~waiting_out && ~is_cycle_froze)
        begin
            if (isPrefetchWeight)
            begin
                if (initWSteps == wtotal)
                    isPrefetchWeight_next = 0;// low priority compare the other assignments
    
            end
    
            if (outputCountDown == 0)
            begin
                outputCountDown_next = k - 1;
                if (isLastLayer)
                begin
                    if (outputWritePos == outputBufH1)
                    begin
                        if (doBM)
                        begin
                            bmPhase_next = 0;
                            isLReluInit_next = 1;
                        end
                        else if (doRelu || doLRelu)
                        begin
                            if (doLRelu)
                                isLReluWeight_next = 1;
                            isLReluInit_next = 1;
                        end
                    end
                end
                if (outputWritePos == outputBufH1)
                begin //TODO: move this to latches after outputCountDown 0
                    outputWritePos_next = 0;
                    outLayerCount_next = outLayerCount + 1;
                end
                else
                    outputWritePos_next = outputWritePos + 1;
    
            end
            else
                outputCountDown_next = outputCountDown - 1;
            if (k == 1)
            begin
                if (outputReadPos < outputBufH1 - 1)
                begin
		    input_src = INPUT_BACKUP;
                    if (frameCountDown == 0)
                        frameCountDown_next = outputBufH1;
                    else
                        frameCountDown_next = frameCountDown - 1;
                    if (outputCountDown != 2)//skip the first cycle for reading psum
                        outputReadPos_next = outputReadPos + 1;
                end
                else if (outputReadPos == outputBufH1 - 1)
                begin//starting next frame
                    if (layerCount < readCLast)
                    begin
			input_src = INPUT_BACKUP;
                        if (layerCount == readCLast - 1)
                            isPrefetchWeight_next = 0;
                        else
                            isPrefetchWeight_next = 1;
                    end
                    else if (layerCount == readCLast)
                        isLastLayer_next = 1;
                    frameCountDown_next = frameCountDown - 1;
                    layerCount_next = layerCount + 1;
		    input_src = INPUT_BACKUP;
                    outputReadPos_next = outputReadPos + 1;
                end
                else if (outputReadPos == outputBufH1)
                begin//starting next frame
                    outputReadPos_next = 0;
                    isInitLayer_next = 0;
                    if (~isLastLayer)
                    begin
                        if (frameCountDown == 0)
                            frameCountDown_next = outputBufH1;
                        else
                            frameCountDown_next = frameCountDown - 1;
		        input_src = INPUT_BACKUP;
                    end
                end
            end
            else
            begin //k > 1
                if (stride == 1)
                begin 
                    if (iterCountDown == 0)
                    begin
                        iterCountDown_next = k - 1;
                        if (outputReadPos == outputBufH1 - 1)
                        begin//starting next frame
                            if (layerCount < readCLast)
                                isPrefetchNext_next = 1;
			    input_src = INPUT_S;
                            outputReadPos_next = outputReadPos + 1;
                        end
                        else if (outputReadPos == outputBufH1)
                        begin//starting next frame
                            isInitLayer_next = 0;
                            if (layerCount < readCLast)
                            begin
				input_src = INPUT_BACKUP;
                                if (layerCount == readCLast - 1)
                                    isPrefetchWeight_next = 0;
                                else
                                    isPrefetchWeight_next = 1;
                            end
                            else if (layerCount == readCLast)
                                isLastLayer_next = 1;
                            layerCount_next = layerCount + 1;
                            outputReadPos_next = 0;
                            isPrefetchNext_next = 0;
                        end
			else begin
			    input_src = INPUT_S;
                            outputReadPos_next = outputReadPos + 1;
			end
                    end
		    else begin
			if (!isLastLayer)
			    input_src = INPUT_E;
                        iterCountDown_next  = iterCountDown - 1;
		    end
                end
                else
                begin //stride > 1
                    if (iterCountDown == 0)
                    begin
                        iterCountDown_next = k - 1;
			input_src = INPUT_BACKUP;
                        if (outputReadPos == outputBufH1 - 1)
                        begin//starting next frame
                            if (layerCount == readCLast)
                                isLastLayer_next = 1;
                            outputReadPos_next = outputReadPos + 1;
                        end
                        else if (outputReadPos == outputBufH1)
                        begin//starting next frame
                            isInitLayer_next = 0;
                            if (layerCount < readCLast)
                            begin
                                if (layerCount == readCLast - 1)
                                    isPrefetchWeight_next = 0;
                                else
                                    isPrefetchWeight_next = 1;
                            end
                            else if (layerCount == readCLast)
                                isLastLayer_next = 1;
                            layerCount_next = layerCount + 1;
                            outputReadPos_next = 0;
                        end
                        else
                            outputReadPos_next = outputReadPos + 1;
                    end
                    else begin
			input_src = INPUT_E;
                        iterCountDown_next = iterCountDown - 1;
		    end
                end
            end
        end
        else if (state == CONV_BM && ~waiting_out && ~isPrefetchBMWeight)
        begin// after BM, start waiting out, and do not want to do BM again.
            if (isLReluInit)
            begin
                outputReadPos_next = 0;
                outputWritePos_next = 0;
                isLReluInit_next = 0;
            end
            else begin
                if (bmPhase == 0)
                begin
                    bmPhase_next = 1;
            if (outputReadPos != 0 || outputWritePos != 0)
            begin
                if (outputWritePos == outputBufH1)
                begin
                    if (doRelu || doLRelu) begin
                        if (doLRelu)
                            isLReluWeight_next = 1;
                        isLReluInit_next = 1;
                        end
                    outputWritePos_next = 0;
                end
                else
                    outputWritePos_next = outputWritePos + 1;
            end
                end
                else
                begin
                    bmPhase_next = 0;
                    if (outputReadPos == outputBufH1)
                    begin
                        outputReadPos_next = 0;
                    end
                    else
                    begin
                        outputReadPos_next = outputReadPos + 1;
                    end
                end
            end
        end
        else if (state == CONV_RELU && ~waiting_out)
        begin
            if (isLReluInit)
            begin
                isLReluInit_next = 0;
                outputReadPos_next = 0;
                outputWritePos_next = 0;
            end
            else begin
            if (outputWritePos == outputBufH1Relu)
            isLReluWeight_next = 0;
            else if (outputReadPos != 0)
            outputWritePos_next = outputWritePos + 1; // at latch stage
            
            if (outputReadPos < outputBufH1Relu ) // not really needed
            outputReadPos_next = outputReadPos + 1;
            end
        end

    end

    always_ff @(posedge clock)
    begin
        if (!resetN)
        begin
            {doAssemble, outLayerCount, workingProgress, outputBufH1} <= '0;
            {outputBufH1Relu, frameCountDown, outBufferUseCount, kCur, usedWords, usedWords_inc, usedWords_reset} <= '0;
            {initFSteps, initWSteps, initBMWSteps, outputCountDown, outputReadPos} <= '0;
            {outputWritePos, iterCountDown, layerCount, usedGroups} <= '0;
            { bmPhase, isRunning, isInitLayer} <= '0;
            {isLastLayer, isPrefetchNext, isReadingFeatures, isPrefetchWeight, isPrefetchBMWeight} <= '0;
            {isLReluInit, isLoadingNextFeatures, hasNextFeatureParams, isLoadingFroze} <= '0;
            {loadNextInst0, isLReluWeight, isPrefetchNextVolume0, isNextVolumeReady,state} <= '0;
            {readWidth0, rowNum0, maxRowCount0, lastLen0} <= '0;
        end
        else 
        begin
        if(usedWords_reset)
            usedWords <= 0;
        else
            usedWords <= usedWords_next;
            {doAssemble, outLayerCount, workingProgress, outputBufH1} <= {doAssemble_next, outLayerCount_next, workingProgress_next, outputBufH1_next};
            {outputBufH1Relu, frameCountDown, outBufferUseCount, kCur, usedWords_inc, usedWords_reset} <= {outputBufH1Relu_next, frameCountDown_next, outBufferUseCount_next, kCur_next, usedWords_inc_next, usedWords_reset_next};
            {initFSteps, initWSteps, initBMWSteps, outputCountDown, outputReadPos} <= {initFSteps_next, initWSteps_next, initBMWSteps_next, outputCountDown_next, outputReadPos_next};
            {outputWritePos, iterCountDown, layerCount, usedGroups} <= {outputWritePos_next, iterCountDown_next, layerCount_next, usedGroups_next};
            {bmPhase, isRunning, isInitLayer} <= {bmPhase_next, isRunning_next, isInitLayer_next};
            {isLastLayer, isPrefetchNext, isReadingFeatures, isPrefetchWeight, isPrefetchBMWeight} <= {isLastLayer_next, isPrefetchNext_next, isReadingFeatures_next, isPrefetchWeight_next, isPrefetchBMWeight_next};
            {isLReluInit, isLoadingNextFeatures, hasNextFeatureParams, isLoadingFroze} <= {isLReluInit_next, isLoadingNextFeatures_next, hasNextFeatureParams_next, isLoadingFroze_next};
            {loadNextInst0, isLReluWeight, isPrefetchNextVolume0, isNextVolumeReady,state} <= {loadNextInst_next, isLReluWeight_next, isPrefetchNextVolume0_next, isNextVolumeReady_next,state_next};
            {readWidth0, rowNum0, maxRowCount0, lastLen0} <= {readWidth0_next, rowNum0_next, maxRowCount0_next, lastLen0_next};
        end
    end
    
endmodule

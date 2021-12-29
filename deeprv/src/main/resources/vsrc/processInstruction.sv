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
/*
module getTotalFrames
import definitions_pkg::*;
(
input logic clock, resetN,
input logic enable,
input layer_addr_t kh, ks, kt,
input cg_addr_t ng,
output logic fc_valid,
output layer_addr_t fc_count
);
    logic fc_computing, fc_done;
	layer_addr_t fc_kh, fc_ks, fc_kt, fc_num;
	cg_addr_t fc_ng;
	logic fc_computing_next, fc_done_next;
	layer_addr_t fc_kh_next, fc_ks_next, fc_kt_next, fc_num_next;
	cg_addr_t fc_ng_next;
	
	
	
	assign fc_valid = fc_done;
	assign fc_count = fc_num;
	
	always_ff @(posedge clock)
	begin
      if (~resetN)
      begin
        {fc_kh, fc_ks, fc_kt, fc_num, fc_ng} <= '0;
        {fc_computing, fc_done} <= '0;
      end
      else begin
        {fc_kh, fc_ks, fc_kt, fc_num, fc_ng} <= {fc_kh_next, fc_ks_next, fc_kt_next, fc_num_next, fc_ng_next};
        {fc_computing, fc_done} <= {fc_computing_next, fc_done_next};
      end
    end
    
    always_comb
    begin
        {fc_kh_next, fc_ks_next, fc_kt_next, fc_num_next, fc_ng_next} = { fc_kh, fc_ks, fc_kt, fc_num, fc_ng};
        {fc_computing_next, fc_done_next} = {fc_computing, fc_done};
        if(enable)
        begin
            fc_done_next = 0;
            fc_computing_next = 1;
            fc_kh_next = kh;
            fc_ks_next = ks;
            fc_kt_next = kt;
            fc_num_next = 0;
            fc_ng_next = ng;
        end
        else if(fc_computing)
        begin
            //automatic layer_addr_t fc_end;
            //fc_end = fc_kh + fc_ng - 1;
            if (fc_kh + fc_ng - 1 >= fc_kt)
            begin
                fc_done_next = 1;
                fc_computing_next = 0;
                fc_num_next = fc_num + fc_kt - fc_kh + 1;
            end
            else
                fc_num_next = fc_num + fc_ng;
            fc_kh_next = fc_kh + fc_ng + fc_ks;
        end
        else 
            fc_done_next = 0;
    end
endmodule
*/
module ProcessInstruction
import definitions_pkg::*;
(
input logic clock, resetN,
input logic enable,
input logic pwrite_isFetchNextInst,
input logic pib_empty,
input InstructionHCB inst,
input logic hasNextFeatureParams,

input logic new_params_prefetch,
input mem_bus_addr_t new_readPos,
input width_t new_writeWidth,
input input_addr_t new_volumeSize,
input seq_t new_reqSeqF,

output logic pib_en,
output logic new_conv_inst,
output k_t inst_k,
//output logic new_params,
output seq_t curSeq, reqSeq,
output seq_t reqProgress,
output logic isProgressMaster,
output logic token_set,
output token_t max_token,
output k_t k,
output pad_t stride,
`ifdef S2_OPTIMIZE
output logic isStride2,
output s_row_addr_t new_nextRowStart,
output k_t new_kIter,
`endif
output out_width_t outW,
output width_t new_outputBufH1,
output width_t outputBufH1Orig,
output width_t outputBufW1,
output loc_frame_t outBufFrameSize,
output outframe_addr_t outFrameSize,
output output_gap_t outputAddrGap, outFrameGapSize,
output pad_t maxpool_stride,
output mem_addr_t new_outputAddr, 
output mem_addr_t new_outputFrameStart,
//output mem_addr_t batchAddr,
output cg_addr_t numGroups,
output token_t token,
output logic isResMaster,
output mem_bus_addr_t readPos,
output mem_bus_addr_t resPos,
output pad_t leftPad,
output width_t new_readWidth,
output width_t writeWidth,
output layer_addr_t readCLast,
output pad_t topPad, downPad,
output s_row_addr_t new_rowAddr,
output s_row_addr_t new_rowNum,
output seq_t reqSeqF,
output layer_addr_t new_kCur,
output layer_addr_t new_kOut,
output layer_addr_t Ks, kt,
output cg_addr_t new_usedGroups,
output res_size_t new_resSize,
output res_size_t new_resReadSize,
output layer_addr_t new_resFrameMax,
output logic doRes, doRelu, doLRelu, doBM, doUpSample, newWriteInst,
output s_feature_t wLRelu,
output cg_addr_t new_wtotal,
output layer_addr_t new_resFrameCount,
output group_t new_resRowCount,
output logic new_isReadResA,
output mem_addr_t new_nextResAddr,
output mem_addr_t new_frameResAddr,
output res_len_t new_resLen,
output output_gap_t new_outResGapSize,
output layer_addr_t new_kRes,  
output loc_frame_t prefetchFrameSize,
output input_addr_t volumeSize,
output input_addr_t curVolumeSize,
output DATA_MODE mode,
output scale_t fScale, wScale,
output input_addr_t new_addrNextFrame,


output res_size_t totalRes,
output cg_addr_t usedGroupsLast,
output cg_addr_t usedCGLast,
output cg_addr_t usedCG0,
output layer_addr_t kCurLast,
output res_size_t resSize0,
output res_size_t resSizeLast,
output res_len_t resLen0,
output res_len_t resLenLast,
output cg_addr_t wtotal_n,
output weight_bus_size_t wlenk_nLast,
output cg_addr_t wtotalLast,
output weight_bus_size_t wlenk_nLast2,
output weight_bus_size_t wlenk_regular,
output weight_bus_size_t wlen_regular,
output weight_bus_size_t new_wlenk,
output weight_bus_size_t new_wlenk_last,
output	layer_addr_t kCurLast_1,
output width1_t new_maxRowCount,
output width_t new_lastLen
);
    logic enable_conv;
    seq_t curSeq0, reqSeq0;
    seq_t reqProgress0;
    logic isProgressMaster0;
    pad_t stride0;
    k_t k0;
`ifdef S2_OPTIMIZE
    logic isStride2_0;
`endif
    out_width_t outW0;
    width_t outputBufH1Orig0, outputBufW1_0;
    loc_frame_t outBufFrameSize0;
    frame_t outFrameSize0;
    pad_t maxpool_stride0;
    output_gap_t outputAddrGap0;
    output_gap_t outFrameGapSize0;
   // mem_addr_t batchAddr0;
    cg_addr_t numGroups0;
    token_t token0;
    logic isResMaster0;
    mem_bus_addr_t readPos0;
    mem_bus_addr_t resPos0;
    pad_t leftPad0;
    //width_t readWidth0;
    width_t writeWidth0;
    layer_addr_t readCLast0;
    pad_t topPad0, downPad0;
    seq_t reqSeqF0;
    layer_addr_t Ks0, kt0;
    logic doRes0, doRelu0, doLRelu0, doBM0, doUpSample0, newWriteInst0;
    s_feature_t wLRelu0;

   // logic doBatch3K1_0;
    //batch_t batchSize0;
    loc_frame_t prefetchFrameSize0;
    input_addr_t volumeSize0;
    input_addr_t curVolumeSize0;
    DATA_MODE mode0;
    scale_t fScale0, wScale0;
    res_size_t totalRes0;
    cg_addr_t usedGroupsLast0;
    cg_addr_t usedCGLast0;
    cg_addr_t usedCG0_0;
    layer_addr_t kCurLast0;
    res_size_t resSize0_0;
    res_size_t resSizeLast0;
    res_len_t resLen0_0;
    res_len_t resLenLast0;
    weight_bus_size_t wlenk_regular0, wlenk_regular0_next;
    weight_bus_size_t wlen_regular0, wlen_regular0_next;
    
    out_width_t outwidth;
	width_t outbufh1, outbufw1;
	mem_addr_t outaddr;
	width_t rw;
	out_width_t nextx;
	pad_t lp, rp, tp, dp;;
	out_width_t ys, yl;
	mem_addr_t fa;
	
	//logic fc_valid;
	//layer_addr_t fc_count;
	//getTotalFrames gc(.clock, .resetN, .enable(enable_conv && (inst.doBM || inst.doRes)),
    //    .kh(inst.Kh), .ks(inst.Ks), .kt(inst.Kt), .ng(inst.ng), .fc_valid, .fc_count);
    
    assign pib_en = enable && pwrite_isFetchNextInst && ~pib_empty;
    assign enable_conv = pib_en ? (inst.itype == CONV) : 0; 
    assign new_conv_inst = enable_conv;
    
    assign wlenk_regular = wlenk_regular0;
    assign wlen_regular = wlen_regular0;
    assign new_outputAddr = outaddr;
	assign new_outputFrameStart = outaddr;
    assign curSeq = curSeq0;
    assign reqSeq = reqSeq0;
    assign reqProgress = reqProgress0;
    assign isProgressMaster = isProgressMaster0;
    assign k = k0;
    assign inst_k = new_conv_inst ? inst.K : k;
    assign stride = stride0;
`ifdef S2_OPTIMIZE    
    assign isStride2 = isStride2_0;
`endif
    assign outW = outW0;
    assign token_set = enable_conv; // ? inst.isProgressMaster:0;
    assign max_token = (inst.mode == MODE_FOUR) ? 3 : ((inst.mode == MODE_TWO) ? 1 : 0);
    assign new_outputBufH1 = outbufh1;
    assign outputBufH1Orig = outputBufH1Orig0;
    assign outputBufW1 = outputBufW1_0;
    assign outBufFrameSize = outBufFrameSize0;
    assign outFrameSize = outFrameSize0;
    assign maxpool_stride = maxpool_stride0;
    assign outputAddrGap = outputAddrGap0;
    assign outFrameGapSize = outFrameGapSize0;
    //assign batchAddr = batchAddr0;
    assign numGroups = numGroups0;
    assign token = token0;
    assign isResMaster = isResMaster0;
    assign readPos = readPos0; 
    assign resPos = resPos0;
    assign leftPad = leftPad0;
    assign new_readWidth = rw;
    assign new_lastLen = rw;
    assign new_maxRowCount = yl - ys;
    assign writeWidth = writeWidth0;
    assign readCLast = readCLast0;
    assign topPad = topPad0;
    assign new_rowAddr = -tp;
    assign new_rowNum = yl - ys + 1;
    assign downPad = downPad0;
    assign reqSeqF = reqSeqF0;
    assign new_kCur = inst.Kh;
    assign new_kOut = inst.Kh;
    assign Ks = Ks0;
    assign kt = kt0;
   // assign kbh = kbh0;
    //assign kbe = kbe0;
    assign new_usedGroups = inst.gu;
    assign new_resSize = inst.resSize;
    assign new_resLen = inst.resLen;
    assign new_outResGapSize = inst.resLen * FEATURE_BYTE_SIZE + inst.outputAddrGap * FEATURE_BYTE_SIZE;
    assign new_resReadSize = '0;
    assign new_resFrameMax = inst.gu - 1;
    assign doRes = doRes0;
	assign doRelu = doRelu0;
	assign doLRelu = doLRelu0;
	assign wLRelu = wLRelu0;
	assign doBM = doBM0;
	assign doUpSample = doUpSample0;
	assign newWriteInst = newWriteInst0;
    assign new_resFrameCount = '0;
    assign new_resRowCount = '0;
    assign new_isReadResA = inst.isRaddr_a;
    assign new_nextResAddr = fa;
	assign new_frameResAddr = fa;
	//assign new_resBatchStart = inst.Res_addr + inst.outkhb;
	assign new_kRes = inst.Kh;
	//assign new_bmBatchStart = inst.BM_addr + 2 * FEATURE_BYTE_SIZE * (inst.Kbh);
	//assign new_bmBatchEnd = inst.BM_addr + 2 * FEATURE_BYTE_SIZE * (inst.Kbe + 1);
	//assign doBatch3K1 = doBatch3K1_0;
	//assign batchSize = batchSize0;
	assign prefetchFrameSize = prefetchFrameSize0;
	assign volumeSize = volumeSize0;
	assign curVolumeSize = curVolumeSize0;
	assign mode = mode0;
	assign fScale = fScale0;
	assign wScale = wScale0;
	assign new_addrNextFrame = inst.pfs;
	
`ifdef S2_OPTIMIZE
    assign new_kIter = inst.K - 1;
	assign new_nextRowStart = inst.S - tp;
`endif	
    assign totalRes = totalRes0;
    assign usedGroupsLast = usedGroupsLast0;
    assign usedCGLast = usedCGLast0;
    assign usedCG0 = usedCG0_0;
    assign kCurLast = kCurLast0;
    assign resSize0 = resSize0_0;
    assign resSizeLast = resSizeLast0;
    assign resLen0 = resLen0_0;
    assign resLenLast = resLenLast0;
    assign new_wtotal = (inst.gu == inst.ng) ? inst.wtotal_n : inst.wtotalLast;
    
    always_ff @(posedge clock)
    begin
        if(~resetN)
            {readPos0, writeWidth0, reqSeqF0, volumeSize0} <= '0;
        else if(new_params_prefetch)
            {readPos0, writeWidth0, reqSeqF0, volumeSize0} <= {new_readPos, new_writeWidth, new_reqSeqF, new_volumeSize}; 
        else if(enable_conv)
        begin
            readPos0 <= inst.ReadPos;
            writeWidth0 <= rw;
            volumeSize0 <= inst.volumeSize;
            if(~hasNextFeatureParams)
                reqSeqF0 <= inst.seqNum;
        end
    end
    
    always_ff @(posedge clock)
	begin
	    if(~resetN)
	    begin
            {curSeq0, reqSeq0, reqProgress0, isProgressMaster0,k0} <= '0;
            {stride0, outW0, outputBufH1Orig0, outputBufW1_0} <= '0;
            {outBufFrameSize0, outFrameSize0, outputAddrGap0, outFrameGapSize0, numGroups0} <= '0;
            {token0, isResMaster0, resPos0, leftPad0, maxpool_stride0} <= '0;
            {readCLast0, topPad0, downPad0, Ks0, kt0} <= '0;
            { doRes0, doRelu0, doLRelu0} <= '0;
            {wLRelu0, doBM0, doUpSample0, newWriteInst0} <= '0;
            {prefetchFrameSize0, curVolumeSize0, mode0, wScale0} <= '0;
            {fScale0, wtotal_n, wlenk_nLast, wtotalLast, wlenk_nLast2} <= '0;
            {kCurLast_1} <= '0;
            {wlenk_regular0, wlen_regular0, totalRes0} <= '0;
	    {usedGroupsLast0, usedCGLast0, usedCG0_0, kCurLast0} <= '0;
	    {resSize0_0, resSizeLast0, resLen0_0, resLenLast0} <= '0;
           
`ifdef S2_OPTIMIZE
            isStride2_0 <= '0;
`endif 
        end
        else if(enable_conv)
        begin
            wlenk_regular0 <= wlenk_regular0_next;
            wlen_regular0 <= wlen_regular0_next;
            curSeq0 <= inst.seqNum;
            reqSeq0 <= inst.reqSeqNum;
            reqProgress0 <= inst.reqProgress;
            isProgressMaster0 <= inst.isProgressMaster;
            k0 <= inst.K;
            stride0 <= inst.S;
 `ifdef S2_OPTIMIZE
            isStride2_0 <= (inst.S == 2);
`endif
            outW0 <= outwidth;
            outputBufH1Orig0 <= outbufh1;
            outputBufW1_0 <= outbufw1;
            outBufFrameSize0 <= inst.outbufsize;
            outFrameSize0 <= inst.ofsize;
            maxpool_stride0 <= inst.maxpool_stride;
            outputAddrGap0 <= inst.outputAddrGap;
            outFrameGapSize0 <= inst.ofsize * FEATURE_BYTE_SIZE + inst.outputAddrGap * FEATURE_BYTE_SIZE;
            //batchAddr0 <= inst.Oaddr + inst.outkhb;
            numGroups0 <= inst.ng;
            token0 <= inst.weightToken;
            isResMaster0 <= inst.isResMaster;
            resPos0 <= inst.ResPos;
            leftPad0 <= lp;
		    readCLast0 <= inst.C - 1;
		    topPad0 <= tp;
		    downPad0 <= dp;
		    Ks0 <= inst.Ks;
	   	    kt0 <= inst.Kt;
		   // kbh0 <= inst.Kbh;
		    //kbe0 <= inst.Kbe;
		    doRes0 <= inst.doRes;
            doRelu0 <= inst.doRelu;
            doLRelu0 <= inst.doLRelu;
            wLRelu0 <= inst.wLRelu;
            doBM0 <= inst.doBM;
            doUpSample0 <= inst.doUpSample;
            newWriteInst0 <= inst.newWriteInst;
            //doBatch3K1_0 <= inst.doBatch3;
            //batchSize0 <= inst.batchSize;
            prefetchFrameSize0 <= inst.pfs;
            curVolumeSize0 <= inst.volumeSize;
            mode0 <= inst.mode;
            wScale0 <= inst.wScale;
		    fScale0 <= inst.fScale;
		    
		    resSize0_0 <= inst.resSize;
		    resSizeLast0 <= inst.resSizeLast;
		    resLen0_0 <= inst.resLen;
		    resLenLast0 <= inst.resLenLast;
		    kCurLast0 <= inst.kCurLast;
		    usedGroupsLast0 <= inst.Kt + 1 - inst.kCurLast;
		    usedCGLast0 <= (inst.Kt + 1 - inst.kCurLast) * inst.K;
		    usedCG0_0 <= inst.ng * inst.K;
            
           // kbe_1 <= inst.kbe_1;
            wtotal_n <= inst.wtotal_n;
		    wtotalLast <= inst.wtotalLast;
		    wlenk_nLast <= inst.wlenk_nLast;
		    wlenk_nLast2 <= inst.wlenk_nLast2;
		    totalRes0 <= inst.totalRes;;
		    //wlenk_bLast <= inst.wlenk_bLast;
		    //wlenk_bLast2 <= inst.wlenk_bLast2;

		    //batch_only_1group <= inst.batch_1group;
		    //wtotal_bn <= inst.ug_batch;
		    //wtotalbLast <= inst.ug_batchLast;
		    if (inst.kCurLast > inst.ng + inst.Ks) //no need for sv
			    kCurLast_1 <= inst.kCurLast - inst.ng - inst.Ks;
		    else
			    kCurLast_1 <= 0;		
	    end
	end
	
	always_comb
	begin
	    if (inst.K == 1)
			wlen_regular0_next = 8;
		else if (inst.K <= 4)
			wlen_regular0_next = 2;
		else
			wlen_regular0_next = 1;
		wlenk_regular0_next = inst.wlenk_regular;
		if (inst.gu == inst.ng) begin
			automatic weight_bus_size_t wlen = GetWLen(inst.wtotal_n, 0, inst.K);
			if (wlen == wlen_regular0_next)
				new_wlenk = inst.wlenk_regular;
			else
				new_wlenk = inst.wlenk_nLast;
			new_wlenk_last = inst.wlenk_nLast;
		end
		else begin
		    automatic weight_bus_size_t wlen2;
			if (wlen_regular0_next > inst.wtotalLast)
				wlen_regular0_next = inst.wtotalLast;
			wlen2 = GetWLen(inst.wtotalLast, 0, inst.K);
			if (wlen2 == wlen_regular0_next)
				new_wlenk = inst.wlenk_regular;
			else
				new_wlenk = inst.wlenk_nLast2;
			new_wlenk_last = inst.wlenk_nLast2;
		end
	end
	
	always_comb
	begin
	    if(inst.S == 2)
	    begin
            outwidth = ((inst.W - inst.K + inst.lPad + inst.rPad) >>1) + 1;
            outbufh1 = ((inst.H1 - inst.K + 1 + inst.lPad + inst.rPad) >>1);
            outbufw1 = ((inst.W1 - inst.K + inst.lPad + inst.rPad) >>1) + 1;
	    end
	    else begin
    	    outwidth = (inst.W - inst.K + inst.lPad + inst.rPad) + 1;
            outbufh1 = ((inst.H1 - inst.K + 1 + inst.lPad + inst.rPad));
            outbufw1 = ((inst.W1 - inst.K + inst.lPad + inst.rPad) + 1);
	    end
	    if (inst.maxpool_stride == 2)
			outwidth = (outwidth>>1);
		if (inst.doUpSample)
		begin
			outwidth = (outwidth << 1);
		end
		outaddr = inst.outkh;
		
		rw = inst.W1;
		nextx = inst.X;
		lp = 0;
		rp = 0;
		if (inst.lPad > 0)
		begin
			if (inst.X > 0)
			begin
				rw = rw + inst.lPad;
				nextx = nextx - inst.lPad;
			end
			else
				lp = inst.lPad;
		end
		if (inst.rPad > 0)
		begin
			if (inst.X + inst.W1 == inst.W)
				rp = inst.rPad;
			else
				rw = rw + inst.rPad;
		end
		ys = inst.Y;
		yl = inst.Y + inst.H1;
		if (inst.lPad > 0)
			if (inst.Y > 0)
			begin
				ys = ys  - inst.lPad;
				tp = 0;
			end
			else
				tp = inst.lPad;
		else
			tp = 0;
		if (inst.rPad > 0)
			if (inst.Y + inst.H1 == inst.H - 1)
				dp = inst.rPad;
			else begin
				yl = yl + inst.rPad;
				dp = 0;
			end
		else
			dp = 0;
		
		fa = inst.Res_addr + inst.outkh * FEATURE_BYTE_SIZE;
	end
	
	
endmodule

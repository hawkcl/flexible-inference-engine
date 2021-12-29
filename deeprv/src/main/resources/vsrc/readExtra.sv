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


module ReadExtraWeights
import definitions_pkg::*;
(
input logic clock, resetN,
input logic isReadingFeatures, pread_RequestFull,
input logic isResMaster, 
input token_t this_token, ptoken,
input logic res_full,
input logic doRes, 
`ifdef S2_OPTIMIZE	
input logic isStride2,
`endif
input DATA_MODE mode,
input width_t outputBufW1, outputBufH1Orig, 
input out_width_t outW,
input outframe_addr_t outFrameSize,
input output_gap_t outputAddrGap, outFrameGapSize,
input logic unsigned [7 : 0] curSeq,
input layer_addr_t ks,
input cg_addr_t numGroups,
input layer_addr_t kCurLast,
input res_size_t resSize0,
input res_size_t resSizeLast,
input res_len_t resLen0,
input res_len_t resLenLast,
input cg_addr_t usedGroupsLast,

input logic setParam,
input layer_addr_t new_kRes,    
input logic new_isReadResA,
input mem_addr_t new_nextResAddr,
input mem_addr_t new_frameResAddr,
input group_t new_resRowCount,
input res_size_t new_resSize,
input res_size_t new_resReadSize,
input layer_addr_t new_resFrameCount,
input layer_addr_t new_resFrameMax,
input res_len_t new_resLen, 
input output_gap_t new_outResGapSize, 
input res_size_t totalRes,
input layer_addr_t kCurLast_1,
input logic resetRequestingRes,
input logic resBuf_ren,
	
output logic enRequest,
output RequestItem_t request
);    
    layer_addr_t kRes;    
//	logic isPreferRes;
	logic isReadResA;
	mem_addr_t nextResAddr;
	//mem_addr_t resBatchStart;
	mem_addr_t frameResAddr;
	width_t resRowCount;
	res_size_t resSize;
	res_size_t resReadSize;
	layer_addr_t resFrameCount;
	layer_addr_t resFrameMax;
	res_size_t askedRes;
	res_len_t resLen, resLen_next;
	output_gap_t outResGapSize, outResGapSize_next;
	logic requestingRes;
	logic requestingRes_next;
	
	layer_addr_t kRes_next;    
//	logic isPreferRes_next;
	logic isReadResA_next;
	mem_addr_t nextResAddr_next;
	//mem_addr_t resBatchStart_next;
	mem_addr_t frameResAddr_next;
	group_t resRowCount_next;
	res_size_t resSize_next;
	res_size_t resReadSize_next;
	layer_addr_t resFrameCount_next;
	layer_addr_t resFrameMax_next;
	res_size_t askedRes_next;
	logic unsigned [7 : 0]  res_Len;
	logic unsigned [9 : 0]  liveRes;
    logic unsigned [2:0] reqRes;
	
	logic resDone;
	RequestItem_t ri;
	logic enable, enable_res;
	
	assign request = ri;
	assign ri.len = res_Len;
	assign enable = ~isReadingFeatures && ~pread_RequestFull && (this_token == ptoken) && isResMaster;
	//assign enable_bm = enable && ~isPreferRes && (askedBM < totalBM) && liveBM < BM_FIFO_DEPTH;// && ~requestingBM;
    assign enable_res = enable  && (askedRes < totalRes) && (liveRes <= RES_FIFO_DEPTH - 4);// && ~requestingRes;
	assign enRequest = enable_res;
	
	always_ff @(posedge clock)
      if (~resetN)
          liveRes <= '0;
      else if(isResMaster) begin
          liveRes <= liveRes + reqRes - resBuf_ren;
      end
	
	always_ff @(posedge clock)
      if (~resetN)
      begin
        kRes <= '0;
        {isReadResA, nextResAddr, frameResAddr, resRowCount} <= '0;
        {resSize, resReadSize, resFrameCount, resFrameMax, askedRes} <= '0;
        {resLen, outResGapSize, requestingRes} <= '0;
      end
      else 
      begin
        kRes <= kRes_next;
        {isReadResA, nextResAddr, frameResAddr, resRowCount} <= {isReadResA_next, nextResAddr_next, frameResAddr_next, resRowCount_next};
        {resSize, resReadSize, resFrameCount, resFrameMax, askedRes} <= {resSize_next, resReadSize_next, resFrameCount_next, resFrameMax_next, askedRes_next};
        {resLen, outResGapSize, requestingRes} <= {resLen_next, outResGapSize_next, requestingRes_next};
      end
    
    /*always_comb
    begin
        requestingBM_next = requestingBM;
        requestingRes_next = requestingRes;
        if(enable_bm)
            requestingBM_next = 1;
        else if(resetRequestingBM)
            requestingBM_next = 0;
        if(enable_res)
            requestingRes_next = 1;
        else if(resetRequestingRes)
            requestingRes_next = 0;
    end*/
      
    always_comb
    begin
        ri.addr = '0;
	    ri.dtype  = TYPE_RES;
	    ri.isRamA = '0;
	    ri.isRamB = '0;
        ri.seq = curSeq;
        ri.token = this_token;
        res_Len = '0;
        /*
        if(enable_bm)
        begin
            
			automatic logic [6:0] len = BM_READ_WIDTH * FEATURE_BYTE_SIZE;
			if (bm_next > bmEndAddr)
				 len = bmEndAddr - bmNextAddr;
			else
			     len = BM_READ_WIDTH * FEATURE_BYTE_SIZE;
			ri.addr = bmNextAddr;
			ri.isRamA = 0;
			ri.isRamB = 0;
			BMLen = len / FEATURE_BYTE_SIZE;
			ri.dtype = TYPE_BM;    
        end
        else 
        */
        if(enable_res)
        begin
            ri.addr = nextResAddr;
            ri.isRamA = 0;
            ri.isRamB = 0;
			ri.dtype = TYPE_RES;
			if (mode == MODE_ONE
`ifdef S2_OPTIMIZE				
			 || mode == MODE_TWO && isStride2
`endif			 
			 )
			begin
`ifdef S2_OPTIMIZE			
				if (mode == MODE_ONE)
					res_Len = outputBufW1 << 2;
				else
					res_Len = outputBufW1 << 1;
`else
                res_Len = outputBufW1 << 2;
`endif					
			end
			else if (mode == MODE_TWO)
			begin
				if (resRowCount == outputBufH1Orig )
					res_Len = outputBufW1 << 1;
				else
					res_Len = outputBufW1 << 2;
			end
			else begin
				if (resReadSize == resSize)
					res_Len = resLen;
				else
					res_Len = outputBufW1 << 2;
			end
        end
    end
    /*
    always_comb
    begin : BM
        reqBM  = 0;
        if(setParam)
        begin
        	askedBM_next = '0;
            {bmLastAddr_next, bmNextAddr_next, bmEndAddr_next} = {new_bmLastAddr, new_bmNextAddr, new_bmEndAddr};
            {bmBlockSize_next, bmSkipSize_next} = {new_bmBlockSize, new_bmSkipSize};
        end
        else begin
            {askedBM_next, bmLastAddr_next, bmNextAddr_next, bmEndAddr_next} = { askedBM, bmLastAddr, bmNextAddr, bmEndAddr};
            { bmBlockSize_next, bmSkipSize_next} = {bmBlockSize, bmSkipSize};
            if(enable_bm)
            begin
                reqBM = 1;
                if (bm_next >= bmEndAddr)
                begin
//                    if (bmEndAddr == bmLastAddr && doBatch3K1)
//                    begin
//                        bmNextAddr_next = bmBatchStart;
//                        bmEndAddr_next = bmBatchEnd;
//                    end
//                    else
                    begin
                        automatic mem_addr_t ea;
                        bmNextAddr_next = bmEndAddr + bmSkipSize;
                        ea = bmEndAddr + bmSkipSize + bmBlockSize;
                        if (ea > bmLastAddr)
                            bmEndAddr_next = bmLastAddr;
                        else
                            bmEndAddr_next = ea;
                    end
                end
                else
                    bmNextAddr_next = bm_next;
                askedBM_next = askedBM + BMLen;
            end
        end       
    end
    
    always_comb
    begin : IsPreferRes
        isPreferRes_next = isPreferRes;
        if(enable_bm)
        begin
            if (bm_next >= bmEndAddr && doRes)
                isPreferRes_next = 1;
        end
        else if(enable_res)
        begin
            if (resDone)
                isPreferRes_next = 0;
        end
        else if(enable)
            isPreferRes_next = 0;
    end
    */
    always_comb
    begin : RES
        resDone = 0;
        resLen_next = resLen;
        outResGapSize_next = outResGapSize;
        reqRes = 0;
        if(setParam)
        begin
            kRes_next = new_kRes;
            askedRes_next = '0;
            {isReadResA_next, nextResAddr_next, frameResAddr_next, resRowCount_next} = {new_isReadResA, new_nextResAddr, new_frameResAddr, new_resRowCount};
            {resSize_next, resReadSize_next, resFrameCount_next, resFrameMax_next} = {new_resSize, new_resReadSize, new_resFrameCount, new_resFrameMax};
	    resLen_next = new_resLen;
            outResGapSize_next = new_outResGapSize;
        end
        else begin
            kRes_next = kRes;
            
            {isReadResA_next, nextResAddr_next, frameResAddr_next, resRowCount_next} = {isReadResA, nextResAddr, frameResAddr, resRowCount};
            {resSize_next, resReadSize_next, resFrameCount_next, resFrameMax_next,  askedRes_next} = {resSize, resReadSize, resFrameCount, resFrameMax, askedRes};
            if(enable_res)
            begin
                if (mode == MODE_ONE
`ifdef S2_OPTIMIZE	                
                 || mode == MODE_TWO && isStride2
`endif                 
                 )
                begin
                    reqRes = 1;
                    askedRes_next = askedRes + outputBufW1;
                    if (resRowCount == outputBufH1Orig )
                    begin
                        automatic mem_addr_t fa;
                        automatic logic lresDone;
                        lresDone = 0;
                        resRowCount_next = 0;
                        if (resFrameCount == resFrameMax)
                        begin
                            resDone = 1;
                            lresDone = 1;
                            resFrameCount_next = 0;
                            fa = frameResAddr + outFrameGapSize;
                        end
                        else
                        begin
                            resFrameCount_next = resFrameCount + 1;
                            fa = frameResAddr + outFrameSize * FEATURE_BYTE_SIZE;
                        end
                        //if (!(lresDone && (kt + 1 - kRes) <= numGroups))
                        begin
                            nextResAddr_next = fa;
                            frameResAddr_next = fa;
                        end
                    end
                    else begin
                        resRowCount_next = resRowCount + 1;
                        nextResAddr_next = nextResAddr + outW * FEATURE_BYTE_SIZE;
                    end
                end
                else if (mode == MODE_TWO)
                begin
                    if (resRowCount == outputBufH1Orig ) begin
                        askedRes_next = askedRes + outputBufW1;
                        reqRes = 1;
                    end
                    else begin
                        askedRes_next = askedRes + outputBufW1 * 2;
                        reqRes = 2;
                    end
    
                    if (resRowCount == outputBufH1Orig || resRowCount == outputBufH1Orig - 1)
                    begin
                        automatic mem_addr_t fa2;
                        automatic logic lresDone2;
                        lresDone2 = 0;
                        resRowCount_next = 0;
                        if (resFrameCount == resFrameMax)
                        begin
                            resDone = 1;
                            lresDone2 = 1;
                            resFrameCount_next = 0;
                            fa2 = frameResAddr + outFrameGapSize;
                        end
                        else begin
                            resFrameCount_next = resFrameCount + 1;
                            fa2 = frameResAddr + outFrameSize * FEATURE_BYTE_SIZE;
                        end
                        //if (!(lresDone2 && (kt + 1 - kRes) <= numGroups))
                        begin
                            nextResAddr_next = fa2;
                            frameResAddr_next = fa2;
                        end
                    end
                    else begin
                        resRowCount_next = resRowCount + 2;
                        nextResAddr_next = nextResAddr + outW * 2 * FEATURE_BYTE_SIZE;
                    end
                end
                else begin
                    reqRes = 4;
                    if (resReadSize == resSize)
                    begin
                        resDone = 1;
                        //if ((kt + 1 - kRes) > numGroups)
                            nextResAddr_next = nextResAddr + outResGapSize;
                        askedRes_next = askedRes + resLen;
                    end
                    else begin
                        resReadSize_next = resReadSize + outputBufW1 * 4;
                        nextResAddr_next = nextResAddr + res_Len * FEATURE_BYTE_SIZE;
                        askedRes_next = askedRes + outputBufW1 * 4;
                    end
                end
                //askedRes += res_Len;
                if (resDone)
                begin
                    kRes_next = kRes + numGroups + ks;
                    if (kRes < kCurLast)
                    begin
                        if (kRes == kCurLast_1) begin
                            resFrameMax_next = usedGroupsLast;
                            resSize_next = resSizeLast;
						    resLen_next = resLenLast;
						    outResGapSize_next = resLenLast * FEATURE_BYTE_SIZE + outputAddrGap * FEATURE_BYTE_SIZE;
                        end
                        else begin
                            resFrameMax_next = numGroups - 1;
                            resSize_next = resSize0;
						    resLen_next = resLen0;
						    outResGapSize_next = resLen0 * FEATURE_BYTE_SIZE + outputAddrGap * FEATURE_BYTE_SIZE;
                        end
                    end
                    else begin
                        resFrameMax_next = numGroups - 1; // do not care
                        resSize_next = resSize0;
						resLen_next = resLen0;
						outResGapSize_next = resLen0 * FEATURE_BYTE_SIZE + outputAddrGap * FEATURE_BYTE_SIZE;
                    end
                    resReadSize_next = 0;
                end
            end
        end
    end
endmodule

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
module StartConvOut
import definitions_pkg::*;
(
input logic clock, resetN,
input logic enable,
input logic isNextVolumeReady, isPrefetchNextVolume_next, isPrefetchNextVolume,
input logic reset_isOnOutput,
input layer_addr_t kt, ks,
input cg_addr_t numGroups,
input k_t k,
input logic doRes,
input logic doUpSample,
input width_t outputBufW1,
input outframe_addr_t outFrameSize,
input out_width_t outW,
input output_gap_t outputAddrGap,
input pad_t maxpool_stride,
input seq_t curSeq,
input logic newWriteInst,
input width_t outputBufH1Orig,
input mem_addr_t  outputAddr, outputFrameStart,
input logic new_params,
input layer_addr_t new_kOut,
input cg_addr_t usedCGLast,
input cg_addr_t usedCG0,
input layer_addr_t kCurLast,
//input logic batch_only_1group,
//input layer_addr_t kbe_1,
//input cg_addr_t wtotalbLast,

output logic isOnOutput,
output logic waiting_out,
output logic cgSwitchOutput,
output logic doRes_out, doUpSample_out,
output width_t outputBufW1_out,
output outframe_addr_t outFrameSize_out,
output out_width_t outW_out, outW_out2,
output pad_t maxpool_stride_out,
output output_gap_t outputAddrGap_out,
output k_t k_out,
output seq_t curSeq_out,
output logic newWriteInst_out,
output width_t outputBufH1_out,
output logic set_out_params,
output mem_addr_t outputAddr_out, outputFrameStart_out,
output logic set_LastOutput,
output cg_addr_t outputIdxMax,
output layer_addr_t kOut
);
    logic onOutput;
    logic waitingOut, waitingOut_next;
    layer_addr_t kOut0, kOut_next;
    cg_addr_t outputIdxMx, outputIdxMx_next; 
    logic doResOut, doResOut_next;
    width_t outputBufW1Out, outputBufW1Out_next;
    logic doUpSampleOut, doUpSampleOut_next;
    outframe_addr_t outFrameSizeOut, outFrameSizeOut_next;
    out_width_t outWOut, outWOut_next;
    out_width_t outWOut2, outWOut2_next;
    pad_t maxpool_stride_out2, maxpool_stride_out2_next;
    output_gap_t outputAddrGapOut, outputAddrGapOut_next;
    k_t k_out1, k_out1_next;
    seq_t curSeqOut, curSeqOut_next;
    logic newWriteInstOut, newWriteInstOut_next;
    width_t outputBufH1Out, outputBufH1Out_next;
    logic enable2;
    mem_addr_t outputAddrOut, outputFrameStartOut;
    
    assign kOut = kOut0;
    assign enable2 = enable && ~isOnOutput;
    assign set_LastOutput = enable2 && ~isNextVolumeReady && ~isPrefetchNextVolume && ~isPrefetchNextVolume_next;
    assign isOnOutput = onOutput;
    assign waiting_out = waitingOut;
    assign cgSwitchOutput = enable2;
    assign doRes_out = doResOut;
    assign doUpSample_out = doUpSampleOut;
    assign outputBufW1_out = outputBufW1Out;
    assign outFrameSize_out = outFrameSizeOut;
    assign outW_out = outWOut;
    assign outW_out2 = outWOut2;
    assign maxpool_stride_out = maxpool_stride_out2;
    assign outputAddrGap_out = outputAddrGapOut;
    assign k_out = k_out1;
    assign curSeq_out = curSeqOut;
    assign newWriteInst_out = newWriteInstOut;
    assign outputBufH1_out = outputBufH1Out;
    assign set_out_params = enable2;
    assign outputAddr_out = outputAddrOut;
    assign outputFrameStart_out = outputFrameStartOut;
    assign outputIdxMax = outputIdxMx;
    
    always_ff @(posedge clock)
	begin
        if(~resetN || reset_isOnOutput)
            onOutput <= 0;
        else if(enable2)
            onOutput <= 1;
    end
    always_ff @(posedge clock)
	begin
        if(~resetN)
            kOut0 <= '0;
        else if (new_params)
            kOut0 <= new_kOut;
        else
            kOut0 <= kOut_next;
	end
	
	always_ff @(posedge clock)
	begin
        if(~resetN)
        begin
            {waitingOut, outputIdxMx, doResOut, maxpool_stride_out2} <= '0;
            {outputBufW1Out, doUpSampleOut, outFrameSizeOut, outWOut, outWOut2} <= '0;
            {outputAddrGapOut, k_out1, curSeqOut, newWriteInstOut, outputBufH1Out} <= '0;           
        end
        else begin
            {waitingOut,outputIdxMx, doResOut, maxpool_stride_out2} <= {waitingOut_next, outputIdxMx_next, doResOut_next, maxpool_stride_out2_next};
            {outputBufW1Out, doUpSampleOut, outFrameSizeOut, outWOut, outWOut2} <= {outputBufW1Out_next, doUpSampleOut_next, outFrameSizeOut_next, outWOut_next, outWOut2_next};
            {outputAddrGapOut, k_out1, curSeqOut, newWriteInstOut, outputBufH1Out} <= {outputAddrGapOut_next, k_out1_next, curSeqOut_next, newWriteInstOut_next, outputBufH1Out_next};     
        end       
	end
	
	always_comb
	begin
	   {outputAddrOut, outputFrameStartOut} = '0;
	   {waitingOut_next, kOut_next, outputIdxMx_next, doResOut_next} = {waitingOut, kOut0, outputIdxMx, doResOut};
	   {outputBufW1Out_next, doUpSampleOut_next, outFrameSizeOut_next, outWOut_next, outWOut2_next} = {outputBufW1Out, doUpSampleOut, outFrameSizeOut, outWOut, outWOut2};
	   {outputAddrGapOut_next, k_out1_next, curSeqOut_next, newWriteInstOut_next, outputBufH1Out_next} = {outputAddrGapOut, k_out1, curSeqOut, newWriteInstOut, outputBufH1Out};
	   maxpool_stride_out2_next = maxpool_stride_out2;
	   if(enable)
	   begin
	        if (isOnOutput)
                waitingOut_next = 1;
            else
            begin
                waitingOut_next = 0;
                if (kOut == kCurLast)
                    outputIdxMx_next = usedCGLast;
                else
                    outputIdxMx_next = usedCG0;
                kOut_next = kOut0 + numGroups + ks;
                doResOut_next = doRes;
                outputBufW1Out_next = outputBufW1;
                doUpSampleOut_next = doUpSample;
                
                outFrameSizeOut_next = outFrameSize;
                outWOut_next = outW;
		if(doUpSample)
                    outWOut2_next = outW - outputBufW1;
                outputAddrGapOut_next = outputAddrGap;
                k_out1_next = k;
                curSeqOut_next = curSeq;
                
                newWriteInstOut_next = newWriteInst;
                outputBufH1Out_next = outputBufH1Orig;
                maxpool_stride_out2_next = maxpool_stride;
//                if (doBatch3K1Out_next && ~doBatch3K1Out)
//                begin
//                    outputAddrOut = batchAddr;
//                    outputFrameStartOut = batchAddr;
//                end
//                else 
                begin
                    outputAddrOut = outputAddr;
                    outputFrameStartOut = outputFrameStart;
                end
            end
	   end
	end
	
endmodule

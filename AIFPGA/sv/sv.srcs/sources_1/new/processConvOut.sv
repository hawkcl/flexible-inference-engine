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
module ProcessConvOut
import definitions_pkg::*;
(
input logic clock, resetN,
input HCB_STATE state,
input logic enable,
input logic isOnOutput,
input logic pwrite_isWritable,
input logic resBuf_empty,
//input logic waiting_out,
//input logic doBatch3K1_out,
input logic doRes_out, doUpSample_out,
input width_t outputBufW1_out,
input outframe_addr_t outFrameSize_out,
input out_width_t outW_out, outW_out2,
input pad_t maxpool_stride_out,
input output_gap_t outputAddrGap_out,
input k_t k_out,
input seq_t curSeq_out, // for debug, unused now
input logic newWriteInst_out,
input width_t outputBufH1_out,
input cg_addr_t outputIdxMax,
input s_feature_t pre_output[CG_NUM][COMPUTING_GROUP_SIZE],
input s_feature_t [COMPUTING_GROUP_SIZE-1:0] resBuf,
input logic set_LastOutput,

input logic new_params,
input mem_addr_t new_outputAddr, 
input mem_addr_t new_outputFrameStart,
input logic set_out_params,
input mem_addr_t new_outputAddr_out, new_outputFrameStart_out,

output logic res_en,
output s_feature_t [COMPUTING_GROUP_SIZE - 1 : 0]pwrite_data,
output logic pwrite_enable,
output mem_addr_t pwrite_addr,
output logic pwrite_setNextInst,
output output_addr_t out_row,
output logic reset_state,    // TO IDLE
output mem_addr_t outputAddr, 
output mem_addr_t outputFrameStart,
output logic reset_isOnOutput,
output seq_t finishedSeq
);
    logic isLastOutput, isLastOutput_next;
    mem_addr_t outAddr, outAddr_next;
    mem_addr_t outFrameStart, outFrameStart_next;
    //logic unsigned [1:0] batchIdx, batchIdx_next;
    cg_addr_t outputCGIdx, outputCGIdx_next;
    cg_addr_t outputCGIdx0, outputCGIdx0_next;
    //output_addr_t outputRowsBatch, outputRowsBatch_next;
    output_addr_t outputRows, outputRows_next;
    mem_addr_t outputAddr_out, outputAddr_out_next; 
    mem_addr_t outputFrameStart_out, outputFrameStart_out_next;
    logic unsigned [1:0] outputUPSteps, outputUPSteps_next;
    s_feature_t bus[COMPUTING_GROUP_SIZE];
    s_feature_t resOutBuf[COMPUTING_GROUP_SIZE * 2];
    s_feature_t bufsave[COMPUTING_GROUP_SIZE * 2];
    seq_t       finishedSeq_next;
    
    
    logic enable2;
    
    assign outputAddr = outAddr;
    assign outputFrameStart = outFrameStart;
    assign enable2 = enable && isOnOutput && pwrite_isWritable && (~doRes_out || ~resBuf_empty);
    assign out_row = outputRows;
    assign pwrite_enable = enable2;
    assign pwrite_addr = outputAddr_out;
    assign res_en = enable2 && doRes_out;
    assign reset_state = reset_isOnOutput && isLastOutput && (state == CONV_OUT);
    assign reset_isOnOutput = enable2 && (~doUpSample_out || outputUPSteps == 3) && (outputRows == outputBufH1_out)
        && (outputCGIdx0 + ( k_out) >= outputIdxMax);
    assign pwrite_setNextInst = reset_isOnOutput && isLastOutput && newWriteInst_out; 
    
	always_ff @(posedge clock)
	begin
        if(~resetN)
            isLastOutput <= '0;
        else if(set_LastOutput)
            isLastOutput <= 1;
        else
            isLastOutput <= isLastOutput_next;
	end
	always_comb
	begin
	   isLastOutput_next = isLastOutput;
	   if(reset_isOnOutput && isLastOutput)
	       isLastOutput_next = 0;
	end
	
	always_ff @(posedge clock)
	begin
        if(~resetN)
            finishedSeq <= '0;
        else
            finishedSeq <= finishedSeq_next;
	end
	always_comb
	begin
	   finishedSeq_next = finishedSeq;
	   if(reset_isOnOutput && isLastOutput)
	       finishedSeq_next = curSeq_out;
	end

	always_ff @(posedge clock)
	begin
        if(~resetN)
            {outFrameStart, outAddr} <= '0;
        else if(new_params)
        begin
            {outFrameStart, outAddr} <= {new_outputFrameStart, new_outputAddr};
        end
        else
            {outFrameStart, outAddr} <= {outFrameStart_next, outAddr_next};
	end
	
//	always_ff @(posedge clock)
//	begin
//        if(~resetN)
//            batchIdx <= '0;
//        else if(set_out_params)
//            batchIdx <= '0;
//        else
//            batchIdx <= batchIdx_next;
//	end
	   
	always_ff @(posedge clock)
	begin
        if(~resetN)
            {outputRows, outputCGIdx, outputCGIdx0, outputUPSteps} <= '0;
        else
            {outputRows, outputCGIdx, outputCGIdx0, outputUPSteps} <= {outputRows_next, outputCGIdx_next, outputCGIdx0_next, outputUPSteps_next};
	end
	
	always_ff @(posedge clock)
	   if (enable2 && doUpSample_out && (outputUPSteps == 0))
	       resOutBuf <= bufsave;
	
	always_comb
	begin
	   for(int i = 0 ; i < COMPUTING_GROUP_SIZE; i++)
	       bus[i] = pre_output[outputCGIdx][i];
	end	
	
	always_comb
	begin
	   for(int i = 0; i < 2 * COMPUTING_GROUP_SIZE; i++)
	       bufsave[i] = bus[i >> 1];
	end
	
	always_comb
	begin
	   if(doUpSample_out)
	   begin
	       if (outputUPSteps == 0) begin
	           for(int i = 0; i < COMPUTING_GROUP_SIZE; i++)
	               pwrite_data[i] = bufsave[i];
           end
           else if (outputUPSteps == 2) begin
                for(int i = 0; i < COMPUTING_GROUP_SIZE; i++)
	               pwrite_data[i] = resOutBuf[i];
           end
           else begin
                for(int i = 0; i < COMPUTING_GROUP_SIZE; i++)
	               pwrite_data[i] = resOutBuf[i + outputBufW1_out];
           end
	   end
	   else begin
	       if (doRes_out)
                for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
                    pwrite_data[i] = resBuf[i] + bus[i];
           else
                for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
                    pwrite_data[i] = bus[i];
	   end
	end
	
	always_ff @(posedge clock)
	begin
        if(~resetN)
            {outputAddr_out, outputFrameStart_out} <= '0;
        else
            {outputAddr_out, outputFrameStart_out} <= {outputAddr_out_next, outputFrameStart_out_next};
	end
	always_comb
	begin
	   outputAddr_out_next = outputAddr_out;
	   outputFrameStart_out_next = outputFrameStart_out;
	   
       if(enable2) begin
           if (doUpSample_out)
           begin
                if (outputUPSteps == 0 || outputUPSteps == 2)
                    outputAddr_out_next = outputAddr_out + outputBufW1_out;
                else begin
                    if (outputRows == outputBufH1_out && outputUPSteps == 3 )
                    begin
                        outputAddr_out_next = outputFrameStart_out + outFrameSize_out;
                        outputFrameStart_out_next = outputFrameStart_out + outFrameSize_out;
                    end
                    else
                        outputAddr_out_next = outputAddr_out + outW_out2;
                end            
            end
            else begin
                if (outputRows == outputBufH1_out)
                begin
                    outputAddr_out_next = outputFrameStart_out + outFrameSize_out;
                    outputFrameStart_out_next = outputFrameStart_out + outFrameSize_out;
                end
                else if ((maxpool_stride_out != 2) || (outputRows & 1))
                    outputAddr_out_next = outputAddr_out + outW_out;
            end
        end
        else if(set_out_params)
            {outputAddr_out_next, outputFrameStart_out_next} = {new_outputAddr_out, new_outputFrameStart_out};
	end
	
	always_comb
	begin
	   outputRows_next = outputRows;
	   outputCGIdx_next = outputCGIdx;
	   outputCGIdx0_next = outputCGIdx0;
	   //outputRowsBatch_next = outputRowsBatch;
	   outAddr_next = outAddr;
	   outFrameStart_next = outFrameStart;
	   //batchIdx_next = batchIdx;
	   if (enable2 && (~doUpSample_out || outputUPSteps == 3))
	   begin
            if (outputRows == outputBufH1_out)
            begin
                outputRows_next = 0;
                if (outputCGIdx0 +  k_out >= outputIdxMax)
                begin
                    outputCGIdx_next = 0;
                    outputCGIdx0_next = 0;
                    //outputRowsBatch_next = 0;
                    if (~isLastOutput)
                    begin
//                        if (doBatch3K1_out)
//                        begin
//                            outAddr_next = outputFrameStart_out_next;
//                            outFrameStart_next = outputFrameStart_out_next;
//                        end
//                        else 
                        begin
                            outAddr_next = outputFrameStart_out_next + outputAddrGap_out;
                            outFrameStart_next = outputFrameStart_out_next + outputAddrGap_out;
                        end
                    end
                end
                else begin
                    outputCGIdx0_next = outputCGIdx0 + ( k_out);
                    outputCGIdx_next  = outputCGIdx0 + ( k_out);
                    //outputRowsBatch_next = 0;
                    //batchIdx_next = 0;
                end
            end
            else begin
                outputRows_next = outputRows + 1;
//                if (doBatch3K1_out)
//                begin
//                    if (batchIdx == 2)
//                    begin
//                        batchIdx_next = 0;
//                        outputCGIdx_next = outputCGIdx0;
//                        outputRowsBatch_next = outputRowsBatch + 1;
//                    end
//                    else begin
//                        batchIdx_next = batchIdx + 1;
//                        outputCGIdx_next = outputCGIdx + 1;
//                    end
//                end
            end   
        end
	end
	
	always_comb
	begin
	   outputUPSteps_next = outputUPSteps;
	   if (enable2 && doUpSample_out)
		    if (outputUPSteps_next == 3)
			     outputUPSteps_next = 0;
		    else
			     outputUPSteps_next = outputUPSteps + 1;
	end
endmodule

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
module BuildInputFifo
import definitions_pkg::*;
(
input logic clock, resetN,
input HCB_STATE state,
input layer_addr_t readCLast,
`ifdef S2_OPTIMIZE	
input logic isStride2,
input s_row_addr_t new_nextRowStart,
input k_t new_kIter,
//s2_buffer
output logic [3:0] s2b_a,
output s_feature_t [INPUT_MEM_WIDTH - 1 : 0] s2b_data_out,
output logic s2b_we,
input s_feature_t [INPUT_MEM_WIDTH - 1 : 0] s2b_data,
`endif
input width_t outputBufH1,
input pad_t downPad, topPad,
input k_t k,
input pad_t stride,
input s_row_addr_t rowNum,

input logic reset_params, //prefetching
input logic new_params, reset_iLayers,
input s_row_addr_t new_rowAddr,

//assemble_buffer
output logic ab_rd_en,
input s_feature_t [INPUT_MEM_WIDTH - 1 : 0] ab_data,  
input logic ab_empty,

//input_fifo
output logic input_wr_en,
output s_feature_t [INPUT_MEM_WIDTH - 1 : 0] input_data_out,
input logic input_full
  

);
    layer_addr_t iLayers, iLayers_next;
	s_row_addr_t rowAddr, rowAddr_next;
	
	
`ifdef S2_OPTIMIZE	
    s_row_addr_t nextRowStart, nextRowStart_next;
	k_t kIter, kIter_next;
    width_t rowCounts, rowCounts_next;
	s_row_addr_t s2b_lastAddr, s2b_lastAddr_next;
	fpga_min_addr_t s2b_end, s2b_end_next;
	fpga_min_addr_t s2b_cur, s2b_cur_next;
	fpga_min_addr_t s2b_start, s2b_start_next;
	logic use_s2b, write_s2b;
	logic lastRow;
`endif	
	s_feature_t [INPUT_MEM_WIDTH - 1 : 0] buffer;
	logic enable;
	logic pad0;
	
	
	assign enable = ~input_full && state != IDLE && iLayers <= readCLast;
	assign input_data_out = buffer;
	assign pad0 = (rowAddr < 0) || (rowAddr >=  signed'({1'b0,rowNum}));
	
	//assign input_wr_en = enable && (isStride2 ? (pad0 || use_s2b  || ~ab_empty) : (pad0 || ~ab_empty));
`ifdef S2_OPTIMIZE	
    assign lastRow = (rowCounts == outputBufH1);
	assign use_s2b = s2b_lastAddr >= rowAddr;
	assign input_wr_en = enable && (pad0 || (isStride2 && use_s2b)  || ~ab_empty);	
	assign ab_rd_en = enable && ~ab_empty && (isStride2 ? (~pad0 && ~use_s2b) : (~pad0));
`else
    assign input_wr_en = enable && (pad0 ||  ~ab_empty);	
	assign ab_rd_en = enable && ~ab_empty && ((~pad0));
`endif	
`ifdef S2_OPTIMIZE  
    assign write_s2b = (rowAddr >= nextRowStart);
    assign s2b_we = enable && isStride2 && ~pad0 && ~use_s2b && ~ab_empty && write_s2b;
    assign s2b_data_out = buffer;	
	assign s2b_a = use_s2b? s2b_cur : s2b_end;
`endif
    
    
	
	always_ff @(posedge clock)
	begin
      if (!resetN)
      begin
        {iLayers, rowAddr} <= '0;
`ifdef S2_OPTIMIZE        
        {s2b_lastAddr, nextRowStart} <= '0;
        {kIter, rowCounts, s2b_end, s2b_cur, s2b_start} <= '0;
`endif        
      end
      else if(new_params)
      begin
        rowAddr <= new_rowAddr;
        iLayers <= '0;
`ifdef S2_OPTIMIZE          
         {nextRowStart, kIter} <= {new_nextRowStart, new_kIter};
        {rowCounts, s2b_end, s2b_cur, s2b_start} <=  '0;
        s2b_lastAddr <= -1;
`endif        
      end
      else if(reset_params)
      begin
        rowAddr <= -topPad;
        
        
`ifdef S2_OPTIMIZE    
        kIter <= k - 1;  
        s2b_lastAddr <= -1;
        nextRowStart <= signed'(stride) - signed'(topPad);    
        {rowCounts, s2b_end, s2b_cur, s2b_start} <=  '0;
`endif        
        if(reset_iLayers)
            iLayers <= '0;
        else
            iLayers <= iLayers_next;
      end
      else
      begin
        {iLayers, rowAddr} <= {iLayers_next, rowAddr_next};
`ifdef S2_OPTIMIZE          
        {s2b_lastAddr, nextRowStart} <= {s2b_lastAddr_next, nextRowStart_next};
        {kIter, rowCounts, s2b_end, s2b_cur, s2b_start} <= {kIter_next, rowCounts_next, s2b_end_next, s2b_cur_next, s2b_start_next};
`endif        
      end
    end
    
    always_comb
    begin
        if(pad0)
            buffer = '{default :0};
`ifdef S2_OPTIMIZE              
        else if(isStride2 && use_s2b)
            buffer = s2b_data;
`endif            
        else
            buffer = ab_data;
    end
`ifdef S2_OPTIMIZE    
    always_comb
    begin
        {s2b_lastAddr_next, s2b_end_next, s2b_cur_next, s2b_start_next} = {s2b_lastAddr, s2b_end, s2b_cur, s2b_start};
        if(enable && isStride2)
        begin
            if(~pad0 && use_s2b)
            begin
                if (kIter != 0 || ~lastRow)
                begin
                    if (rowAddr < nextRowStart)
                        if (s2b_start == S2_BUFFER_SIZE - 1)
                            s2b_start_next = 0;
                        else
                            s2b_start_next = s2b_start + 1;
                    
                    if (s2b_cur == S2_BUFFER_SIZE - 1)
                        s2b_cur_next = '0;
                    else
                        s2b_cur_next = s2b_cur + 1;
                end
            end
            
            if(~pad0 && ~use_s2b && ~ab_empty)
            begin
                if (rowAddr >= nextRowStart)
                begin
                    if (kIter != 0 || ~lastRow)
                    begin
                        if (s2b_end == S2_BUFFER_SIZE - 1)
                            s2b_end_next = '0;
                        else
                            s2b_end_next = s2b_end + 1;
                        s2b_lastAddr_next = rowAddr;
                    end
                end
            end
            
            if(pad0 || use_s2b || ~ab_empty)
            begin
                if (kIter == 0)
                begin
                    if (lastRow)
                    begin
                        s2b_lastAddr_next = -1;
				        s2b_end_next = '0;
				        s2b_cur_next = '0;
				        s2b_start_next = '0;
                    end
                    else begin
                        s2b_cur_next = s2b_start;
                    end
                end
            end
        end
    end
`endif    
    always_comb
    begin
        iLayers_next = iLayers;
        rowAddr_next = rowAddr;
        
`ifdef S2_OPTIMIZE        
        rowCounts_next = rowCounts;
        nextRowStart_next = nextRowStart;
        kIter_next = kIter;
`endif        
        
        if(enable)
        begin
`ifdef S2_OPTIMIZE        
            if(isStride2)
            begin
                if(pad0 || use_s2b || ~ab_empty)
                    if (kIter == 0)
                    begin
                        kIter_next = k - 1;
                        if (lastRow)
                        begin
                            rowCounts_next = 0;
                            rowAddr_next = -topPad;
                            iLayers_next = iLayers + 1;
                            nextRowStart_next = signed'(stride) - signed'(topPad);
                        end
                        else begin
                            rowCounts_next = rowCounts + 1;
                            rowAddr_next = nextRowStart;
                            nextRowStart_next = nextRowStart + stride;
                        end
                    end
                    else begin
                        rowAddr_next = rowAddr + 1;
                        kIter_next = kIter - 1;
                    end
            end
            else 
`endif            
            begin
                if(pad0 || ~ab_empty)
                    if (rowAddr <  signed'({1'b0,rowNum}) + signed'({1'b0,downPad}) - 1)
                        rowAddr_next = rowAddr + 1;
                    else begin
                        rowAddr_next = -topPad;
                        iLayers_next = iLayers + 1;
                    end
            end
        end
    end
endmodule

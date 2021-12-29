//`timescale 1ns / 1ps
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/14 06:23:38
// Design Name: 
// Module Name: UCU
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


module UCU
import definitions_pkg::*;
#(parameter bid = 0, gid = 0, uid = 0, isBottom = 0)
(
   input logic clock, resetN,
    input logic isRunning,
   input ucl_config_t cfg,
   input scale_t conv_scale, bm_scale, wscale,
   INPUT_SOURCE is,
   input logic isOutput0,
   //input feature_t in_shift,
   input s_feature_t shift_e, shift_s,
   input s_feature_t in_backup_bus,
   input s_mult_t psum_low,
   input logic in_backup_bus_valid,
   input logic output_ready, do_output_scale,
   input width_t read_pos, write_pos,
   input output_addr_t out_row,
   input s_feature_t w,
   input logic is_cycle_froze,
   
`ifdef S2_OPTIMIZE
    input logic isStride2,
    input s_feature_t in_backup2_bus,
   input logic in_backup2_bus_valid,
`endif
   
   output s_feature_t pre_output,
   output s_feature_t shift_w, shift_n,
   output s_mult_t psum_up
 );
 	//logic clock;
    s_feature_t inputf, shift, backup;
    s_feature_t inputf_next, shift_next, backup_next;
    
`ifdef S2_OPTIMIZE
    s_feature_t backup2, S2;
    s_feature_t backup2_next, S2_next;
`endif
    output_addr_t a0, a1, dpra0, dpra1;
    s_mult_t d0, d1, dpo0, dpo1, psum, psum_s;
    s_mult_t low, out , out0;
    logic we0, we1;
    
    assign shift_w = inputf;
    assign shift_n = shift;
    assign a0 = write_pos;
    assign a1 = write_pos;
    assign we0 = output_ready && isOutput0 && !is_cycle_froze;
    assign we1 = output_ready && !isOutput0 && !is_cycle_froze;
    assign dpra0 = isOutput0? read_pos : out_row;
    assign dpra1 = isOutput0? out_row : read_pos;
    assign pre_output = isOutput0? dpo1 : dpo0;
    assign psum = isOutput0? dpo0 : dpo1;
    assign psum_s = do_output_scale ? (psum >>> conv_scale) : psum;
    assign low = isBottom ? '0 : psum_low;
    //assign out = (do_output_scale && output_ready) ? (out0 >>> wscale) : out0;
    assign out = out0;
    assign psum_up = out;
    assign d0 = out;
    assign d1 = out;
    
    //IBUFG (.O(clock),.I(clock_in));
    dmem_32_16 output0 (.a(a0), .d(d0), .dpra(dpra0), .clk(clock), .we(we0), .dpo(dpo0));
    dmem_32_16 output1 (.a(a1), .d(d1), .dpra(dpra1), .clk(clock), .we(we1), .dpo(dpo1));
    
    UCL ucl_i(.clock, .resetN, .cfg, .bm_scale, .wscale, .x(inputf)
    ,.w, .psum(psum_s),.low, .is_cycle_froze, .out(out0)); 
    
     // read_input()
    always_ff @(posedge clock)
      if (!resetN) begin
        {inputf, shift, backup} <= '0;
 `ifdef S2_OPTIMIZE
        {backup2, S2} <= '0;
 `endif
      end
      else if(!is_cycle_froze) begin 
        {inputf, shift, backup} <= {inputf_next, shift_next, backup_next};
`ifdef S2_OPTIMIZE
        {backup2, S2} <= {backup2_next, S2_next};
`endif
      end
        
     always_comb begin
        if(in_backup_bus_valid)
            backup_next = in_backup_bus;
        else
            backup_next = backup;
`ifdef S2_OPTIMIZE
        if(in_backup2_bus_valid)
            backup2_next = in_backup2_bus;
        else
            backup2_next = backup2;
        S2_next = S2;
`endif
        inputf_next = inputf;
        shift_next = shift;
        
        case (is)
            INPUT_X :
			 inputf_next = in_backup_bus;
		    INPUT_BACKUP:
                begin
                    inputf_next = backup;
                    shift_next = backup;
`ifdef S2_OPTIMIZE
                    S2_next = backup2;
`endif
                end
            INPUT_E:
`ifdef S2_OPTIMIZE
                if (isStride2)
                begin
                    inputf_next = S2;
                    //if (isLast)
                    //    S2_next = in_shift;
                    //else
                        S2_next = shift_e;;
                end
                else
`endif 
                begin
                    //if (isLast)
                    //    inputf_next = in_shift;
                    //else
                        inputf_next = shift_e;
                end
		    INPUT_S:
                begin
                    inputf_next = shift_s;
                    shift_next = shift_s;
                end
		endcase
     end
    /* 
     always_comb begin
         if(isRunning && bid == 0 && gid < 2) begin
             $write("UID %d, input %x, w %x, psum_s %x, low %x, out0 %x, is %x, rpos %d, wpos %d, froze %d, shifts %x, shiftn %x\n"
                , uid, inputf, w, psum_s, low, out0, is, read_pos, write_pos, is_cycle_froze, shift_s, shift_n); 
         end
     end
      */
endmodule

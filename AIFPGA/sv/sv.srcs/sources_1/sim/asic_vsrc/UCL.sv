//`timescale 1ns / 1ps
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/13 03:18:27
// Design Name: 
// Module Name: UCL
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


module UCL
import definitions_pkg::*;
(
input logic clock, resetN,
   input ucl_config_t cfg,
   input scale_t bm_scale, wscale,
   input s_feature_t x, 
   input s_feature_t w,
   input s_mult_t psum, 
   input s_mult_t low,
   input logic is_cycle_froze,
   output s_mult_t out
    );
    s_mult_t mq, aq, sq;
    s_feature_t psumq, psumq_next;
    s_feature_t psum_1;
   (* use_dsp = "yes" *) s_mult_t mq_next; 
   s_mult_t aq_next, sq_next;
    
	//logic cmpQ, cmpQ1, cmpQ2, cmpQ_next, cmpQ1_next, cmpQ2_next;
	
	always_ff @(posedge clock)
      if (!resetN)
        {mq, aq, sq, psumq} <= '0;
    else if(!is_cycle_froze) begin
        psumq <= psumq_next;
        aq <= aq_next;
        sq <= sq_next;
        mq <= mq_next;
    end
        
    always_comb begin
        s_feature_t m1;
        s_mult_t a0m;
		s_mult_t am;
		s_mult_t add1, add2;
        logic signed [MULT_BIT_SIZE : 0] add1_p, add2_p;
		//s_mult_t c0, c1;
		//logic cmp;
		//s_mult_t cmux;
		s_mult_t sam;
		s_feature_t lky;
		s_feature_t relu;
        if(psum  < -(1 << (FEATURE_BIT_SIZE - 1)))
            psum_1 = -(1<<(FEATURE_BIT_SIZE - 1));
        else if (psum > ((1 << (FEATURE_BIT_SIZE - 1)) - 1))
            psum_1 = ((1 << (FEATURE_BIT_SIZE - 1)) - 1);
        else
            psum_1 = psum[FEATURE_BIT_SIZE - 1:0];
		
		if (cfg.mMux == UCLM_X)
			m1 = x;
		else begin
            m1 = psum_1;
		end
		mq_next = m1 * w;
			
		if (cfg.a0Mux == UCLA0_MUL)
			a0m = mq;
		else if (cfg.a0Mux == UCLA0_MS)
			a0m = mq >>> bm_scale;
		else
			a0m = x;// intend for Res layer, may not need anymore


		
		if (cfg.aMux == UCLA_W)
			am = w;
		else if (cfg.aMux == UCLA_PSUM)
			am = psum;
		else if (cfg.aMux == UCLA_AQ)
			am = aq;
		else
			am = 0;

		add1_p = a0m + am;
        if(add1_p[MULT_BIT_SIZE:MULT_BIT_SIZE-1] == 2'b01) //overflow
            add1 = ((1 << (MULT_BIT_SIZE - 1)) - 1);
        else if(add1_p[MULT_BIT_SIZE:MULT_BIT_SIZE-1] == 2'b10) //underflow
            add1 = -((1 << (MULT_BIT_SIZE - 1)));
        else
            add1 = add1_p[MULT_BIT_SIZE-1:0];
		
		/*
		if (cfg.c0Mux == UCLC0_X)
			c0 = x;
		else if (cfg.c0Mux == UCLC0_LOW)
			c0 = low;
		else
			c0 = psum;
		if (cfg.c1Mux == UCLC1_W)
			c1 = w;
		else
			c1 = sq;
		cmp = (c0 > c1);
		cmux = cmp ? c0 : c1;
		cmpQ_next = cmp;
		cmpQ1_next = ((!cmpQ) && cmp);
		cmpQ2_next = cmpQ1;

		if (cfg.isAct)
		begin //activation
			if (cmpQ2)
				aq_next = add1;
			else
				aq_next = aq;
		end
		else
		begin
			if (cfg.aqMux == UCLAQ_PLUS)
				aq_next = add1;
			else
				aq_next = aq;
		end*/

		//if (debug && fp)
		//	fprintf(fp, "aq %d %d , ", aq.GetValue(), aq.GetNextValue());

		aq_next = add1;
		//if (cfg.saMux == UCLSA_X)
		//	sam = x;
		//else
		sam = low;
		add2_p = sam + sq;
        if(add2_p[MULT_BIT_SIZE:MULT_BIT_SIZE-1] == 2'b01) //overflow
            add2 = ((1 << (MULT_BIT_SIZE - 1)) - 1);
        else if(add2_p[MULT_BIT_SIZE:MULT_BIT_SIZE-1] == 2'b10) //underflow
            add2 = -((1 << (MULT_BIT_SIZE - 1)));
        else
            add2 = add2_p[MULT_BIT_SIZE-1:0];

		if (cfg.sqMux == UCLSQ_AQ)
			sq_next = aq;
		else if (cfg.sqMux == UCLSQ_PLUS)
			sq_next = add2;
		else
			sq_next = sq;
		psumq_next = psum_1;
		if (cfg.lMux == UCLL_0)
			lky = 0;
		else
			lky = (mq >>> wscale);
		
		if (psumq > 0)
			relu = psumq;
		else
			relu = lky;


		case (cfg.oMux)
		 UCLO_AQ: out = aq;
		 UCLO_RELU: out = relu;
		 UCLO_SQ: out = sq;
		default: out = 0;
		endcase
    end
	
endmodule

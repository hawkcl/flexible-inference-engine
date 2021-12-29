//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/14 13:55:11
// Design Name: 
// Module Name: SCG
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

`timescale 1ns / 1ns
//ReadWeight
module ReadWeight
import definitions_pkg::*;
#(parameter id = 0)
(
input k_t k,
input cg_addr_t phcg_weightId,
input logic isBMWeightValid, isWeightValid,
output logic write_weights,
output weight_bus_addr_t start,
output k_t weight_size
);
    cg_addr_t gid; 
    always_comb begin
        write_weights = 0;
        start = 0;
        weight_size = 0;
        gid = 0;
        if (isBMWeightValid)
        begin
		      if(k == 3)
                  gid = id / 3;
              else if(k == 5)
                  gid = id / 5;
              else if(k == 7)
                  gid = id / 7;
              else if(k == 2)
                  gid = id / 2;
              else if(k == 4)
                  gid = id / 4;
              else if(k == 6)
                  gid = id / 6;
              else
                  gid = id;
		  if ((phcg_weightId >> 1) == (gid >> 1))
		  begin
              write_weights = 1;
              start = (gid & 1) * BM_SIZE;
              weight_size = 2;
		  end
		end //isBMWeightValid
		else if (isWeightValid)
		begin
		  weight_size = k;
		  if (k == 1)
		  begin
			automatic int wid;
			wid = id;
			if ((phcg_weightId >> 3) == (wid >> 3))
			begin
			  write_weights = 1;
              start = (wid & 7);
            end
          end //(k == 1
		  else if (k <= 4)
		  begin
			if ((phcg_weightId >> 1) == (id >> 1))
			begin
			  write_weights = 1;
			  if(k == 2)
                  start = (id & 1) * 2;
              else if(k == 3)
                  start = (id & 1) * 3;
              else 
                  start = (id & 1) * 4;
            end
          end //k <= 4
		  else begin
			if ((phcg_weightId) == (id))
			begin
			  write_weights = 1;
			  if(k == 5)
                  start = (id) * 5;
              else if(k == 6)
                  start = (id) * 6;
              else
                  start = (id) * 7;
            end
           end
		end //isWeightValid
    end
endmodule


module ProcessConv
import definitions_pkg::*;
(
input HCB_STATE state,
input k_t k,
input logic isInitLayer, doLRelu, doRelu, bmPhase,
input k_t iterCountDown,
input k_t conv_idx,
output ucl_config_t cfg
);
     always_comb begin
        //cfg = '{default:0};
	cfg.mMux = UCLM_X;
	cfg.a0Mux = UCLA0_MUL;
	cfg.aMux = UCLA_W;
	cfg.sqMux = UCLSQ_AQ;
	cfg.lMux = UCLL_0;
	cfg.oMux = UCLO_RELU;
        case(state)
        CONV_MULT:
			if (k == 1)
			begin
				cfg.mMux = UCLM_X;
				cfg.a0Mux = UCLA0_MUL;
				cfg.oMux = UCLO_AQ;
				if (!isInitLayer)// move to k - 1 is needed
					cfg.aMux = UCLA_PSUM;
				else
					cfg.aMux = UCLA_0;
			end
			else begin
				cfg.mMux = UCLM_X;
				//cfg.aqMux = UCLAQ_PLUS;
				//cfg.saMux = UCLSA_LOW;
				cfg.oMux = UCLO_SQ;
				cfg.a0Mux = UCLA0_MUL;
				if (iterCountDown == k - 1)
				begin
					cfg.aMux = UCLA_AQ;
					if (conv_idx == 0)
						cfg.sqMux = UCLSQ_PLUS;
				end
				else if (iterCountDown == k - 2)
				begin
					cfg.sqMux = UCLSQ_AQ;
					if (!isInitLayer && conv_idx == 0)// move to k - 1 is needed
						cfg.aMux = UCLA_PSUM;
					else
						cfg.aMux = UCLA_0;
				end
				else begin
					cfg.aMux = UCLA_AQ;
					if (conv_idx <= iterCountDown)
						cfg.sqMux = UCLSQ_SQ;
					else if (conv_idx == iterCountDown + 1) // condition not really needed
						cfg.sqMux = UCLSQ_PLUS;
				end
			end
		CONV_BM :
			begin
			//if (bmPhase == 0)
				cfg.oMux = UCLO_AQ;
				cfg.mMux = UCLM_PSUM;
			//else begin
				cfg.a0Mux = UCLA0_MS;
				cfg.aMux = UCLA_W;
			end
        CONV_RELU :
        begin
			if (doRelu)
				cfg.lMux = UCLL_0;
			else if (doLRelu)
			begin
				cfg.lMux = UCLL_MUL;
				cfg.mMux = UCLM_PSUM;
			end
			cfg.oMux = UCLO_RELU;
		end
		endcase
	end
endmodule

module ProcessWeights
import definitions_pkg::*;
(
input HCB_STATE state, state_next,
input k_t k,
input s_feature_t wLRelu,
input logic isLReluWeight, nextWeight,
input k_t weightId,
input s_feature_t weight, new_weight,
output k_t weightId_next,
output s_feature_t weight_next
);
     always_comb begin
        weightId_next = weightId;
        weight_next = weight;
        if (isLReluWeight)
        begin
			weightId_next = 0;
			weight_next = wLRelu;
		end
		else if (state == CONV_MULT  || state == CONV_START)
		begin
			weight_next = new_weight;
			if (state == CONV_START && nextWeight && k != 1)
			//if (state == CONV_START &&  k != 1)
				weightId_next = 1;
			else if (state_next == CONV_BM)
				weightId_next = 0;
			else if (weightId == k - 1 || k == 1)
				weightId_next = 0;
			else
				weightId_next = weightId + 1;

		end 
		else if (state == CONV_BM)
		begin
			weight_next= new_weight;
			if (!nextWeight)
				if (weightId == 0)
					weightId_next = 1;
				else
					weightId_next = 0;
			else
				weightId_next = 0;
		end
		else if (state == CONV_RELU || state == CONV_OUT || nextWeight)
			weightId_next = 0;
		
     end
endmodule 
     
module ReadBackUp
import definitions_pkg::*;
(
`ifdef S2_OPTIMIZE
input logic  isStride2,
output logic in_backup2_bus_valid,
output s_feature_t in_backup2_bus[COMPUTING_GROUP_SIZE],
`endif

input k_t phcg_backupId,
`ifdef S2_OPTIMIZE  
input s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE*2],
`else
input s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE],
`endif
input logic isBackupValid,
input k_t k,
input k_t conv_idx,
output logic in_backup_bus_valid,
output s_feature_t in_backup_bus[COMPUTING_GROUP_SIZE]
);
	always_comb begin 
	   in_backup_bus_valid = 0; 
	   in_backup_bus = '{default:0};
`ifdef S2_OPTIMIZE
	   in_backup2_bus = '{default:0};
	   in_backup2_bus_valid = 0;
`endif
	   if (isBackupValid && (phcg_backupId == conv_idx))
	   begin
		//for (int i = 0; i < COMPUTING_GROUP_SIZE; i++){
`ifdef S2_OPTIMIZE
			if (isStride2)
			begin
			    in_backup_bus_valid = 1;
			    in_backup2_bus_valid = 1;
			    for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
			    begin
				    in_backup_bus[i] = phcg_backupBus[i << 1];
				    in_backup2_bus[i] = phcg_backupBus[(i << 1) + 1];
				end
			end
			else 
`endif
			begin
			    in_backup_bus_valid = 1;
			    for (int i = 0; i < COMPUTING_GROUP_SIZE; i++)
				    in_backup_bus[i] = phcg_backupBus[i];
			end
	   end
	end
endmodule
	
module SCG
import definitions_pkg::*;
#(parameter id = 0, isBottom = 0)
(
input logic clock, resetN,
input HCB_STATE state, state_next,
input scale_t wscale,
input k_t k,
input logic isInitLayer, doLRelu, doRelu, bmPhase,isLReluWeight,
input logic cgSwitchOutput,nextWeight, setConvIndex, 
`ifdef S2_OPTIMIZE
input logic isStride2,
`else
input pad_t stride,
`endif
input logic isBMWeightValid, isWeightValid,
input s_feature_t wLRelu,
input cg_addr_t phcg_weightId,
input k_t inst_k, 
input k_t iterCountDown,
input s_weight_t weightBus[WEIGHT_BUS_SIZE],
//input s_feature_t bmWeightBus[WEIGHT_BUS_SIZE],
input INPUT_SOURCE input_src,
`ifdef S2_OPTIMIZE  
input s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE*2],
`else
input s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE],
`endif
input s_feature_t shiftInputs[MAX_K],
input s_feature_t shift_s[COMPUTING_GROUP_SIZE],
input s_mult_t psum_low[COMPUTING_GROUP_SIZE],
input logic output_ready,
input k_t phcg_backupId,
input logic isBackupValid,
input width_t read_pos, write_pos,
input output_addr_t out_row,
input logic is_cycle_froze,
output s_feature_t shift_n[COMPUTING_GROUP_SIZE],
output s_mult_t psum_up[COMPUTING_GROUP_SIZE],
output s_feature_t pre_output[COMPUTING_GROUP_SIZE]
);
    logic isOutput0;
    k_t conv_idx;
    k_t weightId;
	logic readWeights0;
	s_feature_t weight, new_weight;
	logic isOutput0_next;
    k_t conv_idx_next, cidx;
    k_t weightId_next;
	logic readWeights0_next;
	s_feature_t weight_next;
    ucl_config_t cfg;
    s_feature_t weights0[MAX_K];
    s_feature_t weights1[MAX_K];
    logic write_weights;
    k_t weight_size;
    weight_bus_addr_t start;
    INPUT_SOURCE is;
    logic do_output_scale;
    scale_t conv_scale, conv_scale_next;
    scale_t bm_scale, bm_scale_next;
    logic in_backup_bus_valid;
    s_feature_t shift_e[COMPUTING_GROUP_SIZE];
    s_feature_t in_backup_bus[COMPUTING_GROUP_SIZE];
    s_feature_t pre_output0[COMPUTING_GROUP_SIZE];
`ifdef S2_OPTIMIZE
    logic in_backup2_bus_valid;
    s_feature_t in_backup2_bus[COMPUTING_GROUP_SIZE];
`endif
    genvar geni;
    
    assign shift_e[COMPUTING_GROUP_SIZE - 1] = shiftInputs[conv_idx];
    assign readWeights0_next = nextWeight? ~readWeights0 : readWeights0;
    assign isOutput0_next = cgSwitchOutput? ~isOutput0 : isOutput0;
    assign conv_idx_next = setConvIndex? cidx : conv_idx;
    assign do_output_scale = (state == CONV_BM);
    
`ifdef S2_OPTIMIZE
    assign pre_output = pre_output0;
`else
    always_comb
        for(int i = 0; i < COMPUTING_GROUP_SIZE;i++)
            if(stride == 1)
                pre_output[i] = pre_output0[i];
            else
                pre_output[i] = (i * 2 > COMPUTING_GROUP_SIZE) ? pre_output0[i] : pre_output0[i * 2];
`endif
    
    always_ff @(posedge clock)
      if (!resetN)
        {conv_scale, bm_scale} <= '0;
    else if(!is_cycle_froze)
        {conv_scale, bm_scale} <= {conv_scale_next, bm_scale_next}; 
    
    always_ff @(posedge clock)
      if (!resetN)
        {isOutput0, conv_idx, weightId, readWeights0, weight} <= '0;
    else if(!is_cycle_froze)
        {isOutput0, conv_idx, weightId, readWeights0, weight} 
        <= {isOutput0_next, conv_idx_next, weightId_next, readWeights0_next, weight_next};
       
    always_ff @(posedge clock)
      if (!resetN)
      begin
        weights0 <= '{default:0};
        weights1 <= '{default:0};
      end
      else begin
        if(write_weights && !is_cycle_froze)
            if(isWeightValid)
                if (readWeights0)
                    for(int i = 0; i < MAX_K; i++)
                        weights1[i] <= (i < weight_size)? weightBus[start + i] : signed'(0);
                else
                    for(int i = 0; i < MAX_K; i++)
                        weights0[i] <= (i < weight_size)? weightBus[start + i] : signed'(0);
            else
                if (readWeights0)
                    for(int i = 0; i < MAX_K; i++)
                        weights1[i] <= (i < weight_size)? weightBus[start + i] : signed'(0);
                else
                    for(int i = 0; i < MAX_K; i++)
                        weights0[i] <= (i < weight_size)? weightBus[start + i] : signed'(0);
      end

      always_comb 
      begin
        conv_scale_next = conv_scale;
        bm_scale_next = bm_scale;
        if(isBMWeightValid && write_weights && !is_cycle_froze) 
        begin
            conv_scale_next = weightBus[start + 2] >> 4;
            bm_scale_next = weightBus[start + 2] & 4'hf; 
        end
      end

      always_comb 
      begin
	      if(inst_k == 2)
			cidx = id % 2;
	      else if(inst_k == 3)
			cidx = id % 3;
	      else if(inst_k == 4)
			cidx = id % 4;
	      else if(inst_k == 5)
			cidx = id % 5;
	      else if(inst_k == 6)
			cidx = id % 6;
	      else if(inst_k == 7)
			cidx = id % 7;
	      else 
			cidx = 0;

      end
     // GetWeight()
	always_comb begin
		if (nextWeight)
			if (readWeights0_next)
				new_weight = weights0[0]; 
			else
				new_weight = weights1[0];
		else
			if (readWeights0_next)
				new_weight = weights0[weightId]; 
			else
				new_weight = weights1[weightId];
	end 
    
    always_comb begin  
        if (input_src == INPUT_S && conv_idx == k - 1)
	       is = INPUT_BACKUP;
		else 
		   is = input_src;
	end
	
    generate
        for (geni=0; geni< COMPUTING_GROUP_SIZE; geni = geni + 1) begin : ucu
          if(geni == 0)
            UCU #(.isBottom(isBottom)) u
            (
               .clock, .resetN,
               .cfg,
               .conv_scale, .bm_scale, .wscale,
               .is,
               .isOutput0,
               .shift_e(shift_e[geni]), 
               .shift_s(shift_s[geni]),
               .in_backup_bus(in_backup_bus[geni]),
               .psum_low(psum_low[geni]),
               .in_backup_bus_valid,
               .output_ready, .do_output_scale,
               .read_pos, .write_pos,
               .out_row,
               .w(weight),
               .is_cycle_froze,
`ifdef S2_OPTIMIZE
                .isStride2,
                .in_backup2_bus(in_backup2_bus[geni]),
                .in_backup2_bus_valid,
`endif
               .pre_output(pre_output0[geni]),
               //.shift_w('x), 
               .shift_n(shift_n[geni]),
               .psum_up(psum_up[geni])
             );
          else   
             UCU #(.isBottom(isBottom)) u
            (
               .clock, .resetN,
               .cfg,
               .conv_scale, .bm_scale, .wscale,
               .is,
               .isOutput0,
               .shift_e(shift_e[geni]), 
               .shift_s(shift_s[geni]),
               .in_backup_bus(in_backup_bus[geni]),
               .psum_low(psum_low[geni]),
               .in_backup_bus_valid,
               .output_ready, .do_output_scale,
               .read_pos, .write_pos,
               .out_row,
               .w(weight),
               .is_cycle_froze,
`ifdef S2_OPTIMIZE
                .isStride2,
                .in_backup2_bus(in_backup2_bus[geni]),
                .in_backup2_bus_valid,
`endif
               .pre_output(pre_output0[geni]),
               .shift_w(shift_e[geni - 1]), 
               .shift_n(shift_n[geni]),
               .psum_up(psum_up[geni])
             );
    end 
    endgenerate 
    
    ReadWeight #(.id(id)) readWeight(.*);
    
	ReadBackUp readBackUp(.*);
	
    ProcessWeights processWeights(.*);
     
    ProcessConv  processConv(.*);
     
endmodule

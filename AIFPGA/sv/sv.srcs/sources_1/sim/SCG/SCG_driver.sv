
`timescale 1ns / 1ns
import definitions_pkg::*;
typedef struct {
HCB_STATE state, state_next;
 scale_t wscale;
 k_t k;
 logic isInitLayer, doLRelu, doRelu, bmPhase,isLReluWeight;
 logic cgSwitchOutput,nextWeight, setConvIndex;
`ifdef S2_OPTIMIZE
 logic isStride2;
`else
 pad_t stride;
`endif
 logic isBMWeightValid, isWeightValid;
 s_feature_t wLRelu;
 cg_addr_t phcg_weightId;
 k_t inst_k;
 k_t iterCountDown;
 s_weight_t weightBus[WEIGHT_BUS_SIZE];
 s_feature_t bmWeightBus[WEIGHT_BUS_SIZE];
 INPUT_SOURCE input_src;
`ifdef S2_OPTIMIZE  
 s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE*2];
`else
 s_feature_t phcg_backupBus[COMPUTING_GROUP_SIZE];
`endif
 s_feature_t shiftInputs[MAX_K];
 s_feature_t shift_s[COMPUTING_GROUP_SIZE];
 s_mult_t psum_low[COMPUTING_GROUP_SIZE];
 logic output_ready;
 k_t phcg_backupId;
 logic isBackupValid;
 logic is_cycle_froze;
 width_t read_pos, write_pos;
 output_addr_t out_row;
} SCG_inputs;

typedef struct {
  longint unsigned tm;
  logic write_weights;
  weight_bus_addr_t start;
  cg_addr_t gid;
  logic isOutput0;
  k_t conv_idx;
  k_t weightId;
  logic readWeights0;
  s_feature_t weight;
  s_feature_t shift_n[COMPUTING_GROUP_SIZE];
  s_feature_t inputs[COMPUTING_GROUP_SIZE];
  s_feature_t backups[COMPUTING_GROUP_SIZE];
  s_mult_t mq[COMPUTING_GROUP_SIZE];
  s_mult_t aq[COMPUTING_GROUP_SIZE];
  s_mult_t sq[COMPUTING_GROUP_SIZE];
  s_mult_t psumq[COMPUTING_GROUP_SIZE];
  s_mult_t psum_up[COMPUTING_GROUP_SIZE];
  ucl_config_t cfg;
  s_feature_t pre_output[COMPUTING_GROUP_SIZE];
} SCG_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output SCG_inputs in_data);
import "DPI-C" function void compare_outputs(input SCG_outputs out_data);

class SCG_driver;


  virtual SCG_ports ports;
  SCG_inputs input_data;
  SCG_outputs output_data;
  logic out_clock;

  function new (virtual SCG_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

   task reset_inputs();
  begin
     // ports = '{default:0};
	ports.state = IDLE;
	ports.state_next = IDLE;
	ports.wscale = '0;
	ports.k = '0;
	ports.isInitLayer = '0;
	ports.doLRelu = '0;
	ports.doRelu = '0;
	ports.bmPhase = '0;
	ports.isLReluWeight = '0;
	ports.cgSwitchOutput = '0;
	ports.nextWeight = '0;
	ports.setConvIndex = '0;
`ifdef S2_OPTIMIZE
	ports.isStride2 = '0;
`else
	ports.stride = '0;
`endif
	ports.isBMWeightValid = '0;
	ports.isWeightValid = '0;
	ports.wLRelu = '0;
	ports.phcg_weightId = '0;
	ports.inst_k = '0;
	ports.iterCountDown = '0;
	ports.weightBus = '{default:0};
	ports.bmWeightBus = '{default:0};
	ports.input_src = INPUT_NON;
	ports.phcg_backupBus = '{default:0};
	ports.shiftInputs = '{default:0};
	ports.shift_s = '{default:0};
	ports.psum_low = '{default:0};
	ports.output_ready = '0;
	ports.phcg_backupId = '0;
	ports.isBackupValid = '0;
	ports.is_cycle_froze = '0;
	ports.read_pos = '0;
	ports.write_pos = '0;
	ports.out_row = '0;
  end
  endtask


  task assign_inputs();
  begin
	ports.state = input_data.state ;
	ports.state_next = input_data.state_next;
	ports.wscale = input_data.wscale;
	ports.k = input_data.k;
	ports.isInitLayer = input_data.isInitLayer ;
	ports.doLRelu = input_data.doLRelu;
	ports.doRelu = input_data.doRelu  ;
	ports.bmPhase = input_data.bmPhase;
	ports.isLReluWeight = input_data.isLReluWeight;
	ports.cgSwitchOutput = input_data.cgSwitchOutput;
	ports.nextWeight = input_data.nextWeight  ;
	ports.setConvIndex = input_data.setConvIndex ;
`ifdef S2_OPTIMIZE
	ports.isStride2 = input_data.isStride2;
`else
	ports.stride = input_data.stride;
`endif
	ports.isBMWeightValid = input_data.isBMWeightValid ;
	ports.isWeightValid = input_data.isWeightValid;
	ports.wLRelu = input_data.wLRelu;
	ports.phcg_weightId = input_data.phcg_weightId;
	ports.inst_k = input_data.inst_k ;
	ports.iterCountDown = input_data.iterCountDown;
	ports.weightBus = input_data.weightBus;
	ports.bmWeightBus = input_data.bmWeightBus;
	ports.input_src = input_data.input_src;
	ports.phcg_backupBus = input_data.phcg_backupBus;
	ports.shiftInputs = input_data.shiftInputs;
	ports.shift_s = input_data.shift_s;
	ports.psum_low = input_data.psum_low;
	ports.output_ready = input_data.output_ready ;
	ports.phcg_backupId = input_data.phcg_backupId;
	ports.isBackupValid = input_data.isBackupValid;
	ports.is_cycle_froze = input_data.is_cycle_froze;
	ports.read_pos = input_data.read_pos ;
	ports.write_pos = input_data.write_pos;
	ports.out_row = input_data.out_row;
  end
  endtask

  task assign_outputs();
  begin
      output_data.tm = $time;
	  output_data.write_weights = SCG_tb.scg.write_weights;
	  output_data.start = SCG_tb.scg.start;
	  output_data.gid = SCG_tb.scg.readWeight.gid;
	  output_data.isOutput0 = SCG_tb.scg.isOutput0;
	  output_data.conv_idx = SCG_tb.scg.conv_idx;
	  output_data.weightId = SCG_tb.scg.weightId;
	  output_data.readWeights0 = SCG_tb.scg.readWeights0;
	  output_data.weight = SCG_tb.scg.weight;
	  output_data.shift_n = ports.shift_n;
	  output_data.psum_up = ports.psum_up;
	  output_data.pre_output = ports.pre_output;
	  output_data.cfg = SCG_tb.scg.cfg;
	  output_data.inputs[0] = SCG_tb.scg.ucu[0].genblk1.u.inputf;
	  output_data.inputs[1] = SCG_tb.scg.ucu[1].genblk1.u.inputf;
	  output_data.inputs[2] = SCG_tb.scg.ucu[2].genblk1.u.inputf;
	  output_data.inputs[3] = SCG_tb.scg.ucu[3].genblk1.u.inputf;
	  output_data.inputs[4] = SCG_tb.scg.ucu[4].genblk1.u.inputf;
	  output_data.inputs[5] = SCG_tb.scg.ucu[5].genblk1.u.inputf;
	  output_data.inputs[6] = SCG_tb.scg.ucu[6].genblk1.u.inputf;
	  output_data.backups[0] = SCG_tb.scg.ucu[0].genblk1.u.backup;
	  output_data.backups[1] = SCG_tb.scg.ucu[1].genblk1.u.backup;
	  output_data.backups[2] = SCG_tb.scg.ucu[2].genblk1.u.backup;
	  output_data.backups[3] = SCG_tb.scg.ucu[3].genblk1.u.backup;
	  output_data.backups[4] = SCG_tb.scg.ucu[4].genblk1.u.backup;
	  output_data.backups[5] = SCG_tb.scg.ucu[5].genblk1.u.backup;
	  output_data.backups[6] = SCG_tb.scg.ucu[6].genblk1.u.backup;

	  output_data.mq[0] = SCG_tb.scg.ucu[0].genblk1.u.ucl_i.mq;
	  output_data.mq[1] = SCG_tb.scg.ucu[1].genblk1.u.ucl_i.mq;
	  output_data.mq[2] = SCG_tb.scg.ucu[2].genblk1.u.ucl_i.mq;
	  output_data.mq[3] = SCG_tb.scg.ucu[3].genblk1.u.ucl_i.mq;
	  output_data.mq[4] = SCG_tb.scg.ucu[4].genblk1.u.ucl_i.mq;
	  output_data.mq[5] = SCG_tb.scg.ucu[5].genblk1.u.ucl_i.mq;
	  output_data.mq[6] = SCG_tb.scg.ucu[6].genblk1.u.ucl_i.mq;
	  output_data.aq[0] = SCG_tb.scg.ucu[0].genblk1.u.ucl_i.aq;
	  output_data.aq[1] = SCG_tb.scg.ucu[1].genblk1.u.ucl_i.aq;
	  output_data.aq[2] = SCG_tb.scg.ucu[2].genblk1.u.ucl_i.aq;
	  output_data.aq[3] = SCG_tb.scg.ucu[3].genblk1.u.ucl_i.aq;
	  output_data.aq[4] = SCG_tb.scg.ucu[4].genblk1.u.ucl_i.aq;
	  output_data.aq[5] = SCG_tb.scg.ucu[5].genblk1.u.ucl_i.aq;
	  output_data.aq[6] = SCG_tb.scg.ucu[6].genblk1.u.ucl_i.aq;
	  output_data.sq[0] = SCG_tb.scg.ucu[0].genblk1.u.ucl_i.sq;
	  output_data.sq[1] = SCG_tb.scg.ucu[1].genblk1.u.ucl_i.sq;
	  output_data.sq[2] = SCG_tb.scg.ucu[2].genblk1.u.ucl_i.sq;
	  output_data.sq[3] = SCG_tb.scg.ucu[3].genblk1.u.ucl_i.sq;
	  output_data.sq[4] = SCG_tb.scg.ucu[4].genblk1.u.ucl_i.sq;
	  output_data.sq[5] = SCG_tb.scg.ucu[5].genblk1.u.ucl_i.sq;
	  output_data.sq[6] = SCG_tb.scg.ucu[6].genblk1.u.ucl_i.sq;
	  output_data.psumq[0] = SCG_tb.scg.ucu[0].genblk1.u.ucl_i.psumq;
	  output_data.psumq[1] = SCG_tb.scg.ucu[1].genblk1.u.ucl_i.psumq;
	  output_data.psumq[2] = SCG_tb.scg.ucu[2].genblk1.u.ucl_i.psumq;
	  output_data.psumq[3] = SCG_tb.scg.ucu[3].genblk1.u.ucl_i.psumq;
	  output_data.psumq[4] = SCG_tb.scg.ucu[4].genblk1.u.ucl_i.psumq;
	  output_data.psumq[5] = SCG_tb.scg.ucu[5].genblk1.u.ucl_i.psumq;
	  output_data.psumq[6] = SCG_tb.scg.ucu[6].genblk1.u.ucl_i.psumq;
  end
  endtask

  task gen_oclk();
  begin
  while(1) begin
	  @ (posedge ports.clock);
	  #1 out_clock = 1'b1;
	  @ (negedge ports.clock);
	  #1 out_clock = 1'b0;
  end
  end
  endtask

  task reset();
  begin
    ports.resetN= 1'b0;
    $write("%d test\n", (-(1 << (MULT_BIT_SIZE - 1))));
    $write("%dns : asserting reset\n",$time);
    for(int i = 0; i < 5; i++) begin
       @ (posedge ports.clock);
       $write("%dns :waiting clk\n",$time);
    end
    ports.resetN= 1'b1;
    $write("%dns : Done asserting reset\n",$time);
  end
  endtask

  task gen_input();
  begin
    while (1) begin
       @ (posedge ports.clock);
       if(ports.resetN == 1'b0)
       begin
           reset_inputs();
	       continue;
       end
       read_inputs(input_data);
       assign_inputs();
       //#1
       //assign_outputs();
       //compare_outputs(output_data);
       //$write("%dns : state = %d %d, icd %d, mMux %d, a0Mux %d, aMux %d, sqMux %d, lMux %d, oMux %d\n", $time
       //		,ports.state, ports.state_next, ports.iterCountDown, SCG_tb.scg.cfg.mMux, SCG_tb.scg.cfg.a0Mux, SCG_tb.scg.cfg.aMux
	//	, SCG_tb.scg.cfg.sqMux, SCG_tb.scg.cfg.lMux, SCG_tb.scg.cfg.oMux);
     //  if(ports.isBMWeightValid)
	//    $write("BMWeights (%d) %d %d %d %d %d %d %d %d\n", ports.phcg_weightId
    	//	,ports.bmWeightBus[0],ports.bmWeightBus[1],ports.bmWeightBus[2],ports.bmWeightBus[3]
	//	,ports.bmWeightBus[4],ports.bmWeightBus[5],ports.bmWeightBus[6],ports.bmWeightBus[7]);

    //$write("%dns : isWeightValid %d , isBMWeightValid %d\n",$time, ports.isWeightValid, ports.isBMWeightValid);
    //$write("weights0: %d %d %d\n", SCG_tb.scg.weights0[0], SCG_tb.scg.weights0[1], SCG_tb.scg.weights0[2]);
    //$write("weights1: %d %d %d\n", SCG_tb.scg.weights1[0], SCG_tb.scg.weights1[1], SCG_tb.scg.weights1[2]);
    //$write("state = %d %d , nextweight = %d, readweights0 %d, weightId %d %d, weight %d, new_weight %d, isLRelu %d, wLrelu %d\n"
    //      , ports.state, ports.state_next, ports.nextWeight, SCG_tb.scg.readWeights0
	//  , SCG_tb.scg.weightId, SCG_tb.scg.weightId_next, SCG_tb.scg.weight, SCG_tb.scg.new_weight
	//  , ports.isLReluWeight, ports.wLRelu);
    end
  end
  endtask

  task cmp_output();
  begin
      int first_output = 1;
    while (1) begin
      @ (posedge out_clock);
       if(ports.resetN == 1'b0)
	       continue;
       if(first_output) begin
           first_output = 0;
           continue;
       end
       #1
       assign_outputs();
       compare_outputs(output_data);
    end
  end
  endtask
  
  task go();
  begin
    // Assert reset first
    // Start the monitors
    fork
      reset();
      gen_oclk();
      gen_input();
      cmp_output();
    join
  end
  endtask 
endclass

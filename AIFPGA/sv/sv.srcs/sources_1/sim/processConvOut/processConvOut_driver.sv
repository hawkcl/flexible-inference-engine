
import definitions_pkg::*;
typedef struct {
	HCB_STATE state;
	logic enable;
	logic isOnOutput;
	logic pwrite_isWritable;
	logic resBuf_empty;
	//logic waiting_out;
	//logic doBatch3K1_out;
	logic doRes_out, doUpSample_out;
	width_t outputBufW1_out;
	outframe_addr_t outFrameSize_out;
	out_width_t outW_out, outW_out2;
	pad_t maxpool_stride_out;
	output_gap_t outputAddrGap_out;
	k_t k_out;
	seq_t curSeq_out; // for debug; unused now
	logic newWriteInst_out;
	width_t outputBufH1_out;
	cg_addr_t outputIdxMax;
	s_feature_t pre_output[CG_NUM][COMPUTING_GROUP_SIZE];
	s_feature_t  resBuf[COMPUTING_GROUP_SIZE];
	logic set_LastOutput;

	logic new_params;
	mem_addr_t new_outputAddr; 
	mem_addr_t new_outputFrameStart;
	logic set_out_params;
	mem_addr_t new_outputAddr_out, new_outputFrameStart_out;
} processConvOut_inputs;

typedef struct {
	logic res_en;
	s_feature_t pwrite_data[COMPUTING_GROUP_SIZE];
	logic pwrite_enable;
	mem_addr_t pwrite_addr;
	logic pwrite_setNextInst;
	output_addr_t out_row;
	logic reset_state;    // TO IDLE
	mem_addr_t outputAddr; 
	mem_addr_t outputFrameStart;
	logic reset_isOnOutput;

	cg_addr_t outputCGIdx;
	cg_addr_t outputCGIdx0;
	mem_addr_t outputFrameStart_out;
	logic unsigned [1:0] outputUPSteps;
} processConvOut_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output processConvOut_inputs in_data);
import "DPI-C" function void compare_outputs(input processConvOut_outputs out_data);

class processConvOut_driver;


  virtual processConvOut_ports ports;
  processConvOut_inputs input_data;
  processConvOut_outputs output_data;
  logic out_clock;

  function new (virtual processConvOut_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.state = input_data.state;
	ports.enable = input_data.enable;
        ports.isOnOutput = input_data.isOnOutput;
        ports.pwrite_isWritable = input_data.pwrite_isWritable;
	ports.resBuf_empty = input_data.resBuf_empty;
	ports.doRes_out = input_data.doRes_out;
	ports.doUpSample_out = input_data.doUpSample_out;
	ports.outputBufW1_out = input_data.outputBufW1_out;
	ports.outFrameSize_out = input_data.outFrameSize_out;
	ports.outW_out = input_data.outW_out;
	ports.outW_out2 = input_data.outW_out2;
	ports.maxpool_stride_out = input_data.maxpool_stride_out;
	ports.outputAddrGap_out = input_data.outputAddrGap_out;
	ports.k_out = input_data.k_out;
	ports.curSeq_out = input_data.curSeq_out;
	ports.newWriteInst_out = input_data.newWriteInst_out;
	ports.outputBufH1_out = input_data.outputBufH1_out;
	ports.outputIdxMax = input_data.outputIdxMax;
	ports.pre_output = input_data.pre_output;
	ports.set_LastOutput = input_data.set_LastOutput;
	ports.new_params = input_data.new_params;
	ports.new_outputAddr = input_data.new_outputAddr;
	ports.new_outputFrameStart = input_data.new_outputFrameStart;
	ports.set_out_params = input_data.set_out_params;
	ports.new_outputAddr_out = input_data.new_outputAddr_out;
	ports.new_outputFrameStart_out = input_data.new_outputFrameStart_out;
	for(int i = 0; i < COMPUTING_GROUP_SIZE; i++)
		ports.resBuf[i] = input_data.resBuf[i];

  end
  endtask

  task assign_outputs();
  begin
	  output_data.res_en = ports.res_en;
      for(int i = 0; i < COMPUTING_GROUP_SIZE; i++) begin
    	  output_data.pwrite_data[i] = ports.pwrite_data[i];
      end
	  output_data.pwrite_enable = ports.pwrite_enable;
	  output_data.pwrite_addr = ports.pwrite_addr;
	  output_data.pwrite_setNextInst = ports.pwrite_setNextInst;
	  output_data.out_row = ports.out_row;
	  output_data.reset_state = ports.reset_state;
	  output_data.outputAddr = ports.outputAddr;
	  output_data.outputFrameStart = ports.outputFrameStart;
	  output_data.reset_isOnOutput = ports.reset_isOnOutput;
	
	  output_data.outputCGIdx = processConvOut_tb.processConvOut.outputCGIdx;
	  output_data.outputCGIdx0 = processConvOut_tb.processConvOut.outputCGIdx0;
	  output_data.outputFrameStart_out = processConvOut_tb.processConvOut.outputFrameStart_out;
	  output_data.outputUPSteps = processConvOut_tb.processConvOut.outputUPSteps;

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
	       continue;
       read_inputs(input_data);
       assign_inputs();
       $write("%dns : inputs\n", $time);
    end
  end
  endtask

  task cmp_output();
  begin
      int first_output = 1;
    while (1) begin
      @ (posedge out_clock);
       //@ processConvOut_ports.cb
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

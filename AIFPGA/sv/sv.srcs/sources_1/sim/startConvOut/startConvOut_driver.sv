
import definitions_pkg::*;
typedef struct {
	logic enable;
	logic isNextVolumeReady, isPrefetchNextVolume_next, isPrefetchNextVolume;
	logic reset_isOnOutput;
	layer_addr_t kt, ks;
	cg_addr_t numGroups;
	k_t k;
	logic doRes;
	logic doUpSample;
	width_t outputBufW1;
	outframe_addr_t outFrameSize;
	out_width_t outW;
	output_gap_t outputAddrGap;
	pad_t maxpool_stride;
	seq_t curSeq;
	logic newWriteInst;
	width_t outputBufH1Orig;
	mem_addr_t  outputAddr, outputFrameStart;
	logic new_params;
	layer_addr_t new_kOut;
	cg_addr_t usedCGLast;
	cg_addr_t usedCG0;
	layer_addr_t kCurLast;
} startConvOut_inputs;

typedef struct {
	logic isOnOutput;
	logic waiting_out;
	logic cgSwitchOutput;
	logic doRes_out, doUpSample_out;
	width_t outputBufW1_out;
	outframe_addr_t outFrameSize_out;
	out_width_t outW_out, outW_out2;
	pad_t maxpool_stride_out;
	output_gap_t outputAddrGap_out;
	k_t k_out;
	seq_t curSeq_out;
	logic newWriteInst_out;
	width_t outputBufH1_out;
	logic set_out_params;
	mem_addr_t outputAddr_out, outputFrameStart_out;
	logic set_LastOutput;
	cg_addr_t outputIdxMax;
	layer_addr_t kOut;

} startConvOut_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output startConvOut_inputs in_data);
import "DPI-C" function void compare_outputs(input startConvOut_outputs out_data);

class startConvOut_driver;


  virtual startConvOut_ports ports;
  startConvOut_inputs input_data;
  startConvOut_outputs output_data;
  logic out_clock;

  function new (virtual startConvOut_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.enable = input_data.enable;
        ports.isNextVolumeReady = input_data.isNextVolumeReady;
        ports.isPrefetchNextVolume_next = input_data.isPrefetchNextVolume_next;
	ports.isPrefetchNextVolume = input_data.isPrefetchNextVolume;
	ports.reset_isOnOutput = input_data.reset_isOnOutput;
	ports.kt = input_data.kt;
	ports.ks = input_data.ks;
	ports.numGroups = input_data.numGroups;
	ports.k = input_data.k;
	ports.doRes = input_data.doRes;
	ports.doUpSample = input_data.doUpSample;
	ports.outputBufW1 = input_data.outputBufW1;
	ports.outFrameSize = input_data.outFrameSize;
	ports.outW = input_data.outW;
	ports.outputAddrGap = input_data.outputAddrGap;
	ports.maxpool_stride = input_data.maxpool_stride;
	ports.curSeq = input_data.curSeq;
	ports.newWriteInst = input_data.newWriteInst;
	ports.outputBufH1Orig = input_data.outputBufH1Orig;
	ports.outputAddr = input_data.outputAddr;
	ports.outputFrameStart = input_data.outputFrameStart;
	ports.new_params = input_data.new_params;
	ports.new_kOut = input_data.new_kOut;
	ports.usedCGLast = input_data.usedCGLast;
	ports.usedCG0 = input_data.usedCG0;
	ports.kCurLast = input_data.kCurLast;

  end
  endtask

  task assign_outputs();
  begin
	  output_data.isOnOutput = ports.isOnOutput;
	  output_data.waiting_out = ports.waiting_out;
	  output_data.cgSwitchOutput = ports.cgSwitchOutput;
	  output_data.doRes_out = ports.doRes_out;
	  output_data.doUpSample_out = ports.doUpSample_out;
	  output_data.outputBufW1_out = ports.outputBufW1_out;
	  output_data.outFrameSize_out = ports.outFrameSize_out;
	  output_data.outW_out = ports.outW_out;
	  output_data.outW_out2 = ports.outW_out2;
	  output_data.maxpool_stride_out = ports.maxpool_stride_out;
	  output_data.outputAddrGap_out = ports.outputAddrGap_out;
	  output_data.k_out = ports.k_out;
	  output_data.curSeq_out = ports.curSeq_out;
	  output_data.newWriteInst_out = ports.newWriteInst_out;
	  output_data.outputBufH1_out = ports.outputBufH1_out;
	  output_data.set_out_params = ports.set_out_params;
	  output_data.outputAddr_out = ports.outputAddr_out;
	  output_data.outputFrameStart_out = ports.outputFrameStart_out;
	  output_data.set_LastOutput = ports.set_LastOutput;
	  output_data.outputIdxMax = ports.outputIdxMax;
	  output_data.kOut = ports.kOut;
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
       //@ startConvOut_ports.cb
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

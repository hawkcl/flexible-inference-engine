
import definitions_pkg::*;
typedef struct {
	logic enable;
	logic stop;
	logic waiting_out;
	k_t k;
	pad_t stride;
	logic doBM;
	logic doRelu;
	logic doLRelu; 
	logic doRes;
	logic isOnOutput;
	logic reset_isOnOutput; // finished one output
	logic BM_enough_data;
	logic w_enough_data;
	res_size_t receivedRes;
	res_size_t totalRes;
	logic input_fifo_empty;
	layer_addr_t readCLast;
	logic new_conv_inst;
	layer_addr_t Ks;
	layer_addr_t kt;
	cg_addr_t new_wtotal;
	cg_addr_t numGroups;
	logic reset_state;
	logic resetLoadingNextFeatures;
	logic resetReadingFeatures;
	logic new_params_prefetch;
	logic setLoadingFroze;
	logic resetLoadingFroze;
	width_t writeWidth;
	logic resetAssemble;
	width_t new_readWidth;
	width_t new_outputBufH1;
	s_row_addr_t new_rowNum;
	loc_frame_t prefetchFrameSize;
	layer_addr_t new_kCur;
	cg_addr_t new_usedGroups;
	k_t inst_k;
	layer_addr_t kOut;
	layer_addr_t kCurLast;
	cg_addr_t usedGroupsLast;
	cg_addr_t wtotal_n;
	weight_bus_size_t wlenk_nLast;
	cg_addr_t wtotalLast;
	weight_bus_size_t wlenk_nLast2;
	weight_bus_size_t wlenk_regular;
	weight_bus_size_t wlen_regular;
	weight_bus_size_t new_wlenk;
	weight_bus_size_t new_wlenk_last;
	layer_addr_t kCurLast_1;
	width1_t new_maxRowCount;
	width_t new_lastLen;
} HCBCtrl_inputs;

typedef struct {
	logic startPrefetching;
	logic startConvOut; 
	weight_bus_size_t BMlen; 
	weight_bus_size_t wlenk;
	logic enSendBMWeights;
	logic enSendWeights;
	logic isBMWeightValid;
	logic isWeightValid;
	cg_addr_t weightId;
	logic sendBackUpInput_valid;
	k_t backupId;
	logic isOutputReady;
	logic nextWeight;
	width_t readWidth;
	s_row_addr_t rowNum;
	logic reset_iLayers;
	logic loadNextInst;
	logic isPrefetchNextVolume_next;
	logic isPrefetchNextVolume;
	layer_addr_t workingProgress_o;
	logic doAssemble_o;
	input_addr_t usedWords_o;
	logic isInitLayer_o;
	logic isReadingFeatures_o;
	logic isLoadingFroze_o;
	logic hasNextFeatureParams_o;
	logic isLoadingNextFeatures_o;
	logic isLReluWeight_o;
	k_t iterCountDown_o;
	width_t outputReadPos_o;
	width_t outputWritePos_o;
	HCB_STATE state_o;
	HCB_STATE state_next_o;
	width_t outputBufH1_o;
	logic isNextVolumeReady_o;
	logic bmPhase_o;
	logic isRunning_o;
	logic is_cycle_froze;
	width1_t maxRowCount;
	width_t lastLen;
	INPUT_SOURCE input_src;

	layer_addr_t outLayerCount;
	k_t initFSteps;
	cg_addr_t initWSteps;
	cg_addr_t initBMWSteps;
	layer_addr_t layerCount;
	cg_addr_t usedGroups;
	cg_addr_t wtotal;
	weight_bus_size_t wlen;
    int unsigned tm;
} HCBCtrl_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output HCBCtrl_inputs in_data);
import "DPI-C" function void compare_outputs(input HCBCtrl_outputs out_data);

class HCBCtrl_driver;


  virtual HCBCtrl_ports ports;
  HCBCtrl_inputs input_data;
  HCBCtrl_outputs output_data;
  logic out_clock;

  function new (virtual HCBCtrl_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.enable = input_data.enable;
	ports.stop = input_data.stop;
	ports.waiting_out = input_data.waiting_out;
	ports.k = input_data.k;
	ports.stride = input_data.stride;
	ports.doBM = input_data.doBM;
	ports.doRelu = input_data.doRelu;
	ports.doLRelu = input_data.doLRelu;
	ports.doRes = input_data.doRes;
	ports.isOnOutput = input_data.isOnOutput;
	ports.reset_isOnOutput = input_data.reset_isOnOutput;
	ports.BM_enough_data = input_data.BM_enough_data;
	ports.w_enough_data = input_data.w_enough_data;
	ports.receivedRes = input_data.receivedRes;
	ports.totalRes = input_data.totalRes;
	ports.input_fifo_empty = input_data.input_fifo_empty;
	ports.readCLast = input_data.readCLast;
	ports.new_conv_inst = input_data.new_conv_inst;
	ports.Ks = input_data.Ks;
	ports.kt = input_data.kt;
	ports.new_wtotal = input_data.new_wtotal;
	ports.numGroups = input_data.numGroups;
	ports.reset_state = input_data.reset_state;
	ports.resetLoadingNextFeatures = input_data.resetLoadingNextFeatures;
	ports.resetReadingFeatures = input_data.resetReadingFeatures;
	ports.new_params_prefetch = input_data.new_params_prefetch;
	ports.setLoadingFroze = input_data.setLoadingFroze;
	ports.resetLoadingFroze = input_data.resetLoadingFroze;
	ports.writeWidth = input_data.writeWidth;
	ports.resetAssemble = input_data.resetAssemble;
	ports.new_readWidth = input_data.new_readWidth;
	ports.new_outputBufH1 = input_data.new_outputBufH1;
	ports.new_rowNum = input_data.new_rowNum;
	ports.prefetchFrameSize = input_data.prefetchFrameSize;
	ports.new_kCur = input_data.new_kCur;
	ports.new_usedGroups = input_data.new_usedGroups;
	ports.inst_k = input_data.inst_k;
	ports.kOut = input_data.kOut;
	ports.kCurLast = input_data.kCurLast;
	ports.usedGroupsLast = input_data.usedGroupsLast;
	ports.wtotal_n = input_data.wtotal_n;
	ports.wlenk_nLast = input_data.wlenk_nLast;
	ports.wtotalLast = input_data.wtotalLast;
	ports.wlenk_nLast2 = input_data.wlenk_nLast2;
	ports.wlenk_regular = input_data.wlenk_regular;
	ports.wlen_regular = input_data.wlen_regular;
	ports.new_wlenk = input_data.new_wlenk;
	ports.new_wlenk_last = input_data.new_wlenk_last;
	ports.kCurLast_1 = input_data.kCurLast_1;
	ports.new_maxRowCount = input_data.new_maxRowCount;
	ports.new_lastLen = input_data.new_lastLen;
	

  end
  endtask

  task assign_outputs();
  begin
	  output_data.tm = $time; 
	  output_data.startPrefetching = ports.startPrefetching;
	  output_data.startConvOut = ports.startConvOut;
	  output_data.BMlen = ports.BMlen;
	  output_data.wlenk = ports.wlenk;
	  output_data.enSendBMWeights = ports.enSendBMWeights;
	  output_data.enSendWeights = ports.enSendWeights;
	  output_data.isBMWeightValid = ports.isBMWeightValid;
	  output_data.isWeightValid = ports.isWeightValid;
	  output_data.weightId = ports.weightId;
	  output_data.sendBackUpInput_valid = ports.sendBackUpInput_valid && !ports.is_cycle_froze;
	  output_data.backupId = ports.backupId;
	  output_data.isOutputReady = ports.isOutputReady;
	  output_data.nextWeight = ports.nextWeight;
	  output_data.readWidth = ports.readWidth;
	  output_data.rowNum = ports.rowNum;
	  output_data.reset_iLayers = ports.reset_iLayers;
	  output_data.loadNextInst = ports.loadNextInst;
	  output_data.isPrefetchNextVolume_next = ports.isPrefetchNextVolume_next;
	  output_data.isPrefetchNextVolume = ports.isPrefetchNextVolume;
	  output_data.workingProgress_o = ports.workingProgress_o;
	  output_data.doAssemble_o = ports.doAssemble_o;
	  output_data.usedWords_o = ports.usedWords_o;
	  output_data.isInitLayer_o = ports.isInitLayer_o;
	  output_data.isReadingFeatures_o = ports.isReadingFeatures_o;
	  output_data.isLoadingFroze_o = ports.isLoadingFroze_o;
	  output_data.hasNextFeatureParams_o = ports.hasNextFeatureParams_o;
	  output_data.isLoadingNextFeatures_o = ports.isLoadingNextFeatures_o;
	  output_data.isLReluWeight_o = ports.isLReluWeight_o;
	  output_data.iterCountDown_o = ports.iterCountDown_o;
	  output_data.outputReadPos_o = ports.outputReadPos_o;
	  output_data.outputWritePos_o = ports.outputWritePos_o;
	  output_data.state_o = ports.state_o;
	  output_data.state_next_o = ports.state_next_o;
	  output_data.outputBufH1_o = ports.outputBufH1_o;
	  output_data.isNextVolumeReady_o = ports.isNextVolumeReady_o;
	  output_data.bmPhase_o = ports.bmPhase_o;
	  output_data.isRunning_o = ports.isRunning_o;
	  output_data.is_cycle_froze = ports.is_cycle_froze;
	  output_data.maxRowCount = ports.maxRowCount;
	  output_data.lastLen = ports.lastLen;
	  output_data.input_src = ports.input_src;

	output_data.outLayerCount = HCBCtrl_tb.HCBCtrl.outLayerCount;
	output_data.initFSteps = HCBCtrl_tb.HCBCtrl.initFSteps;
	output_data.initWSteps = HCBCtrl_tb.HCBCtrl.initWSteps;
	output_data.initBMWSteps = HCBCtrl_tb.HCBCtrl.initBMWSteps;
	output_data.layerCount = HCBCtrl_tb.HCBCtrl.layerCount;
	output_data.usedGroups = HCBCtrl_tb.HCBCtrl.usedGroups;	  
	output_data.wtotal = HCBCtrl_tb.HCBCtrl.wtotal;	  
	output_data.wlen = HCBCtrl_tb.HCBCtrl.wlen;	  

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
       //@ HCBCtrl_ports.cb
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

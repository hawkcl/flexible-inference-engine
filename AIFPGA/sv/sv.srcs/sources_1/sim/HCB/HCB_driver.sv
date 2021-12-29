
import definitions_pkg::*;
typedef struct {
	logic 		inst_enable;
	logic 		start; 
	logic 		stop;
	logic 		pwrite_isFetchNextInst;
	InstructionHCB_unpack 	inst;
	logic 		pread_busValid;
	logic 		pread_isFeature;
	seq_t 		pread_seqNum;
	s_feature_t  	dataBus[MAX_READ_WIDTH];
	seq_t 		pcweight_seq;
	logic 		pcweight_busValid;
	s_weight_t 	pcweight_dataBus[WEIGHT_MEM_BUS_SIZE];
	logic 		pread_RequestFull;
	token_t 	ptoken;
	ReturnData_t_unpack 	pread_dataBus;
	logic 		pwrite_isWritable; 
} HCB_inputs;

//`define DETAIL_VERIFY
typedef struct {
    longint unsigned tm;
	logic 		weights_almost_full;
	logic 		instfifo_full;
	logic 		token_set;
	token_t 	max_token;
	logic 		pread_RequestValid;
	RequestItem_t_unpack 	pread_request;
	s_feature_t 	pwrite_data[COMPUTING_GROUP_SIZE];
	logic 		pwrite_enable;
	mem_addr_t 	pwrite_addr;
	logic 		pwrite_setNextInst;
	logic 		isFetchNextInst;
	layer_addr_t 	workingProgress;

    logic            isRunning;
    logic            isReadingFeatures;
    seq_t            reqFeature;
    seq_t            finishedSeq;
    seq_t            workingSeq;
    logic            isReadingWeights;
    seq_t            reqWeight;
    logic            isLoadingFroze;
    logic            isStopable;

`ifdef DETAIL_VERIFY
	logic 		new_conv_inst;
	HCB_STATE 	state;
	INPUT_SOURCE 	input_src;
	logic		isWeightValid;
	logic 		isBMWeightValid;
	logic 		isInitLayer;
	logic 		isLastLayer;
	logic 		isPrefetchWeight;
	logic 		isPrefetchBMWeight;
	logic 		isLoadingNextFeatures;
	logic		nextWeight;
	logic		cgSwitchOutput;
	logic		isPrefetchNextVolume;
	logic		isOnOutput;
	logic		waiting_out;
	logic		isNextVolumeReady;
	logic		startPrefetching; 
	logic		new_params_readFeatures;
	logic		startConvOut;
	logic 		sendBackUpInput_valid;
	cg_addr_t 	initWSteps;
	k_t 		initFSteps;
	cg_addr_t 	weightId;
	k_t 		inst_k;
	k_t 		iterCountDown;
	logic 		isOutputReady;
	logic 		doOutScale;
	k_t 		backupId;
	logic 		isBackupValid;
	width_t 	outputReadPos;
	width_t 	outputWritePos;
	output_addr_t 	outputRows;
	s_weight_t 	weightsBus[WEIGHT_BUS_SIZE];
	s_feature_t 	backupBus[COMPUTING_GROUP_SIZE];
	s_feature_t 	shiftInputs[MAX_K];
	s_mult_t 	mq0, aq0, sq0, psumq0;
	s_mult_t 	mq1, aq1, sq1, psumq1;
	s_mult_t 	mq2, aq2, sq2, psumq2;
	s_mult_t        out0, out1, out2;
`endif
} HCB_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output HCB_inputs in_data);
import "DPI-C" function void compare_outputs(input HCB_outputs out_data);

class HCB_driver;


  virtual HCB_ports ports;
  HCB_inputs input_data;
  HCB_outputs output_data;
  logic out_clock;

  function new (virtual HCB_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.inst_enable = input_data.inst_enable;
        ports.start = input_data.start;
        ports.stop = input_data.stop;
	ports.pwrite_isFetchNextInst = input_data.pwrite_isFetchNextInst;
	ports.pread_busValid = input_data.pread_busValid;
	ports.pread_isFeature = input_data.pread_isFeature;
	ports.pread_seqNum = input_data.pread_seqNum;
    for(int i = 0; i < MAX_READ_WIDTH; i++) begin
        ports.dataBus[i] = input_data.dataBus[i];
    end
	ports.pcweight_seq = input_data.pcweight_seq;
	ports.pcweight_busValid = input_data.pcweight_busValid;
	ports.pcweight_dataBus = input_data.pcweight_dataBus;
	ports.pread_RequestFull = input_data.pread_RequestFull;
	ports.ptoken = input_data.ptoken;
	//ports.pread_dataBus = input_data.pread_dataBus;

    ports.pread_dataBus.dtype = input_data.pread_dataBus.dtype;
    ports.pread_dataBus.seq = input_data.pread_dataBus.seq;
    ports.pread_dataBus.len = input_data.pread_dataBus.len;
    ports.pread_dataBus.token = input_data.pread_dataBus.token;
    for(int i = 0; i < BRAM_BUS_WIDTH; i++) begin
        ports.pread_dataBus.data[i] = input_data.pread_dataBus.data[i];
    end

	ports.pwrite_isWritable = input_data.pwrite_isWritable;

	ports.inst.isResMaster = input_data.inst.isResMaster;
	ports.inst.isProgressMaster = input_data.inst.isProgressMaster;
	ports.inst.isRaddr_a = input_data.inst.isRaddr_a;
	ports.inst.doRes = input_data.inst.doRes;
	ports.inst.doRelu = input_data.inst.doRelu;
	ports.inst.doLRelu = input_data.inst.doLRelu;
	ports.inst.doBM = input_data.inst.doBM;
	ports.inst.doUpSample = input_data.inst.doUpSample;
	ports.inst.newWriteInst = input_data.inst.newWriteInst;

	ports.inst.Id = input_data.inst.Id;
	ports.inst.itype = input_data.inst.itype;
	ports.inst.reqSeqNum = input_data.inst.reqSeqNum;
	ports.inst.reqProgress = input_data.inst.reqProgress;
	ports.inst.reqSeqNumW = input_data.inst.reqSeqNumW;
	ports.inst.reqProgressW = input_data.inst.reqProgressW;
	ports.inst.seqNum = input_data.inst.seqNum;
	ports.inst.W = input_data.inst.W;
	ports.inst.H = input_data.inst.H;
	ports.inst.C = input_data.inst.C;
	ports.inst.Waddr = input_data.inst.Waddr;
	ports.inst.WEnd = input_data.inst.WEnd;
	ports.inst.weightPos = input_data.inst.weightPos;
	ports.inst.ReadPos = input_data.inst.ReadPos;
	ports.inst.ResPos = input_data.inst.ResPos;
	ports.inst.W1 = input_data.inst.W1;
	ports.inst.H1 = input_data.inst.H1;
	ports.inst.X = input_data.inst.X;
	ports.inst.Y = input_data.inst.Y;
	ports.inst.S = input_data.inst.S;
	ports.inst.lPad = input_data.inst.lPad;
	ports.inst.rPad = input_data.inst.rPad;
	ports.inst.K = input_data.inst.K;
	ports.inst.M = input_data.inst.M;
	ports.inst.Kh = input_data.inst.Kh;
	ports.inst.Ks = input_data.inst.Ks;
	ports.inst.Kt = input_data.inst.Kt;
	ports.inst.Res_addr = input_data.inst.Res_addr;
	ports.inst.wScale = input_data.inst.wScale;
	ports.inst.fScale = input_data.inst.fScale;
	ports.inst.wLRelu = input_data.inst.wLRelu;
	ports.inst.weightToken = input_data.inst.weightToken;
	ports.inst.maxpool_size = input_data.inst.maxpool_size;
	ports.inst.maxpool_stride = input_data.inst.maxpool_stride;
	ports.inst.mode = input_data.inst.mode;
	ports.inst.outbufsize = input_data.inst.outbufsize;
	ports.inst.ofsize = input_data.inst.ofsize;
	ports.inst.outyx = input_data.inst.outyx;
	ports.inst.outputAddrGap = input_data.inst.outputAddrGap;
	ports.inst.outkh = input_data.inst.outkh;
	ports.inst.ng = input_data.inst.ng;
	ports.inst.gu = input_data.inst.gu;
	ports.inst.resSize = input_data.inst.resSize;
	ports.inst.resSizeLast = input_data.inst.resSizeLast;
	ports.inst.resLen = input_data.inst.resLen;
	ports.inst.resLenLast = input_data.inst.resLenLast;
	ports.inst.pfs = input_data.inst.pfs;
	ports.inst.volumeSize = input_data.inst.volumeSize;
	ports.inst.kCurLast = input_data.inst.kCurLast;
	ports.inst.wtotal_n = input_data.inst.wtotal_n;
	ports.inst.wtotalLast = input_data.inst.wtotalLast;
	ports.inst.wlenk_regular = input_data.inst.wlenk_regular;
	ports.inst.wlenk_nLast = input_data.inst.wlenk_nLast;
	ports.inst.wlenk_nLast2 = input_data.inst.wlenk_nLast2;
	ports.inst.totalRes = input_data.inst.totalRes;
	
  end
  endtask

  task assign_outputs();
  begin

	  output_data.tm 		= $time;
	  output_data.weights_almost_full	= ports.weights_almost_full;
	  output_data.instfifo_full 		= ports.instfifo_full;
	  output_data.token_set 		= ports.token_set;
	  output_data.max_token 		= ports.max_token;
	  output_data.pread_RequestValid 	= ports.pread_RequestValid;
      for(int i = 0; i < COMPUTING_GROUP_SIZE; i++) begin
          output_data.pwrite_data[i] 		= ports.pwrite_data[i];
      end
	  output_data.pwrite_enable 		= ports.pwrite_enable;
	  output_data.pwrite_addr 		= ports.pwrite_addr;
	  output_data.pwrite_setNextInst 	= ports.pwrite_setNextInst;
	  output_data.isFetchNextInst 		= ports.isFetchNextInst;
	  output_data.workingProgress 		= ports.workingProgress;
	  output_data.pread_request.addr 		= ports.pread_request.addr;
	  output_data.pread_request.seq 		= ports.pread_request.seq;
	  output_data.pread_request.len 		= ports.pread_request.len;
	  output_data.pread_request.token 		= ports.pread_request.token;
	  output_data.pread_request.dtype 		= ports.pread_request.dtype;
	  output_data.pread_request.isRamA 		= ports.pread_request.isRamA;
	  output_data.pread_request.isRamB 		= ports.pread_request.isRamB;
	 
	  output_data.isReadingFeatures = ports.isReadingFeatures;
	  output_data.isReadingWeights = ports.isReadingWeights;
	  output_data.isLoadingFroze = ports.isLoadingFroze;
	  output_data.isStopable = ports.isStopable;
	  output_data.isRunning = ports.isRunning;
	  output_data.reqFeature = ports.reqFeature;
	  output_data.finishedSeq = ports.finishedSeq;
	  output_data.workingSeq = ports.workingSeq;
	  output_data.reqWeight = ports.reqWeight;


`ifdef DETAIL_VERIFY
	  output_data.new_conv_inst = HCB_tb.hcb.processInstruction.new_conv_inst;
	  output_data.state = HCB_tb.hcb.hcbCtrl.state;
	  output_data.input_src = HCB_tb.hcb.hcbCtrl.input_src;
	  output_data.isWeightValid = HCB_tb.hcb.hcbCtrl.isWeightValid;
	  output_data.isBMWeightValid = HCB_tb.hcb.hcbCtrl.isBMWeightValid;
	  output_data.isInitLayer = HCB_tb.hcb.hcbCtrl.isInitLayer;
	  output_data.isLastLayer = HCB_tb.hcb.hcbCtrl.isLastLayer;
	  output_data.isPrefetchWeight = HCB_tb.hcb.hcbCtrl.isPrefetchWeight;
	  output_data.isPrefetchBMWeight = HCB_tb.hcb.hcbCtrl.isPrefetchBMWeight;
	  output_data.isLoadingNextFeatures = HCB_tb.hcb.hcbCtrl.isLoadingNextFeatures;
	  output_data.nextWeight = HCB_tb.hcb.hcbCtrl.nextWeight;
	  output_data.cgSwitchOutput = HCB_tb.hcb.start_ConvOut.cgSwitchOutput;
	  output_data.isPrefetchNextVolume = HCB_tb.hcb.hcbCtrl.isPrefetchNextVolume;
	  output_data.isOnOutput = HCB_tb.hcb.start_ConvOut.isOnOutput;
	  output_data.waiting_out = HCB_tb.hcb.start_ConvOut.waiting_out;
	  output_data.isNextVolumeReady = HCB_tb.hcb.hcbCtrl.isNextVolumeReady;
	  output_data.startPrefetching = HCB_tb.hcb.hcbCtrl.startPrefetching;
	  output_data.new_params_readFeatures = HCB_tb.hcb.new_params_readFeatures;
	  output_data.startConvOut = HCB_tb.hcb.hcbCtrl.startConvOut;
	  output_data.sendBackUpInput_valid = HCB_tb.hcb.hcbCtrl.sendBackUpInput_valid & ~HCB_tb.hcb.is_cycle_froze;
	  output_data.initFSteps = HCB_tb.hcb.hcbCtrl.initFSteps;
	  output_data.initWSteps = HCB_tb.hcb.hcbCtrl.initWSteps;
	  output_data.weightId = HCB_tb.hcb.hcbCtrl.weightId;
	  output_data.inst_k = HCB_tb.hcb.processInstruction.inst_k;
	  output_data.iterCountDown = HCB_tb.hcb.hcbCtrl.iterCountDown;
	  output_data.isOutputReady = HCB_tb.hcb.hcbCtrl.isOutputReady;
	  output_data.backupId = HCB_tb.hcb.hcbCtrl.backupId;
	  output_data.isBackupValid = HCB_tb.hcb.sendBackUpInput.isBackupValid;
	  output_data.outputReadPos = HCB_tb.hcb.hcbCtrl.outputReadPos;
	  output_data.outputWritePos = HCB_tb.hcb.hcbCtrl.outputWritePos;
	  output_data.outputRows = HCB_tb.hcb.processConvOut.outputRows;
	  output_data.weightsBus = HCB_tb.hcb.sendWeights.weightsBus;
	  output_data.backupBus = HCB_tb.hcb.sendBackUpInput.backupBus;
	  output_data.shiftInputs = HCB_tb.hcb.setupShiftInputs.shiftInputs;
	  output_data.aq0 = HCB_tb.hcb.scg[0].g.ucu[0].genblk1.u.ucl_i.aq;
	  output_data.sq0 = HCB_tb.hcb.scg[0].g.ucu[0].genblk1.u.ucl_i.sq;
	  output_data.mq0 = HCB_tb.hcb.scg[0].g.ucu[0].genblk1.u.ucl_i.mq;
	  output_data.psumq0 = HCB_tb.hcb.scg[0].g.ucu[0].genblk1.u.ucl_i.psumq;
	  output_data.aq1 = HCB_tb.hcb.scg[1].g.ucu[0].genblk1.u.ucl_i.aq;
	  output_data.sq1 = HCB_tb.hcb.scg[1].g.ucu[0].genblk1.u.ucl_i.sq;
	  output_data.mq1 = HCB_tb.hcb.scg[1].g.ucu[0].genblk1.u.ucl_i.mq;
	  output_data.psumq1 = HCB_tb.hcb.scg[1].g.ucu[0].genblk1.u.ucl_i.psumq;
	  output_data.aq2 = HCB_tb.hcb.scg[2].g.ucu[0].genblk1.u.ucl_i.aq;
	  output_data.sq2 = HCB_tb.hcb.scg[2].g.ucu[0].genblk1.u.ucl_i.sq;
	  output_data.mq2 = HCB_tb.hcb.scg[2].g.ucu[0].genblk1.u.ucl_i.mq;
	  output_data.psumq2 = HCB_tb.hcb.scg[2].g.ucu[0].genblk1.u.ucl_i.psumq;
	  output_data.out0 = HCB_tb.hcb.scg[0].g.ucu[0].genblk1.u.out;
	  output_data.out1 = HCB_tb.hcb.scg[1].g.ucu[0].genblk1.u.out;
	  output_data.out2 = HCB_tb.hcb.scg[2].g.ucu[0].genblk1.u.out;
`endif
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
       //@ HCB_ports.cb
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

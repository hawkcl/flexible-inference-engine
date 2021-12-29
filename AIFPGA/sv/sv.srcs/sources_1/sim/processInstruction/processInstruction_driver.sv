
import definitions_pkg::*;
typedef struct {
	logic		enable;
	logic		pwrite_isFetchNextInst;
	logic		pib_empty;
	InstructionHCB_unpack		inst;
	logic		hasNextFeatureParams;
	logic		new_params_prefetch;
	mem_bus_addr_t		new_readPos;
	width_t		new_writeWidth;
	input_addr_t		new_volumeSize;
	seq_t		new_reqSeqF;
} processInstruction_inputs;

typedef struct {
	logic		pib_en;
	logic		new_conv_inst;
	k_t		inst_k;
	seq_t		curSeq,		reqSeq;
	seq_t		reqProgress;
	logic		isProgressMaster;
	logic		token_set;
	token_t		max_token;
	k_t		k;
	pad_t		stride;
`ifdef		S2_OPTIMIZE
	logic		isStride2;
	s_row_addr_t		new_nextRowStart;
	k_t		new_kIter;
`endif
	out_width_t		outW;
	width_t		new_outputBufH1;
	width_t		outputBufH1Orig;
	width_t		outputBufW1;
	loc_frame_t		outBufFrameSize;
	outframe_addr_t		outFrameSize;
	output_gap_t		outputAddrGap;
	output_gap_t		outFrameGapSize;
	pad_t		maxpool_stride;
	mem_addr_t		new_outputAddr;		
	mem_addr_t		new_outputFrameStart;
	cg_addr_t		numGroups;
	token_t		token;
	logic		isResMaster;
	mem_bus_addr_t		readPos;
	mem_bus_addr_t		resPos;
	pad_t		leftPad;
	width_t		new_readWidth;
	width_t		writeWidth;
	layer_addr_t		readCLast;
	pad_t		topPad,		downPad;
	s_row_addr_t		new_rowAddr;
	s_row_addr_t		new_rowNum;
	seq_t		reqSeqF;
	layer_addr_t		new_kCur;
	layer_addr_t		new_kOut;
	layer_addr_t		Ks,		kt;
	cg_addr_t		new_usedGroups;
	res_size_t		new_resSize;
	res_size_t		new_resReadSize;
	layer_addr_t		new_resFrameMax;
	logic		doRes;
	logic		doRelu;
	logic		doLRelu;
	logic		doBM;
	logic		doUpSample;
	logic		newWriteInst;
	s_feature_t		wLRelu;
	cg_addr_t		new_wtotal;
	layer_addr_t		new_resFrameCount;
	group_t		new_resRowCount;
	logic		new_isReadResA;
	mem_addr_t		new_nextResAddr;
	mem_addr_t		new_frameResAddr;
	res_len_t		new_resLen;
	output_gap_t		new_outResGapSize;
	layer_addr_t		new_kRes;				
	loc_frame_t		prefetchFrameSize;
	input_addr_t		volumeSize;
	input_addr_t		curVolumeSize;
	DATA_MODE		mode;
	scale_t		fScale;
	scale_t		wScale;
	input_addr_t		new_addrNextFrame;
	res_size_t		totalRes;
	cg_addr_t		usedGroupsLast;
	cg_addr_t		usedCGLast;
	cg_addr_t		usedCG0;
	layer_addr_t		kCurLast;
	res_size_t		resSize0;
	res_size_t		resSizeLast;
	res_len_t		resLen0;
	res_len_t		resLenLast;
	cg_addr_t		wtotal_n;
	weight_bus_size_t		wlenk_nLast;
	cg_addr_t		wtotalLast;
	weight_bus_size_t		wlenk_nLast2;
	weight_bus_size_t		wlenk_regular;
	weight_bus_size_t		wlen_regular;
	weight_bus_size_t		new_wlenk;
	weight_bus_size_t		new_wlenk_last;
	layer_addr_t		kCurLast_1;
	width1_t		new_maxRowCount;
	width_t		new_lastLen;
} processInstruction_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output processInstruction_inputs in_data);
import "DPI-C" function void compare_outputs(input processInstruction_outputs out_data);

class processInstruction_driver;


  virtual processInstruction_ports ports;
  processInstruction_inputs input_data;
  processInstruction_outputs output_data;
  logic out_clock;

  function new (virtual processInstruction_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.enable = input_data.enable;
        ports.pwrite_isFetchNextInst = input_data.pwrite_isFetchNextInst;
        ports.pib_empty = input_data.pib_empty;
	//ports.inst = input_data.inst;
	ports.hasNextFeatureParams = input_data.hasNextFeatureParams;
	ports.new_params_prefetch = input_data.new_params_prefetch;
	ports.new_readPos = input_data.new_readPos;
	ports.new_writeWidth = input_data.new_writeWidth;
	ports.new_volumeSize = input_data.new_volumeSize;
	ports.new_reqSeqF = input_data.new_reqSeqF;

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
	  output_data.pib_en = ports.pib_en;
	  output_data.new_conv_inst = ports.new_conv_inst;
	  output_data.inst_k = ports.inst_k;
	  output_data.curSeq = ports.curSeq;
	  output_data.reqSeq = ports.reqSeq;
	  output_data.reqProgress = ports.reqProgress;
	  output_data.isProgressMaster = ports.isProgressMaster;
	  output_data.token_set = ports.token_set;
	  output_data.max_token = ports.max_token;
	  output_data.k = ports.k;
	  output_data.stride = ports.stride;
`ifdef		S2_OPTIMIZE	  
	  output_data.isStride2 = ports.isStride2;
	  output_data.new_nextRowStart = ports.new_nextRowStart;
	  output_data.new_kIter = ports.new_kIter;
`endif
	  output_data.outW = ports.outW;
	  output_data.new_outputBufH1 = ports.new_outputBufH1;
	  output_data.outputBufH1Orig = ports.outputBufH1Orig;
	  output_data.outputBufW1 = ports.outputBufW1;
	  output_data.outBufFrameSize = ports.outBufFrameSize;
	  output_data.outFrameSize = ports.outFrameSize;
	  output_data.outputAddrGap = ports.outputAddrGap;
	  output_data.outFrameGapSize = ports.outFrameGapSize;
	  output_data.maxpool_stride = ports.maxpool_stride;
	  output_data.new_outputAddr = ports.new_outputAddr;
	  output_data.new_outputFrameStart = ports.new_outputFrameStart;
	  output_data.numGroups = ports.numGroups;
	  output_data.token = ports.token;
	  output_data.isResMaster = ports.isResMaster;
	  output_data.readPos = ports.readPos;
	  output_data.resPos = ports.resPos;
	  output_data.leftPad = ports.leftPad;
	  output_data.new_readWidth = ports.new_readWidth;
	  output_data.writeWidth = ports.writeWidth;
	  output_data.readCLast = ports.readCLast;
	  output_data.topPad = ports.topPad;
	  output_data.downPad = ports.downPad;
	  output_data.new_rowAddr = ports.new_rowAddr;
	  output_data.new_rowNum = ports.new_rowNum;
	  output_data.reqSeqF = ports.reqSeqF;
	  output_data.new_kCur = ports.new_kCur;
	  output_data.new_kOut = ports.new_kOut;
	  output_data.Ks = ports.Ks;
	  output_data.kt = ports.kt;
	  output_data.new_usedGroups = ports.new_usedGroups;
	  output_data.new_resSize = ports.new_resSize;
	  output_data.new_resReadSize = ports.new_resReadSize;
	  output_data.new_resFrameMax = ports.new_resFrameMax;
	  output_data.doRes = ports.doRes;
	  output_data.doRelu = ports.doRelu;
	  output_data.doLRelu = ports.doLRelu;
	  output_data.doBM = ports.doBM;
	  output_data.doUpSample = ports.doUpSample;
	  output_data.newWriteInst = ports.newWriteInst;
	  output_data.wLRelu = ports.wLRelu;
	  output_data.new_wtotal = ports.new_wtotal;
	  output_data.new_resFrameCount = ports.new_resFrameCount;
	  output_data.new_resRowCount = ports.new_resRowCount;
	  output_data.new_isReadResA = ports.new_isReadResA;
	  output_data.new_nextResAddr = ports.new_nextResAddr;
	  output_data.new_frameResAddr = ports.new_frameResAddr;
	  output_data.new_resLen = ports.new_resLen;
	  output_data.new_outResGapSize = ports.new_outResGapSize;
	  output_data.new_kRes = ports.new_kRes;
	  output_data.prefetchFrameSize = ports.prefetchFrameSize;
	  output_data.volumeSize = ports.volumeSize;
	  output_data.curVolumeSize = ports.curVolumeSize;
	  output_data.mode = ports.mode;
	  output_data.fScale = ports.fScale;
	  output_data.wScale = ports.wScale;
	  output_data.new_addrNextFrame = ports.new_addrNextFrame;
	  output_data.totalRes = ports.totalRes;
	  output_data.usedGroupsLast = ports.usedGroupsLast;
	  output_data.usedCGLast = ports.usedCGLast;
	  output_data.usedCG0 = ports.usedCG0;
	  output_data.kCurLast = ports.kCurLast;
	  output_data.resSize0 = ports.resSize0;
	  output_data.resSizeLast = ports.resSizeLast;
	  output_data.resLen0 = ports.resLen0;
	  output_data.resLenLast = ports.resLenLast;
	  output_data.wtotal_n = ports.wtotal_n;
	  output_data.wlenk_nLast = ports.wlenk_nLast;
	  output_data.wtotalLast = ports.wtotalLast;
	  output_data.wlenk_nLast2 = ports.wlenk_nLast2;
	  output_data.wlenk_regular = ports.wlenk_regular;
	  output_data.wlen_regular = ports.wlen_regular;
	  output_data.new_wlenk = ports.new_wlenk;
	  output_data.new_wlenk_last = ports.new_wlenk_last;
	  output_data.kCurLast_1 = ports.kCurLast_1;
	  output_data.new_maxRowCount = ports.new_maxRowCount;
	  output_data.new_lastLen = ports.new_lastLen;
	
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
       //@ processInstruction_ports.cb
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

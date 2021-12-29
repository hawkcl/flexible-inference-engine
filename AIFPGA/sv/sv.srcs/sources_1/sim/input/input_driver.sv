
import definitions_pkg::*;
typedef struct {
logic 		pread_busValid, pread_isFeature;
logic 		isReadingFeatures, isLoadingFroze;
logic 		isLoadingNextFeatures;
seq_t 		pread_seqNum, reqSeqF;
width_t 	writeWidth;
logic 		new_params_readFeatures;
mem_bus_addr_t 	readPos;
input_addr_t 	volumeSize;
input_addr_t 	usedWords;
s_feature_t  	dataBus[MAX_READ_WIDTH];

//AssembleInput
logic 		doAssemble;
width_t 	readWidth;
loc_frame_t 	prefetchFrameSize;
logic 		new_conv_inst, startPrefetching;
input_addr_t 	new_addrNextFrame;
input_addr_t 	curVolumeSize;
width1_t 	maxRowCount;
width_t 	lastLen;

//BuildInputFifo
HCB_STATE 	state;
layer_addr_t 	readCLast;
width_t 	outputBufH1;
pad_t 		downPad, topPad;
k_t 		k;
pad_t 		stride;
s_row_addr_t 	rowNum;
logic 		reset_iLayers;
s_row_addr_t 	new_rowAddr;

//SendBackUpInput
logic 		sendBackUpInput_valid;
k_t 		backupId;
pad_t 		leftPad;

//SetupShiftInputs
INPUT_SOURCE 	input_src;
} input_inputs;

typedef struct {
logic 		setLoadingFroze, resetLoadingFroze;
logic 		resetLoadingNextFeatures, resetReadingFeatures;
logic 		resetAssemble;
`ifdef S2_OPTIMIZE  
	s_feature_t backupBus[COMPUTING_GROUP_SIZE*2];
`else
	s_feature_t backupBus[COMPUTING_GROUP_SIZE];
`endif
logic 		isBackupValid;
s_feature_t 	shiftInputs[MAX_K];
input_addr_t nextWritePos;
 logic unsigned [4:0] ibSize;
 width_t atmpSize;
 width1_t curRowCount;
 input_addr_t addrNextFrame;
 input_addr_t addrCurAssemble;
 layer_addr_t iLayers;
s_row_addr_t rowAddr;

logic rf_wen;
 logic unsigned [12:0]rf_addrOut;
 s_feature_t  rf_dataOut[INPUT_MEM_WIDTH];


 //s_feature_t input_buffer[INPUT_MEM_WIDTH];
 logic input_ren;
 logic assemble_buff_wen, assemble_buff_ren, is_assemble_buff_full, is_assemble_buff_empty;
 logic inputfifo_wen, inputfifo_ren, is_input_fifo_full, is_input_fifo_empty;
 logic inputs_buffer_progfull, inputs_buffer_wen, inputs_buffer_ren;
 logic inputs_buffer_empty;
 logic unsigned [INPUT_ADDR_WIDTH - 1 :0]inputs_raddr;
 logic input_requested;
 logic unsigned [INPUT_ADDR_WIDTH - 1 :0] addrNextAssemble;
 
} input_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output input_inputs in_data);
import "DPI-C" function void compare_outputs(input input_outputs out_data);

class input_driver;


  virtual input_ports ports;
  input_inputs input_data;
  input_outputs output_data;
  logic out_clock;

  function new (virtual input_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.pread_busValid = input_data.pread_busValid;
        ports.pread_isFeature = input_data.pread_isFeature;
        ports.isReadingFeatures = input_data.isReadingFeatures;
	ports.isLoadingFroze = input_data.isLoadingFroze;
	ports.isLoadingNextFeatures = input_data.isLoadingNextFeatures;
	ports.pread_seqNum = input_data.pread_seqNum;
	ports.reqSeqF = input_data.reqSeqF;
	ports.writeWidth = input_data.writeWidth;
	ports.new_params_readFeatures = input_data.new_params_readFeatures;
	ports.readPos = input_data.readPos;
	ports.volumeSize = input_data.volumeSize;
	ports.usedWords = input_data.usedWords;
    for(int i =0; i < MAX_READ_WIDTH; i++)
        ports.dataBus[i] = input_data.dataBus[i];
	ports.doAssemble = input_data.doAssemble;
	ports.readWidth = input_data.readWidth;
	ports.prefetchFrameSize = input_data.prefetchFrameSize;
	ports.new_conv_inst = input_data.new_conv_inst;
	ports.startPrefetching = input_data.startPrefetching;
	ports.new_addrNextFrame = input_data.new_addrNextFrame;
	ports.curVolumeSize = input_data.curVolumeSize;
	ports.maxRowCount = input_data.maxRowCount;
	ports.lastLen = input_data.lastLen;
	ports.state = input_data.state;
	ports.readCLast = input_data.readCLast;
	ports.outputBufH1 = input_data.outputBufH1;
	ports.downPad = input_data.downPad;
	ports.topPad = input_data.topPad;
	ports.k = input_data.k;
	ports.stride = input_data.stride;
	ports.rowNum = input_data.rowNum;
	ports.reset_iLayers = input_data.reset_iLayers;
	ports.new_rowAddr = input_data.new_rowAddr;
	ports.sendBackUpInput_valid = input_data.sendBackUpInput_valid;
	ports.backupId = input_data.backupId;
	ports.leftPad = input_data.leftPad;
	ports.input_src = input_data.input_src;
  end
  endtask

  task assign_outputs();
  begin
	  output_data.setLoadingFroze = ports.setLoadingFroze;
	  output_data.resetLoadingFroze = ports.resetLoadingFroze;
	  output_data.resetLoadingNextFeatures = ports.resetLoadingNextFeatures;
	  output_data.resetReadingFeatures = ports.resetReadingFeatures;
	  output_data.resetAssemble = ports.resetAssemble;
	  output_data.backupBus = ports.backupBus;
	  output_data.isBackupValid = ports.isBackupValid;
	  output_data.shiftInputs = ports.shiftInputs;

	  output_data.rf_addrOut = input_tb.readfeatures.addrOut;
	  for(int i = 0; i < INPUT_MEM_WIDTH; i++)
		  output_data.rf_dataOut[i] = input_tb.readfeatures.dataOut[i];
	  output_data.rf_wen = input_tb.readfeatures.wen;
	  output_data.nextWritePos = input_tb.readfeatures.nextWritePos;
	  output_data.ibSize = input_tb.readfeatures.ibSize;
	 // output_data.input_buffer = input_tb.readfeatures.input_buffer;

	  output_data.atmpSize = input_tb.assembleInput.atmpSize;
	  output_data.curRowCount = input_tb.assembleInput.curRowCount;
	  output_data.addrNextFrame = input_tb.assembleInput.addrNextFrame;
	  output_data.addrCurAssemble = input_tb.assembleInput.addrCurAssemble;

	  output_data.iLayers = input_tb.buildInputFifo.iLayers;
	  output_data.rowAddr = input_tb.buildInputFifo.rowAddr;

	  output_data.input_ren = input_tb.inputs_ren;
	  output_data.assemble_buff_wen = input_tb.assemble_buffer_wen;
	  output_data.assemble_buff_ren = input_tb.assemble_buffer_ren;
	  output_data.is_assemble_buff_full = input_tb.assemble_buffer_full;
	  output_data.is_assemble_buff_empty = input_tb.assemble_buffer_empty;
	  output_data.inputfifo_wen = input_tb.input_fifo_wen;
	  output_data.inputfifo_ren = input_tb.input_fifo_ren;
	  output_data.is_input_fifo_full = input_tb.input_fifo_full;
	  output_data.is_input_fifo_empty = input_tb.input_fifo_empty;

	  output_data.inputs_buffer_progfull = input_tb.inputs_buffer_progfull;
	  output_data.inputs_buffer_wen = input_tb.inputs_buffer_wen;
	  output_data.inputs_buffer_ren = input_tb.inputs_buffer_ren;
	  output_data.inputs_buffer_empty = input_tb.inputs_buffer_empty;
	  output_data.inputs_raddr = input_tb.inputs_raddr;
	  output_data.input_requested = input_tb.assembleInputBuffer.input_requested;
	  output_data.addrNextAssemble = input_tb.assembleInputBuffer.addrNextAssemble;

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
       //@ input_ports.cb
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

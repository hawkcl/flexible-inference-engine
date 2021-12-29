
import definitions_pkg::*;
typedef struct {
  logic isReadingFeatures, pread_RequestFull;
  logic isResMaster; 
  token_t this_token, ptoken;
  logic res_full;
  logic doRes; 
 `ifdef S2_OPTIMIZE	
   logic isStride2;
 `endif
  DATA_MODE mode;
  width_t outputBufW1, outputBufH1Orig; 
  out_width_t outW;
  outframe_addr_t outFrameSize;
  output_gap_t outputAddrGap, outFrameGapSize;
  logic unsigned [7 : 0] curSeq;
  layer_addr_t ks;
  cg_addr_t numGroups;
  layer_addr_t kCurLast;
  res_size_t resSize0;
  res_size_t resSizeLast;
  res_len_t resLen0;
  res_len_t resLenLast;
  cg_addr_t usedGroupsLast;
  
  logic setParam;
  layer_addr_t new_kRes;    
  logic new_isReadResA;
  mem_addr_t new_nextResAddr;
  mem_addr_t new_frameResAddr;
  group_t new_resRowCount;
  res_size_t new_resSize;
  res_size_t new_resReadSize;
  layer_addr_t new_resFrameCount;
  layer_addr_t new_resFrameMax;
  res_len_t new_resLen; 
  output_gap_t new_outResGapSize; 
  res_size_t totalRes;
  layer_addr_t kCurLast_1;
  logic resetRequestingRes;
  logic extWeights_ren;
  logic resBuf_ren;
} rex_inputs;

typedef struct {
  logic enRequest;
  RequestItem_t_unpack request;
	logic enable_res;
	logic enable;
	logic isReadingFeatures;
	logic pread_RequestFull;
	logic isResMaster;
	token_t this_token, ptoken;
} rex_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output rex_inputs in_data);
import "DPI-C" function void compare_outputs(input rex_outputs out_data);

class rex_driver;


  virtual rex_ports ports;
  rex_inputs input_data;
  rex_outputs output_data;
  logic out_clock;

  function new (virtual rex_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.isReadingFeatures = input_data.isReadingFeatures;
        ports.pread_RequestFull = input_data.pread_RequestFull;
        ports.isResMaster = input_data.isResMaster;
        ports.this_token = input_data.this_token;
        ports.ptoken = input_data.ptoken;
        ports.res_full = input_data.res_full;
        ports.doRes = input_data.doRes;

`ifdef S2_OPTIMIZE	
        ports.isStride2 = input_data.isStride2;
`endif
        ports.mode = input_data.mode;
        ports.outputBufW1 = input_data.outputBufW1;
        ports.outputBufH1Orig = input_data.outputBufH1Orig;
        ports.outW = input_data.outW;
        ports.outFrameSize = input_data.outFrameSize;
        ports.outputAddrGap = input_data.outputAddrGap;
        ports.outFrameGapSize = input_data.outFrameGapSize;
        ports.curSeq = input_data.curSeq;
        ports.ks = input_data.ks;
        ports.numGroups = input_data.numGroups;
        ports.kCurLast = input_data.kCurLast;
        ports.resSize0 = input_data.resSize0;
        ports.resSizeLast = input_data.resSizeLast;
        ports.resLen0 = input_data.resLen0;
        ports.resLenLast = input_data.resLenLast;
        ports.usedGroupsLast = input_data.usedGroupsLast;
        ports.setParam = input_data.setParam;
        ports.new_kRes = input_data.new_kRes;
        ports.new_isReadResA = input_data.new_isReadResA;
        ports.new_nextResAddr = input_data.new_nextResAddr;
        ports.new_frameResAddr = input_data.new_frameResAddr;
        ports.new_resRowCount = input_data.new_resRowCount;
        ports.new_resSize = input_data.new_resSize;
        ports.new_resReadSize = input_data.new_resReadSize;
        ports.new_resFrameCount = input_data.new_resFrameCount;
        ports.new_resFrameMax = input_data.new_resFrameMax;
        ports.new_resLen = input_data.new_resLen;
        ports.new_outResGapSize = input_data.new_outResGapSize;
        ports.totalRes = input_data.totalRes;
        ports.kCurLast_1 = input_data.kCurLast_1;
        ports.resetRequestingRes = input_data.resetRequestingRes;
        ports.extWeights_ren = input_data.extWeights_ren;
        ports.resBuf_ren = input_data.resBuf_ren;
  end
  endtask

  task assign_outputs();
  begin
	  output_data.enRequest = ports.enRequest;
	  output_data.request.addr = ports.request.addr;
	  output_data.request.seq = ports.request.seq;
	  output_data.request.len = ports.request.len;
	  output_data.request.token = ports.request.token;
	  output_data.request.dtype = ports.request.dtype;
	  output_data.request.isRamA = ports.request.isRamA;
	  output_data.request.isRamB = ports.request.isRamB;
	  output_data.enable_res = rex_tb.readExtra.enable_res;
	  output_data.enable = rex_tb.readExtra.enable;
	  output_data.isReadingFeatures = rex_tb.readExtra.isReadingFeatures;
	  output_data.pread_RequestFull = rex_tb.readExtra.pread_RequestFull;
	  output_data.isResMaster = rex_tb.readExtra.isResMaster;
	  output_data.this_token = rex_tb.readExtra.this_token;
	  output_data.ptoken = rex_tb.readExtra.ptoken;

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
       //@ rex_ports.cb
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


`timescale 1ns / 1ns
import definitions_pkg::*;
typedef struct {
  logic enSendBMWeights;
  weight_bus_size_t len;
  logic pread_busValid, pread_isFeature;
  ReturnData_t_unpack data;
  logic unsigned [7 : 0] curSeq;
  token_t token;
  logic new_conv_inst;
  int   num;
} bm_inputs;

typedef struct {
  bm_size_t receivedBM;
  s_feature_t bmWeightBus[WEIGHT_BUS_SIZE];
  logic enough_data;
  logic unsigned [4:0] numBuf;
  logic wr_en;
  logic rd_en;
  logic isEmpty;
} bm_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output bm_inputs in_data);
import "DPI-C" function void compare_outputs(input bm_outputs out_data);

class bm_driver;


  virtual bm_ports ports;
  bm_inputs input_data;
  bm_outputs output_data;
  logic out_clock;
  logic is_glbl_init;

  function new (virtual bm_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
    is_glbl_init = 0;
  end
  endfunction

  task init_inputs();
  begin
	    ports.enSendBMWeights = 0;
        ports.len = 0;
        ports.pread_busValid = 0;
        ports.pread_isFeature = 0;
        ports.curSeq = 0;
        ports.token = 0;
        ports.new_conv_inst = 0;

        ports.data.dtype = TYPE_BM;
        ports.data.seq = 0;
        ports.data.len = 0;
        ports.data.token = 0;
        for(int i = 0; i < BRAM_BUS_WIDTH; i++) begin
            ports.data.data[i] = 0;
        end
  end
  endtask

  task assign_inputs();
  begin
	ports.enSendBMWeights = input_data.enSendBMWeights;
        ports.len = input_data.len;
        ports.pread_busValid = input_data.pread_busValid;
        ports.pread_isFeature = input_data.pread_isFeature;
        ports.curSeq = input_data.curSeq;
        ports.token = input_data.token;
        ports.new_conv_inst = input_data.new_conv_inst;

        ports.data.dtype = input_data.data.dtype;
        ports.data.seq = input_data.data.seq;
        ports.data.len = input_data.data.len;
        ports.data.token = input_data.data.token;
        for(int i = 0; i < BRAM_BUS_WIDTH; i++) begin
            ports.data.data[i] = input_data.data.data[i];
        end
  end
  endtask

  task assign_outputs();
  begin
	  output_data.receivedBM = ports.receivedBM;
	  output_data.bmWeightBus = ports.bmWeightBus;
	  output_data.enough_data = ports.enough_data;
	  output_data.numBuf = bm_tb.sendBMWeights.numBuf;
	  output_data.wr_en = bm_tb.extWeights_wen;
	  output_data.rd_en = bm_tb.extWeights_ren;
	  output_data.isEmpty = bm_tb.extWeights_empty;
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
    /*while(1) begin
        @ (posedge ports.clock);
        if(bm_tb.g.GSR_int == 1'b0) begin
            is_glbl_init = 0;
            break;
        end
    end*/
    $write("%dns : asserting reset\n",$time);
    for(int i = 0; i < 50; i++) begin
       @ (posedge ports.clock);
       $write("%dns :waiting clk\n",$time);
    end
    #2 ports.resetN= 1'b1;
    $write("%dns : Done asserting reset\n",$time);
  end
  endtask

  task gen_input();
  begin
    while (1) begin
       @ (posedge ports.clock);
       if(ports.resetN == 1'b0 || is_glbl_init) begin
           init_inputs();
	       continue;
       end
       read_inputs(input_data);
       assign_inputs();
       $write("%dns : inputs  %d\n", $time, input_data.num);
       // , ports.pread_busValid, ports.pread_isFeature, ports.curSeq, ports.token);
    end
  end
  endtask

  task cmp_output();
  begin
    while (1) begin
      //@ (posedge ports.clock);
      @ (posedge out_clock);
       if(ports.resetN == 1'b0 || is_glbl_init)
	       continue;
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

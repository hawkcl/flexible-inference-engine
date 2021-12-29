
import definitions_pkg::*;
typedef struct {
   HCB_STATE state;
 layer_addr_t readCLast;

 width_t outputBufH1;
 pad_t downPad, topPad;
 k_t k;
 pad_t stride;
 s_row_addr_t rowNum;

 logic reset_params; //prefetching
 logic new_params, reset_iLayers;
 s_row_addr_t new_rowAddr;

 logic input_full;
//assemble_buffer
//input s_feature_t [INPUT_MEM_WIDTH - 1 : 0] ab_data,  
 s_feature_t  ab_data[INPUT_MEM_WIDTH];
 logic ab_empty;
} buildInputFifo_inputs;

typedef struct {
   logic input_wr_en;
//output s_feature_t [INPUT_MEM_WIDTH - 1 : 0] input_data_out,
 s_feature_t  input_data_out[INPUT_MEM_WIDTH];
 logic ab_rd_en;
 layer_addr_t iLayers;
s_row_addr_t rowAddr;

} buildInputFifo_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output buildInputFifo_inputs in_data);
import "DPI-C" function void compare_outputs(input buildInputFifo_outputs out_data);

class buildInputFifo_driver;


  virtual buildInputFifo_ports ports;
  buildInputFifo_inputs input_data;
  buildInputFifo_outputs output_data;
  logic out_clock;

  function new (virtual buildInputFifo_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.state = input_data.state;
        ports.readCLast = input_data.readCLast;
        ports.outputBufH1 = input_data.outputBufH1;
	ports.downPad = input_data.downPad;
	ports.topPad = input_data.topPad;
	ports.k = input_data.k;
	ports.stride = input_data.stride;
	ports.rowNum = input_data.rowNum;
	ports.reset_params = input_data.reset_params;
	ports.new_params = input_data.new_params;
	ports.reset_iLayers = input_data.reset_iLayers;
	ports.new_rowAddr = input_data.new_rowAddr;
	ports.input_full = input_data.input_full;
    for(int i = 0; i < INPUT_MEM_WIDTH; i++)
        ports.ab_data[i] = input_data.ab_data[i];
	ports.ab_empty = input_data.ab_empty;
  end
  endtask

  task assign_outputs();
  begin
	  output_data.input_wr_en = ports.input_wr_en;
      for(int i = 0; i < INPUT_MEM_WIDTH; i++)
          output_data.input_data_out[i] = ports.input_data_out[i];
	  output_data.ab_rd_en = ports.ab_rd_en;
	  
	  output_data.iLayers = buildInputFifo_tb.buildInputFifo.iLayers;
	  output_data.rowAddr = buildInputFifo_tb.buildInputFifo.rowAddr;

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
       //$write("%dns : inputs\n", $time);
    end
  end
  endtask

  task cmp_output();
  begin
    while (1) begin
      @ (posedge out_clock);
       //@ buildInputFifo_ports.cb
       if(ports.resetN == 1'b0)
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

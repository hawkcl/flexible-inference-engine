
import definitions_pkg::*;
typedef struct {
 logic doAssemble;
 logic buffer_full;
 logic inputs_buffer_empty;
 width_t readWidth;
 s_feature_t  data_input[INPUT_MEM_WIDTH];
 loc_frame_t prefetchFrameSize;

 logic new_param, reset_param;
 input_addr_t new_addrNextFrame;
 input_addr_t curVolumeSize;
 width1_t maxRowCount;
 width_t lastLen;
} assembleInput_inputs;

typedef struct {
  logic buffer_wen;
 s_feature_t  buffer_data[INPUT_MEM_WIDTH];
 logic ren;
 logic resetAssemble;
 width_t atmpSize;
 width1_t curRowCount;
 input_addr_t addrNextFrame;
 input_addr_t addrCurAssemble;
} assembleInput_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output assembleInput_inputs in_data);
import "DPI-C" function void compare_outputs(input assembleInput_outputs out_data);

class assembleInput_driver;


  virtual assembleInput_ports ports;
  assembleInput_inputs input_data;
  assembleInput_outputs output_data;
  logic out_clock;

  function new (virtual assembleInput_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.doAssemble = input_data.doAssemble;
	ports.buffer_full = input_data.buffer_full;
	ports.inputs_buffer_empty = input_data.inputs_buffer_empty;
	ports.readWidth = input_data.readWidth;
    for(int i = 0; i < INPUT_MEM_WIDTH; i++)
        ports.data_input[i] = input_data.data_input[i];
	ports.prefetchFrameSize = input_data.prefetchFrameSize;
	ports.new_param = input_data.new_param;
	ports.reset_param = input_data.reset_param;
	ports.new_addrNextFrame = input_data.new_addrNextFrame;
	ports.curVolumeSize = input_data.curVolumeSize;
        ports.maxRowCount = input_data.maxRowCount;
        ports.lastLen = input_data.lastLen;

  end
  endtask

  task assign_outputs();
  begin
	  output_data.buffer_wen = ports.buffer_wen;
      for(int i =0; i < INPUT_MEM_WIDTH; i++)
          output_data.buffer_data[i] = ports.buffer_data[i];
	  output_data.ren = ports.ren;
	  output_data.resetAssemble = ports.resetAssemble;
	  
	  output_data.atmpSize = assembleInput_tb.assembleInput.atmpSize;
	  output_data.curRowCount = assembleInput_tb.assembleInput.curRowCount;
	  output_data.addrNextFrame = assembleInput_tb.assembleInput.addrNextFrame;
	  output_data.addrCurAssemble = assembleInput_tb.assembleInput.addrCurAssemble;
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
    //$write("%dns : Done asserting reset\n",$time);
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
       $write("%dns : inputs new_addrNextFrame %d\n", $time, input_data.new_addrNextFrame);
    end
  end
  endtask

  task cmp_output();
  begin
    while (1) begin
      @ (posedge out_clock);
       //@ assembleInput_ports.cb
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

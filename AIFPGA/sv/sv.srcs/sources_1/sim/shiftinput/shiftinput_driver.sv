
import definitions_pkg::*;
typedef struct {
  INPUT_SOURCE input_src;
  k_t k;
  s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE];
} shiftinput_inputs;

typedef struct {
  s_feature_t shiftInputs[MAX_K];
} shiftinput_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output shiftinput_inputs in_data);
import "DPI-C" function void compare_outputs(input shiftinput_outputs out_data);

class shiftinput_driver;


  virtual shiftinput_ports ports;
  shiftinput_inputs input_data;
  shiftinput_outputs output_data;
  logic out_clock;

  function new (virtual shiftinput_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.input_src = input_data.input_src;
        ports.k = input_data.k;
        ports.shiftBufBackup = input_data.shiftBufBackup;
        
  end
  endtask

  task assign_outputs();
  begin
	  output_data.shiftInputs = ports.shiftInputs;
	  
	  //output_data.ptoken = shiftinput_tb.readExtra.ptoken;

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
    while (1) begin
      @ (posedge out_clock);
       //@ shiftinput_ports.cb
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

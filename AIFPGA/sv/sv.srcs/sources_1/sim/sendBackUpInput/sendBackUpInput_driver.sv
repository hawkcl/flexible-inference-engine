
import definitions_pkg::*;
typedef struct {
   logic sendBackUpInput_valid;
 k_t backupId;
 s_feature_t  fifo_data[INPUT_MEM_WIDTH];
 logic fifo_empty;
`ifdef S2_OPTIMIZE
 logic isStride2;
`endif
 width_t readWidth;
 pad_t leftPad;
} sendBackUpInput_inputs;

typedef struct {
   logic rd_en;
 s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE];
`ifdef S2_OPTIMIZE  
 s_feature_t backupBus[COMPUTING_GROUP_SIZE*2];
`else
 s_feature_t backupBus[COMPUTING_GROUP_SIZE];
`endif
 logic isBackupValid;

} sendBackUpInput_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output sendBackUpInput_inputs in_data);
import "DPI-C" function void compare_outputs(input sendBackUpInput_outputs out_data);

class sendBackUpInput_driver;


  virtual sendBackUpInput_ports ports;
  sendBackUpInput_inputs input_data;
  sendBackUpInput_outputs output_data;
  logic out_clock;

  function new (virtual sendBackUpInput_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.sendBackUpInput_valid = input_data.sendBackUpInput_valid;
    ports.backupId = input_data.backupId;
    for(int i = 0; i < INPUT_MEM_WIDTH; i++)
        ports.fifo_data[i] = input_data.fifo_data[i];
	ports.fifo_empty = input_data.fifo_empty;
	ports.readWidth = input_data.readWidth;
	ports.leftPad = input_data.leftPad;
`ifdef S2_OPTIMIZE
	ports.isStride2 = input_data.isStride2;
`endif

  end
  endtask

  task assign_outputs();
  begin
	  output_data.rd_en = ports.rd_en;
	  output_data.shiftBufBackup = ports.shiftBufBackup;
	  output_data.backupBus = ports.backupBus;
	  output_data.isBackupValid = ports.isBackupValid;

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
       //@ sendBackUpInput_ports.cb
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

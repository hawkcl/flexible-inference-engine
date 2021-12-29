
import definitions_pkg::*;
typedef struct {
  logic 		enSendWeights;
  logic 		enSendBMWeights;
  logic is_cycle_froze;
  weight_bus_size_t 	len;
  weight_bus_size_t 	bm_len;
  logic 		isRunning, pcweight_busValid;
  seq_t 		pcweight_seq;
  logic 		new_weight_params;
  mem_bus_addr_t 	new_weightReadPos;
  weight_addr_t 	new_nextWeightRead;
  weight_addr_t 	new_endWeightRead;
  seq_t 		new_reqSeqW;
  s_weight_t  		w_bus[WEIGHT_MEM_BUS_SIZE];
  logic 		new_conv_inst;
} weight_inputs;

typedef struct {
  s_weight_t 		weightsBus[WEIGHT_BUS_SIZE];
  s_weight_t 		fifodata[WEIGHT_BUS_SIZE];
  logic 		bm_enough_data;
  logic 		enough_data;
  logic 		isReadingWeights;
  mem_bus_addr_t 	weightReadPos;
  weight_addr_t 	nextWeightRead;
  weight_addr_t 	endWeightRead;
  logic unsigned [4:0] 	numBuf;
  logic 		wr_en;
  logic 		rd_en;
} weight_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output weight_inputs in_data);
import "DPI-C" function void compare_outputs(input weight_outputs out_data);

class weight_driver;


  virtual weight_ports ports;
  weight_inputs input_data;
  weight_outputs output_data;
  logic out_clock;

  function new (virtual weight_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.enSendWeights = input_data.enSendWeights;
	ports.enSendBMWeights = input_data.enSendBMWeights;
	ports.is_cycle_froze = input_data.is_cycle_froze;
        ports.len = input_data.len;
        ports.bm_len = input_data.bm_len;
        ports.isRunning = input_data.isRunning;
        ports.pcweight_busValid = input_data.pcweight_busValid;
        ports.pcweight_seq = input_data.pcweight_seq;
        ports.new_weight_params = input_data.new_weight_params;
        ports.new_weightReadPos = input_data.new_weightReadPos;
        ports.new_nextWeightRead = input_data.new_nextWeightRead;
        ports.new_endWeightRead = input_data.new_endWeightRead;
        ports.new_reqSeqW = input_data.new_reqSeqW;
        ports.w_bus = input_data.w_bus;
        ports.new_conv_inst = input_data.new_conv_inst;
  end
  endtask

  task assign_outputs();
  begin
	  for(int i = 0; i < WEIGHT_BUS_SIZE; i++)
		  output_data.fifodata[i] = weight_tb.weights_wdata[i];
	  output_data.weightsBus = ports.weightsBus;
	  output_data.enough_data = ports.enough_data;
	  output_data.bm_enough_data = ports.bm_enough_data;
	  output_data.isReadingWeights = ports.isReadingWeights;
	  output_data.numBuf = weight_tb.sendWeights.numBuf;
	  output_data.wr_en = weight_tb.weights_wen;
	  output_data.rd_en = weight_tb.weights_ren;

	  output_data.weightReadPos = weight_tb.readWeights.weightReadPos;
	  output_data.nextWeightRead = weight_tb.readWeights.nextWeightRead;
	  output_data.endWeightRead = weight_tb.readWeights.endWeightRead;
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
       //@ (posedge ports.clock);
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

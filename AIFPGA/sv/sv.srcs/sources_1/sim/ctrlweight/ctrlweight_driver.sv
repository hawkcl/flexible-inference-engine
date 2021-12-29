
import definitions_pkg::*;
typedef struct {
	logic 		    cwinst_enable;
    InstructionWeight_unpack 	cwinst;
    logic           ddr_read_ready;
    ddr_id_t        valid_id;
    s_weight_t  	weight_data[WEIGHT_READ_WIDTH];
    logic           cb_isReadingWeights[BANK_NUM];
    logic           cb_isWeightFull[BANK_NUM];
    seq_t           cb_ReqWeight[BANK_NUM];
} ctrlweight_inputs;

typedef struct {
	logic           weight_ram_enable;
    ddr_id_t        weight_ddr_id;
    mem_addr_t      weight_ram_addr;
    logic 		    pcweight_busValid;
    logic 		    isStopable;
    seq_t 		    pcweight_seq;
    s_weight_t  	w_bus[WEIGHT_READ_WIDTH];
    logic 			hasMoreData;
    mem_addr_t 		nextReadAddr;
    logic unsigned [1:0]    dataIdx;
    logic           saved_enable;
    logic           read_mem;
    logic 			data_fifo_ren;
    logic 			data_fifo_wen;
    logic 			data_fifo_empty;
    logic 			data_fifo_progfull;
    logic           weight_mem_ren;
    logic           weight_mem_wen;
    DATA_MODE 		mode;
} ctrlweight_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output ctrlweight_inputs in_data);
import "DPI-C" function void compare_outputs(input ctrlweight_outputs out_data);

class ctrlweight_driver;


  virtual ctrlweight_ports ports;
  ctrlweight_inputs input_data;
  ctrlweight_outputs output_data;
  logic out_clock;

  function new (virtual ctrlweight_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
        ports.cwinst_enable = input_data.cwinst_enable;
        ports.cb_isReadingWeights = input_data.cb_isReadingWeights;
        ports.cb_isWeightFull = input_data.cb_isWeightFull;
        ports.cb_ReqWeight = input_data.cb_ReqWeight;
        ports.ddr_read_ready = input_data.ddr_read_ready;
        ports.valid_id = input_data.valid_id;
        for(int i = 0; i < WEIGHT_READ_WIDTH; i++)
            ports.weight_data[i] = input_data.weight_data[i];
        ports.cwinst.isReadRam = input_data.cwinst.isReadRam;
        ports.cwinst.isWriteRam = input_data.cwinst.isWriteRam;
        ports.cwinst.mode = input_data.cwinst.mode;
        ports.cwinst.dropSize = input_data.cwinst.dropSize;
        ports.cwinst.seqNum = input_data.cwinst.seqNum;
        ports.cwinst.Oaddr = input_data.cwinst.Oaddr;
        ports.cwinst.size = input_data.cwinst.size;


  end
  endtask

  task assign_outputs();
  begin
	  output_data.weight_ram_enable = ports.weight_ram_enable;
	  output_data.weight_ddr_id = ports.weight_ddr_id;
	  output_data.weight_ram_addr = ports.weight_ram_addr;
	  output_data.pcweight_busValid = ports.pcweight_busValid;
	  output_data.isStopable = ports.isStopable;
	  output_data.pcweight_seq = ports.pcweight_seq;
	  output_data.w_bus = ports.w_bus;
	  
      output_data.hasMoreData = ctrlweight_tb.ctrlweight.hasMoreData;
      output_data.nextReadAddr = ctrlweight_tb.ctrlweight.nextReadAddr;
      output_data.dataIdx = ctrlweight_tb.ctrlweight.dataIdx;
      output_data.saved_enable = ctrlweight_tb.ctrlweight.saved_enable;
      output_data.read_mem = ctrlweight_tb.ctrlweight.read_mem;
      output_data.data_fifo_ren = ctrlweight_tb.ctrlweight.data_fifo_ren;
      output_data.data_fifo_wen = ctrlweight_tb.ctrlweight.data_fifo_wen;
      output_data.data_fifo_empty = ctrlweight_tb.ctrlweight.data_fifo_empty;
      output_data.data_fifo_progfull = ctrlweight_tb.ctrlweight.data_fifo_progfull;
      output_data.weight_mem_ren = ctrlweight_tb.ctrlweight.weight_mem_ren;
      output_data.weight_mem_wen = ctrlweight_tb.ctrlweight.weight_mem_wen;
      output_data.mode = ctrlweight_tb.ctrlweight.mode;

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
       $write("%dns : inputs, len %d\n", $time, ctrlweight_tb.weight_write_len);
    end
  end
  endtask

  task cmp_output();
  begin
      int first_output = 1;
    while (1) begin
      @ (posedge out_clock);
       //@ ctrlweight_ports.cb
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

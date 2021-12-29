
import definitions_pkg::*;
typedef struct {
	logic         req_valid;
    ddr_id_t      req_id;
    mem_addr_t    req_addr;
    ddr_len_t     req_len;

    ddr_id_t      ddr_vid;
    ubyte_t       ddr_data[DDR_DATAWIDTH];
    logic         ddr_isLast;
} ddrreadassist_inputs;

typedef struct {
	logic        read_ready;
    ddr_id_t     valid_id;
    ubyte_t      valid_data[MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE];

    ddr_id_t     axi_rid;
    mem_addr_t   axi_raddr;
    ddr_width_t  axi_len;
    logic        read_request;
    logic        read_freeze;

    mem_addr_t      next_addr;
    ddr_len_t       buf_addr;
    ubyte_t         saved_buf[DDR_DATAWIDTH];
    ubyte_t         data_next[MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE];
} ddrreadassist_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output ddrreadassist_inputs in_data);
import "DPI-C" function void compare_outputs(input ddrreadassist_outputs out_data);

class ddrreadassist_driver;


  virtual ddrreadassist_ports ports;
  ddrreadassist_inputs input_data;
  ddrreadassist_outputs output_data;
  logic out_clock;

  function new (virtual ddrreadassist_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
        ports.req_valid = input_data.req_valid;
        ports.req_id = input_data.req_id;
        ports.req_addr = input_data.req_addr;
        ports.req_len = input_data.req_len;
        ports.axi_ready = 1;
        ports.ddr_vid = input_data.ddr_vid;
        ports.ddr_isLast = input_data.ddr_isLast;
        for(int i = 0; i < DDR_DATAWIDTH; i++)
            ports.ddr_data[i] = input_data.ddr_data[i];
  end
  endtask

  task assign_outputs();
  begin
	  output_data.read_ready = ports.read_ready;
	  output_data.valid_id = ports.valid_id;
	  output_data.axi_rid = ports.axi_rid;
	  output_data.axi_raddr = ports.axi_raddr;
	  output_data.axi_len = ports.axi_len;
	  output_data.read_request = ports.read_request;
	  output_data.read_freeze = ports.read_freeze;
      for(int i = 0; i < MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE; i++)
          output_data.valid_data[i] = ports.valid_data[i];
	  
      output_data.next_addr = ddrreadassist_tb.ddrreadassist.next_addr;
      output_data.buf_addr = ddrreadassist_tb.ddrreadassist.buf_addr;
      for(int i = 0; i < DDR_DATAWIDTH; i++)
          output_data.saved_buf[i] = ddrreadassist_tb.ddrreadassist.saved_buf[i];
      for(int i = 0; i < MAX_LOAD_WIDTH * FEATURE_BYTE_SIZE; i++)
          output_data.data_next[i] = ddrreadassist_tb.ddrreadassist.data_next[i];
     

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
       //@ ddrreadassist_ports.cb
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

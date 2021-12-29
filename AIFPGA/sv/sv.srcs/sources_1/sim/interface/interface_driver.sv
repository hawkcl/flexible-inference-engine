
import definitions_pkg::*;
typedef struct {
	 logic                        buf_received;
     logic [7 : 0]                buffer[DDR_LEN_SIZE + 8];

     logic                        add_output;
     logic [DDR_ADDR_WIDTH-1:0]   add_output_address;
     logic [DDR_ADDR_WIDTH-1:0]   add_output_size;
     
     logic                        ren_weight;
     logic [DDR_ADDR_WIDTH-1:0]   read_addr_weight;
     logic [DDR_LEN_WIDTH-1 : 0]  read_len_weight;
     
     logic                        ren_data1;
     logic [DDR_ADDR_WIDTH-1:0]   read_addr_data1;
     logic [DDR_LEN_WIDTH-1 : 0]  read_len_data1;

     logic                        wen_data1;
     logic [DDR_ADDR_WIDTH-1:0]   write_addr_data1;
     logic [DDR_LEN_WIDTH-1 : 0]  write_len_data1;
     logic [DDR_DATA_WIDTH-1:0]   write_data_data1[DDR_LEN_SIZE];

} interface_inputs;

typedef struct {
	 logic                        addrbuf_enable;
     logic [DDR_ADDR_WIDTH-1:0]   inst_address;

     logic                        output_enable;
     logic [DDR_ADDR_WIDTH-1:0]   output_addr;
     logic [DDR_DATA_WIDTH-1:0]   output_data[DDR_LEN_SIZE];
     logic [DDR_LEN_WIDTH-1 : 0]  output_len;

     logic [DDR_DATA_WIDTH-1:0]   read_data_weight[DDR_LEN_SIZE];
     logic [DDR_DATA_WIDTH-1:0]   read_data_data1[DDR_LEN_SIZE];

     
    logic                         output_state;
    logic [DDR_ADDR_WIDTH-1:0]    out_addr;
    logic [DDR_ADDR_WIDTH-1:0]    out_len;
    logic [DDR_ADDR_WIDTH-1:0]    out_size;
} interface_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output interface_inputs in_data);
import "DPI-C" function void compare_outputs(input interface_outputs out_data);

class interface_driver;


  virtual interface_ports ports;
  interface_inputs input_data;
  interface_outputs output_data;
  logic out_clock;

  function new (virtual interface_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin

        ports.buf_received = input_data.buf_received;
        ports.buffer = input_data.buffer;
        ports.add_output = input_data.add_output;
        ports.add_output_address = input_data.add_output_address;
        ports.add_output_size = input_data.add_output_size;
        ports.ren_weight = input_data.ren_weight;
        ports.read_addr_weight = input_data.read_addr_weight;
        ports.read_len_weight = input_data.read_len_weight;
        ports.ren_data1 = input_data.ren_data1;
        ports.read_addr_data1 = input_data.read_addr_data1;
        ports.read_len_data1 = input_data.read_len_data1;
        ports.wen_data1 = input_data.wen_data1;
        ports.write_addr_data1 = input_data.write_addr_data1;
        ports.write_len_data1 = input_data.write_len_data1;
        ports.write_data_data1 = input_data.write_data_data1;
       
  end
  endtask

  task assign_outputs();
  begin
	  output_data.addrbuf_enable = ports.addrbuf_enable;
	  output_data.inst_address = ports.inst_address;
	  output_data.output_enable = ports.output_enable;
	  output_data.output_addr = ports.output_addr;
	  output_data.output_data = ports.output_data;
	  output_data.output_len = ports.output_len;
	  output_data.read_data_weight = ports.read_data_weight;
	  output_data.read_data_data1 = ports.read_data_data1;
	 
      output_data.output_state = interface_tb.iftest.output_state;
      output_data.out_addr = interface_tb.iftest.out_addr;
      output_data.out_len = interface_tb.iftest.out_len;
      output_data.out_size = interface_tb.iftest.out_size;
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
    #2 ports.resetN= 1'b1;
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
       //@ interface_ports.cb
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

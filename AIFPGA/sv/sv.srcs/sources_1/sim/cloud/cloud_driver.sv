
import definitions_pkg::*;
typedef struct {
	logic                    buf_received;
    logic [7 : 0]            buffer[DDR_LEN_SIZE + 8];
} cloud_inputs;

typedef struct {
	 logic                        output_enable;
     logic [DDR_ADDR_WIDTH-1:0]   output_addr;
     logic [DDR_DATA_WIDTH-1:0]   output_data[DDR_LEN_SIZE];
     logic [DDR_LEN_WIDTH-1 : 0]  output_len;

     logic                        addrbuf_enable;
     logic [DDR_ADDR_WIDTH-1:0]   inst_address;
     
     logic                           ren_weight;
     logic   [DDR_ADDR_WIDTH-1:0]    read_addr_weight;
     logic   [DDR_LEN_WIDTH-1 : 0]   read_len_weight;
     logic [DDR_DATA_WIDTH-1:0]   read_data_weight[DDR_LEN_SIZE];

     logic                           ren_data1;
     logic   [DDR_ADDR_WIDTH-1:0]    read_addr_data1;
     logic   [DDR_LEN_WIDTH-1 : 0]   read_len_data1;
     logic [DDR_DATA_WIDTH-1:0]   read_data_data1[DDR_LEN_SIZE];

     logic                           wen_data1;
    logic   [DDR_ADDR_WIDTH-1:0]    write_addr_data1;
    logic   [DDR_LEN_WIDTH-1 : 0]   write_len_data1;
    logic   [DDR_DATA_WIDTH-1:0]    write_data_data1[DDR_LEN_SIZE];
} cloud_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output cloud_inputs in_data);
import "DPI-C" function void compare_outputs(input cloud_outputs out_data);

class cloud_driver;


  virtual cloud_ports ports;
  cloud_inputs input_data;
  cloud_outputs output_data;
  logic out_clock;

  function new (virtual cloud_ports ports);
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
  end
  endtask

  task assign_outputs();
  begin

	  output_data.output_enable = ports.output_enable;
	  output_data.output_addr = ports.output_addr;
	  output_data.output_data = ports.output_data;
	  output_data.output_len = ports.output_len;

      output_data.addrbuf_enable = cloud_tb.cloud.addrbuf_enable;
	  output_data.inst_address = cloud_tb.cloud.inst_address;
      output_data.ren_weight = cloud_tb.cloud.ren_weight;
      output_data.read_addr_weight = cloud_tb.cloud.read_addr_weight;
      output_data.read_len_weight = cloud_tb.cloud.read_len_weight;
      output_data.read_data_weight = cloud_tb.cloud.read_data_weight;
      
	  output_data.ren_data1 = cloud_tb.cloud.ren_data1;
	  output_data.read_addr_data1 = cloud_tb.cloud.read_addr_data1;
	  output_data.read_len_data1 = cloud_tb.cloud.read_len_data1;
	  output_data.read_data_data1 = cloud_tb.cloud.read_data_data1;

	  output_data.wen_data1 = cloud_tb.cloud.wen_data1;
	  output_data.write_addr_data1 = cloud_tb.cloud.write_addr_data1;
	  output_data.write_len_data1 = cloud_tb.cloud.write_len_data1;
	  output_data.write_data_data1 = cloud_tb.cloud.write_data_data1;

    
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
       //@ cloud_ports.cb
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

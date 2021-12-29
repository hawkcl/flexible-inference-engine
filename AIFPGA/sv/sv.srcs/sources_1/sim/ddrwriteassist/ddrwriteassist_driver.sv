
import definitions_pkg::*;
typedef struct {
     logic         axi_ready;
	 logic         req_valid;
     mem_addr_t    req_addr;
     ddr_len_t     req_len;
     ubyte_t	   req_data[BRAM_BUS_WIDTH * FEATURE_BYTE_SIZE];
} ddrwriteassist_inputs;

typedef struct {
	logic        write_ready;
    logic        write_request;
    ddr_id_t     axi_wid;
    mem_addr_t   axi_waddr;
    logic    [DDR_DATAWIDTH-1 : 0] axi_wstrobe;
    ubyte_t      axi_wdata[DDR_DATAWIDTH];

    mem_addr_t      buf_addr;
    ddr_width_t     buf_start;
    ddr_width1_t    buf_end; // 1 after last ocupied pos
    logic [2:0]     idle_count;
    mem_addr_t      next_fifo_addr;
    logic           busy_state;
    logic           buf_used;
    ubyte_t         saved_buf[DDR_DATAWIDTH];
    logic           flash_saved;
    logic           do_process;
    ddr_width1_t    saved_pos;
    ddr_width_t     saved_start;
    ddr_len_t       data_pos;
    mem_addr_t      saddr;
} ddrwriteassist_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output ddrwriteassist_inputs in_data);
import "DPI-C" function void compare_outputs(input ddrwriteassist_outputs out_data);

class ddrwriteassist_driver;


  virtual ddrwriteassist_ports ports;
  ddrwriteassist_inputs input_data;
  ddrwriteassist_outputs output_data;
  logic out_clock;

  function new (virtual ddrwriteassist_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
        ports.req_valid = input_data.req_valid;
        ports.axi_ready = input_data.axi_ready;
        ports.req_addr = input_data.req_addr;
        ports.req_len = input_data.req_len;
        for(int i = 0; i < BRAM_BUS_WIDTH * FEATURE_BYTE_SIZE; i++)
            ports.req_data[i] = input_data.req_data[i];
  end
  endtask

  task assign_outputs();
  begin
	  output_data.write_ready = ports.write_ready;
	  output_data.write_request = ports.write_request;
	  output_data.axi_wid = ports.axi_wid;
	  output_data.axi_waddr = ports.axi_waddr;
	  output_data.axi_wstrobe = ports.axi_wstrobe;
      for(int i = 0; i < DDR_DATAWIDTH; i++)
          output_data.axi_wdata[i] = ports.axi_wdata[i];
	  
      output_data.buf_addr = ddrwriteassist_tb.ddrwriteassist.buf_addr;
      output_data.buf_start = ddrwriteassist_tb.ddrwriteassist.buf_start;
      for(int i = 0; i < DDR_DATAWIDTH; i++)
          output_data.saved_buf[i] = ddrwriteassist_tb.ddrwriteassist.saved_buf_next[i];
      output_data.buf_end = ddrwriteassist_tb.ddrwriteassist.buf_end;
      output_data.idle_count = ddrwriteassist_tb.ddrwriteassist.idle_count;
      output_data.next_fifo_addr = ddrwriteassist_tb.ddrwriteassist.next_fifo_addr;
      output_data.busy_state = ddrwriteassist_tb.ddrwriteassist.busy_state;
      output_data.buf_used = ddrwriteassist_tb.ddrwriteassist.buf_used;
      output_data.flash_saved = ddrwriteassist_tb.ddrwriteassist.flash_saved;
      output_data.do_process = ddrwriteassist_tb.ddrwriteassist.do_process;
      output_data.saved_pos = ddrwriteassist_tb.ddrwriteassist.saved_pos;
      output_data.saved_start = ddrwriteassist_tb.ddrwriteassist.saved_start;
      output_data.data_pos = ddrwriteassist_tb.ddrwriteassist.data_pos;
      output_data.saddr = ddrwriteassist_tb.ddrwriteassist.saddr;
     
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
       //@ ddrwriteassist_ports.cb
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

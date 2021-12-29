
import definitions_pkg::*;
typedef struct {
	logic 		    cwinst_enable;
    InstructionWrite_unpack 	cwinst;
    seq_t           cb0_finishedSeq;
    logic           cb_isFetchNextInst[BANK_NUM];
    logic           pwrite_setNextInst[BANK_NUM];

    s_feature_t 	pwrite_data[BANK_NUM][COMPUTING_GROUP_SIZE];
    logic 		    pwrite_enable[BANK_NUM];
    mem_addr_t 	    pwrite_addr[BANK_NUM];
    logic           ddr_write_ready;

} ctrlwrite_inputs;

typedef struct {
	seq_t               pwrite_finishedSeq;
    logic               pwrite_isFetchNextInst;
    logic               pwrite_isWritable[BANK_NUM];

    logic               ddr_write_enable;
    mem_addr_t          ddr_write_addr;
    logic   [DDR_LEN_WIDTH-1 : 0]       ddr_write_len;
    logic               rama_write_enable;
    logic               ramb_write_enable;
    mem_addr_t          ram_write_addr;
    ctrl_width_t        ram_write_len;
    logic               isStopable;
    s_feature_t         outbuf[BRAM_BUS_WIDTH];

    logic               fifo_empty[BANK_NUM];
    logic               fifo_full[BANK_NUM];
    logic               fifo_ren[BANK_NUM];
    logic unsigned [1:0] 	idx;
    width_t             curH01;
    width_t             curH23;
    logic               pool_flush_01;
    logic               pool_flush_23;
    mem_addr_t          addr_pool_01;
    mem_addr_t          addr_pool_23;
} ctrlwrite_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output ctrlwrite_inputs in_data);
import "DPI-C" function void compare_outputs(input ctrlwrite_outputs out_data);

class ctrlwrite_driver;


  virtual ctrlwrite_ports ports;
  ctrlwrite_inputs input_data;
  ctrlwrite_outputs output_data;
  logic out_clock;

  function new (virtual ctrlwrite_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
        ports.cwinst_enable = input_data.cwinst_enable;
        ports.cb0_finishedSeq = input_data.cb0_finishedSeq;
        ports.ddr_write_ready = input_data.ddr_write_ready;
        for(int i = 0; i < BANK_NUM; i++)
        begin
            ports.cb_isFetchNextInst[i] = input_data.cb_isFetchNextInst[i];
            ports.pwrite_setNextInst[i] = input_data.pwrite_setNextInst[i];
            ports.pwrite_enable[i] = input_data.pwrite_enable[i];
            ports.pwrite_addr[i] = input_data.pwrite_addr[i];
            for(int j = 0; j < COMPUTING_GROUP_SIZE; j++)
                ports.pwrite_data[i][j] = input_data.pwrite_data[i][j];

        end

        ports.cwinst.mode = input_data.cwinst.mode;
        ports.cwinst.dataWidth = input_data.cwinst.dataWidth;
        ports.cwinst.dataWidth2 = input_data.cwinst.dataWidth2;
        ports.cwinst.Oaddr = input_data.cwinst.Oaddr;
        ports.cwinst.outH1 = input_data.cwinst.outH1;
        ports.cwinst.isUpsample = input_data.cwinst.isUpsample;
        ports.cwinst.isMaddr_a = input_data.cwinst.isMaddr_a;
        ports.cwinst.isMaddr_b = input_data.cwinst.isMaddr_b;
        ports.cwinst.maxpool_stride = input_data.cwinst.maxpool_stride;
        ports.cwinst.maxpool_size = input_data.cwinst.maxpool_size;
  end
  endtask

  task assign_outputs();
  begin
	  output_data.pwrite_finishedSeq = ports.pwrite_finishedSeq;
	  output_data.pwrite_isFetchNextInst = ports.pwrite_isFetchNextInst;
	  output_data.ddr_write_enable = ports.ddr_write_enable;
	  output_data.ddr_write_addr = ports.ddr_write_addr;
	  output_data.ddr_write_len = ports.ddr_write_len;
	  output_data.rama_write_enable = ports.rama_write_enable;
	  output_data.ramb_write_enable = ports.ramb_write_enable;
	  output_data.isStopable = ports.isStopable;
	  output_data.ram_write_addr = ports.ram_write_addr;
	  output_data.ram_write_len = ports.ram_write_len;
	  
      for(int i = 0; i < BANK_NUM; i++)
      begin
          output_data.pwrite_isWritable[i] = ports.pwrite_isWritable[i];
      end
      for(int i = 0; i < BRAM_BUS_WIDTH; i++)
      begin
          output_data.outbuf[i] = ports.outbuf[i];
      end


      output_data.idx = ctrlwrite_tb.ctrlwrite.idx;
      output_data.curH01 = ctrlwrite_tb.ctrlwrite.curH01;
      output_data.curH23 = ctrlwrite_tb.ctrlwrite.curH23;
      output_data.pool_flush_01 = ctrlwrite_tb.ctrlwrite.pool_flush_01;
      output_data.pool_flush_23 = ctrlwrite_tb.ctrlwrite.pool_flush_23;
      output_data.addr_pool_01 = ctrlwrite_tb.ctrlwrite.addr_pool_01;
      output_data.addr_pool_23 = ctrlwrite_tb.ctrlwrite.addr_pool_23;

      for(int i = 0; i < BANK_NUM; i++)
      begin
          output_data.fifo_empty[i] = ctrlwrite_tb.ctrlwrite.data_fifo_empty[i];
          output_data.fifo_full[i] = ctrlwrite_tb.ctrlwrite.data_fifo_full[i];
          output_data.fifo_ren[i] = ctrlwrite_tb.ctrlwrite.data_fifo_ren[i];
      end
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
       //@ ctrlwrite_ports.cb
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

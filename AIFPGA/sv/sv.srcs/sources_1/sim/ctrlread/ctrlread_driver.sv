
import definitions_pkg::*;
typedef struct {
	logic 		crinst_enable;
    InstructionRead_unpack 	crinst;

    logic         cb_isRunning[BANK_NUM];
    logic         cb_isReadingFeatures[BANK_NUM];
    logic         cb_isLoadingFroze[BANK_NUM];
    seq_t         cb_ReqFeature[BANK_NUM];
    seq_t         cb_FinishedSeq[BANK_NUM];
    seq_t         cb_WorkingSeq[BANK_NUM];
    seq_t         cb_WorkingProgress[BANK_NUM];

    logic         [BANK_NUM - 1:0]requestValid;
    RequestItem_t_unpack    ritem[BANK_NUM];
    logic         reqGIBValid;
    RequestItem_t_unpack    reqGIB;

    logic           ddr_read_ready;
    ddr_id_t        ddr_data_id;
    s_feature_t  	ddr_data[MAX_LOAD_WIDTH];
    s_feature_t  	rama_data[MAX_LOAD_WIDTH];
    s_feature_t  	ramb_data[MAX_LOAD_WIDTH];
} ctrlread_inputs;

typedef struct {
	logic        ddr_enable;
    mem_addr_t   ddr_addr;
    ctrl_width_t ddr_len;
    ddr_id_t     ddr_id;
    logic        rama_ren;
    logic        ramb_ren;
    mem_addr_t   ram_addr;
    ctrl_width_t ram_len;

    logic           pread_waitForSeq;
    logic 		    pread_busValid;
    logic 		    pread_isFeature;
    logic           pread_RequestFull;
    logic           isStopable;
    seq_t           pread_SeqNum;
    s_feature_t 	data_bus[MAX_LOAD_WIDTH];
    ReturnData_t_unpack    reqdata;

    logic           reqGIBValid;

    logic 			input_data_fifo_ren;
    logic 			input_data_fifo_wen;
    data_fifo_t     liveCount;
    logic               readMoreData;
    logic               newReqSeq;
    logic 			data_fifo_ren;
    logic 			data_fifo_wen;
} ctrlread_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output ctrlread_inputs in_data);
import "DPI-C" function void compare_outputs(input ctrlread_outputs out_data);

class ctrlread_driver;


  virtual ctrlread_ports ports;
  ctrlread_inputs input_data;
  ctrlread_outputs output_data;
  logic out_clock;

  function new (virtual ctrlread_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
        ports.crinst_enable = input_data.crinst_enable;
        ports.requestValid = input_data.requestValid;
        ports.reqGIBValid = input_data.reqGIBValid;
        for(int i = 0; i < BANK_NUM; i++)
        begin
            ports.cb_isRunning[i] = input_data.cb_isRunning[i];
            ports.cb_isReadingFeatures[i] = input_data.cb_isReadingFeatures[i];
            ports.cb_isLoadingFroze[i] = input_data.cb_isLoadingFroze[i];
            ports.cb_ReqFeature[i] = input_data.cb_ReqFeature[i];
            ports.cb_FinishedSeq[i] = input_data.cb_FinishedSeq[i];
            ports.cb_WorkingSeq[i] = input_data.cb_WorkingSeq[i];
            ports.cb_WorkingProgress[i] = input_data.cb_WorkingProgress[i];
        end

        for(int i = 0; i < MAX_LOAD_WIDTH; i++)
        begin
            ports.ddr_data[i] = input_data.ddr_data[i];
            ports.rama_data[i] = input_data.rama_data[i];
            ports.ramb_data[i] = input_data.ramb_data[i];
        end
        ports.ddr_data_id = input_data.ddr_data_id;
        ports.ddr_read_ready = input_data.ddr_read_ready;

        ports.crinst.mode = input_data.crinst.mode;
        ports.crinst.reqSeqNum = input_data.crinst.reqSeqNum;
        ports.crinst.reqProgress = input_data.crinst.reqProgress;
        ports.crinst.seqNum = input_data.crinst.seqNum;
        ports.crinst.W = input_data.crinst.W;
        ports.crinst.H = input_data.crinst.H;
        ports.crinst.C = input_data.crinst.C;
        ports.crinst.Maddr = input_data.crinst.Maddr;
        ports.crinst.W1 = input_data.crinst.W1;
        ports.crinst.W2 = input_data.crinst.W2;
        ports.crinst.H1 = input_data.crinst.H1;
        ports.crinst.X = input_data.crinst.X;
        ports.crinst.Y = input_data.crinst.Y;
        ports.crinst.S = input_data.crinst.S;
        ports.crinst.lPad = input_data.crinst.lPad;
        ports.crinst.rPad = input_data.crinst.rPad;
        ports.crinst.isMaddr_a = input_data.crinst.isMaddr_a;
        ports.crinst.isMaddr_b = input_data.crinst.isMaddr_b;
        ports.crinst.isRes_a = input_data.crinst.isRes_a;

        for(int i = 0; i < BANK_NUM; i++) begin
            ports.ritem[i].addr = input_data.ritem[i].addr;
            ports.ritem[i].seq = input_data.ritem[i].seq;
            ports.ritem[i].len = input_data.ritem[i].len;
            ports.ritem[i].token = input_data.ritem[i].token;
            ports.ritem[i].dtype = input_data.ritem[i].dtype;
            ports.ritem[i].isRamA = input_data.ritem[i].isRamA;
            ports.ritem[i].isRamB = input_data.ritem[i].isRamB;
        end

        ports.reqGIB.addr = input_data.reqGIB.addr;
        ports.reqGIB.seq = input_data.reqGIB.seq;
        ports.reqGIB.len = input_data.reqGIB.len;
        ports.reqGIB.token = input_data.reqGIB.token;
        ports.reqGIB.dtype = input_data.reqGIB.dtype;
        ports.reqGIB.isRamA = input_data.reqGIB.isRamA;
        ports.reqGIB.isRamB = input_data.reqGIB.isRamB;

        
  end
  endtask

  task assign_outputs();
  begin
	  output_data.ddr_enable = ports.ddr_enable;
	  output_data.ddr_addr = ports.ddr_addr;
	  output_data.ddr_len = ports.ddr_len;
	  output_data.ddr_id = ports.ddr_id;
	  output_data.rama_ren = ports.rama_ren;
	  output_data.ramb_ren = ports.ramb_ren;
	  output_data.ram_addr = ports.ram_addr;
	  output_data.ram_len = ports.ram_len;
	  output_data.pread_waitForSeq = ports.pread_waitForSeq;
	  output_data.pread_busValid = ports.pread_busValid;
	  output_data.pread_isFeature = ports.pread_isFeature;
	  output_data.pread_RequestFull = ports.pread_RequestFull;
	  output_data.isStopable = ports.isStopable;
	  output_data.pread_SeqNum = ports.pread_SeqNum;
	  
      for(int i = 0; i < MAX_LOAD_WIDTH; i++)
      begin
          output_data.data_bus[i] = ports.data_bus[i];
      end

	  output_data.reqdata.seq = ports.data_bus_ret.seq;
	  output_data.reqdata.len = ports.data_bus_ret.len;
	  output_data.reqdata.token = ports.data_bus_ret.token;
	  output_data.reqdata.dtype = ports.data_bus_ret.dtype;
      for(int i = 0; i < WEIGHT_MEM_BUS_SIZE; i++)
      begin
          output_data.reqdata.data[i] = ports.data_bus_ret.data[i];
      end
      // $write("seq %d %d\n",output_data.reqdata.seq, ports.data_bus_ret.seq);

      output_data.reqGIBValid = ctrlread_tb.ctrlread.reqGIBValid0;

      output_data.input_data_fifo_ren = ctrlread_tb.ctrlread.readData.input_data_fifo_ren;
        output_data.input_data_fifo_wen = ctrlread_tb.ctrlread.readData.input_data_fifo_wen;
        output_data.liveCount = ctrlread_tb.ctrlread.readData.liveCount;
        output_data.readMoreData = ctrlread_tb.ctrlread.readData.readMoreData;
        output_data.newReqSeq = ctrlread_tb.ctrlread.readData.newReqSeq;
        output_data.data_fifo_ren = ctrlread_tb.ctrlread.data_fifo_ren;
        output_data.data_fifo_wen = ctrlread_tb.ctrlread.data_fifo_wen;
      
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
       //@ ctrlread_ports.cb
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

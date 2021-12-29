
import definitions_pkg::*;
typedef struct {
	seq_t 		    rama_finishedSeq;
    seq_t 		    ramb_finishedSeq;
    seq_t 		    pcwrite_finishedSeq;
    logic           addressBuffer_empty;
    mem_addr_t      addressBuffer_rdata;
    logic           pcread_busValid;
    logic           pcread_isFeature;
    logic           pcread_RequestGIBValid;
    ReturnData_t_unpack 	pread_dataBus;
    logic           cb_ibfull[BANK_NUM+2];
    logic             hcb_isStopable[BANK_NUM];
    logic             read_isStopable;
    logic             write_isStopable;
    logic             weight_isStopable;
} GIB_inputs;

typedef struct {
	logic                       pif_AddOutput;
    mem_addr_t                  endInst_oAddr;
    mem_addr_t                  endInst_oSize;
    logic                       addressBuffer_ren;
    logic                       reqGIBValid;
    RequestItem_t_unpack        reqGIB;
    logic                       cb_start[BANK_NUM];
    logic                       cb_stop[BANK_NUM];
    logic 		                inst_enable[BANK_NUM];
    InstructionHCB_unpack 	    cb_inst[BANK_NUM];
    logic 		                cwtinst_enable;
    InstructionWeight_unpack    cwtinst;
    logic 		                crinst_enable;
    InstructionRead_unpack 	    crinst;
    logic 		                cwinst_enable;
    InstructionWrite_unpack     cwinst;

    mem_addr_t          address;
    logic               addressValid;
    logic               fetchMore;
    logic               endValid;
    gib_len_t           readLen;
    gib_len_t           maxLen;
    InstructionType     itype;
    logic               pendingRequest;
    logic               doDecodeInstruction;
    seq_t               end_reqSeqNum;
    logic               end_fifo_wen;
} GIB_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output GIB_inputs in_data);
import "DPI-C" function void compare_outputs(input GIB_outputs out_data);

class GIB_driver;


  virtual GIB_ports ports;
  GIB_inputs input_data;
  GIB_outputs output_data;
  logic out_clock;

  function new (virtual GIB_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
        ports.rama_finishedSeq = input_data.rama_finishedSeq;
        ports.ramb_finishedSeq = input_data.ramb_finishedSeq;
        ports.pcwrite_finishedSeq = input_data.pcwrite_finishedSeq;
        ports.addressBuffer_empty = input_data.addressBuffer_empty;
        ports.addressBuffer_rdata = input_data.addressBuffer_rdata;
        ports.pcread_busValid = input_data.pcread_busValid;
        ports.pcread_isFeature = input_data.pcread_isFeature;
        ports.pcread_RequestGIBValid = input_data.pcread_RequestGIBValid;
        for(int i = 0; i < BANK_NUM+2; i++)
        begin
            ports.cb_ibfull[i] = input_data.cb_ibfull[i];
        end
        for(int i = 0; i < BANK_NUM; i++)
        begin
            ports.hcb_isStopable[i] = input_data.hcb_isStopable[i];
        end
        ports.read_isStopable = input_data.read_isStopable;
        ports.write_isStopable = input_data.write_isStopable;
        ports.weight_isStopable = input_data.weight_isStopable;
        ports.pread_dataBus.dtype = input_data.pread_dataBus.dtype;
        ports.pread_dataBus.seq = input_data.pread_dataBus.seq;
        ports.pread_dataBus.len = input_data.pread_dataBus.len;
        ports.pread_dataBus.token = input_data.pread_dataBus.token;
        for(int i = 0; i < BRAM_BUS_WIDTH; i++) begin
            ports.pread_dataBus.data[i] = input_data.pread_dataBus.data[i];
        end

  end
  endtask

  task assign_outputs();
  begin
	  output_data.pif_AddOutput = ports.pif_AddOutput;
	  output_data.endInst_oAddr = ports.endInst_oAddr;
	  output_data.endInst_oSize = ports.endInst_oSize;
	  output_data.addressBuffer_ren = ports.addressBuffer_ren;
	  output_data.reqGIBValid = ports.reqGIBValid;
	  output_data.cwtinst_enable = ports.cwtinst_enable;
	  output_data.crinst_enable = ports.crinst_enable;
	  output_data.cwinst_enable = ports.cwinst_enable;
	  
      for(int i = 0; i < BANK_NUM; i++)
      begin
          output_data.cb_start[i] = ports.cb_start[i];
          output_data.cb_stop[i] = ports.cb_stop[i];
          output_data.inst_enable[i] = ports.inst_enable[i];

            output_data.cb_inst[i].isResMaster = ports.cb_inst[i].isResMaster;
            output_data.cb_inst[i].isProgressMaster = ports.cb_inst[i].isProgressMaster;
            output_data.cb_inst[i].isRaddr_a = ports.cb_inst[i].isRaddr_a;
            output_data.cb_inst[i].doRes = ports.cb_inst[i].doRes;
            output_data.cb_inst[i].doRelu = ports.cb_inst[i].doRelu;
            output_data.cb_inst[i].doLRelu = ports.cb_inst[i].doLRelu;
            output_data.cb_inst[i].doBM = ports.cb_inst[i].doBM;
            output_data.cb_inst[i].doUpSample = ports.cb_inst[i].doUpSample;
            output_data.cb_inst[i].newWriteInst = ports.cb_inst[i].newWriteInst;

            output_data.cb_inst[i].Id = ports.cb_inst[i].Id;
            output_data.cb_inst[i].itype = ports.cb_inst[i].itype;
            output_data.cb_inst[i].reqSeqNum = ports.cb_inst[i].reqSeqNum;
            output_data.cb_inst[i].reqProgress = ports.cb_inst[i].reqProgress;
            output_data.cb_inst[i].reqSeqNumW = ports.cb_inst[i].reqSeqNumW;
            output_data.cb_inst[i].reqProgressW = ports.cb_inst[i].reqProgressW;
            output_data.cb_inst[i].seqNum = ports.cb_inst[i].seqNum;
            output_data.cb_inst[i].W = ports.cb_inst[i].W;
            output_data.cb_inst[i].H = ports.cb_inst[i].H;
            output_data.cb_inst[i].C = ports.cb_inst[i].C;
            output_data.cb_inst[i].Waddr = ports.cb_inst[i].Waddr;
            output_data.cb_inst[i].WEnd = ports.cb_inst[i].WEnd;
            output_data.cb_inst[i].weightPos = ports.cb_inst[i].weightPos;
            output_data.cb_inst[i].ReadPos = ports.cb_inst[i].ReadPos;
            output_data.cb_inst[i].ResPos = ports.cb_inst[i].ResPos;
            output_data.cb_inst[i].W1 = ports.cb_inst[i].W1;
            output_data.cb_inst[i].H1 = ports.cb_inst[i].H1;
            output_data.cb_inst[i].X = ports.cb_inst[i].X;
            output_data.cb_inst[i].Y = ports.cb_inst[i].Y;
            output_data.cb_inst[i].S = ports.cb_inst[i].S;
            output_data.cb_inst[i].lPad = ports.cb_inst[i].lPad;
            output_data.cb_inst[i].rPad = ports.cb_inst[i].rPad;
            output_data.cb_inst[i].K = ports.cb_inst[i].K;
            output_data.cb_inst[i].M = ports.cb_inst[i].M;
            output_data.cb_inst[i].Kh = ports.cb_inst[i].Kh;
            output_data.cb_inst[i].Ks = ports.cb_inst[i].Ks;
            output_data.cb_inst[i].Kt = ports.cb_inst[i].Kt;
            output_data.cb_inst[i].Res_addr = ports.cb_inst[i].Res_addr;
            output_data.cb_inst[i].wScale = ports.cb_inst[i].wScale;
            output_data.cb_inst[i].fScale = ports.cb_inst[i].fScale;
            output_data.cb_inst[i].BM_addr = ports.cb_inst[i].BM_addr;
            output_data.cb_inst[i].wLRelu = ports.cb_inst[i].wLRelu;
            output_data.cb_inst[i].weightToken = ports.cb_inst[i].weightToken;
            output_data.cb_inst[i].maxpool_size = ports.cb_inst[i].maxpool_size;
            output_data.cb_inst[i].maxpool_stride = ports.cb_inst[i].maxpool_stride;
            output_data.cb_inst[i].mode = ports.cb_inst[i].mode;
            output_data.cb_inst[i].outbufsize = ports.cb_inst[i].outbufsize;
            output_data.cb_inst[i].ofsize = ports.cb_inst[i].ofsize;
            output_data.cb_inst[i].outyx = ports.cb_inst[i].outyx;
            output_data.cb_inst[i].outputAddrGap = ports.cb_inst[i].outputAddrGap;
            output_data.cb_inst[i].outkh = ports.cb_inst[i].outkh;
            output_data.cb_inst[i].ng = ports.cb_inst[i].ng;
            output_data.cb_inst[i].gu = ports.cb_inst[i].gu;
            output_data.cb_inst[i].resSize = ports.cb_inst[i].resSize;
            output_data.cb_inst[i].resSizeLast = ports.cb_inst[i].resSizeLast;
            output_data.cb_inst[i].resLen = ports.cb_inst[i].resLen;
            output_data.cb_inst[i].resLenLast = ports.cb_inst[i].resLenLast;
            output_data.cb_inst[i].pfs = ports.cb_inst[i].pfs;
            output_data.cb_inst[i].volumeSize = ports.cb_inst[i].volumeSize;
            output_data.cb_inst[i].kCurLast = ports.cb_inst[i].kCurLast;
            output_data.cb_inst[i].wtotal_n = ports.cb_inst[i].wtotal_n;
            output_data.cb_inst[i].wtotalLast = ports.cb_inst[i].wtotalLast;
            output_data.cb_inst[i].wlenk_regular = ports.cb_inst[i].wlenk_regular;
            output_data.cb_inst[i].wlenk_nLast = ports.cb_inst[i].wlenk_nLast;
            output_data.cb_inst[i].wlenk_nLast2 = ports.cb_inst[i].wlenk_nLast2;
            output_data.cb_inst[i].totalBM = ports.cb_inst[i].totalBM;
            output_data.cb_inst[i].totalRes = ports.cb_inst[i].totalRes;
          
      end
      
        output_data.crinst.mode = ports.crinst.mode;
        output_data.crinst.reqSeqNum = ports.crinst.reqSeqNum;
        output_data.crinst.reqProgress = ports.crinst.reqProgress;
        output_data.crinst.seqNum = ports.crinst.seqNum;
        output_data.crinst.W = ports.crinst.W;
        output_data.crinst.H = ports.crinst.H;
        output_data.crinst.C = ports.crinst.C;
        output_data.crinst.Maddr = ports.crinst.Maddr;
        output_data.crinst.W1 = ports.crinst.W1;
        output_data.crinst.W2 = ports.crinst.W2;
        output_data.crinst.H1 = ports.crinst.H1;
        output_data.crinst.X = ports.crinst.X;
        output_data.crinst.Y = ports.crinst.Y;
        output_data.crinst.S = ports.crinst.S;
        output_data.crinst.lPad = ports.crinst.lPad;
        output_data.crinst.rPad = ports.crinst.rPad;
        output_data.crinst.isMaddr_a = ports.crinst.isMaddr_a;
        output_data.crinst.isMaddr_b = ports.crinst.isMaddr_b;
        output_data.crinst.isRes_a = ports.crinst.isRes_a;

        output_data.cwtinst.isReadRam = ports.cwtinst.isReadRam;
        output_data.cwtinst.isWriteRam = ports.cwtinst.isWriteRam;
        output_data.cwtinst.mode = ports.cwtinst.mode;
        output_data.cwtinst.dropSize = ports.cwtinst.dropSize;
        output_data.cwtinst.seqNum = ports.cwtinst.seqNum;
        output_data.cwtinst.Oaddr = ports.cwtinst.Oaddr;
        output_data.cwtinst.size = ports.cwtinst.size;

        output_data.cwinst.mode = ports.cwinst.mode;
        output_data.cwinst.dataWidth = ports.cwinst.dataWidth;
        output_data.cwinst.dataWidth2 = ports.cwinst.dataWidth2;
        output_data.cwinst.Oaddr = ports.cwinst.Oaddr;
        output_data.cwinst.outH1 = ports.cwinst.outH1;
        output_data.cwinst.isUpsample = ports.cwinst.isUpsample;
        output_data.cwinst.isMaddr_a = ports.cwinst.isMaddr_a;
        output_data.cwinst.isMaddr_b = ports.cwinst.isMaddr_b;
        output_data.cwinst.maxpool_stride = ports.cwinst.maxpool_stride;
        output_data.cwinst.maxpool_size = ports.cwinst.maxpool_size;

        output_data.reqGIB.addr 		= ports.reqGIB.addr;
	    output_data.reqGIB.seq 		= ports.reqGIB.seq;
	    output_data.reqGIB.len 		= ports.reqGIB.len;
	    output_data.reqGIB.token 		= ports.reqGIB.token;
	    output_data.reqGIB.dtype 		= ports.reqGIB.dtype;
	    output_data.reqGIB.isRamA 		= ports.reqGIB.isRamA;
	    output_data.reqGIB.isRamB 		= ports.reqGIB.isRamB;
      
        output_data.address = GIB_tb.gib.address;
        output_data.addressValid = GIB_tb.gib.addressValid;
        output_data.fetchMore = GIB_tb.gib.fetchMore;
        output_data.endValid = GIB_tb.gib.endValid;
        output_data.readLen = GIB_tb.gib.readLen;
        output_data.maxLen = GIB_tb.gib.maxLen;
        output_data.itype = GIB_tb.gib.itype;
        output_data.pendingRequest = GIB_tb.gib.pendingRequest;
        output_data.doDecodeInstruction = GIB_tb.gib.doDecodeInstruction;
        output_data.end_reqSeqNum = GIB_tb.gib.endInst.reqSeqNum;
        output_data.end_fifo_wen = GIB_tb.gib.inst_fifo_wen;
      
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
       //@ GIB_ports.cb
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

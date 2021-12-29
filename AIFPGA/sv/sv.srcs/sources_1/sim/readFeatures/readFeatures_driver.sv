
import definitions_pkg::*;
typedef struct {
  logic pread_busValid, pread_isFeature;
 logic isReadingFeatures, isLoadingFroze;
 logic isLoadingNextFeatures;
 seq_t pread_seqNum, reqSeqF;
 width_t writeWidth;

 logic new_params;
 mem_bus_addr_t readPos;
 input_addr_t volumeSize;

 input_addr_t usedWords;
 s_feature_t  dataBus[MAX_READ_WIDTH];
} readFeatures_inputs;

typedef struct {
  logic setLoadingFroze, resetLoadingFroze;
 logic resetLoadingNextFeatures, resetReadingFeatures;
 logic wen;
 logic unsigned [13:0]addrOut;
 s_feature_t  dataOut[INPUT_MEM_WIDTH];
 input_addr_t nextWritePos;
 logic unsigned [4:0] ibSize;
} readFeatures_outputs;

import "DPI-C" function void init_files();
import "DPI-C" function void read_inputs(output readFeatures_inputs in_data);
import "DPI-C" function void compare_outputs(input readFeatures_outputs out_data);

class readFeatures_driver;


  virtual readFeatures_ports ports;
  readFeatures_inputs input_data;
  readFeatures_outputs output_data;
  logic out_clock;

  function new (virtual readFeatures_ports ports);
  begin
    this.ports = ports;
    init_files();
    out_clock = 0;
  end
  endfunction

  task assign_inputs();
  begin
	ports.pread_busValid = input_data.pread_busValid;
        ports.pread_isFeature = input_data.pread_isFeature;
        ports.isReadingFeatures = input_data.isReadingFeatures;
	ports.isLoadingFroze = input_data.isLoadingFroze;
	ports.isLoadingNextFeatures = input_data.isLoadingNextFeatures;
	ports.pread_seqNum = input_data.pread_seqNum;
	ports.reqSeqF = input_data.reqSeqF;
	ports.writeWidth = input_data.writeWidth;
	ports.new_params = input_data.new_params;
	ports.readPos = input_data.readPos;
	ports.volumeSize = input_data.volumeSize;
	ports.usedWords = input_data.usedWords;
    for(int i = 0; i < MAX_READ_WIDTH; i++) begin
    	ports.dataBus[i] = input_data.dataBus[i];
    end
        
  end
  endtask

  task assign_outputs();
  begin
	  output_data.setLoadingFroze = ports.setLoadingFroze;
	  output_data.resetLoadingFroze = ports.resetLoadingFroze;
	  output_data.resetLoadingNextFeatures = ports.resetLoadingNextFeatures;
	  output_data.resetReadingFeatures = ports.resetReadingFeatures;
	  output_data.addrOut = ports.addrOut;
      for(int i = 0; i < INPUT_MEM_WIDTH; i++) begin
          output_data.dataOut[i] = ports.dataOut[i];
      end
	  output_data.wen = ports.wen;
	  
	  output_data.nextWritePos = readFeatures_tb.readfeatures.nextWritePos;
	  output_data.ibSize = readFeatures_tb.readfeatures.ibSize;
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
       //@ readFeatures_ports.cb
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

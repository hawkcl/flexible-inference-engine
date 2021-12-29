`timescale 1ns / 1ns
module sendBackUpInput_tb
import definitions_pkg::*;
();

logic clock, resetN;
 logic sendBackUpInput_valid;
 k_t backupId;
 s_feature_t  [INPUT_MEM_WIDTH-1:0]fifo_data;
 logic fifo_empty;
`ifdef S2_OPTIMIZE
 logic isStride2;
`endif
 width_t readWidth;
 pad_t leftPad;

 logic rd_en;
 s_feature_t shiftBufBackup[MAX_K][MAX_SHIFT_SIZE];
`ifdef S2_OPTIMIZE  
 s_feature_t backupBus[COMPUTING_GROUP_SIZE*2];
`else
 s_feature_t backupBus[COMPUTING_GROUP_SIZE];
`endif
 logic isBackupValid;
 

sendBackUpInput_ports ports(.*);
sendBackUpInput_top top(ports);

SendBackUpInput sendBackUpInput(.*);
  
initial begin
  //$dumpfile("fifo.vcd");
  //$dumpvars();
  clock = 0;
end

always #10 clock  = ~clock;

endmodule

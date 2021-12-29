`include "processInstruction_ports.sv"

module processInstruction_top (processInstruction_ports ports);
//  `include "fifo_sb.sv"
  `include "processInstruction_driver.sv"

  processInstruction_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

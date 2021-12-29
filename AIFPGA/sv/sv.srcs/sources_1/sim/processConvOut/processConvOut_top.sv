`include "processConvOut_ports.sv"

module processConvOut_top (processConvOut_ports ports);
//  `include "fifo_sb.sv"
  `include "processConvOut_driver.sv"

  processConvOut_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

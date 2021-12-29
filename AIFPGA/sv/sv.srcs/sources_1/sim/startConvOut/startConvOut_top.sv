`include "startConvOut_ports.sv"

module startConvOut_top (startConvOut_ports ports);
//  `include "fifo_sb.sv"
  `include "startConvOut_driver.sv"

  startConvOut_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

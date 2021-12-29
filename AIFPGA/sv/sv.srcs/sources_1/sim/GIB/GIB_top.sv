`include "GIB_ports.sv"

module GIB_top (GIB_ports ports);
//  `include "fifo_sb.sv"
  `include "GIB_driver.sv"

  GIB_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

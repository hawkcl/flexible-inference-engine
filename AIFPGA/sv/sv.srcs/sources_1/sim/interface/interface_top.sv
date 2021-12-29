`include "interface_ports.sv"

module interface_top (interface_ports ports);
//  `include "fifo_sb.sv"
  `include "interface_driver.sv"

  interface_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

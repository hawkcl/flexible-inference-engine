`include "ctrlwrite_ports.sv"

module ctrlwrite_top (ctrlwrite_ports ports);
//  `include "fifo_sb.sv"
  `include "ctrlwrite_driver.sv"

  ctrlwrite_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

`include "ctrlread_ports.sv"

module ctrlread_top (ctrlread_ports ports);
//  `include "fifo_sb.sv"
  `include "ctrlread_driver.sv"

  ctrlread_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

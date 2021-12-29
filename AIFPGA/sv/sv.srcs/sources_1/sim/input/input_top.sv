`include "input_ports.sv"

module input_top (input_ports ports);
//  `include "fifo_sb.sv"
  `include "input_driver.sv"

  input_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

`timescale 1ns / 1ns
`include "weight_ports.sv"

module weight_top (weight_ports ports);
//  `include "fifo_sb.sv"
  `include "weight_driver.sv"

  weight_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

`timescale 1ns / 1ns
`include "SCG_ports.sv"

module SCG_top (SCG_ports ports);
//  `include "fifo_sb.sv"
  `include "SCG_driver.sv"

  SCG_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

`timescale 1ns / 1ns
`include "bm_ports.sv"

module bm_top (bm_ports ports);
//  `include "fifo_sb.sv"
  `include "bm_driver.sv"

  bm_driver driver = new(ports);

  initial begin
    driver.go();
  end
endmodule
//endprogram

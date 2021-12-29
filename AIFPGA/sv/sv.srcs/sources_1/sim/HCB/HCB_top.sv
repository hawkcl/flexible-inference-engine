`include "HCB_ports.sv"

module HCB_top (HCB_ports ports);
//  `include "fifo_sb.sv"
  `include "HCB_driver.sv"

  HCB_driver driver = new(ports);

  initial begin
    driver.go();
  end
endmodule
//endprogram

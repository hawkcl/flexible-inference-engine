`include "HCBCtrl_ports.sv"

module HCBCtrl_top (HCBCtrl_ports ports);
//  `include "fifo_sb.sv"
  `include "HCBCtrl_driver.sv"

  HCBCtrl_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

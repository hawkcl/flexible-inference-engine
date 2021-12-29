`include "cloud_ports.sv"

module cloud_top (cloud_ports ports);
//  `include "fifo_sb.sv"
  `include "cloud_driver.sv"

  cloud_driver driver = new(ports);

  initial begin
    driver.go();
  end
endmodule
//endprogram

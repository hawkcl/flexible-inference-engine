`include "axi_ports.sv"

module axi_top (axi_ports ports);
//  `include "fifo_sb.sv"
  `include "axi_driver.sv"

  axi_driver driver = new(ports);

  initial begin
    driver.go();
  end
endmodule
//endprogram

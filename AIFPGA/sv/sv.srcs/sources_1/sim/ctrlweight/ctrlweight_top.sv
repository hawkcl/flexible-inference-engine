`include "ctrlweight_ports.sv"

module ctrlweight_top (ctrlweight_ports ports);
//  `include "fifo_sb.sv"
  `include "ctrlweight_driver.sv"

  ctrlweight_driver driver = new(ports);

  initial begin
    driver.go();
  end
endmodule
//endprogram

`include "readFeatures_ports.sv"

module readFeatures_top (readFeatures_ports ports);
//  `include "fifo_sb.sv"
  `include "readFeatures_driver.sv"

  readFeatures_driver driver = new(ports);

  initial begin
    driver.go();
  end
endmodule
//endprogram

`include "assembleInput_ports.sv"

program assembleInput_top (assembleInput_ports ports);
//  `include "fifo_sb.sv"
  `include "assembleInput_driver.sv"

  assembleInput_driver driver = new(ports);

  initial begin
    driver.go();
  end

endprogram

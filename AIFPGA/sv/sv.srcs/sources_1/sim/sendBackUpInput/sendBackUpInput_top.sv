`include "sendBackUpInput_ports.sv"

program sendBackUpInput_top (sendBackUpInput_ports ports);
//  `include "fifo_sb.sv"
  `include "sendBackUpInput_driver.sv"

  sendBackUpInput_driver driver = new(ports);

  initial begin
    driver.go();
  end

endprogram

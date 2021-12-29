`include "shiftinput_ports.sv"

program shiftinput_top (shiftinput_ports ports);
//  `include "fifo_sb.sv"
  `include "shiftinput_driver.sv"

  shiftinput_driver driver = new(ports);

  initial begin
    driver.go();
  end

endprogram

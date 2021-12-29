`include "buildInputFifo_ports.sv"

program buildInputFifo_top (buildInputFifo_ports ports);
//  `include "fifo_sb.sv"
  `include "buildInputFifo_driver.sv"

  buildInputFifo_driver driver = new(ports);

  initial begin
    driver.go();
  end

endprogram

`include "rex_ports.sv"

module rex_top (rex_ports ports);
//  `include "fifo_sb.sv"
  `include "rex_driver.sv"

  rex_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

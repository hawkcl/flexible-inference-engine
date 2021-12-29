`include "ddrreadassist_ports.sv"

module ddrreadassist_top (ddrreadassist_ports ports);
//  `include "fifo_sb.sv"
  `include "ddrreadassist_driver.sv"

  ddrreadassist_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

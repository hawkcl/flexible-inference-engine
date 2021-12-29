`include "ddrwriteassist_ports.sv"

module ddrwriteassist_top (ddrwriteassist_ports ports);
//  `include "fifo_sb.sv"
  `include "ddrwriteassist_driver.sv"

  ddrwriteassist_driver driver = new(ports);

  initial begin
    driver.go();
  end

endmodule

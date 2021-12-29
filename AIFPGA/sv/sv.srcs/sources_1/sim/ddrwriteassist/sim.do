vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/ddrwriteassist.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ram_fifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrwriteassist/fifo_DDRWriteInfo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrwriteassist/ddrwriteassist_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrwriteassist/ddrwriteassist_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrwriteassist/ddrwriteassist_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrwriteassist/ddrwriteassist_top.sv
vsim -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrwriteassist/svdpi ddrwriteassist_tb 
add wave -position insertpoint sim:/ddrwriteassist_tb/ddrwriteassist/*
#vlog -reportprogress 300 -work work D:/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v

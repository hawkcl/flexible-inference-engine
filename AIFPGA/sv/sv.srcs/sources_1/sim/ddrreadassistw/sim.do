vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/ddrreadassist.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ram_fifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrreadassist/fifo_DDRReadInfo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrreadassist/ddrreadassist_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrreadassist/ddrreadassist_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrreadassist/ddrreadassist_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrreadassist/ddrreadassist_top.sv
vsim -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ddrreadassist/svdpi ddrreadassist_tb 
add wave -position insertpoint sim:/ddrreadassist_tb/ddrreadassist/*
#vlog -reportprogress 300 -work work D:/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v

vlib work
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/test/test.sv
#vlog -reportprogress 300 -work work D:/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v
#vlog -reportprogress 300 -work work D:/Xilinx/Vivado/2018.3/data/verilog/src/unisims/FDSE.v
vsim -debugDB -L unisims_ver -gui  tb 
#work.glbl


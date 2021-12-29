vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/ctrlwrite.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ram_fifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlwrite/fifo_ctrlwrite_addr.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlwrite/fifo_ctrlwrite_data.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlwrite/fifo_InstructionWrite.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlwrite/ctrlwrite_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlwrite/ctrlwrite_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlwrite/ctrlwrite_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlwrite/ctrlwrite_top.sv
vsim -L D:/modeltech64_10.2c/XilinxLib/Xilinx_Corelib -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlwrite/svdpi ctrlwrite_tb 
add wave -position insertpoint sim:/ctrlwrite_tb/ctrlwrite/*

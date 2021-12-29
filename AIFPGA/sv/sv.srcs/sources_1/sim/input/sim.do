vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/assembleInput.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/assembleInputBuffer.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/buildInputFifo.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/readFeatures.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/sendBackUpInput.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/setupShiftInputs.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ram_fifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/input/inputs_mem.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/input/fifo_assemble_buffer.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/input/input_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/input/input_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/input/input_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/input/input_top.sv
vsim -L D:/modeltech64_10.2c/XilinxLib/Xilinx_Corelib -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/input/svdpi input_tb 
add wave -position insertpoint sim:/input_tb/readfeatures/*
add wave -position insertpoint sim:/input_tb/assembleInput/*
add wave -position insertpoint sim:/input_tb/buildInputFifo/*
add wave -position insertpoint sim:/input_tb/sendBackUpInput/*
add wave -position insertpoint sim:/input_tb/shiftinput/*

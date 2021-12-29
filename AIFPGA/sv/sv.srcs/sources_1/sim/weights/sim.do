vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/weightFifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ram_fifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/weights/fifo_weights.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/weights/weight_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/weights/weight_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/weights/weight_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/weights/weight_top.sv
vsim -L D:/modeltech64_10.2c/XilinxLib/Xilinx_Corelib -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/weights/svdpi weight_tb 
add wave -position insertpoint sim:/weight_tb/readWeights/*
add wave -position insertpoint sim:/weight_tb/sendWeights/*
add wave -position insertpoint sim:/weight_tb/weightsBus
add wave -position insertpoint sim:/weight_tb/sendWeights/buffer

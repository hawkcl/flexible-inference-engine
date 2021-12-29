vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/buildInputFifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/BuildInputFifo/buildInputFifo_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/BuildInputFifo/buildInputFifo_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/BuildInputFifo/buildInputFifo_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/BuildInputFifo/buildInputFifo_top.sv
vsim -L D:/modeltech64_10.2c/XilinxLib/Xilinx_Corelib -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/BuildInputFifo/svdpi buildInputFifo_tb 
add wave -position insertpoint sim:/buildInputFifo_tb/buildInputFifo/*

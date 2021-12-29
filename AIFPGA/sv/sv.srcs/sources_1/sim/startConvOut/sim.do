vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/startConvOut.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/startConvOut/startConvOut_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/startConvOut/startConvOut_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/startConvOut/startConvOut_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/startConvOut/startConvOut_top.sv
vsim -L D:/modeltech64_10.2c/XilinxLib/Xilinx_Corelib -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/startConvOut/svdpi startConvOut_tb 
add wave -position insertpoint sim:/startConvOut_tb/startConvOut/*

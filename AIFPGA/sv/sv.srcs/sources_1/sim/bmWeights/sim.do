vlib work
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/BMWeightFifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/ip/fifo_bmweights/fifo_bmweights_sim_netlist.v
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/bmWeights/bm_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/bmWeights/bm_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/bmWeights/bm_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/bmWeights/bm_top.sv
vsim -debugDB -L unisims_ver -gui -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/bmWeights/svdpi bm_tb work.glbl
add wave -position insertpoint sim:/bm_tb/readBMWeights/*
add wave -position insertpoint sim:/bm_tb/sendBMWeights/*
add wave -position insertpoint sim:/bm_tb/bmWeightBus

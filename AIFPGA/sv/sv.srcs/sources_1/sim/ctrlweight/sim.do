vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/ctrlweight.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/ctrlweight_mem.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ram_fifo.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/fifo_ctrlweight_data.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/fifo_InstructionWeight.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/ctrlweight_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/ctrlweight_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/ctrlweight_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/ctrlweight_top.sv
#vsim -L unisims_ver -L blk_mem_gen_v8_4_2 -L blk_mem_gen_v8_3_6 -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/svdpi ctrlweight_tb work.glbl 
vsim -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/ctrlweight/svdpi ctrlweight_tb 
add wave -position insertpoint sim:/ctrlweight_tb/ctrlweight/*
#vlog -reportprogress 300 -work work D:/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v

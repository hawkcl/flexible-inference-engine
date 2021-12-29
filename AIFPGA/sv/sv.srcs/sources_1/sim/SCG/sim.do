vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/pkg.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/SCG.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/UCL.sv
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/new/UCU.sv
vlog -reportprogress 300 -work work D:/Xilinx/Vivado/2018.3/data/verilog/src/glbl.v
vlog -reportprogress 30 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/ip/dmem_32_16/dmem_32_16_sim_netlist.v
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/SCG/SCG_driver.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/SCG/SCG_ports.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/SCG/SCG_tb.sv
vlog -reportprogress 300 -work work C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/SCG/SCG_top.sv
vsim -L unisims_ver  -gui -novopt -sv_lib C:/AI/AIFPGA/sv/sv.srcs/sources_1/sim/SCG/svdpi SCG_tb work.glbl 
//add wave -position insertpoint {sim:/SCG_tb/scg/ucu[0]/genblk1/u/*}
add wave -position insertpoint   	sim:/SCG_tb/scg/state

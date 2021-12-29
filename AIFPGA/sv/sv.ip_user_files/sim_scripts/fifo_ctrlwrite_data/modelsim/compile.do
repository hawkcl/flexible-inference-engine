vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../sv.srcs/sources_1/ip/fifo_ctrlwrite_data/sim/fifo_ctrlwrite_data.v" \


vlog -work xil_defaultlib \
"glbl.v"


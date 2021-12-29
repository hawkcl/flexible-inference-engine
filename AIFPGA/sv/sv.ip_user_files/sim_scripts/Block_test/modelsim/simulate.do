onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L axi_infrastructure_v1_1_0 -L fifo_generator_v13_2_3 -L axi_clock_converter_v2_1_17 -L xil_defaultlib -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_13 -L xlconstant_v1_1_5 -L smartconnect_v1_0 -L generic_baseblocks_v2_1_0 -L axi_data_fifo_v2_1_17 -L axi_register_slice_v2_1_18 -L axi_protocol_converter_v2_1_18 -L blk_mem_gen_v8_4_2 -L axi_dwidth_converter_v2_1_18 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.Block_test xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {Block_test.udo}

run -all

quit -force

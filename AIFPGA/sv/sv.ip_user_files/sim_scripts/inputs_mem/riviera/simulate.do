onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+inputs_mem -L xilinx_vip -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_2 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.inputs_mem xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {inputs_mem.udo}

run -all

endsim

quit -force

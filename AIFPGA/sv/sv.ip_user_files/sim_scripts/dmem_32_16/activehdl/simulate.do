onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+dmem_32_16 -L xilinx_vip -L xil_defaultlib -L xpm -L dist_mem_gen_v8_0_12 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dmem_32_16 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {dmem_32_16.udo}

run -all

endsim

quit -force

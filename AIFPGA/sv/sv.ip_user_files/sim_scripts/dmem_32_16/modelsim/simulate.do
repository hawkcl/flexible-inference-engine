onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L dist_mem_gen_v8_0_12 -L xil_defaultlib -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.dmem_32_16 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {dmem_32_16.udo}

run -all

quit -force

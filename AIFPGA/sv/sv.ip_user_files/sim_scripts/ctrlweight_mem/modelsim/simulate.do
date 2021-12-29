onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L blk_mem_gen_v8_4_2 -L xil_defaultlib -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.ctrlweight_mem xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {ctrlweight_mem.udo}

run -all

quit -force

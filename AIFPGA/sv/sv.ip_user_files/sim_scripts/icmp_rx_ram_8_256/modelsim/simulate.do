onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L blk_mem_gen_v8_4_2 -L xil_defaultlib -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.icmp_rx_ram_8_256 xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {icmp_rx_ram_8_256.udo}

run -all

quit -force

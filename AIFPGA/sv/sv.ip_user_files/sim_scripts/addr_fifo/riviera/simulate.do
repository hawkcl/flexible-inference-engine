onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+addr_fifo -L xilinx_vip -L xil_defaultlib -L xpm -L fifo_generator_v13_2_3 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.addr_fifo xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {addr_fifo.udo}

run -all

endsim

quit -force

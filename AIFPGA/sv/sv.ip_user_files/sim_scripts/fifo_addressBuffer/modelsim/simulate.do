onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -L fifo_generator_v13_2_3 -L xil_defaultlib -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.fifo_addressBuffer xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {fifo_addressBuffer.udo}

run -all

quit -force

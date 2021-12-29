onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+fifo_InstructionHCB -L xilinx_vip -L xil_defaultlib -L xpm -L fifo_generator_v13_2_3 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.fifo_InstructionHCB xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {fifo_InstructionHCB.udo}

run -all

endsim

quit -force

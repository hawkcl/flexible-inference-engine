onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_InstructionEnd_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_InstructionEnd.udo}

run -all

quit -force

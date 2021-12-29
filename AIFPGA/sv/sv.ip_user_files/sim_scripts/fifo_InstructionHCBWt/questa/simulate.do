onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_InstructionHCBWt_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_InstructionHCBWt.udo}

run -all

quit -force

onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_addressBuffer_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_addressBuffer.udo}

run -all

quit -force

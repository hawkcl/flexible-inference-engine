onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_resdata_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_resdata.udo}

run -all

quit -force

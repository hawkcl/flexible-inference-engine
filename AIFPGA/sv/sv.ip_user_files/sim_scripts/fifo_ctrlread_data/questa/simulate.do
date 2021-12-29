onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_ctrlread_data_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_ctrlread_data.udo}

run -all

quit -force

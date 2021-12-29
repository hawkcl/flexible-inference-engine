onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_ctrlread_req_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_ctrlread_req.udo}

run -all

quit -force

onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib dmem_32_16_opt

do {wave.do}

view wave
view structure
view signals

do {dmem_32_16.udo}

run -all

quit -force

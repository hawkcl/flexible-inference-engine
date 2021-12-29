#Source
#SV_FILE =  ..\..\new\pkg.sv  ..\..\new\UCL.sv ..\..\ip\dmem_32_16\dmem_32_16_sim_netlist.v ..\..\new\UCU.sv ..\..\new\SCG.sv SCG_tb.sv
XSC_FILE =  -svlog ..\..\new\pkg.sv  \
			-svlog ..\..\new\UCL.sv \
			-svlog ..\ram_fifo.sv \
			-svlog dmem_32_16.sv \
			-svlog ..\..\new\UCU.sv \
			-svlog ..\..\new\SCG.sv \
			-svlog SCG_driver.sv \
			-svlog SCG_top.sv \
			-svlog SCG_tb.sv
#SV_FILE =  ..\..\new\pkg.sv  ..\..\new\UCL.sv ..\ram_fifo.sv dmem_32_16.sv ..\..\new\UCU.sv ..\..\new\SCG.sv SCG_driver.sv SCG_top.sv SCG_tb.sv
SV_FILE =  ..\..\new\pkg.sv  ..\..\new\UCL.sv ..\..\ip\dmem_32_16\dmem_32_16_sim_netlist.v ..\..\new\UCU.sv ..\..\new\SCG.sv SCG_driver.sv SCG_top.sv SCG_tb.sv
TOP_NAME = SCG_tb
SRC = SCG_file.c
DPI_OBJ = svdpi
#Tool
MODELSIM_HOME = D:\modeltech64_10.2c
VLIB = vlib
VLOG = vlog
VSIM = vsim
CC = gcc
#CC = clang

OBJ = $(SRC:%.c=%.o)

run : vlib vlog vsim beep

beep:
	python -c "import sys;print('\7\7\7', file=sys.stderr)"

vlib:
	$(VLIB) work

vlog:
	$(VLOG) -sv -dpiheader dpiheader.h  $(SV_FILE)

vsim: $(DPI_OBJ).dll
	$(VSIM)  -c -novopt -sv_lib $(DPI_OBJ) -L unisims_ver $(TOP_NAME) work.glbl  -do "run -all; quit -f"

.c.o:
	$(CC) -c -fpic  -I$(MODELSIM_HOME)/include $<

$(DPI_OBJ).dll :$(OBJ)
	$(CC) -shared  $(OBJ) -o $(DPI_OBJ).dll

xsc0:
	xelab -dpiheader dpiheader.h  $(XSC_FILE)

xsc1:
	xsc $(SRC)

xsc2:
	xelab $(XSC_FILE) -sv_lib dpi -R


clean:
	rm -rf work  $(DPI_OBJ).dll $(OBJ) dpiheader.h  transcript *.wlf 

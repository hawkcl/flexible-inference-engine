#Source
XSC_FILE = -svlog ..\..\new\pkg.sv  \
	   -svlog ..\..\new\BMWeightFifo.sv \
	   -svlog ..\..\ip\fifo_bmweights\fifo_bmweights_sim_netlist.v \
	   -svlog bm_driver.sv \
	   -svlog bm_top.sv \
	   -svlog bm_tb.sv
	   #-svlog ..\ram_fifo.sv \
	   #-svlog fifo_bmweights.sv 
SV_FILE =  ..\..\new\pkg.sv  \
	   ..\..\new\BMWeightFifo.sv \
	   ..\ram_fifo.sv \
	   fifo_bmweights.sv \
	   bm_driver.sv \
	   bm_top.sv \
	   bm_tb.sv
TOP_NAME = bm_tb
SRC = bm_file.c
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

xsc : xsc0 xsc1 xsc2 beep

beep:
	python -c "import sys;print('\7\7\7', file=sys.stderr)"

vlib:
	$(VLIB) work

vlog:
	$(VLOG) -sv -dpiheader dpiheader.h  $(SV_FILE)

vsim: $(DPI_OBJ).dll
	$(VSIM)  -c -novopt -sv_lib $(DPI_OBJ)  $(TOP_NAME)   -do "run -all; quit -f"

.c.o:
	$(CC) -c -fpic  -I$(MODELSIM_HOME)/include $<

$(DPI_OBJ).dll :$(OBJ)
	$(CC) -shared  $(OBJ) -o $(DPI_OBJ).dll

xsc0:
	xelab -L UNISIMS_VER -dpiheader dpiheader.h  $(XSC_FILE)

xsc1:
	xsc $(SRC)

xsc4:
	xelab -L UNISIMS_VER -debug typical $(XSC_FILE) -sv_lib dpi

xsc5:
	xsim work.glbl#work.bm_tb -gui

xsc2:
	xelab -L UNISIMS_VER $(XSC_FILE) -sv_lib dpi -R

clean:
	rm -rf work  $(DPI_OBJ).dll $(OBJ) dpiheader.h  transcript *.wlf 

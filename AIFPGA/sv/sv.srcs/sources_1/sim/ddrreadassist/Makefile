#Source
SV_FILE =  ..\..\new\pkg.sv  ..\..\new\ddrreadassist.sv \
		   ..\ram_fifo.sv  fifo_DDRReadInfo.sv \
		   ddrreadassist_driver.sv ddrreadassist_top.sv ddrreadassist_tb.sv

TOP_NAME = ddrreadassist_tb
SRC = ddrreadassist_file.c
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
	$(VSIM)  -c -novopt -sv_lib $(DPI_OBJ) -L D:/modeltech64_10.2c/XilinxLib/Xilinx_Corelib $(TOP_NAME)  -do "run -all; quit -f"

.c.o:
	$(CC) -c -fpic  -I$(MODELSIM_HOME)/include $<

$(DPI_OBJ).dll :$(OBJ)
	$(CC) -shared  $(OBJ) -o $(DPI_OBJ).dll

clean:
	rm -rf work  $(DPI_OBJ).dll $(OBJ) dpiheader.h  transcript *.wlf 

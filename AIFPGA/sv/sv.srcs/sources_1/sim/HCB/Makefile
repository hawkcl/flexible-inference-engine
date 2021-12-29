#Source
SV_FILE =  ..\ram_fifo.sv \
	..\..\new\pkg.sv \
	..\SCG\dmem_32_16.sv \
	..\input\inputs_mem.sv \
	..\input\fifo_assemble_buffer.sv \
	..\bmWeights\fifo_bmweights.sv \
	..\weights\fifo_weights.sv \
	..\resData\fifo_resdata.sv \
	fifo_InstructionHCB.sv \
	fifo_InstructionHCBWt.sv \
	..\..\new\assembleInputBuffer.sv \
	..\..\new\readExtra.sv \
	..\..\new\readFeatures.sv \
	..\..\new\resFifo.sv \
	..\..\new\SCG.sv \
	..\..\new\sendBackUpInput.sv \
	..\..\new\setupShiftInputs.sv \
	..\..\new\startConvOut.sv \
	..\..\new\UCL.sv \
	..\..\new\UCU.sv \
	..\..\new\weightFifo.sv \
	..\..\new\assembleInput.sv \
	..\..\new\BMWeightFifo.sv \
	..\..\new\buildInputFifo.sv \
	..\..\new\HCBCtrl.sv \
	..\..\new\processConvOut.sv \
	..\..\new\processInstruction.sv \
	..\..\new\processNextFeatureLoading.sv \
	..\..\new\processNextWeightLoading.sv \
	..\..\new\pushHCBInst.sv \
	..\..\new\HCB.sv \
	HCB_driver.sv \
	HCB_top.sv \
	HCB_tb.sv

TOP_NAME = HCB_tb
SRC = HCB_file.c
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

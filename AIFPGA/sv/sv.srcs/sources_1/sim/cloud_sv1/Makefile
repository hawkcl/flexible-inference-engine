#Source
SV_FILE =  ..\ram_fifo.sv \
	..\..\new\pkg.sv \
	..\SCG\dmem_32_16.sv \
	..\input\inputs_mem.sv \
	..\input\fifo_assemble_buffer.sv \
	..\bmWeights\fifo_bmweights.sv \
	..\weights\fifo_weights.sv \
	..\resData\fifo_resdata.sv \
	..\HCB\fifo_InstructionHCB.sv \
	..\HCB\fifo_InstructionHCBWt.sv \
	..\interface\fifo_out_addrs_sizes.sv \
	..\GIB\fifo_InstructionEnd.sv \
	..\ctrlread\fifo_ctrlread_data.sv \
	..\ctrlread\fifo_ctrlread_info.sv \
	..\ctrlread\fifo_ctrlread_req.sv \
	..\ctrlread\fifo_ctrlread_ret.sv \
	..\ctrlread\fifo_InstructionRead.sv \
	..\ctrlweight\fifo_ctrlweight_data.sv \
	..\ctrlweight\fifo_InstructionWeight.sv \
	..\ctrlweight\ctrlweight_mem.sv \
	..\ctrlwrite\fifo_ctrlwrite_addr.sv \
	..\ctrlwrite\fifo_ctrlwrite_data.sv \
	..\ctrlwrite\fifo_InstructionWrite.sv \
	..\cloud\fifo_addressBuffer.sv	\
	..\cloud\fifo_DDR_Load_Info.sv	\
	..\ddrreadassist\fifo_DDRReadInfo.sv	\
	..\ddrwriteassist\fifo_DDRWriteInfo.sv	\
	..\..\new\readExtra.sv \
	..\..\new\readFeatures.sv \
	..\..\new\resFifo.sv \
	..\..\new\ddrwriteassist.sv \
	..\..\new\ddrreadassist.sv \
	..\..\new\SCG.sv \
	..\..\new\sendBackUpInput.sv \
	..\..\new\setupShiftInputs.sv \
	..\..\new\startConvOut.sv \
	..\..\new\UCL.sv \
	..\..\new\UCU.sv \
	..\..\new\weightFifo.sv \
	..\..\new\assembleInput.sv \
	..\..\new\assembleInputBuffer.sv \
	..\..\new\BMWeightFifo.sv \
	..\..\new\buildInputFifo.sv \
	..\..\new\HCBCtrl.sv \
	..\..\new\processConvOut.sv \
	..\..\new\processInstruction.sv \
	..\..\new\processNextFeatureLoading.sv \
	..\..\new\processNextWeightLoading.sv \
	..\..\new\pushHCBInst.sv \
	..\..\new\HCB.sv \
	..\..\new\Token.sv \
	..\..\new\GIB.sv \
	..\..\new\ctrlread.sv \
	..\..\new\ctrlwrite.sv \
	..\..\new\ctrlweight.sv \
	..\..\new\cloud.sv \
	..\interface\DDR.sv \
	..\interface\if_test.sv \
	cloud_driver.sv \
	cloud_top.sv \
	cloud_tb.sv

TOP_NAME = cloud_tb
#Tool
MODELSIM_HOME = D:\modeltech64_10.2c
VLIB = vlib
VLOG = vlog
VSIM = vsim


run : vlib vlog vsim beep

beep:
	python -c "import sys;print('\7\7\7', file=sys.stderr)"

vlib:
	$(VLIB) work

vlog:
	$(VLOG) -sv $(SV_FILE)

vsim: 
	$(VSIM)  -c -novopt  $(TOP_NAME)  -do "run -all; quit -f"

clean:
	rm -rf work  $(DPI_OBJ).dll $(OBJ) dpiheader.h  transcript *.wlf 

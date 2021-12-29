#Source
SV_FILE =  -svlog ..\ram_fifo.sv \
	-svlog ..\..\new\pkg.sv \
	-svlog ..\SCG\dmem_32_16.sv \
	-svlog ..\input\inputs_mem.sv \
	-svlog ..\input\fifo_assemble_buffer.sv \
	-svlog ..\bmWeights\fifo_bmweights.sv \
	-svlog ..\weights\fifo_weights.sv \
	-svlog ..\resData\fifo_resdata.sv \
	-svlog ..\HCB\fifo_InstructionHCB.sv \
	-svlog ..\HCB\fifo_InstructionHCBWt.sv \
	-svlog ..\interface\fifo_out_addrs_sizes.sv \
	-svlog ..\GIB\fifo_InstructionEnd.sv \
	-svlog ..\ctrlread\fifo_ctrlread_data.sv \
	-svlog ..\ctrlread\fifo_ctrlread_req.sv \
	-svlog ..\ctrlread\fifo_ctrlread_ret.sv \
	-svlog ..\ctrlread\fifo_InstructionRead.sv \
	-svlog ..\ctrlweight\fifo_ctrlweight_data.sv \
	-svlog ..\ctrlweight\fifo_InstructionWeight.sv \
	-svlog ..\ctrlweight\ctrlweight_mem.sv \
	-svlog ..\ctrlwrite\fifo_ctrlwrite_addr.sv \
	-svlog ..\ctrlwrite\fifo_ctrlwrite_data.sv \
	-svlog ..\ctrlwrite\fifo_InstructionWrite.sv \
	-svlog ..\cloud\fifo_addressBuffer.sv	\
	-svlog ..\..\new\readExtra.sv \
	-svlog ..\..\new\readFeatures.sv \
	-svlog ..\..\new\resFifo.sv \
	-svlog ..\..\new\SCG.sv \
	-svlog ..\..\new\sendBackUpInput.sv \
	-svlog ..\..\new\setupShiftInputs.sv \
	-svlog ..\..\new\startConvOut.sv \
	-svlog ..\..\new\UCL.sv \
	-svlog ..\..\new\UCU.sv \
	-svlog ..\..\new\weightFifo.sv \
	-svlog ..\..\new\assembleInput.sv \
	-svlog ..\..\new\BMWeightFifo.sv \
	-svlog ..\..\new\buildInputFifo.sv \
	-svlog ..\..\new\HCBCtrl.sv \
	-svlog ..\..\new\processConvOut.sv \
	-svlog ..\..\new\processInstruction.sv \
	-svlog ..\..\new\processNextFeatureLoading.sv \
	-svlog ..\..\new\processNextWeightLoading.sv \
	-svlog ..\..\new\pushHCBInst.sv \
	-svlog ..\..\new\HCB.sv \
	-svlog ..\..\new\Token.sv \
	-svlog ..\..\new\GIB.sv \
	-svlog ..\..\new\ctrlread.sv \
	-svlog ..\..\new\ctrlwrite.sv \
	-svlog ..\..\new\ctrlweight.sv \
	-svlog ..\interface\DDR.sv \
	-svlog ..\interface\if_test.sv \
	-svlog ..\cloud\cloud.sv \
	-svlog ..\cloud_sv\cloud_driver.sv \
	-svlog ..\cloud_sv\cloud_top.sv \
	-svlog ..\cloud_sv\cloud_tb.sv

TOP_NAME = cloud_tb
#Tool


run : xsc0 xsc2 beep

beep:
	python -c "import sys;print('\7\7\7', file=sys.stderr)"

xsc0:
	xelab -L UNISIMS_VER $(SV_FILE)

xsc4:
	xelab -L UNISIMS_VER -debug typical $(SV_FILE) 

xsc5:
	xsim work.glbl#work.cloud_tb -gui

xsc2:
	xelab -L UNISIMS_VER $(SV_FILE)  -R

clean:
	rm -rf work  $(DPI_OBJ).dll $(OBJ) dpiheader.h  transcript *.wlf 

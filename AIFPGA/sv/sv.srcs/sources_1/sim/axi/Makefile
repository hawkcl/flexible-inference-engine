#Source
SV_FILE =  ..\ram_fifo.sv \
	..\asic_vsrc\pkg.sv \
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
	..\asic_vsrc\readExtra.sv \
	..\asic_vsrc\readFeatures.sv \
	..\asic_vsrc\resFifo.sv \
	..\asic_vsrc\ddrwriteassist.sv \
	..\asic_vsrc\ddrwriteassist_axi.sv \
	..\asic_vsrc\ddrreadassist.sv \
	..\asic_vsrc\ddrreadassist_axi.sv \
	..\asic_vsrc\SCG.sv \
	..\asic_vsrc\sendBackUpInput.sv \
	..\asic_vsrc\setupShiftInputs.sv \
	..\asic_vsrc\startConvOut.sv \
	..\asic_vsrc\UCL.sv \
	..\asic_vsrc\UCU.sv \
	..\asic_vsrc\weightFifo.sv \
	..\asic_vsrc\assembleInput.sv \
	..\asic_vsrc\assembleInputBuffer.sv \
	..\asic_vsrc\BMWeightFifo.sv \
	..\asic_vsrc\buildInputFifo.sv \
	..\asic_vsrc\HCBCtrl.sv \
	..\asic_vsrc\processConvOut.sv \
	..\asic_vsrc\processInstruction.sv \
	..\asic_vsrc\processNextFeatureLoading.sv \
	..\asic_vsrc\processNextWeightLoading.sv \
	..\asic_vsrc\pushHCBInst.sv \
	..\asic_vsrc\HCB.sv \
	..\asic_vsrc\Token.sv \
	..\asic_vsrc\GIB.sv \
	..\asic_vsrc\ctrlread.sv \
	..\asic_vsrc\ctrlwrite.sv \
	..\asic_vsrc\ctrlweight.sv \
	..\asic_vsrc\rv_top.sv \
	..\asic_vsrc\rv_axi4.sv \
	axi_driver.sv \
	axi_top.sv \
	axi_tb.sv

TOP_NAME = axi_tb
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

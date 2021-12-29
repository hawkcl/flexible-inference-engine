#Source
#	 ..\..\ip\fifo_out_addrs_sizes\fifo_out_addrs_sizes_sim_netlist.v \

SV_FILE = ..\..\new\pkg.sv \
		  ..\ram_fifo.sv \
	..\interface\fifo_out_addrs_sizes.sv \
	 ..\..\ip\dmem_32_16\dmem_32_16_sim_netlist.v \
	 ..\..\ip\inputs_mem\inputs_mem_sim_netlist.v \
	 ..\..\ip\fifo_assemble_buffer\fifo_assemble_buffer_sim_netlist.v \
	 ..\..\ip\fifo_bmweights\fifo_bmweights_sim_netlist.v \
	 ..\..\ip\fifo_weights\fifo_weights_sim_netlist.v \
	 ..\..\ip\fifo_resdata\fifo_resdata_sim_netlist.v \
	 ..\..\ip\fifo_InstructionHCB\fifo_InstructionHCB_sim_netlist.v \
	 ..\..\ip\fifo_InstructionHCBWt\fifo_InstructionHCBWt_sim_netlist.v \
	 ..\..\ip\fifo_InstructionEnd\fifo_InstructionEnd_sim_netlist.v \
	 ..\ctrlread\fifo_ctrlread_data.sv \
	..\ctrlread\fifo_ctrlread_info.sv \
	..\ctrlread\fifo_ctrlread_req.sv \
	..\ctrlread\fifo_ctrlread_ret.sv \
	 ..\..\ip\fifo_InstructionRead\fifo_InstructionRead_sim_netlist.v \
	 ..\..\ip\fifo_ctrlweight_data\fifo_ctrlweight_data_sim_netlist.v \
	 ..\..\ip\fifo_InstructionWeight\fifo_InstructionWeight_sim_netlist.v \
	 ..\..\ip\fifo_ctrlwrite_addr\fifo_ctrlwrite_addr_sim_netlist.v \
	 ..\..\ip\fifo_ctrlwrite_data\fifo_ctrlwrite_data_sim_netlist.v \
	 ..\..\ip\fifo_InstructionWrite\fifo_InstructionWrite_sim_netlist.v \
	 ..\cloud\fifo_addressBuffer.sv	\
	 ..\..\ip\fifo_DDRReadInfo\fifo_DDRReadInfo_sim_netlist.v \
	 ..\..\ip\fifo_DDRWriteInfo\fifo_DDRWriteInfo_sim_netlist.v \
	 ..\..\ip\ctrlweight_mem\ctrlweight_mem_sim_netlist.v \
	 ..\cloud\fifo_DDR_Load_Info.sv	\
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
	..\cloud\cloud.sv	\
	 ..\interface\DDR.sv \
	 ..\interface\if_test.sv \
	 cloud_driver.sv \
	 cloud_top.sv \
	 cloud_tb.sv

TOP_NAME = cloud_tb
	 #..\..\ip\fifo_bmweights\fifo_bmweights_sim_netlist.v \
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
	$(VLOG) -sv  $(SV_FILE)

vsim: 
	$(VSIM)  -c -novopt -L unisims_ver $(TOP_NAME) work.glbl  -do "run -all; quit -f"


clean:
	rm -rf work  $(DPI_OBJ).dll $(OBJ) dpiheader.h  transcript *.wlf 

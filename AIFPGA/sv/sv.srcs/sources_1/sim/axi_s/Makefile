#Source
SRC_DIR = ../vsrc
IP_DIR = ../ips
SV_FILE =  $(SRC_DIR)/pkg.sv \
  /opt/Synopsys/dc2016/dw/sim_ver/DW_ram_r_w_s_dff.v \
	/opt/Synopsys/dc2016/dw/sim_ver/DW_fifo_s1_sf.v \
	/opt/Synopsys/dc2016/dw/sim_ver/DW_fifoctl_s1_sf.v \
	/opt/Foundary_Library/TSMC65/TSMCHOME/digital/Front_End/verilog/tcbn65lp_200a/tcbn65lp.v \
  /home/IC/work/AI/ips/db65/ts1n65lphsa8192x96m4s_210a/VERILOG/ts1n65lphsa8192x96m4s_210a_ss1p08v125c.v \
	/home/IC/work/AI/ips/db65/ts1n65lphsa512x96m4s_210a/VERILOG/ts1n65lphsa512x96m4s_210a_ss1p08v125c.v \
	/home/IC/work/AI/ips/db65/ts1n65lphsa1024x128m4s_210a/VERILOG/ts1n65lphsa1024x128m4s_210a_ss1p08v125c.v \
	$(IP_DIR)/dmem_32_16/dmem_32_16.sv \
	$(IP_DIR)/inputs_mem65/inputs_mem.sv \
	$(IP_DIR)/fifo_assemble_buffer/fifo_assemble_buffer.sv \
	$(IP_DIR)/fifo_weights/fifo_weights.sv \
	$(IP_DIR)/fifo_resdata/fifo_resdata.sv \
	$(IP_DIR)/fifo_InstructionHCB/fifo_InstructionHCB.sv \
	$(IP_DIR)/fifo_InstructionHCBWt/fifo_InstructionHCBWt.sv \
	$(IP_DIR)/fifo_InstructionEnd/fifo_InstructionEnd.sv \
	$(IP_DIR)/fifo_ctrlread_data/fifo_ctrlread_data.sv \
	$(IP_DIR)/fifo_ctrlread_info/fifo_ctrlread_info.sv \
	$(IP_DIR)/fifo_ctrlread_req/fifo_ctrlread_req.sv \
	$(IP_DIR)/fifo_ctrlread_ret/fifo_ctrlread_ret.sv \
	$(IP_DIR)/fifo_InstructionRead/fifo_InstructionRead.sv \
	$(IP_DIR)/fifo_ctrlweight_data/fifo_ctrlweight_data.sv \
	$(IP_DIR)/fifo_InstructionWeight/fifo_InstructionWeight.sv \
	$(IP_DIR)/ctrlweight_mem65/ctrlweight_mem.sv \
	$(IP_DIR)/fifo_ctrlwrite_addr/fifo_ctrlwrite_addr.sv \
	$(IP_DIR)/fifo_ctrlwrite_data/fifo_ctrlwrite_data.sv \
	$(IP_DIR)/fifo_InstructionWrite/fifo_InstructionWrite.sv \
	$(IP_DIR)/fifo_addressBuffer/fifo_addressBuffer.sv	\
	$(IP_DIR)/fifo_DDRReadInfo/fifo_DDRReadInfo.sv	\
	$(IP_DIR)/fifo_DDRWriteInfo/fifo_DDRWriteInfo.sv	\
	$(SRC_DIR)/readExtra.sv \
	$(SRC_DIR)/readFeatures.sv \
	$(SRC_DIR)/resFifo.sv \
	$(SRC_DIR)/ddrwriteassist.sv \
	$(SRC_DIR)/ddrwriteassist_axi.sv \
	$(SRC_DIR)/ddrreadassist.sv \
	$(SRC_DIR)/ddrreadassist_axi.sv \
	$(SRC_DIR)/SCG.sv \
	$(SRC_DIR)/sendBackUpInput.sv \
	$(SRC_DIR)/setupShiftInputs.sv \
	$(SRC_DIR)/startConvOut.sv \
	$(SRC_DIR)/UCL.sv \
	$(SRC_DIR)/UCU.sv \
	$(SRC_DIR)/weightFifo.sv \
	$(SRC_DIR)/assembleInput.sv \
	$(SRC_DIR)/assembleInputBuffer.sv \
	$(SRC_DIR)/BMWeightFifo.sv \
	$(SRC_DIR)/buildInputFifo.sv \
	$(SRC_DIR)/HCBCtrl.sv \
	$(SRC_DIR)/processConvOut.sv \
	$(SRC_DIR)/processInstruction.sv \
	$(SRC_DIR)/processNextFeatureLoading.sv \
	$(SRC_DIR)/processNextWeightLoading.sv \
	$(SRC_DIR)/pushHCBInst.sv \
	$(SRC_DIR)/HCB.sv \
	$(SRC_DIR)/Token.sv \
	$(SRC_DIR)/GIB.sv \
	$(SRC_DIR)/ctrlread.sv \
	$(SRC_DIR)/ctrlwrite.sv \
	$(SRC_DIR)/ctrlweight.sv \
	$(SRC_DIR)/rv_top.sv \
	$(SRC_DIR)/rv_axi4.sv \
	axi_driver.sv \
	axi_top.sv \
	axi_tb.sv

TOP_NAME = axi_tb
#Tool
run : simv run_simv beep

beep:
	python -c "from __future__ import print_function;import sys;print('/7/7/7', file=sys.stderr)"

simv: 
	vcs -sverilog -lca -debug_access+all +notimingcheck $(SV_FILE)
	#vcs +vcs+vcdpluson -debug_pp -sverilog -lca -debug_access+all +notimingcheck $(SV_FILE)

run_simv:
	./simv

clean:
	rm -rf simv.daidir  csrc   simv

vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/pkg.sv" \
"../../ram_fifo.sv" \
"../../bmWeights/fifo_bmweights.sv" \
"../../SCG/dmem_32_16.sv" \
"../../input/fifo_assemble_buffer.sv" \
"../../weights/fifo_weights.sv" \
"../../resData/fifo_resdata.sv" \
"../../HCB/fifo_InstructionHCB.sv" \
"../../input/inputs_mem.sv" \
"../../HCB/fifo_InstructionHCBWt.sv" \
"../../GIB/fifo_InstructionEnd.sv" \
"../../ctrlread/fifo_ctrlread_ret.sv" \
"../../ctrlread/fifo_InstructionRead.sv" \
"../../ctrlweight/fifo_ctrlweight_data.sv" \
"../../ctrlweight/fifo_InstructionWeight.sv" \
"../../ctrlwrite/fifo_ctrlwrite_addr.sv" \
"../../ctrlwrite/fifo_ctrlwrite_data.sv" \
"../../ctrlwrite/fifo_InstructionWrite.sv" \
"../../cloud/fifo_addressBuffer.sv" \
"../../ctrlread/fifo_ctrlread_data.sv" \
"../../ctrlread/fifo_ctrlread_info.sv" \
"../../../ip/addr_fifo/sim/addr_fifo.v" \
"../../../ip/icmp_rx_ram_8_256/sim/icmp_rx_ram_8_256.v" \
"../../../ip/ps_rec_data_fifo/sim/ps_rec_data_fifo.v" \
"../../../ip/rec_data_fifo/sim/rec_data_fifo.v" \
"../../../ip/send_data_fifo/sim/send_data_fifo.v" \
"../../../ip/udp_checksum_fifo/sim/udp_checksum_fifo.v" \
"../../../ip/udp_tx_data_fifo/sim/udp_tx_data_fifo.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_addr_decode.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_read.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg_bank.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_top.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_write.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_ar_channel.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_aw_channel.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_b_channel.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_arbiter.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_fsm.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_translator.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_fifo.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_incr_cmd.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_r_channel.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_simple_fifo.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wrap_cmd.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wr_cmd_fsm.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_w_channel.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axic_register_slice.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_register_slice.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_upsizer.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_a_upsizer.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_and.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_and.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_or.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_or.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_command_fifo.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel_static.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_r_upsizer.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_w_upsizer.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_clk_ibuf.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_infrastructure.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_iodelay_ctrl.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_tempmon.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_mux.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_row_col.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_select.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_cntrl.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_common.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_compare.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_mach.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_queue.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_state.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_col_mach.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_mc.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_cntrl.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_common.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_mach.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_round_robin_arb.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_buf.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_dec_fix.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_gen.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_merge_enc.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_fi_xor.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ip_top/mig_7series_v4_2_memc_ui_top_axi.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ip_top/mig_7series_v4_2_mem_intfc.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_group_io.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_lane.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_calib_top.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_if_post_fifo.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy_wrapper.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_of_pre_fifo.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_4lanes.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal_hr.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_init.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_cntlr.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_data.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_edge.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_lim.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_mux.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_samp.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_oclkdelay_cal.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_prbs_rdlvl.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_rdlvl.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_tempmon.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_top.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrcal.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl_off_delay.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_prbs_gen.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_skip_calib_tap.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_cc.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_edge_store.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_meta.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_pd.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_tap_base.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_top.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_cmd.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_rd_data.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_top.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_wr_data.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/DDR_Block_mig_7series_0_0_mig_sim.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_mig_7series_0_0_1/DDR_Block_mig_7series_0_0/user_design/rtl/DDR_Block_mig_7series_0_0.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_axi_clock_converter_0_0/sim/Block_test_axi_clock_converter_0_0.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_axi_clock_converter_1_0/sim/Block_test_axi_clock_converter_1_0.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/sim/bd_8d04.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_0/sim/bd_8d04_one_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_1/sim/bd_8d04_psr_aclk_0.vhd" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_2/sim/bd_8d04_arsw_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_3/sim/bd_8d04_rsw_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_4/sim/bd_8d04_awsw_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_5/sim/bd_8d04_wsw_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_6/sim/bd_8d04_bsw_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_7/sim/bd_8d04_s00mmu_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_8/sim/bd_8d04_s00tr_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_9/sim/bd_8d04_s00sic_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_10/sim/bd_8d04_s00a2s_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_11/sim/bd_8d04_sarn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_12/sim/bd_8d04_srn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_13/sim/bd_8d04_sawn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_14/sim/bd_8d04_swn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_15/sim/bd_8d04_sbn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_16/sim/bd_8d04_s01mmu_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_17/sim/bd_8d04_s01tr_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_18/sim/bd_8d04_s01sic_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_19/sim/bd_8d04_s01a2s_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_20/sim/bd_8d04_sarn_1.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_21/sim/bd_8d04_srn_1.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_22/sim/bd_8d04_sawn_1.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_23/sim/bd_8d04_swn_1.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_24/sim/bd_8d04_sbn_1.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_25/sim/bd_8d04_s02mmu_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_26/sim/bd_8d04_s02tr_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_27/sim/bd_8d04_s02sic_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_28/sim/bd_8d04_s02a2s_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_29/sim/bd_8d04_sarn_2.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_30/sim/bd_8d04_srn_2.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_31/sim/bd_8d04_sawn_2.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_32/sim/bd_8d04_swn_2.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_33/sim/bd_8d04_sbn_2.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_34/sim/bd_8d04_m00s2a_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_35/sim/bd_8d04_m00arn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_36/sim/bd_8d04_m00rn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_37/sim/bd_8d04_m00awn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_38/sim/bd_8d04_m00wn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_39/sim/bd_8d04_m00bn_0.sv" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_40/sim/bd_8d04_m00e_0.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_smartconnect_0_0/sim/Block_test_smartconnect_0_0.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_axi_clock_converter_0_1/sim/Block_test_axi_clock_converter_0_1.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_axi_dwidth_converter_0_0/sim/Block_test_axi_dwidth_converter_0_0.v" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/sendBackUpInput.sv" \
"../../../new/HCBCtrl.sv" \
"../../../new/processInstruction.sv" \
"../../../new/buildInputFifo.sv" \
"../../../new/processNextWeightLoading.sv" \
"../../../new/processConvOut.sv" \
"../../../new/assembleInput.sv" \
"../../../new/resFifo.sv" \
"../../../new/HCB.sv" \
"../../../new/processNextFeatureLoading.sv" \
"../../../new/pushHCBInst.sv" \
"../../../new/UCL.sv" \
"../../../new/startConvOut.sv" \
"../../../new/readFeatures.sv" \
"../../../new/UCU.sv" \
"../../../new/SCG.sv" \
"../../../new/setupShiftInputs.sv" \
"../../../new/BMWeightFifo.sv" \
"../../../new/weightFifo.sv" \
"../../../new/readExtra.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../ctrlread/fifo_ctrlread_req.sv" \
"../../ctrlweight/ctrlweight_mem.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_0/sim/bd_268b_one_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_1/sim/bd_268b_psr_aclk_0.vhd" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_2/sim/bd_268b_arsw_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_3/sim/bd_268b_rsw_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_4/sim/bd_268b_awsw_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_5/sim/bd_268b_wsw_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_6/sim/bd_268b_bsw_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_7/sim/bd_268b_s00mmu_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_8/sim/bd_268b_s00tr_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_9/sim/bd_268b_s00sic_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_10/sim/bd_268b_s00a2s_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_11/sim/bd_268b_sarn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_12/sim/bd_268b_srn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_13/sim/bd_268b_sawn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_14/sim/bd_268b_swn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_15/sim/bd_268b_sbn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_16/sim/bd_268b_s01mmu_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_17/sim/bd_268b_s01tr_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_18/sim/bd_268b_s01sic_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_19/sim/bd_268b_s01a2s_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_20/sim/bd_268b_sarn_1.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_21/sim/bd_268b_srn_1.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_22/sim/bd_268b_sawn_1.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_23/sim/bd_268b_swn_1.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_24/sim/bd_268b_sbn_1.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_25/sim/bd_268b_m00s2a_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_26/sim/bd_268b_m00arn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_27/sim/bd_268b_m00rn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_28/sim/bd_268b_m00awn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_29/sim/bd_268b_m00wn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_30/sim/bd_268b_m00bn_0.sv" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/ip/ip_31/sim/bd_268b_m00e_0.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/bd_0/sim/bd_268b.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_smartconnect_0_0/sim/DDR_Block_smartconnect_0_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_proc_sys_reset_0_0/sim/DDR_Block_proc_sys_reset_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_processing_system7_0_0/sim/DDR_Block_processing_system7_0_0.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_axi_protocol_convert_0_0/sim/DDR_Block_axi_protocol_convert_0_0.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_axi_clock_converter_0_0/sim/DDR_Block_axi_clock_converter_0_0.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/ip/DDR_Block_axi_clock_converter_1_0/sim/DDR_Block_axi_clock_converter_1_0.v" \
"../../../../../sv.ip_user_files/bd/DDR_Block/sim/DDR_Block.v" \
"../../../bd/DDR_Block/hdl/DDR_Block_wrapper.v" \
"../../ddrwriteassist/fifo_DDRWriteInfo.sv" \
"../../ddrreadassist/fifo_DDRReadInfo.sv" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/ddr_recif.sv" \
"../../../new/ctrlread.sv" \
"../../../new/ddr_sendif.sv" \
"../../../new/ps_ddr_recif.sv" \
"../../../new/ddrwriteassist.sv" \
"../../../new/GIB.sv" \
"../../../new/ddrreadassist_axi.sv" \
"../../../new/ddrreadassist.sv" \
"../../../new/top.sv" \
"../../../new/ddrtop.sv" \
"../../../new/ctrlwrite.sv" \
"../../../new/ctrlweight.sv" \
"../../../new/ddrwriteassist_axi.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/net/util_gmii_to_rgmii.v" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/net/ethernet_top.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/net/reset.v" \
"../../../new/net/gmii_arbi1.v" \
"../../../new/net/mac/arp_cache.v" \
"../../../new/net/mac/rx/mac_rx_top.v" \
"../../../new/net/mac/tx/mac_tx.v" \
"../../../new/net/mac/tx/arp_tx.v" \
"../../../new/net/mac/rx/ip_rx.v" \
"../../../new/net/mac/rx/mac_rx.v" \
"../../../new/net/mac/tx/mac_tx_top.v" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/net/mac/mac_test.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/net/mac/rx/udp_rx.v" \
"../../../new/net/mac/mac_top.v" \
"../../../new/net/mac/tx/mac_tx_mode.v" \
"../../../new/net/mac/tx/ip_tx.v" \
"../../../new/net/mac/rx/arp_rx.v" \
"../../../new/net/mac/tx/ip_tx_mode.v" \
"../../../new/net/mac/tx/udp_tx.v" \
"../../../new/net/mac/crc.v" \
"../../../new/net/mac/icmp_reply.v" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/Token.sv" \
"../../../new/assembleInputBuffer.sv" \

vcom -work xil_defaultlib -64 -93 \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_proc_sys_reset_0_0/sim/Block_test_proc_sys_reset_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_addr_decode.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_read.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg_bank.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_top.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_write.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_ar_channel.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_aw_channel.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_b_channel.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_arbiter.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_fsm.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_translator.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_fifo.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_incr_cmd.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_r_channel.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_simple_fifo.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wrap_cmd.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wr_cmd_fsm.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_w_channel.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axic_register_slice.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_register_slice.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_upsizer.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_a_upsizer.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_and.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_and.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_or.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_or.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_command_fifo.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel_static.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_r_upsizer.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_w_upsizer.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_clk_ibuf.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_infrastructure.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_iodelay_ctrl.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_tempmon.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_mux.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_row_col.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_select.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_cntrl.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_common.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_compare.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_mach.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_queue.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_state.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_col_mach.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_mc.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_cntrl.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_common.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_mach.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_round_robin_arb.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_buf.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_dec_fix.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_gen.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_merge_enc.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_fi_xor.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ip_top/mig_7series_v4_2_memc_ui_top_axi.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ip_top/mig_7series_v4_2_mem_intfc.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_group_io.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_lane.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_calib_top.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_if_post_fifo.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy_wrapper.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_of_pre_fifo.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_4lanes.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal_hr.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_init.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_cntlr.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_data.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_edge.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_lim.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_mux.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_samp.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_oclkdelay_cal.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_prbs_rdlvl.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_rdlvl.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_tempmon.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_top.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrcal.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl_off_delay.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_prbs_gen.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_skip_calib_tap.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_cc.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_edge_store.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_meta.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_pd.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_tap_base.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_top.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_cmd.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_rd_data.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_top.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_wr_data.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/Block_test_mig_7series_0_0_mig_sim.v" \
"../../../../../sv.ip_user_files/bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/Block_test_mig_7series_0_0.v" \
"../../../../../sv.ip_user_files/bd/Block_test/sim/Block_test.v" \
"../../../bd/Block_test/hdl/Block_test_wrapper.v" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/sim_tb_top.sv" \
"../../../new/cloud_driver.sv" \
"../../../new/cloud_top.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/wiredly.v" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../bd/DDR_Block/ipshared/979d/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/b2d0/hdl/verilog" "+incdir+../../../bd/DDR_Block/ipshared/ec67/hdl" "+incdir+../../../bd/DDR_Block/ipshared/70cf/hdl" "+incdir+../../../bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+../../../new" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../new/ddr3_model.sv" \
"../../../new/cloud_ports.sv" \

vlog -work xil_defaultlib \
"glbl.v"


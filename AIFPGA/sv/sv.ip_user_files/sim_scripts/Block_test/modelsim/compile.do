vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/Block_test/ip/Block_test_axi_clock_converter_0_0/sim/Block_test_axi_clock_converter_0_0.v" \
"../../../bd/Block_test/ip/Block_test_axi_clock_converter_1_0/sim/Block_test_axi_clock_converter_1_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/Block_test/ip/Block_test_proc_sys_reset_0_0/sim/Block_test_proc_sys_reset_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/sim/bd_8d04.v" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_0/sim/bd_8d04_one_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_1/sim/bd_8d04_psr_aclk_0.vhd" \

vlog -work xil_defaultlib -64 -incr -sv -L axi_vip_v1_1_4 -L processing_system7_vip_v1_0_6 -L smartconnect_v1_0 -L xilinx_vip "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_2/sim/bd_8d04_arsw_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_3/sim/bd_8d04_rsw_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_4/sim/bd_8d04_awsw_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_5/sim/bd_8d04_wsw_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_6/sim/bd_8d04_bsw_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_7/sim/bd_8d04_s00mmu_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_8/sim/bd_8d04_s00tr_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_9/sim/bd_8d04_s00sic_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_10/sim/bd_8d04_s00a2s_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_11/sim/bd_8d04_sarn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_12/sim/bd_8d04_srn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_13/sim/bd_8d04_sawn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_14/sim/bd_8d04_swn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_15/sim/bd_8d04_sbn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_16/sim/bd_8d04_s01mmu_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_17/sim/bd_8d04_s01tr_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_18/sim/bd_8d04_s01sic_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_19/sim/bd_8d04_s01a2s_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_20/sim/bd_8d04_sarn_1.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_21/sim/bd_8d04_srn_1.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_22/sim/bd_8d04_sawn_1.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_23/sim/bd_8d04_swn_1.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_24/sim/bd_8d04_sbn_1.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_25/sim/bd_8d04_s02mmu_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_26/sim/bd_8d04_s02tr_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_27/sim/bd_8d04_s02sic_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_28/sim/bd_8d04_s02a2s_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_29/sim/bd_8d04_sarn_2.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_30/sim/bd_8d04_srn_2.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_31/sim/bd_8d04_sawn_2.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_32/sim/bd_8d04_swn_2.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_33/sim/bd_8d04_sbn_2.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_34/sim/bd_8d04_m00s2a_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_35/sim/bd_8d04_m00arn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_36/sim/bd_8d04_m00rn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_37/sim/bd_8d04_m00awn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_38/sim/bd_8d04_m00wn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_39/sim/bd_8d04_m00bn_0.sv" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/bd_0/ip/ip_40/sim/bd_8d04_m00e_0.sv" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/ec67/hdl" "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/979d/hdl/verilog" "+incdir+../../../../sv.srcs/sources_1/bd/Block_test/ipshared/b2d0/hdl/verilog" "+incdir+D:/Xilinx/Vivado/2018.3/data/xilinx_vip/include" \
"../../../bd/Block_test/ip/Block_test_smartconnect_0_0/sim/Block_test_smartconnect_0_0.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_addr_decode.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_read.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_reg_bank.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_top.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_ctrl_write.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_ar_channel.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_aw_channel.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_b_channel.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_arbiter.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_fsm.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_cmd_translator.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_fifo.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_incr_cmd.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_r_channel.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_simple_fifo.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wrap_cmd.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_wr_cmd_fsm.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_axi_mc_w_channel.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axic_register_slice.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_register_slice.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_axi_upsizer.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_a_upsizer.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_and.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_and.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_latch_or.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_carry_or.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_command_fifo.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_comparator_sel_static.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_r_upsizer.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/axi/mig_7series_v4_2_ddr_w_upsizer.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_clk_ibuf.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_infrastructure.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_iodelay_ctrl.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/clocking/mig_7series_v4_2_tempmon.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_mux.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_row_col.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_arb_select.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_cntrl.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_common.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_compare.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_mach.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_queue.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_bank_state.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_col_mach.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_mc.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_cntrl.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_common.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_rank_mach.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/controller/mig_7series_v4_2_round_robin_arb.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_buf.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_dec_fix.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_gen.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_ecc_merge_enc.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ecc/mig_7series_v4_2_fi_xor.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ip_top/mig_7series_v4_2_memc_ui_top_axi.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ip_top/mig_7series_v4_2_mem_intfc.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_group_io.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_byte_lane.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_calib_top.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_if_post_fifo.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_mc_phy_wrapper.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_of_pre_fifo.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_4lanes.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ck_addr_cmd_delay.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_dqs_found_cal_hr.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_init.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_cntlr.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_data.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_edge.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_lim.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_mux.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_po_cntlr.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_ocd_samp.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_oclkdelay_cal.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_prbs_rdlvl.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_rdlvl.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_tempmon.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_top.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrcal.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_phy_wrlvl_off_delay.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_prbs_gen.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_ddr_skip_calib_tap.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_cc.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_edge_store.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_meta.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_pd.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_tap_base.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/phy/mig_7series_v4_2_poc_top.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_cmd.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_rd_data.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_top.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/ui/mig_7series_v4_2_ui_wr_data.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/Block_test_mig_7series_0_0_mig_sim.v" \
"../../../bd/Block_test/ip/Block_test_mig_7series_0_0/Block_test_mig_7series_0_0/user_design/rtl/Block_test_mig_7series_0_0.v" \
"../../../bd/Block_test/ip/Block_test_axi_clock_converter_0_1/sim/Block_test_axi_clock_converter_0_1.v" \
"../../../bd/Block_test/ip/Block_test_axi_dwidth_converter_0_0/sim/Block_test_axi_dwidth_converter_0_0.v" \
"../../../bd/Block_test/sim/Block_test.v" \

vlog -work xil_defaultlib \
"glbl.v"


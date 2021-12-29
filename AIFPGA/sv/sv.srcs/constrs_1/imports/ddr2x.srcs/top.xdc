set_false_path -from [get_pins sendif/send_addr_fifo/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gr1_int.rfwft/empty_fwft_i_reg/C] -to [get_pins {sendif/used_size_reg[19]/R}]
set_false_path -from [get_pins sendif/send_addr_fifo/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gr1_int.rfwft/empty_fwft_i_reg/C] -to [get_pins {sendif/used_size_reg[20]/R}]
set_false_path -from [get_pins sendif/send_addr_fifo/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gr1_int.rfwft/empty_fwft_i_reg/C] -to [get_pins {sendif/used_size_reg[12]/R}]
#############SPI Configurate Setting##################
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property CONFIG_MODE SPIx4 [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]

set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]


set_false_path -to [get_pins sendif/clk_data_fifo_empty_reg/D]
set_false_path -to [get_pins sendif/send_fifo_flash_reg/D]
############# clock define################################
create_clock -period 5.000 [get_ports sys_clk_p]
set_property PACKAGE_PIN F9 [get_ports sys_clk_p]
set_property PACKAGE_PIN E8 [get_ports sys_clk_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports sys_clk_p]
############## key define##################
set_property PACKAGE_PIN AH16 [get_ports sys_rst]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst]
############## fan define##################
set_property IOSTANDARD LVCMOS33 [get_ports fan_pwm]
set_property PACKAGE_PIN AG16 [get_ports fan_pwm]
##############LED define##################
set_property PACKAGE_PIN AJ16 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN AK16 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN AE16 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN AE15 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
#########################ethernet 1######################
create_clock -period 8.000 [get_ports rgmii_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rxd[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_txd[*]}]
set_property SLEW FAST [get_ports {rgmii_txd[*]}]

set_property IOSTANDARD LVCMOS18 [get_ports e_mdc]
set_property IOSTANDARD LVCMOS18 [get_ports e_mdio]
set_property IOSTANDARD LVCMOS18 [get_ports e_reset]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_rxctl]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_txc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_txctl]
set_property SLEW FAST [get_ports rgmii_txc]
set_property SLEW FAST [get_ports rgmii_txctl]

set_property PACKAGE_PIN F13 [get_ports {rgmii_rxd[3]}]
set_property PACKAGE_PIN E12 [get_ports {rgmii_rxd[2]}]
set_property PACKAGE_PIN F14 [get_ports {rgmii_rxd[1]}]
set_property PACKAGE_PIN F15 [get_ports {rgmii_rxd[0]}]
set_property PACKAGE_PIN L13 [get_ports {rgmii_txd[3]}]
set_property PACKAGE_PIN K13 [get_ports {rgmii_txd[2]}]
set_property PACKAGE_PIN G15 [get_ports {rgmii_txd[1]}]
set_property PACKAGE_PIN G14 [get_ports {rgmii_txd[0]}]
set_property PACKAGE_PIN B14 [get_ports e_mdc]
set_property PACKAGE_PIN A14 [get_ports e_mdio]
set_property PACKAGE_PIN B15 [get_ports e_reset]
set_property PACKAGE_PIN E13 [get_ports rgmii_rxc]
set_property PACKAGE_PIN D13 [get_ports rgmii_rxctl]
set_property PACKAGE_PIN K15 [get_ports rgmii_txc]
set_property PACKAGE_PIN J15 [get_ports rgmii_txctl]


set_false_path -from [get_pins sendif/send_addr_fifo/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gr1_int.rfwft/empty_fwft_i_reg/C] -to [get_pins {sendif/used_size_reg[12]/R}]
set_false_path -from [get_pins sendif/send_addr_fifo/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gr1_int.rfwft/empty_fwft_i_reg/C] -to [get_pins {sendif/used_size_reg[5]/R}]
set_false_path -from [get_pins sendif/send_addr_fifo/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gl0.rd/gr1.gr1_int.rfwft/empty_fwft_i_reg/C] -to [get_pins {sendif/used_size_reg[6]/R}]
set_false_path -from [get_pins {sendif/used_size_reg[18]/C}] -to [get_pins {sendif/used_size2_reg[18]/D}]
set_false_path -from [get_pins {sendif/used_size_reg[5]/C}] -to [get_pins {sendif/used_size2_reg[5]/D}]
set_false_path -from [get_pins {sendif/used_size_reg[8]/C}] -to [get_pins {sendif/used_size2_reg[8]/D}]
set_false_path -from [get_pins {sendif/used_size_reg[15]/C}] -to [get_pins {sendif/used_size2_reg[15]/D}]
set_false_path -from [get_pins {sendif/used_size_reg[15]/C}] -to [get_pins {sendif/used_size2_reg[15]/D}]
set_false_path -from [get_pins {sendif/used_size_reg[6]/C}] -to [get_pins {sendif/used_size2_reg[6]/D}]









set_operating_conditions -grade extended

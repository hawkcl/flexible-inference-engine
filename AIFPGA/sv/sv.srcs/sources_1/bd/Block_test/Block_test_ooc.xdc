################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name ACLK_PS -period 6.667 [get_ports ACLK_PS]
create_clock -name clock_clk_p -period 5 [get_ports clock_clk_p]

################################################################################
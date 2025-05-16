set_property PACKAGE_PIN Y18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -name PL_CLK -period 100.000 [get_ports clk]

set_property PACKAGE_PIN AA19 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]

#
set_property PACKAGE_PIN G2 [get_ports enable]
set_property IOSTANDARD LVCMOS33 [get_ports enable]

#
set_property PACKAGE_PIN T16 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
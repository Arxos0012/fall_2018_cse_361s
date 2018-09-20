create_clock -period 20.0 -name clk -waveform {0.000 10.0} [get_ports clk]
set_property PACKAGE_PIN E3 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

set_property PACKAGE_PIN C12 [get_ports {reset_l}]
set_property IOSTANDARD LVCMOS33 [get_ports {reset_l}]
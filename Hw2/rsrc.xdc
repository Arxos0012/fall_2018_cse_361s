create_clock -period 10.0 -name clk -waveform {0.000 5.0} [get_ports clk]
set_property PACKAGE_PIN E3 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

set_property PACKAGE_PIN C12 [get_ports {reset_l}]
set_property IOSTANDARD LVCMOS33 [get_ports {reset_l}]

#---------------------Red pins---------------------
set_property PACKAGE_PIN A3 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]

set_property PACKAGE_PIN B4 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]

set_property PACKAGE_PIN C5 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]

set_property PACKAGE_PIN A4 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]

#---------------------Green pins---------------------
set_property PACKAGE_PIN C6 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]

set_property PACKAGE_PIN A5 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]

set_property PACKAGE_PIN B6 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]

set_property PACKAGE_PIN A6 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]

#---------------------Blue pins---------------------
set_property PACKAGE_PIN B7 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]

set_property PACKAGE_PIN C7 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]

set_property PACKAGE_PIN D7 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]

set_property PACKAGE_PIN D8 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]

#---------------------HS pin---------------------
set_property PACKAGE_PIN B11 [get_ports {hs}]
set_property IOSTANDARD LVCMOS33 [get_ports {hs}]

#---------------------VS pin---------------------
set_property PACKAGE_PIN B12 [get_ports {vs}]
set_property IOSTANDARD LVCMOS33 [get_ports {vs}]



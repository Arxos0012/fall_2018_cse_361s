vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom -work xil_defaultlib -64 -93 \
"../../../../Hw2.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_sim_netlist.vhdl" \



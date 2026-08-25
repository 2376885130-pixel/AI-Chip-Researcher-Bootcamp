# Day27 timing preparation. Physical KV260 clock pin mapping belongs to the
# selected carrier/SOM design and must be confirmed in Vivado board files.
create_clock -name clk_100mhz -period 10.000 [get_ports clk_100mhz]
set_property IOSTANDARD LVCMOS18 [get_ports reset]
set_property IOSTANDARD LVCMOS18 [get_ports start]
set_property IOSTANDARD LVCMOS18 [get_ports busy]
set_property IOSTANDARD LVCMOS18 [get_ports done]

# Do not add guessed PACKAGE_PIN values. KV260 uses board-specific clock and
# PS/PL connectivity; those locations are supplied by the selected board
# interface or the final carrier-card design.

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## VGA output
set_property PACKAGE_PIN A3 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]

set_property PACKAGE_PIN B4 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

set_property PACKAGE_PIN C5 [get_ports red[0]]
set_property IOSTANDARD LVCMOS33 [get_ports red[0]]
# ... (repeat for red[1]–[3], green[0]–[3], blue[0]–[3])

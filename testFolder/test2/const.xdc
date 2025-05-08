## Clock signal
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports { clk }];

## VGA Connector
set_property -dict { PACKAGE_PIN A3 IOSTANDARD LVCMOS33 } [get_ports { red[0] }]; 
set_property -dict { PACKAGE_PIN B4 IOSTANDARD LVCMOS33 } [get_ports { red[1] }]; 
set_property -dict { PACKAGE_PIN C5 IOSTANDARD LVCMOS33 } [get_ports { red[2] }]; 
set_property -dict { PACKAGE_PIN A4 IOSTANDARD LVCMOS33 } [get_ports { red[3] }]; 

set_property -dict { PACKAGE_PIN C6 IOSTANDARD LVCMOS33 } [get_ports { green[0] }]; 
set_property -dict { PACKAGE_PIN A5 IOSTANDARD LVCMOS33 } [get_ports { green[1] }]; 
set_property -dict { PACKAGE_PIN B6 IOSTANDARD LVCMOS33 } [get_ports { green[2] }]; 
set_property -dict { PACKAGE_PIN A6 IOSTANDARD LVCMOS33 } [get_ports { green[3] }]; 

set_property -dict { PACKAGE_PIN B7 IOSTANDARD LVCMOS33 } [get_ports { blue[0] }]; 
set_property -dict { PACKAGE_PIN C7 IOSTANDARD LVCMOS33 } [get_ports { blue[1] }]; 
set_property -dict { PACKAGE_PIN D7 IOSTANDARD LVCMOS33 } [get_ports { blue[2] }]; 
set_property -dict { PACKAGE_PIN D8 IOSTANDARD LVCMOS33 } [get_ports { blue[3] }]; 

set_property -dict { PACKAGE_PIN B11 IOSTANDARD LVCMOS33 } [get_ports { hsync }]; 
set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports { vsync }]; 

## Buttons
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { btnu }]; 
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { btnc }]; 
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { btnd }]; 

## Audio Out
set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports { audio_out_pwm }]; 
set_property -dict { PACKAGE_PIN D12 IOSTANDARD LVCMOS33 } [get_ports { aud_sd }]; 

## Use reset button for reset signal
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports { reset }];

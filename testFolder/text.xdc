##check if these are correct
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports { audio_out_pwm }]
set_property -dict { PACKAGE_PIN D12 IOSTANDARD LVCMOS33 } [get_ports { aud_sd }]

set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { reset }]

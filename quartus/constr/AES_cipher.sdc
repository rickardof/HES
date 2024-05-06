# ---- Without virtual PIN: 92.65  MHz
 create_clock -name clk -period 10.8 [get_ports clk]
 set_false_path -from [get_ports rst_n] -to [get_clocks clk]
 set_input_delay  -min 1.08 [all_inputs]  -clock [get_clocks clk]
 set_input_delay  -max 2.16 [all_inputs]  -clock [get_clocks clk]
 set_output_delay -min 1.08 [all_outputs] -clock [get_clocks clk]
 set_output_delay -max 2.16 [all_outputs] -clock [get_clocks clk]

# ---- With virtual PIN: 142 MHz
# create_clock -name clk -period 7 [get_ports clk]
# set_false_path -from [get_ports rst_n] -to [get_clocks clk]
# set_input_delay  -min 0.7 [all_inputs]  -clock [get_clocks clk]
# set_input_delay  -max 1.4 [all_inputs]  -clock [get_clocks clk]
# set_output_delay -min 0.7 [all_outputs] -clock [get_clocks clk]
# set_output_delay -max 1.4 [all_outputs] -clock [get_clocks clk]
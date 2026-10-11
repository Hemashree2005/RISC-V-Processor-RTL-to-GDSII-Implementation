
# Clock definition: 100 MHz
create_clock -name clk -period 10.0 [get_ports clk]
set_clock_uncertainty 0.2 [get_clocks clk]
set_clock_transition 0.1 [get_clocks clk]
set_input_delay 1.0 -clock clk [get_ports reset]
set_output_delay 1.0 -clock clk [all_outputs]
set_input_transition 0.1 [get_ports reset]

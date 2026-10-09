# ==========================================
# RISC-V Processor Timing Constraints
# File: riscv.sdc
# ==========================================

# Clock definition: 100 MHz
create_clock -name clk -period 10.0 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.2 [get_clocks clk]

# Clock transition
set_clock_transition 0.1 [get_clocks clk]

# Reset input delay
set_input_delay 1.0 -clock clk [get_ports reset]

# Reset input transition
set_input_transition 0.1 [get_ports reset]

# Input and output delays should be added
# according to the actual top-level interface.

# ==========================================

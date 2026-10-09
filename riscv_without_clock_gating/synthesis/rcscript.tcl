# ==========================================
# RISC-V Processor - Genus Synthesis
# Without Clock Gating
# ==========================================

set_db / .init_lib_search_path {/home/install/FOUNDRY/digital/180nm/dig/lib}
set_db / .library {slow.lib}

set DESIGN riscv_core

# Read RTL files
read_hdl alu.v
read_hdl control_unit.v
read_hdl data_memory.v
read_hdl instruction_memory.v
read_hdl program_counter.v
read_hdl register_file.v
read_hdl riscv_core.v

# Elaborate design
elaborate $DESIGN
set_top $DESIGN

check_design -unresolved

# Read timing constraints
read_sdc riscv.sdc

# Synthesis effort
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

# Synthesis stages
syn_generic
syn_map
syn_opt

# Write synthesized netlist and constraints
write_hdl > riscv_netlist.v
write_sdc > riscv_synth.sdc

# Reports
report timing > riscv_timing.rpt
report power > riscv_power.rpt
report area > riscv_area.rpt
report messages > riscv_message.rpt

gui_show

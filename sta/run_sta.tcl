read_liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog synth/alu_32bit_netlist.v

link_design alu_32bit

read_sdc constarints/alu.sdc

report_checks

report_tns

report_wns
//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.01 (64-bit) 
//Created Time: 2025-11-22 17:34:32
create_clock -name sys_clk -period 20 -waveform {0 10} [get_ports {sys_clk}]
create_generated_clock -name clkout_10m -source [get_ports {sys_clk}] -master_clock sys_clk -divide_by 5 [get_nets {clkout_10m}]
create_generated_clock -name clk_10k -source [get_nets {clkout_10m}] -master_clock clkout_10m -divide_by 1000 [get_nets {clk_10k}]

//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.01 (64-bit) 
//Created Time: 2025-08-11 20:25:33
create_clock -name sys_clk -period 20 -waveform {0 10} [all_inputs]
create_generated_clock -name clk3 -source [get_ports {sys_clk}] -master_clock sys_clk -divide_by 2 -multiply_by 1 [get_nets {clk3}]
create_generated_clock -name sclk -source [get_nets {clk3}] -master_clock clk3 -divide_by 189 [get_nets {sclk}]
create_generated_clock -name joystick_clk -source [get_nets {sclk}] -master_clock sclk -divide_by 1 -multiply_by 1 [get_ports {joystick_clk}]
create_generated_clock -name joystick_clk2 -source [get_nets {sclk}] -master_clock sclk -divide_by 1 -multiply_by 1 [get_ports {joystick_clk2}]

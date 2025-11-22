//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.01 (64-bit) 
//Created Time: 2025-11-22 23:31:07
create_clock -name sys_clk -period 20 -waveform {0 10} [get_ports {sys_clk}]

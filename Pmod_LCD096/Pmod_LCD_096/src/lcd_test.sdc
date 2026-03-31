//Copyright (C)2014-2026 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.01 (64-bit) 
//Created Time: 2026-04-01 00:07:27
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
create_generated_clock -name spi_clk -source [get_ports {clk}] -master_clock clk -divide_by 128 -multiply_by 16 [get_nets {lcd_clk}]

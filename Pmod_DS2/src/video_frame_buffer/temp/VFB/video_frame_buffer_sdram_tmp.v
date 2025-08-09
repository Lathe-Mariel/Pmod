//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.01 (64-bit)
//Part Number: GW5A-LV25MG121NES
//Device: GW5A-25
//Device Version: A
//Created Time: Sat Aug  9 21:03:30 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	Video_Frame_Buffer_SDRAM your_instance_name(
		.I_rst_n(I_rst_n), //input I_rst_n
		.I_dma_clk(I_dma_clk), //input I_dma_clk
		.I_wr_halt(I_wr_halt), //input [0:0] I_wr_halt
		.I_rd_halt(I_rd_halt), //input [0:0] I_rd_halt
		.I_vin0_clk(I_vin0_clk), //input I_vin0_clk
		.I_vin0_vs_n(I_vin0_vs_n), //input I_vin0_vs_n
		.I_vin0_de(I_vin0_de), //input I_vin0_de
		.I_vin0_data(I_vin0_data), //input [15:0] I_vin0_data
		.O_vin0_fifo_full(O_vin0_fifo_full), //output O_vin0_fifo_full
		.I_vout0_clk(I_vout0_clk), //input I_vout0_clk
		.I_vout0_vs_n(I_vout0_vs_n), //input I_vout0_vs_n
		.I_vout0_de(I_vout0_de), //input I_vout0_de
		.O_vout0_den(O_vout0_den), //output O_vout0_den
		.O_vout0_data(O_vout0_data), //output [15:0] O_vout0_data
		.O_vout0_fifo_empty(O_vout0_fifo_empty), //output O_vout0_fifo_empty
		.I_sdrc_busy_n(I_sdrc_busy_n), //input I_sdrc_busy_n
		.O_sdrc_wr_n(O_sdrc_wr_n), //output O_sdrc_wr_n
		.O_sdrc_rd_n(O_sdrc_rd_n), //output O_sdrc_rd_n
		.O_sdrc_addr(O_sdrc_addr), //output [21:0] O_sdrc_addr
		.O_sdrc_data_len(O_sdrc_data_len), //output [7:0] O_sdrc_data_len
		.O_sdrc_data(O_sdrc_data), //output [15:0] O_sdrc_data
		.O_sdrc_dqm(O_sdrc_dqm), //output [1:0] O_sdrc_dqm
		.I_sdrc_rd_valid(I_sdrc_rd_valid), //input I_sdrc_rd_valid
		.I_sdrc_data_out(I_sdrc_data_out), //input [15:0] I_sdrc_data_out
		.I_sdrc_init_done(I_sdrc_init_done) //input I_sdrc_init_done
	);

//--------Copy end-------------------

//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.01 (64-bit)
//Part Number: GW5A-LV25MG121NES
//Device: GW5A-25
//Device Version: A
//Created Time: Sat Aug  9 20:52:32 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	SDRAM_controller_top_SIP your_instance_name(
		.O_sdram_clk(O_sdram_clk), //output O_sdram_clk
		.O_sdram_cke(O_sdram_cke), //output O_sdram_cke
		.O_sdram_cs_n(O_sdram_cs_n), //output O_sdram_cs_n
		.O_sdram_cas_n(O_sdram_cas_n), //output O_sdram_cas_n
		.O_sdram_ras_n(O_sdram_ras_n), //output O_sdram_ras_n
		.O_sdram_wen_n(O_sdram_wen_n), //output O_sdram_wen_n
		.O_sdram_dqm(O_sdram_dqm), //output [1:0] O_sdram_dqm
		.O_sdram_addr(O_sdram_addr), //output [12:0] O_sdram_addr
		.O_sdram_ba(O_sdram_ba), //output [0:0] O_sdram_ba
		.IO_sdram_dq(IO_sdram_dq), //inout [15:0] IO_sdram_dq
		.I_sdrc_rst_n(I_sdrc_rst_n), //input I_sdrc_rst_n
		.I_sdrc_clk(I_sdrc_clk), //input I_sdrc_clk
		.I_sdram_clk(I_sdram_clk), //input I_sdram_clk
		.I_sdrc_selfrefresh(I_sdrc_selfrefresh), //input I_sdrc_selfrefresh
		.I_sdrc_power_down(I_sdrc_power_down), //input I_sdrc_power_down
		.I_sdrc_wr_n(I_sdrc_wr_n), //input I_sdrc_wr_n
		.I_sdrc_rd_n(I_sdrc_rd_n), //input I_sdrc_rd_n
		.I_sdrc_addr(I_sdrc_addr), //input [21:0] I_sdrc_addr
		.I_sdrc_data_len(I_sdrc_data_len), //input [7:0] I_sdrc_data_len
		.I_sdrc_dqm(I_sdrc_dqm), //input [1:0] I_sdrc_dqm
		.I_sdrc_data(I_sdrc_data), //input [15:0] I_sdrc_data
		.O_sdrc_data(O_sdrc_data), //output [15:0] O_sdrc_data
		.O_sdrc_init_done(O_sdrc_init_done), //output O_sdrc_init_done
		.O_sdrc_busy_n(O_sdrc_busy_n), //output O_sdrc_busy_n
		.O_sdrc_rd_valid(O_sdrc_rd_valid), //output O_sdrc_rd_valid
		.O_sdrc_wrd_ack(O_sdrc_wrd_ack) //output O_sdrc_wrd_ack
	);

//--------Copy end-------------------

//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Part Number: GW5A-LV25MG121NES
//Device: GW5A-25
//Device Version: A


//Change the instance name and port connections to the signal names
//--------Copy here to design--------
    Gowin_PLL your_instance_name(
        .clkin(clkin), //input  clkin
        .clkout0(clkout0), //output  clkout0
        .clkout1(clkout1), //output  clkout1
        .clkout2(clkout2), //output  clkout2
        .clkout3(clkout3), //output  clkout3
        .lock(lock), //output  lock
        .mdclk(mdclk) //input  mdclk
);


//--------Copy end-------------------

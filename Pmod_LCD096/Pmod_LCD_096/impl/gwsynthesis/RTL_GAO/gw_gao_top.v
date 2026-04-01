module gw_gao(
    rst_n,
    lcd_cs,
    lcd_mosi,
    lcd_dc,
    lcd_clk,
    lcd_rst,
    spi_clk,
    \u_ctrl/tx_start ,
    \u_ctrl/tx_start_r ,
    \u_ctrl/tx_data[15] ,
    \u_ctrl/tx_data[14] ,
    \u_ctrl/tx_data[13] ,
    \u_ctrl/tx_data[12] ,
    \u_ctrl/tx_data[11] ,
    \u_ctrl/tx_data[10] ,
    \u_ctrl/tx_data[9] ,
    \u_ctrl/tx_data[8] ,
    \u_ctrl/tx_data[7] ,
    \u_ctrl/tx_data[6] ,
    \u_ctrl/tx_data[5] ,
    \u_ctrl/tx_data[4] ,
    \u_ctrl/tx_data[3] ,
    \u_ctrl/tx_data[2] ,
    \u_ctrl/tx_data[1] ,
    \u_ctrl/tx_data[0] ,
    clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input rst_n;
input lcd_cs;
input lcd_mosi;
input lcd_dc;
input lcd_clk;
input lcd_rst;
input spi_clk;
input \u_ctrl/tx_start ;
input \u_ctrl/tx_start_r ;
input \u_ctrl/tx_data[15] ;
input \u_ctrl/tx_data[14] ;
input \u_ctrl/tx_data[13] ;
input \u_ctrl/tx_data[12] ;
input \u_ctrl/tx_data[11] ;
input \u_ctrl/tx_data[10] ;
input \u_ctrl/tx_data[9] ;
input \u_ctrl/tx_data[8] ;
input \u_ctrl/tx_data[7] ;
input \u_ctrl/tx_data[6] ;
input \u_ctrl/tx_data[5] ;
input \u_ctrl/tx_data[4] ;
input \u_ctrl/tx_data[3] ;
input \u_ctrl/tx_data[2] ;
input \u_ctrl/tx_data[1] ;
input \u_ctrl/tx_data[0] ;
input clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire rst_n;
wire lcd_cs;
wire lcd_mosi;
wire lcd_dc;
wire lcd_clk;
wire lcd_rst;
wire spi_clk;
wire \u_ctrl/tx_start ;
wire \u_ctrl/tx_start_r ;
wire \u_ctrl/tx_data[15] ;
wire \u_ctrl/tx_data[14] ;
wire \u_ctrl/tx_data[13] ;
wire \u_ctrl/tx_data[12] ;
wire \u_ctrl/tx_data[11] ;
wire \u_ctrl/tx_data[10] ;
wire \u_ctrl/tx_data[9] ;
wire \u_ctrl/tx_data[8] ;
wire \u_ctrl/tx_data[7] ;
wire \u_ctrl/tx_data[6] ;
wire \u_ctrl/tx_data[5] ;
wire \u_ctrl/tx_data[4] ;
wire \u_ctrl/tx_data[3] ;
wire \u_ctrl/tx_data[2] ;
wire \u_ctrl/tx_data[1] ;
wire \u_ctrl/tx_data[0] ;
wire clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i(rst_n),
    .data_i({rst_n,lcd_cs,lcd_mosi,lcd_dc,lcd_clk,lcd_rst,spi_clk,\u_ctrl/tx_start ,\u_ctrl/tx_start_r ,\u_ctrl/tx_data[15] ,\u_ctrl/tx_data[14] ,\u_ctrl/tx_data[13] ,\u_ctrl/tx_data[12] ,\u_ctrl/tx_data[11] ,\u_ctrl/tx_data[10] ,\u_ctrl/tx_data[9] ,\u_ctrl/tx_data[8] ,\u_ctrl/tx_data[7] ,\u_ctrl/tx_data[6] ,\u_ctrl/tx_data[5] ,\u_ctrl/tx_data[4] ,\u_ctrl/tx_data[3] ,\u_ctrl/tx_data[2] ,\u_ctrl/tx_data[1] ,\u_ctrl/tx_data[0] }),
    .clk_i(clk)
);

endmodule

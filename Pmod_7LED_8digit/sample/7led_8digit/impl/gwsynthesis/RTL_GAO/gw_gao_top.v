module gw_gao(
    sclk,
    serial_data,
    \line_counter[4] ,
    \line_counter[3] ,
    \line_counter[2] ,
    \line_counter[1] ,
    \line_counter[0] ,
    rclk,
    \s_counter[4] ,
    \s_counter[3] ,
    \s_counter[2] ,
    \s_counter[1] ,
    \s_counter[0] ,
    \line_data[15] ,
    \line_data[14] ,
    \line_data[13] ,
    \line_data[12] ,
    \line_data[11] ,
    \line_data[10] ,
    \line_data[9] ,
    \line_data[8] ,
    \line_data[7] ,
    \line_data[6] ,
    \line_data[5] ,
    \line_data[4] ,
    \line_data[3] ,
    \line_data[2] ,
    \line_data[1] ,
    \line_data[0] ,
    \ti/counter[7] ,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input sclk;
input serial_data;
input \line_counter[4] ;
input \line_counter[3] ;
input \line_counter[2] ;
input \line_counter[1] ;
input \line_counter[0] ;
input rclk;
input \s_counter[4] ;
input \s_counter[3] ;
input \s_counter[2] ;
input \s_counter[1] ;
input \s_counter[0] ;
input \line_data[15] ;
input \line_data[14] ;
input \line_data[13] ;
input \line_data[12] ;
input \line_data[11] ;
input \line_data[10] ;
input \line_data[9] ;
input \line_data[8] ;
input \line_data[7] ;
input \line_data[6] ;
input \line_data[5] ;
input \line_data[4] ;
input \line_data[3] ;
input \line_data[2] ;
input \line_data[1] ;
input \line_data[0] ;
input \ti/counter[7] ;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire sclk;
wire serial_data;
wire \line_counter[4] ;
wire \line_counter[3] ;
wire \line_counter[2] ;
wire \line_counter[1] ;
wire \line_counter[0] ;
wire rclk;
wire \s_counter[4] ;
wire \s_counter[3] ;
wire \s_counter[2] ;
wire \s_counter[1] ;
wire \s_counter[0] ;
wire \line_data[15] ;
wire \line_data[14] ;
wire \line_data[13] ;
wire \line_data[12] ;
wire \line_data[11] ;
wire \line_data[10] ;
wire \line_data[9] ;
wire \line_data[8] ;
wire \line_data[7] ;
wire \line_data[6] ;
wire \line_data[5] ;
wire \line_data[4] ;
wire \line_data[3] ;
wire \line_data[2] ;
wire \line_data[1] ;
wire \line_data[0] ;
wire \ti/counter[7] ;
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

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({sclk,serial_data,\line_counter[4] ,\line_counter[3] ,\line_counter[2] ,\line_counter[1] ,\line_counter[0] ,rclk,\s_counter[4] ,\s_counter[3] ,\s_counter[2] ,\s_counter[1] ,\s_counter[0] ,\line_data[15] ,\line_data[14] ,\line_data[13] ,\line_data[12] ,\line_data[11] ,\line_data[10] ,\line_data[9] ,\line_data[8] ,\line_data[7] ,\line_data[6] ,\line_data[5] ,\line_data[4] ,\line_data[3] ,\line_data[2] ,\line_data[1] ,\line_data[0] }),
    .clk_i(\ti/counter[7] )
);

endmodule

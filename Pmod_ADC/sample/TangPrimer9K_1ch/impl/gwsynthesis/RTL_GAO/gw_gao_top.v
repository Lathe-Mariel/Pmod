module gw_gao(
    \fft_inst/xk_im[7] ,
    \fft_inst/xk_im[6] ,
    \fft_inst/xk_im[5] ,
    \fft_inst/xk_im[4] ,
    \fft_inst/xk_im[3] ,
    \fft_inst/xk_im[2] ,
    \sum[12] ,
    \sum[11] ,
    \sum[10] ,
    \sum[9] ,
    \sum[8] ,
    \sum[7] ,
    \sum[6] ,
    \sum[5] ,
    \sum[4] ,
    \sum[3] ,
    \sum[2] ,
    \sum[1] ,
    \sum[0] ,
    \xk_re_o[7] ,
    \xk_re_o[6] ,
    \xk_re_o[5] ,
    \xk_re_o[4] ,
    \xk_re_o[3] ,
    \xk_re_o[2] ,
    \xk_re_o[1] ,
    \xk_re_o[0] ,
    \fft_inst/start ,
    \inst_1/counter[6] ,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \fft_inst/xk_im[7] ;
input \fft_inst/xk_im[6] ;
input \fft_inst/xk_im[5] ;
input \fft_inst/xk_im[4] ;
input \fft_inst/xk_im[3] ;
input \fft_inst/xk_im[2] ;
input \sum[12] ;
input \sum[11] ;
input \sum[10] ;
input \sum[9] ;
input \sum[8] ;
input \sum[7] ;
input \sum[6] ;
input \sum[5] ;
input \sum[4] ;
input \sum[3] ;
input \sum[2] ;
input \sum[1] ;
input \sum[0] ;
input \xk_re_o[7] ;
input \xk_re_o[6] ;
input \xk_re_o[5] ;
input \xk_re_o[4] ;
input \xk_re_o[3] ;
input \xk_re_o[2] ;
input \xk_re_o[1] ;
input \xk_re_o[0] ;
input \fft_inst/start ;
input \inst_1/counter[6] ;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \fft_inst/xk_im[7] ;
wire \fft_inst/xk_im[6] ;
wire \fft_inst/xk_im[5] ;
wire \fft_inst/xk_im[4] ;
wire \fft_inst/xk_im[3] ;
wire \fft_inst/xk_im[2] ;
wire \sum[12] ;
wire \sum[11] ;
wire \sum[10] ;
wire \sum[9] ;
wire \sum[8] ;
wire \sum[7] ;
wire \sum[6] ;
wire \sum[5] ;
wire \sum[4] ;
wire \sum[3] ;
wire \sum[2] ;
wire \sum[1] ;
wire \sum[0] ;
wire \xk_re_o[7] ;
wire \xk_re_o[6] ;
wire \xk_re_o[5] ;
wire \xk_re_o[4] ;
wire \xk_re_o[3] ;
wire \xk_re_o[2] ;
wire \xk_re_o[1] ;
wire \xk_re_o[0] ;
wire \fft_inst/start ;
wire \inst_1/counter[6] ;
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
    .trig0_i(\fft_inst/start ),
    .data_i({\fft_inst/xk_im[7] ,\fft_inst/xk_im[6] ,\fft_inst/xk_im[5] ,\fft_inst/xk_im[4] ,\fft_inst/xk_im[3] ,\fft_inst/xk_im[2] ,\sum[12] ,\sum[11] ,\sum[10] ,\sum[9] ,\sum[8] ,\sum[7] ,\sum[6] ,\sum[5] ,\sum[4] ,\sum[3] ,\sum[2] ,\sum[1] ,\sum[0] ,\xk_re_o[7] ,\xk_re_o[6] ,\xk_re_o[5] ,\xk_re_o[4] ,\xk_re_o[3] ,\xk_re_o[2] ,\xk_re_o[1] ,\xk_re_o[0] }),
    .clk_i(\inst_1/counter[6] )
);

endmodule

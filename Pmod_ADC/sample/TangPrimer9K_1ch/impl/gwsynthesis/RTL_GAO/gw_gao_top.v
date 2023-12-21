module gw_gao(
    \decode7seg.in[3] ,
    \decode7seg.in[2] ,
    \decode7seg.in[1] ,
    \decode7seg.in[0] ,
    P1_COM_SER,
    P2_COM_RCLK,
    \processCounter[5] ,
    \processCounter[4] ,
    \processCounter[3] ,
    \processCounter[2] ,
    \processCounter[1] ,
    \processCounter[0] ,
    P3_SEG_SER,
    P9_SEG_SRCLK,
    P4_SEG_RCLK,
    controlCLK,
    \inst_1/counter[5] ,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \decode7seg.in[3] ;
input \decode7seg.in[2] ;
input \decode7seg.in[1] ;
input \decode7seg.in[0] ;
input P1_COM_SER;
input P2_COM_RCLK;
input \processCounter[5] ;
input \processCounter[4] ;
input \processCounter[3] ;
input \processCounter[2] ;
input \processCounter[1] ;
input \processCounter[0] ;
input P3_SEG_SER;
input P9_SEG_SRCLK;
input P4_SEG_RCLK;
input controlCLK;
input \inst_1/counter[5] ;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \decode7seg.in[3] ;
wire \decode7seg.in[2] ;
wire \decode7seg.in[1] ;
wire \decode7seg.in[0] ;
wire P1_COM_SER;
wire P2_COM_RCLK;
wire \processCounter[5] ;
wire \processCounter[4] ;
wire \processCounter[3] ;
wire \processCounter[2] ;
wire \processCounter[1] ;
wire \processCounter[0] ;
wire P3_SEG_SER;
wire P9_SEG_SRCLK;
wire P4_SEG_RCLK;
wire controlCLK;
wire \inst_1/counter[5] ;
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
    .data_i({\decode7seg.in[3] ,\decode7seg.in[2] ,\decode7seg.in[1] ,\decode7seg.in[0] ,P1_COM_SER,P2_COM_RCLK,\processCounter[5] ,\processCounter[4] ,\processCounter[3] ,\processCounter[2] ,\processCounter[1] ,\processCounter[0] ,P3_SEG_SER,P9_SEG_SRCLK,P4_SEG_RCLK,controlCLK}),
    .clk_i(\inst_1/counter[5] )
);

endmodule

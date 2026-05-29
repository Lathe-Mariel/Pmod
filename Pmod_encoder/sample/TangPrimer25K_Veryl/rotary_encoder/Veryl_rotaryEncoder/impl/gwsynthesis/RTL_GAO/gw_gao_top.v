module gw_gao(
    i_enc_a,
    i_enc_b,
    \enc_state[1] ,
    \enc_state[0] ,
    \enc_state_prev[1] ,
    \enc_state_prev[0] ,
    enc_a_sync,
    enc_b_sync,
    enc_a_debounced,
    enc_b_debounced,
    quad_up,
    quad_down,
    step_up,
    step_down,
    \digit0[3] ,
    \digit0[2] ,
    \digit0[1] ,
    \digit0[0] ,
    \digit1[3] ,
    \digit1[2] ,
    \digit1[1] ,
    \digit1[0] ,
    \digit2[3] ,
    \digit2[2] ,
    \digit2[1] ,
    \digit2[0] ,
    \digit3[3] ,
    \digit3[2] ,
    \digit3[1] ,
    \digit3[0] ,
    \digit4[3] ,
    \digit4[2] ,
    \digit4[1] ,
    \digit4[0] ,
    \digit5[3] ,
    \digit5[2] ,
    \digit5[1] ,
    \digit5[0] ,
    i_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input i_enc_a;
input i_enc_b;
input \enc_state[1] ;
input \enc_state[0] ;
input \enc_state_prev[1] ;
input \enc_state_prev[0] ;
input enc_a_sync;
input enc_b_sync;
input enc_a_debounced;
input enc_b_debounced;
input quad_up;
input quad_down;
input step_up;
input step_down;
input \digit0[3] ;
input \digit0[2] ;
input \digit0[1] ;
input \digit0[0] ;
input \digit1[3] ;
input \digit1[2] ;
input \digit1[1] ;
input \digit1[0] ;
input \digit2[3] ;
input \digit2[2] ;
input \digit2[1] ;
input \digit2[0] ;
input \digit3[3] ;
input \digit3[2] ;
input \digit3[1] ;
input \digit3[0] ;
input \digit4[3] ;
input \digit4[2] ;
input \digit4[1] ;
input \digit4[0] ;
input \digit5[3] ;
input \digit5[2] ;
input \digit5[1] ;
input \digit5[0] ;
input i_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire i_enc_a;
wire i_enc_b;
wire \enc_state[1] ;
wire \enc_state[0] ;
wire \enc_state_prev[1] ;
wire \enc_state_prev[0] ;
wire enc_a_sync;
wire enc_b_sync;
wire enc_a_debounced;
wire enc_b_debounced;
wire quad_up;
wire quad_down;
wire step_up;
wire step_down;
wire \digit0[3] ;
wire \digit0[2] ;
wire \digit0[1] ;
wire \digit0[0] ;
wire \digit1[3] ;
wire \digit1[2] ;
wire \digit1[1] ;
wire \digit1[0] ;
wire \digit2[3] ;
wire \digit2[2] ;
wire \digit2[1] ;
wire \digit2[0] ;
wire \digit3[3] ;
wire \digit3[2] ;
wire \digit3[1] ;
wire \digit3[0] ;
wire \digit4[3] ;
wire \digit4[2] ;
wire \digit4[1] ;
wire \digit4[0] ;
wire \digit5[3] ;
wire \digit5[2] ;
wire \digit5[1] ;
wire \digit5[0] ;
wire i_clk;
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
    .data_i({i_enc_a,i_enc_b,\enc_state[1] ,\enc_state[0] ,\enc_state_prev[1] ,\enc_state_prev[0] ,enc_a_sync,enc_b_sync,enc_a_debounced,enc_b_debounced,quad_up,quad_down,step_up,step_down,\digit0[3] ,\digit0[2] ,\digit0[1] ,\digit0[0] ,\digit1[3] ,\digit1[2] ,\digit1[1] ,\digit1[0] ,\digit2[3] ,\digit2[2] ,\digit2[1] ,\digit2[0] ,\digit3[3] ,\digit3[2] ,\digit3[1] ,\digit3[0] ,\digit4[3] ,\digit4[2] ,\digit4[1] ,\digit4[0] ,\digit5[3] ,\digit5[2] ,\digit5[1] ,\digit5[0] }),
    .clk_i(i_clk)
);

endmodule

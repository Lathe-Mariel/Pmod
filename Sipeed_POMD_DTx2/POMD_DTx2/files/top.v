// =============================================================
// Project  : 7セグメントLED カウンタ
// Board    : Tang Primer 25K (GW5A-25)
// PMOD     : Sipeed PMOD-DTx2 (2桁7セグメント)
// 機能     : 0-99 を1秒ごとにカウントアップして表示
// クロック : 50MHz (Tang Primer 25K オンボードクロック)
// =============================================================

module top (
    input  wire        sys_clk,    // 50MHz システムクロック
    input  wire        sys_rst_n,  // リセット (アクティブLow)

    // PMOD-DTx2 セグメント信号 (アクティブLow)
    output wire        seg_a,
    output wire        seg_b,
    output wire        seg_c,
    output wire        seg_d,
    output wire        seg_e,
    output wire        seg_f,
    output wire        seg_g,
    output wire        seg_dp,

    // PMOD-DTx2 桁選択信号 (アクティブLow)
    output wire        dig0,       // 下位桁 (1の位)
    output wire        dig1        // 上位桁 (10の位)
);

// ------------------------------------------------------------
// パラメータ
// ------------------------------------------------------------
parameter CLK_FREQ    = 50_000_000;   // 50 MHz
parameter CNT_1SEC    = CLK_FREQ - 1; // 1秒カウント値
parameter CNT_1MS     = CLK_FREQ / 1000 - 1; // 1ms (ダイナミック点灯用)

// ------------------------------------------------------------
// 1秒カウンタ → 0-99 の表示値生成
// ------------------------------------------------------------
reg [25:0] r_sec_cnt;
reg [6:0]  r_val;     // 表示値 (0-99)

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        r_sec_cnt <= 26'd0;
        r_val     <= 7'd0;
    end else if (r_sec_cnt == CNT_1SEC) begin
        r_sec_cnt <= 26'd0;
        if (r_val == 7'd99)
            r_val <= 7'd0;
        else
            r_val <= r_val + 1'b1;
    end else begin
        r_sec_cnt <= r_sec_cnt + 1'b1;
    end
end

// ------------------------------------------------------------
// BCD変換 (0-99 → 十の位 / 一の位)
// ------------------------------------------------------------
wire [3:0] w_tens = r_val / 10;
wire [3:0] w_ones = r_val % 10;

// ------------------------------------------------------------
// ダイナミック点灯制御 (約1ms周期で桁を切り替え)
// ------------------------------------------------------------
reg [15:0] r_dyn_cnt;
reg        r_digit_sel;  // 0: 一の位, 1: 十の位

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        r_dyn_cnt  <= 16'd0;
        r_digit_sel <= 1'b0;
    end else if (r_dyn_cnt == CNT_1MS) begin
        r_dyn_cnt   <= 16'd0;
        r_digit_sel <= ~r_digit_sel;
    end else begin
        r_dyn_cnt <= r_dyn_cnt + 1'b1;
    end
end

// ------------------------------------------------------------
// 現在表示する桁の値を選択
// ------------------------------------------------------------
wire [3:0] w_cur_digit = r_digit_sel ? w_tens : w_ones;

// ------------------------------------------------------------
// 7セグメントデコーダ (アクティブLow)
//   セグメント配置:
//     --a--
//    f   b
//     --g--
//    e   c
//     --d--  (dp)
//
//   出力 [6:0] = {g, f, e, d, c, b, a}
// ------------------------------------------------------------
reg [7:0] r_seg;  // {dp, g, f, e, d, c, b, a}

always @(*) begin
    case (w_cur_digit)
        4'd0:  r_seg = 8'b1100_0000; // 0: a,b,c,d,e,f ON
        4'd1:  r_seg = 8'b1111_1001; // 1: b,c ON
        4'd2:  r_seg = 8'b1010_0100; // 2: a,b,d,e,g ON
        4'd3:  r_seg = 8'b1011_0000; // 3: a,b,c,d,g ON
        4'd4:  r_seg = 8'b1001_1001; // 4: b,c,f,g ON
        4'd5:  r_seg = 8'b1001_0010; // 5: a,c,d,f,g ON
        4'd6:  r_seg = 8'b1000_0010; // 6: a,c,d,e,f,g ON
        4'd7:  r_seg = 8'b1111_1000; // 7: a,b,c ON
        4'd8:  r_seg = 8'b1000_0000; // 8: all ON
        4'd9:  r_seg = 8'b1001_0000; // 9: a,b,c,d,f,g ON
        default: r_seg = 8'b1111_1111; // all OFF
    endcase
end

// ------------------------------------------------------------
// 出力割り当て
// ------------------------------------------------------------
assign seg_a  = r_seg[0];
assign seg_b  = r_seg[1];
assign seg_c  = r_seg[2];
assign seg_d  = r_seg[3];
assign seg_e  = r_seg[4];
assign seg_f  = r_seg[5];
assign seg_g  = r_seg[6];
assign seg_dp = r_seg[7];  // 常時OFF (1=消灯)

// 桁選択 (アクティブLow: 0で点灯)
assign dig0 = r_digit_sel ? 1'b1 : 1'b0;  // 一の位
assign dig1 = r_digit_sel ? 1'b0 : 1'b1;  // 十の位

endmodule

// =============================================================
// Project  : 7セグメントLED カウンタ
// Board    : Tang Primer 25K (GW5A-25)
// PMOD     : Sipeed PMOD-DTx2 (2桁7セグメント)
// 機能     : 0-99 を1秒ごとにカウントアップして表示
// クロック : 50MHz (Tang Primer 25K オンボードクロック)
//
// PMOD1 ピン割り当て:
//   ピン0 (G11) = seg_f    ピン4 (G10) = seg_g
//   ピン1 (D11) = seg_e    ピン5 (D10) = seg_d
//   ピン2 (B11) = seg_b    ピン6 (B10) = seg_a
//   ピン3 (C11) = seg_c    ピン7 (C10) = dig0
//   dig1 → PMOD2 先頭ピン (top.cst を確認)
// =============================================================

module top (
    input  wire sys_clk,    // 50MHz システムクロック (H11)
    input  wire sys_rst_n,  // S1ボタン リセット (H11, アクティブLow)

    // PMOD-DTx2 セグメント信号 (アクティブLow)
    output wire seg_a,
    output wire seg_b,
    output wire seg_c,
    output wire seg_d,
    output wire seg_e,
    output wire seg_f,
    output wire seg_g,

    // PMOD-DTx2 桁選択信号
    // dig0=0: 一の位点灯, dig0=1: 十の位点灯
    output wire dig0    // PMOD1 ピン7 = C10
);

// ------------------------------------------------------------
// パラメータ
// ------------------------------------------------------------
parameter CLK_FREQ = 50_000_000;          // 50 MHz
parameter CNT_1SEC = CLK_FREQ - 1;        // 1秒カウント値
parameter CNT_1MS  = CLK_FREQ / 1000 - 1; // 1ms (ダイナミック点灯周期)

// ------------------------------------------------------------
// 1秒カウンタ → 0-99 のカウントアップ
// ------------------------------------------------------------
reg [25:0] r_sec_cnt;
reg [6:0]  r_val;

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        r_sec_cnt <= 26'd0;
        r_val     <= 7'd0;
    end else if (r_sec_cnt == CNT_1SEC) begin
        r_sec_cnt <= 26'd0;
        r_val     <= (r_val == 7'd99) ? 7'd0 : r_val + 1'b1;
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
// ダイナミック点灯制御 (1ms ごとに桁を切り替え)
// ------------------------------------------------------------
reg [15:0] r_dyn_cnt;
reg        r_digit_sel;  // 0: 一の位, 1: 十の位

always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        r_dyn_cnt   <= 16'd0;
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
//
//   セグメント配置:
//     --a--
//    f     b
//     --g--
//    e     c
//     --d--
//
//   r_seg ビット割り当て: {g, f, e, d, c, b, a}
//   0=点灯, 1=消灯
// ------------------------------------------------------------
reg [6:0] r_seg;

always @(*) begin
    case (w_cur_digit)
        4'd0:    r_seg = 7'b100_0000; // 0: a,b,c,d,e,f ON
        4'd1:    r_seg = 7'b111_1001; // 1: b,c ON
        4'd2:    r_seg = 7'b010_0100; // 2: a,b,d,e,g ON
        4'd3:    r_seg = 7'b011_0000; // 3: a,b,c,d,g ON
        4'd4:    r_seg = 7'b001_1001; // 4: b,c,f,g ON
        4'd5:    r_seg = 7'b001_0010; // 5: a,c,d,f,g ON
        4'd6:    r_seg = 7'b000_0010; // 6: a,c,d,e,f,g ON
        4'd7:    r_seg = 7'b111_1000; // 7: a,b,c ON
        4'd8:    r_seg = 7'b000_0000; // 8: all ON
        4'd9:    r_seg = 7'b001_0000; // 9: a,b,c,d,f,g ON
        default: r_seg = 7'b111_1111; // all OFF
    endcase
end

// ------------------------------------------------------------
// 出力割り当て
// ------------------------------------------------------------
assign seg_a = r_seg[0];
assign seg_b = r_seg[1];
assign seg_c = r_seg[2];
assign seg_d = r_seg[3];
assign seg_e = r_seg[4];
assign seg_f = r_seg[5];
assign seg_g = r_seg[6];

// 桁選択: dig0=0 → 一の位点灯, dig0=1 → 十の位点灯
assign dig0 = ~r_digit_sel;

endmodule
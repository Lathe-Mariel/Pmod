// =============================================================================
// led_matrix_top.v
// 8x8 2色マトリクスLED ダイナミックドライブ + PWM諧調制御
//
// ターゲット  : Shrike lite / Renesas ForgeFPGA SLG47910V
// システムCLK : 50MHz (OSC_CLK)
// 出力ピン    :
//   COL_Red   - GPIO12 (FPGA F18) : 赤カソード用 74LS595 SPI データ
//   COL_Green - GPIO15 (FPGA F17) : 緑カソード用 74LS595 SPI データ
//   ROW       - GPIO14 (FPGA F18) : アノード用   74LS595 SPI データ
//   ※ 3本の74LS595は共通クロック・共通ラッチで駆動
//
// 構成概要 :
//   ┌──────────────┐   ┌─────────────────┐   ┌────────────────┐
//   │ フレームバッファ│──▶│ スキャンコントローラ │──▶│ シフトレジスタ出力 │
//   │ (BRAM 32b×8) │   │ (行選択・PWM比較) │   │ (74LS595×3)   │
//   └──────────────┘   └─────────────────┘   └────────────────┘
//
// フレームバッファ :
//   アドレス [row][frame] の 32ビット値
//   [31:27] 未使用
//   [26:24] R諧調(3bit) col7
//   [23:21] G諧調(3bit) col7
//   ... 各カラム3+3=6ビット×8カラム = 48ビット → 2ワード使用
//
//   本実装では省メモリのため以下フォーマット採用:
//   1ワード32ビット/行
//     [31:24] = 赤8ピクセル (MSBが col0)  -- 1bit on/off
//     [23:16] = 緑8ピクセル (MSBが col0)  -- 1bit on/off
//     [15:6]  = 未使用
//     [5:3]   = 行の赤輝度 (3bit)
//     [2:0]   = 行の緑輝度 (3bit)
//
//   ※ 色深度6bit(R3G3)はPWMカウンタと行単位輝度の組み合わせで実現
//      より細かい画素毎の色は上位モジュール拡張で対応可能
//
// アニメーション :
//   "Renesas" 7文字 × 各1フレーム(static display) = 4フレーム循環
//   フレーム切り替え周期 : 約0.5秒
// =============================================================================

`default_nettype none
(* top *) module top(
(* iopad_external_pin, clkbuf_inhibit *) input wire clk,
(* iopad_external_pin *) output wire clk_en,
(* iopad_external_pin *) input wire sw,
(* iopad_external_pin *) output wire sw_en,
(* iopad_external_pin *) output wire CLR1,
(* iopad_external_pin *) output wire CLR1_en,
(* iopad_external_pin *) output wire CLR2,
(* iopad_external_pin *) output wire CLR2_en,
(* iopad_external_pin *) output wire CLR3,
(* iopad_external_pin *) output wire CLR3_en,
(* iopad_external_pin *) output wire sr_dat_red,        // serial data
(* iopad_external_pin *) output wire sr_dat_red_en,
(* iopad_external_pin *) output wire sr_dat_grn,        // serial data
(* iopad_external_pin *) output wire sr_dat_grn_en,
(* iopad_external_pin *) output wire sr_dat_row,        //serial data
(* iopad_external_pin *) output wire sr_dat_row_en,
(* iopad_external_pin *) output wire sr_lat,            //transfering value of shift register to storage register
(* iopad_external_pin *) output wire sr_lat_en,
(* iopad_external_pin *) output wire sr_clk,
(* iopad_external_pin *) output wire sr_clk_en,
(* iopad_external_pin *) output wire led_en,
(* iopad_external_pin *) output reg led
);

assign clk_en =1;
assign sw_en =1;
assign CLR1_en =1;
assign CLR2_en =1;
assign CLR3_en =1;
assign sr_dat_red_en =1;
assign sr_dat_grn_en =1;
assign sr_dat_row_en =1;
assign sr_lat_en =1;
assign sr_clk_en =1;
assign led_en =1;

//assign led =1;
assign CLR1 =1;
assign CLR2 =1;
assign CLR3 =1;

    // =========================================================================
    // パラメータ
    // =========================================================================
    localparam CLK_HZ      = 50_000_000;
    localparam ROWS        = 8;
    localparam COLS        = 8;
    localparam PWM_BITS    = 3;               // 3bit → 8階調
    localparam PWM_MAX     = (1<<PWM_BITS);   // 8

    // ダイナミックスキャン周期
    // 1行表示 = PWMサイクル × 1 = (2^3)=8 PWMステップ
    // 全8行 = 64 PWMステップ/フレーム
    // 目標フレームレート: ~200Hz → 1フレーム=5ms
    // 1行 = 5ms/8 = 625µs
    // PWMステップ = 625µs/8 ≒ 78µs → 78000/50MHz ≒ 3906 clk
    localparam SCAN_DIV    = 3906;            // 1 PWMステップあたりのクロック数
    localparam SCAN_CNT_W  = 12;

    // アニメーション切り替え : 0.5秒
    localparam ANIM_DIV    = CLK_HZ / 2;
    localparam ANIM_CNT_W  = 25;

    // シフトレジスタ送信: 8ビット×3チップ → 8クロック
    // sr_clk = clk/4
    localparam SR_CLK_DIV  = 2;
    localparam SR_CNT_W    = 4;              // 4ビット (0..15 for 8bits + margin)

    // =========================================================================
    // フレームバッファ (ROM定義)
    // フォーマット: {red[7:0], grn[7:0], 10'b0, row_r[2:0], row_g[2:0]}
    // =========================================================================
    // "Renesas" フォント (5×8ドット, 8ピクセル幅)
    // 各行: [31:24]=赤マスク [23:16]=緑マスク [5:3]=R輝度 [2:0]=G輝度
    //
    // 文字と色の対応:
    //   R - 赤 (R=7,G=0)
    //   e - 橙 (R=7,G=3)
    //   n - 黄 (R=7,G=7)
    //   e - 緑 (R=0,G=7)
    //   s - 水 (R=0,G=7) ← 青は赤緑2色では青単独不可、水色で代替
    //   a - 紫代替マゼンタ (R=7,G=0) 赤で代替
    //   s - 緑 (R=0,G=7)
    //
    // 4フレーム分 × 8行 = 32エントリ
    // フレーム0: "Rene" フレーム1: "esas" (2文字ずつスクロール的に表示)
    // 簡略化: フレーム0="Re", フレーム1="na", フレーム2="sa", フレーム3="s"
    // → 実際には1フレームに8行=1文字分を格納
    //
    // ここでは "Renesas" の各文字を1フレームに割り当て
    // フレーム数=4なので 'R','e','n','e' を表示 (残り "sas" は拡張可能)

    // ---- 文字フォント定義 (5幅 左詰め 8ビット) ----
    // 各文字8行 × {赤マスク8bit, 緑マスク8bit}
    // R  (赤)
    // e  (黄: R+G)
    // n  (緑)
    // a  (水: Gのみ点灯で擬似青緑)
    // s  (赤)
    // (a)(橙)
    // s  (緑)

    // フレームバッファ: [frame*8 + row]
    reg [31:0] fb [0:63];

    // ---- フォントデータ初期化 ----
    // ビット配置: [31:24]=赤列マスク, [23:16]=緑列マスク, [5:3]=R輝度, [2:0]=G輝度
    // 列マスク: bit7=col0(左), bit0=col7(右)
    integer i;
    initial begin
        // ---- Frame 0: 'R' 赤 ----

        fb[ 0] = {8'hFE, 8'h00, 10'b0, 3'h7, 3'h0}; // 1111_1110 赤
        fb[ 1] = {8'h81, 8'h00, 10'b0, 3'h7, 3'h0}; // 1000_0001
        fb[ 2] = {8'h81, 8'h00, 10'b0, 3'h7, 3'h0}; // 1000_0001
        fb[ 3] = {8'hFE, 8'h00, 10'b0, 3'h7, 3'h0}; // 1111_1110
        fb[ 4] = {8'h88, 8'h00, 10'b0, 3'h7, 3'h0}; // 1000_1000
        fb[ 5] = {8'h84, 8'h00, 10'b0, 3'h7, 3'h0}; // 1000_0100
        fb[ 6] = {8'h82, 8'h00, 10'b0, 3'h7, 3'h0}; // 1000_0010
        fb[ 7] = {8'h81, 8'h00, 10'b0, 3'h7, 3'h0}; // 1000_0001

        // ---- Frame 1: 'e' 黄(R+G) ----
        // e:  .##. .   0110 0000
        //     .... .// 黄
        fb[ 8] = {8'h00, 8'h00, 10'b0, 3'h7, 3'h7}; //0000_0000 
        fb[ 9] = {8'h3C, 8'h3C, 10'b0, 3'h7, 3'h7}; //0011_1100
        fb[10] = {8'h42, 8'h42, 10'b0, 3'h7, 3'h7}; //0100_0010
        fb[11] = {8'h81, 8'h81, 10'b0, 3'h7, 3'h7}; //1000_0001
        fb[12] = {8'hFF, 8'hFF, 10'b0, 3'h7, 3'h7}; //1111_1111
        fb[13] = {8'h80, 8'h80, 10'b0, 3'h7, 3'h7}; //1000_0000
        fb[14] = {8'h42, 8'h42, 10'b0, 3'h7, 3'h7}; //0100_0010
        fb[15] = {8'h3C, 8'h3C, 10'b0, 3'h7, 3'h7}; //0011_1100

        // ---- Frame 2: 'n' 緑 ----
        // n
        fb[16] = {8'hBC, 8'hBC, 10'b0, 3'h0, 3'h7}; //1011_1100 
        fb[17] = {8'hE2, 8'hE2, 10'b0, 3'h0, 3'h7}; //1110_0010 
        fb[18] = {8'h81, 8'h81, 10'b0, 3'h0, 3'h7}; //1000_0001 
        fb[19] = {8'h81, 8'h81, 10'b0, 3'h0, 3'h7}; //1000_0001 
        fb[20] = {8'h81, 8'h81, 10'b0, 3'h0, 3'h7}; //1000_0001 
        fb[21] = {8'h81, 8'h81, 10'b0, 3'h0, 3'h7}; //1000_0001 
        fb[22] = {8'h81, 8'h81, 10'b0, 3'h0, 3'h7}; //1000_0001 
        fb[23] = {8'h81, 8'h81, 10'b0, 3'h0, 3'h7}; //1000_0001 

        // ---- Frame 3: 'e' 橙(R多,G少) ----
        fb[24] = {8'h00, 8'h00, 10'b0, 3'h7, 3'h3}; //0000_0000 
        fb[25] = {8'h3C, 8'h3C, 10'b0, 3'h7, 3'h3}; //0000_0000 
        fb[26] = {8'h42, 8'h42, 10'b0, 3'h7, 3'h3}; //0000_0000 
        fb[27] = {8'h81, 8'h81, 10'b0, 3'h7, 3'h3}; //0000_0000 
        fb[28] = {8'hFF, 8'hFF, 10'b0, 3'h7, 3'h3}; //0000_0000 
        fb[29] = {8'h80, 8'h80, 10'b0, 3'h7, 3'h3}; //0000_0000 
        fb[30] = {8'h42, 8'h42, 10'b0, 3'h7, 3'h3}; //0000_0000 
        fb[31] = {8'h3C, 8'h3C, 10'b0, 3'h7, 3'h3}; //0000_0000 
        
        // s
        fb[32] = {8'h00, 8'h00, 10'b0, 3'h3, 3'h7}; //0000_0000 
        fb[33] = {8'h3C, 8'h3C, 10'b0, 3'h3, 3'h7}; //0011_1100 
        fb[34] = {8'h42, 8'h42, 10'b0, 3'h3, 3'h7}; //0100_0010 
        fb[35] = {8'h40, 8'h40, 10'b0, 3'h3, 3'h7}; //0100_0000 
        fb[36] = {8'h3C, 8'h3C, 10'b0, 3'h3, 3'h7}; //0011_1100 
        fb[37] = {8'h02, 8'h02, 10'b0, 3'h3, 3'h7}; //0000_0010 
        fb[38] = {8'h44, 8'h44, 10'b0, 3'h3, 3'h7}; //0100_0100 
        fb[39] = {8'h38, 8'h38, 10'b0, 3'h3, 3'h7}; //0011_1000 
        
        // a
        fb[40] = {8'h00, 8'h00, 10'b0, 3'h2, 3'h0}; //0000_0000 
        fb[41] = {8'h38, 8'h38, 10'b0, 3'h2, 3'h0}; //0011_1000 
        fb[42] = {8'h44, 8'h44, 10'b0, 3'h2, 3'h0}; //0100_0100 
        fb[43] = {8'h84, 8'h84, 10'b0, 3'h2, 3'h0}; //1000_0100 
        fb[44] = {8'h82, 8'h82, 10'b0, 3'h2, 3'h0}; //1000_0010 
        fb[45] = {8'h82, 8'h82, 10'b0, 3'h2, 3'h0}; //1000_0010 
        fb[46] = {8'h42, 8'h42, 10'b0, 3'h2, 3'h0}; //0100_0010 
        fb[47] = {8'h3D, 8'h3D, 10'b0, 3'h2, 3'h0}; //0011_1101 
    
        // s
        fb[48] = {8'h00, 8'h00, 10'b0, 3'h0, 3'h2}; // 
        fb[49] = {8'h3C, 8'h3C, 10'b0, 3'h0, 3'h2}; // 
        fb[50] = {8'h42, 8'h42, 10'b0, 3'h0, 3'h2}; // 
        fb[51] = {8'h40, 8'h40, 10'b0, 3'h0, 3'h2}; // 
        fb[52] = {8'h3C, 8'h3C, 10'b0, 3'h0, 3'h2}; // 
        fb[53] = {8'h02, 8'h02, 10'b0, 3'h0, 3'h2}; // 
        fb[54] = {8'h44, 8'h44, 10'b0, 3'h0, 3'h2}; // 
        fb[55] = {8'h38, 8'h38, 10'b0, 3'h0, 3'h2}; // 
        
        // .
        fb[56] = {8'h00, 8'h00, 10'b0, 3'h0, 3'h1}; //0000_0000 
        fb[57] = {8'h00, 8'h00, 10'b0, 3'h0, 3'h1}; //0000_0000 
        fb[58] = {8'h00, 8'h00, 10'b0, 3'h0, 3'h1}; //0000_0000 
        fb[59] = {8'h00, 8'h00, 10'b0, 3'h0, 3'h1}; //0000_0000 
        fb[60] = {8'h00, 8'h00, 10'b0, 3'h0, 3'h1}; //0000_0000 
        fb[61] = {8'h00, 8'h00, 10'b0, 3'h0, 3'h1}; //0000_0000 
        fb[62] = {8'h06, 8'h06, 10'b0, 3'h0, 3'h1}; //0000_0110 
        fb[63] = {8'h06, 8'h06, 10'b0, 3'h0, 3'h1}; //0000_0110 
    end

    // =========================================================================
    // アニメーションカウンタ (フレーム切り替え)
    // =========================================================================
    reg [ANIM_CNT_W-1:0] anim_cnt;
    reg [2:0]            frame_sel;  // 0..7

    always @(posedge clk) begin
        if (anim_cnt == ANIM_DIV - 1) begin
            anim_cnt  <= 0;
            frame_sel <= frame_sel + 1'b1;
            led <= ~led;
        end else begin
            anim_cnt <= anim_cnt + 1'b1;
        end
    end

    // =========================================================================
    // スキャンカウンタ (PWMステップ × 行選択)
    // =========================================================================
    reg [SCAN_CNT_W-1:0] scan_cnt;
    reg [PWM_BITS-1:0]   pwm_phase;  // 0..7 (PWMステップ)
    reg [2:0]            row_idx;    // 0..7 (現在スキャン行)
    reg                  scan_tick;  // 1サイクルパルス: 次の行/PWMへ

    always @(posedge clk) begin
        scan_tick <= 1'b0;
        if (scan_cnt == SCAN_DIV - 1) begin
            scan_cnt  <= 0;
            scan_tick <= 1'b1;
            if (pwm_phase == PWM_MAX - 1) begin
                pwm_phase <= 0;
                row_idx   <= row_idx + 1'b1;
            end else begin
                pwm_phase <= pwm_phase + 1'b1;
            end
        end else begin
            scan_cnt <= scan_cnt + 1'b1;
        end
    end

    // =========================================================================
    // フレームバッファ読み出し & PWM比較
    // =========================================================================
    wire [5:0]  fb_addr  = {frame_sel, row_idx};  // [5:3]=frame [2:0]=row
    wire [31:0] fb_data  = fb[fb_addr];

    wire [7:0]  red_mask = fb_data[31:24];
    wire [7:0]  grn_mask = fb_data[23:16];
    wire [2:0]  row_r    = fb_data[5:3];
    wire [2:0]  row_g    = fb_data[2:0];

    // PWM比較: pwm_phase < 輝度 → 点灯
    wire        pwm_r_on = (pwm_phase < row_r);
    wire        pwm_g_on = (pwm_phase < row_g);

    // 各カラムの最終点灯データ (アノードコモン: カソードをLowで点灯)
    // 赤: カソードが有効(0) = red_mask bit が 1 かつ PWM ON
    // 74LS595はQ7がSER入力の1ビット目(最初にシフトインされる最下位)
    // → col0=MSB(bit7)として8回シフト
    wire [7:0]  col_r_data = pwm_r_on ? ~red_mask : 8'hFF; // 0=点灯
    wire [7:0]  col_g_data = pwm_g_on ? ~grn_mask : 8'hFF; // 0=点灯

    // 行アノード: アノードコモン → 選択行をHighに
    // 74LS595出力で選択行のみ1 (アクティブHigh)
    wire [7:0]  row_data   = 8'h01 << row_idx; // one-hot

    // =========================================================================
    // シフトレジスタ送信ステートマシン
    // scan_tick でトリガ → 24ビット(3×8)を順次送信 → ラッチ
    // =========================================================================
    // sr_clkはclk/4で生成
    reg [1:0]  sr_clk_cnt;
    wire       sr_clk_rise = (sr_clk_cnt == 2'b01);
    wire       sr_clk_fall = (sr_clk_cnt == 2'b11);
    reg        sr_clk_r;

    always @(posedge clk) begin
        sr_clk_cnt <= sr_clk_cnt + 1'b1;
        if (sr_clk_cnt == 2'b10) sr_clk_r <= 1'b1;
        if (sr_clk_cnt == 2'b00) sr_clk_r <= 1'b0;
    end

    // 送信レジスタ
    reg [7:0]  sr_red_reg, sr_grn_reg, sr_row_reg;
    reg [3:0]  sr_bit_cnt;   // 0..8
    reg        sr_active;    // 送信中フラグ
    reg        sr_lat_r;

    // scan_tick 検出: 送信開始
    always @(posedge clk) begin
        sr_lat_r <= 1'b0;
        if (scan_tick) begin
            // 送信データをラッチ
            sr_red_reg <= col_r_data;
            sr_grn_reg <= col_g_data;
            sr_row_reg <= row_data;
            sr_bit_cnt <= 4'd0;
            sr_active  <= 1'b1;
        end else if (sr_active && sr_clk_fall) begin
            if (sr_bit_cnt == 4'd7) begin
                sr_active  <= 1'b0;
                sr_lat_r   <= 1'b1;  // 送信完了→ラッチパルス
            end else begin
                sr_bit_cnt <= sr_bit_cnt + 1'b1;
                sr_red_reg <= {1'b0, sr_red_reg[7:1]};
                sr_grn_reg <= {1'b0, sr_grn_reg[7:1]};
                sr_row_reg <= {sr_row_reg[6:0], 1'b0};
            end
        end
    end

    // =========================================================================
    // 出力割り当て
    // =========================================================================
    assign sr_clk     = sr_active ? sr_clk_r : 1'b0;
    assign sr_lat     = sr_lat_r;
    assign sr_dat_red = sr_active ? sr_red_reg[0] : 1'b1; // アイドル時High(消灯)
    assign sr_dat_grn = sr_active ? sr_grn_reg[0] : 1'b1;
    assign sr_dat_row = sr_active ? sr_row_reg[7] : 1'b0; // アイドル時Low

endmodule
`default_nettype wire

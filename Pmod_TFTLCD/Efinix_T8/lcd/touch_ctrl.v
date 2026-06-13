// ============================================================
// touch_ctrl.v - XPT2046 タッチパネルコントローラ
// Tang Primer 25K + PMOD-TFTLCD v1.1
//
// 接続ピン:
//   Port2 Pmod5 (A10) → TC_CS   (Chip Select, Low有効)
//   Port2 Pmod6 (E10) → TC_MOSI (DIN: コマンド送信)
//   Port0 Pmod7 (H7)  → TC_MISO (DOUT: データ受信)
//   Port2 Pmod8 (K5)  → TC_CLK  (DCLK: SPIクロック)
//
// XPT2046 SPIプロトコル (24クロック/変換):
//   Phase1 (CLK 1-8)  : コントロールバイト送信 (DIN)
//   Phase2 (CLK 9-11) : アクワイア期間 (BUSY High)
//   Phase3 (CLK 12-23): 12bit ADC結果受信 (DOUT, MSB first)
//   Phase4 (CLK 24)   : ゼロ埋め (無視)
//
// コントロールバイト:
//   X位置: 0xD0 = 1_101_0_0_00 (START,A=101,12bit,DFR,PD=00)
//   Y位置: 0x90 = 1_001_0_0_00 (START,A=001,12bit,DFR,PD=00)
//
// 動作:
//   10ms ごとにX→Yの順で座標を取得
//   タッチ検出: Z1測定 (0xB0) が閾値より大きければタッチあり
//   3回サンプリングして中央値をとることでノイズ除去
//
// 出力:
//   touch_valid : タッチ検出中はHigh
//   touch_x     : LCD座標系X (0~319)
//   touch_y     : LCD座標系Y (0~239)
// ============================================================

module touch_ctrl (
    input  wire        clk,         // 50 MHz
    input  wire        rst_n,       // Low有効リセット

    // XPT2046 SPI
    output reg         tc_cs,       // A10 Chip Select (Low有効)
    output reg         tc_mosi,     // E10 DIN
    input  wire        tc_miso,     // H7  DOUT
    output reg         tc_clk,      // K5  DCLK

    // タッチ座標出力
    output reg         touch_valid, // タッチ検出中
    output reg  [8:0]  touch_x,     // LCD X座標 (0~319)
    output reg  [7:0]  touch_y      // LCD Y座標 (0~239)
);

// ============================================================
// SPIクロック分周
//   XPT2046 最大CLK: 2MHz (125kHz × 16)
//   50MHz / 32 = 1.5625MHz → 安全マージン込みで使用
//   clk_div が 0→15 で立ち上がり、16→31 で立ち下がり
// ============================================================
reg [4:0] clk_div;
wire spi_clk_rise = (clk_div == 5'd15);  // 立ち上がりエッジタイミング
wire spi_clk_fall = (clk_div == 5'd31);  // 立ち下がりエッジタイミング

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) clk_div <= 5'd0;
    else        clk_div <= clk_div + 5'd1;
end

// ============================================================
// サンプリング周期タイマー: 10ms ごとに計測開始
//   50MHz × 10ms = 500,000 サイクル
// ============================================================
localparam [19:0] SAMPLE_PERIOD = 20'd500_000;

reg [19:0] sample_cnt;
reg        sample_req;  // 1クロックパルス

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sample_cnt <= 20'd0;
        sample_req <= 1'b0;
    end else begin
        if (sample_cnt == SAMPLE_PERIOD - 1'b1) begin
            sample_cnt <= 20'd0;
            sample_req <= 1'b1;
        end else begin
            sample_cnt <= sample_cnt + 1'b1;
            sample_req <= 1'b0;
        end
    end
end

// ============================================================
// Z1 タッチ判定閾値
//   XPT2046 のZ1測定: タッチなし≒0、タッチあり≒200~4095
// ============================================================
localparam [11:0] TOUCH_THRESH = 12'd200;

// ============================================================
// XPT2046 ADCロー値 → LCD座標変換
//   ADCは12bit (0~4095)
//   X ADC: 実測で約 200 (右端) ~ 3900 (左端) ← 反転注意
//   Y ADC: 実測で約 200 (下端) ~ 3900 (上端) ← 反転注意
//   キャリブレーション値は実機で調整すること
// ============================================================
localparam [11:0] X_ADC_MIN = 12'd200;
localparam [11:0] X_ADC_MAX = 12'd3900;
localparam [11:0] Y_ADC_MIN = 12'd200;
localparam [11:0] Y_ADC_MAX = 12'd3900;

// LCD座標変換関数
// LCD_X = (X_ADC_MAX - raw_x) * 319 / (X_ADC_MAX - X_ADC_MIN)
// LCD_Y = (Y_ADC_MAX - raw_y) * 239 / (Y_ADC_MAX - Y_ADC_MIN)
// 実装: 乗算器を使用 (FPGA内部DSPで合成)
function [8:0] adc_to_lcd_x;
    input [11:0] raw;
    reg   [23:0] tmp;
    begin
        if (raw <= X_ADC_MIN)
            adc_to_lcd_x = 9'd319;
        else if (raw >= X_ADC_MAX)
            adc_to_lcd_x = 9'd0;
        else begin
            tmp = (X_ADC_MAX - raw) * 24'd319;
            adc_to_lcd_x = tmp[21:13];  // / (3700) ≈ >> 9 (近似)
            // より正確な除算: tmp / (X_ADC_MAX - X_ADC_MIN)
            // 3700 ≈ 4096 * (319/355) → シフトで近似
            // 正確な値が必要な場合は実機キャリブレーションで調整
        end
    end
endfunction

function [7:0] adc_to_lcd_y;
    input [11:0] raw;
    reg   [23:0] tmp;
    begin
        if (raw <= Y_ADC_MIN)
            adc_to_lcd_y = 8'd239;
        else if (raw >= Y_ADC_MAX)
            adc_to_lcd_y = 8'd0;
        else begin
            tmp = (Y_ADC_MAX - raw) * 24'd239;
            adc_to_lcd_y = tmp[20:13];  // / (3700) ≈ >> 9 (近似)
        end
    end
endfunction

// ============================================================
// 中央値フィルタ用サンプルバッファ (3回サンプリング)
// ============================================================
reg [11:0] x_samples [0:2];
reg [11:0] y_samples [0:2];
reg [1:0]  sample_idx;

// 3サンプルの中央値を返す関数
function [11:0] median3;
    input [11:0] a, b, c;
    begin
        if ((a >= b && a <= c) || (a >= c && a <= b))
            median3 = a;
        else if ((b >= a && b <= c) || (b >= c && b <= a))
            median3 = b;
        else
            median3 = c;
    end
endfunction

// ============================================================
// SPI バイト送受信器
//   24クロックで1回の変換:
//     送信: 8bit コントロールバイト (bit7=MSB first)
//     受信: 先頭1bit=0(null), 12bit ADC値, 末尾3bit=0(ignore)
//           → CLK 2~13 で有効データ (DOUT の MSB = CLK fall 後)
// ============================================================
// コントロールバイト定数
localparam [7:0] CMD_X  = 8'hD0;  // X位置  (1_101_0_0_00)
localparam [7:0] CMD_Y  = 8'h90;  // Y位置  (1_001_0_0_00)
localparam [7:0] CMD_Z1 = 8'hB0;  // Z1圧力 (1_011_0_0_00)

reg [7:0]  spi_cmd;      // 送信コマンド
reg        spi_start;    // 送信開始パルス
reg        spi_busy;     // 変換中
reg [4:0]  spi_bit;      // CLKカウント (0~23)
reg [11:0] spi_result;   // 受信した12bit ADC値
reg [7:0]  shift_out;    // 送信シフトレジスタ
reg [11:0] shift_in;     // 受信シフトレジスタ

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tc_cs     <= 1'b1;
        tc_mosi   <= 1'b0;
        tc_clk    <= 1'b0;
        spi_busy  <= 1'b0;
        spi_bit   <= 5'd0;
        spi_result<= 12'd0;
        shift_out <= 8'd0;
        shift_in  <= 12'd0;
    end else if (spi_start && !spi_busy) begin
        // 送信開始
        tc_cs     <= 1'b0;
        tc_clk    <= 1'b0;
        spi_busy  <= 1'b1;
        spi_bit   <= 5'd0;
        shift_out <= spi_cmd;
        shift_in  <= 12'd0;
        tc_mosi   <= spi_cmd[7];  // MSB先行
    end else if (spi_busy) begin
        if (spi_clk_rise) begin
            // 立ち上がり: データサンプル (DOUT読み取り)
            tc_clk <= 1'b1;
            // CLK 9~20 がデータビット (1ビット目はnull、2~13が12bit)
            // bit番号(0-indexed): CLK1=0...CLK8=7(送信完), CLK9=8(null),
            //                     CLK10=9(bit11)...CLK21=20(bit0)
            if (spi_bit >= 5'd9 && spi_bit <= 5'd20) begin
                shift_in <= {shift_in[10:0], tc_miso};
            end
        end else if (spi_clk_fall) begin
            // 立ち下がり: データ送出
            tc_clk  <= 1'b0;
            spi_bit <= spi_bit + 5'd1;

            if (spi_bit < 5'd7) begin
                // CLK 1-7: 次のビットを出力
                tc_mosi <= shift_out[6 - spi_bit[2:0]];
            end else if (spi_bit == 5'd7) begin
                // CLK 8: 送信完了、MOSI=0
                tc_mosi <= 1'b0;
            end else if (spi_bit == 5'd23) begin
                // CLK 24: 変換完了
                spi_result <= shift_in;
                spi_busy   <= 1'b0;
                tc_cs      <= 1'b1;
            end
        end
    end
end

// ============================================================
// メインステートマシン
// ============================================================
localparam [3:0]
    S_IDLE      = 4'd0,   // サンプリング要求待ち
    S_Z1_START  = 4'd1,   // Z1 (タッチ圧力) 計測開始
    S_Z1_WAIT   = 4'd2,   // Z1 SPI完了待ち
    S_Z1_CHECK  = 4'd3,   // タッチ判定
    S_X_START   = 4'd4,   // X座標計測開始
    S_X_WAIT    = 4'd5,   // X SPI完了待ち
    S_Y_START   = 4'd6,   // Y座標計測開始
    S_Y_WAIT    = 4'd7,   // Y SPI完了待ち
    S_STORE     = 4'd8,   // サンプル格納
    S_MEDIAN    = 4'd9,   // 3サンプル揃ったら中央値算出・出力
    S_NO_TOUCH  = 4'd10;  // タッチなし → valid=0

reg [3:0]  state;
reg [11:0] raw_x, raw_y, raw_z1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state       <= S_IDLE;
        spi_start   <= 1'b0;
        spi_cmd     <= 8'd0;
        raw_x       <= 12'd0;
        raw_y       <= 12'd0;
        raw_z1      <= 12'd0;
        sample_idx  <= 2'd0;
        touch_valid <= 1'b0;
        touch_x     <= 9'd0;
        touch_y     <= 8'd0;
        x_samples[0]<= 12'd0;
        x_samples[1]<= 12'd0;
        x_samples[2]<= 12'd0;
        y_samples[0]<= 12'd0;
        y_samples[1]<= 12'd0;
        y_samples[2]<= 12'd0;
    end else begin
        spi_start <= 1'b0;

        case (state)

            // ---- サンプリング周期待ち ----
            S_IDLE: begin
                if (sample_req)
                    state <= S_Z1_START;
            end

            // ---- Z1 (タッチ圧力) 計測 ----
            S_Z1_START: begin
                if (!spi_busy && !spi_start) begin
                    spi_cmd   <= CMD_Z1;
                    spi_start <= 1'b1;
                    state     <= S_Z1_WAIT;
                end
            end

            S_Z1_WAIT: begin
                if (!spi_busy && !spi_start) begin
                    raw_z1 <= spi_result;
                    state  <= S_Z1_CHECK;
                end
            end

            // ---- タッチ判定 ----
            S_Z1_CHECK: begin
                if (raw_z1 >= TOUCH_THRESH)
                    state <= S_X_START;    // タッチあり → 座標取得
                else
                    state <= S_NO_TOUCH;   // タッチなし
            end

            // ---- X座標計測 ----
            S_X_START: begin
                if (!spi_busy && !spi_start) begin
                    spi_cmd   <= CMD_X;
                    spi_start <= 1'b1;
                    state     <= S_X_WAIT;
                end
            end

            S_X_WAIT: begin
                if (!spi_busy && !spi_start) begin
                    raw_x <= spi_result;
                    state <= S_Y_START;
                end
            end

            // ---- Y座標計測 ----
            S_Y_START: begin
                if (!spi_busy && !spi_start) begin
                    spi_cmd   <= CMD_Y;
                    spi_start <= 1'b1;
                    state     <= S_Y_WAIT;
                end
            end

            S_Y_WAIT: begin
                if (!spi_busy && !spi_start) begin
                    raw_y <= spi_result;
                    state <= S_STORE;
                end
            end

            // ---- サンプル格納 ----
            S_STORE: begin
                x_samples[sample_idx] <= raw_x;
                y_samples[sample_idx] <= raw_y;
                if (sample_idx == 2'd2) begin
                    sample_idx <= 2'd0;
                    state      <= S_MEDIAN;
                end else begin
                    sample_idx <= sample_idx + 2'd1;
                    state      <= S_IDLE;
                end
            end

            // ---- 中央値算出 & LCD座標変換 & 出力 ----
            S_MEDIAN: begin
                begin : median_calc
                    reg [11:0] med_x, med_y;
                    med_x = median3(x_samples[0], x_samples[1], x_samples[2]);
                    med_y = median3(y_samples[0], y_samples[1], y_samples[2]);
                    touch_x     <= adc_to_lcd_x(med_x);
                    touch_y     <= adc_to_lcd_y(med_y);
                    touch_valid <= 1'b1;
                end
                state <= S_IDLE;
            end

            // ---- タッチなし ----
            S_NO_TOUCH: begin
                touch_valid <= 1'b0;
                sample_idx  <= 2'd0;  // サンプルバッファリセット
                state       <= S_IDLE;
            end

            default: state <= S_IDLE;
        endcase
    end
end

endmodule

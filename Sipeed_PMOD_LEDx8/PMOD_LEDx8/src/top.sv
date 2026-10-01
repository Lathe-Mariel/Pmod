// =============================================================
// Project  : PMOD_LEDx8 LED パターンデモ
// Board    : Tang Primer 25K Dock (GW5A-LV25MG121NES)
// PMOD     : Sipeed PMOD_LEDx8 (LED 8個, アクティブLow)
// クロック : 50MHz (E2)
//
// 操作:
//   S1 (H10) : リセット
//   S2 (H11) : 表示モード切替 (押すたびに次のモードへ)
//
// 表示モード:
//   0 : 流れるLED (L1 -> L8 を繰り返し)
//   1 : ナイトライダー (往復)
//   2 : 8bit バイナリカウンタ
//   3 : ホタル (全LEDをPWMでゆっくり明滅)
// =============================================================

module top #(
    parameter int CLK_FREQ    = 50_000_000,
    parameter int STEP_HZ     = 8,     // パターン更新周波数 [Hz]
    parameter int DEBOUNCE_MS = 10     // ボタンのチャタリング除去時間 [ms]
) (
    input  logic       sys_clk,    // 50MHz
    input  logic       reset,      // S1, 押下で High
    input  logic       mode_btn,   // S2, 押下で High
    output logic [7:0] led_n       // led_n[0]=L1 ... led_n[7]=L8, Low で点灯
);

    // ---------------------------------------------------------
    // リセット同期化
    // ---------------------------------------------------------
    logic [1:0] rst_sync = 2'b11;
    logic       rst;

    always_ff @(posedge sys_clk) rst_sync <= {rst_sync[0], reset};
    assign rst = rst_sync[1];

    // ---------------------------------------------------------
    // モード切替ボタン: 同期化 + チャタリング除去 + 立ち上がり検出
    // ---------------------------------------------------------
    localparam int DB_MAX = CLK_FREQ / 1000 * DEBOUNCE_MS - 1;
    localparam int DB_W   = $clog2(DB_MAX + 1);

    logic [1:0]      btn_sync = 2'b00;
    logic [DB_W-1:0] db_cnt;
    logic            btn_stable;
    logic            btn_prev;
    logic            btn_rise;

    always_ff @(posedge sys_clk) btn_sync <= {btn_sync[0], mode_btn};

    always_ff @(posedge sys_clk) begin
        if (rst) begin
            db_cnt     <= '0;
            btn_stable <= 1'b0;
        end else if (btn_sync[1] == btn_stable) begin
            db_cnt <= '0;
        end else if (db_cnt == DB_W'(DB_MAX)) begin
            db_cnt     <= '0;
            btn_stable <= btn_sync[1];
        end else begin
            db_cnt <= db_cnt + 1'b1;
        end
    end

    always_ff @(posedge sys_clk) begin
        if (rst) btn_prev <= 1'b0;
        else     btn_prev <= btn_stable;
    end
    assign btn_rise = btn_stable & ~btn_prev;

    // ---------------------------------------------------------
    // モードレジスタ
    // ---------------------------------------------------------
    typedef enum logic [1:0] {
        MODE_SHIFT   = 2'd0,
        MODE_RIDER   = 2'd1,
        MODE_COUNTER = 2'd2,
        MODE_BREATH  = 2'd3
    } mode_t;

    mode_t mode;

    always_ff @(posedge sys_clk) begin
        if (rst)           mode <= MODE_SHIFT;
        else if (btn_rise) mode <= mode_t'(mode + 2'd1);
    end

    // ---------------------------------------------------------
    // パターン更新タイミング (STEP_HZ)
    // ---------------------------------------------------------
    localparam int STEP_MAX = CLK_FREQ / STEP_HZ - 1;
    localparam int STEP_W   = $clog2(STEP_MAX + 1);

    logic [STEP_W-1:0] step_cnt;
    logic              step;

    always_ff @(posedge sys_clk) begin
        if (rst || step_cnt == STEP_W'(STEP_MAX)) step_cnt <= '0;
        else                             step_cnt <= step_cnt + 1'b1;
    end
    assign step = (step_cnt == STEP_W'(STEP_MAX));

    // ---------------------------------------------------------
    // パターン生成
    // ---------------------------------------------------------
    logic [7:0] shift_pat;    // 流れるLED
    logic [7:0] rider_pat;    // ナイトライダー
    logic       rider_dir;    // 1: L8方向, 0: L1方向
    logic [7:0] count_pat;    // バイナリカウンタ

    always_ff @(posedge sys_clk) begin
        if (rst || btn_rise) begin
            shift_pat <= 8'b0000_0001;
            rider_pat <= 8'b0000_0001;
            rider_dir <= 1'b1;
            count_pat <= 8'd0;
        end else if (step) begin
            shift_pat <= {shift_pat[6:0], shift_pat[7]};

            if (rider_dir) begin
                rider_pat <= rider_pat << 1;
                if (rider_pat[6]) rider_dir <= 1'b0;
            end else begin
                rider_pat <= rider_pat >> 1;
                if (rider_pat[1]) rider_dir <= 1'b1;
            end

            count_pat <= count_pat + 8'd1;
        end
    end

    // ---------------------------------------------------------
    // ホタル: 約 1.3 秒周期で明るさを三角波状に変化させる PWM
    //   PWM キャリア : 50MHz / 2^16 ≒ 763Hz
    //   明るさ       : キャリア 2 周期ごとに 1 段階 (0..255) 増減
    // ---------------------------------------------------------
    logic [15:0] pwm_cnt;
    logic [9:0]  bright_phase;  // [9]=減光中, [8:1]=明るさ
    logic [7:0]  brightness;
    logic [15:0] duty;
    logic        pwm_out;

    always_ff @(posedge sys_clk) begin
        if (rst) begin
            pwm_cnt      <= '0;
            bright_phase <= '0;
        end else begin
            pwm_cnt <= pwm_cnt + 1'b1;
            if (&pwm_cnt) bright_phase <= bright_phase + 1'b1;
        end
    end

    assign brightness = bright_phase[9] ? ~bright_phase[8:1] : bright_phase[8:1];
    // 明るさを2乗して目の感度に近づける (簡易ガンマ補正)
    assign duty       = brightness * brightness;
    assign pwm_out    = (pwm_cnt < duty);

    // ---------------------------------------------------------
    // 出力 (アクティブLow)
    // ---------------------------------------------------------
    logic [7:0] led;

    always_comb begin
        unique case (mode)
            MODE_SHIFT:   led = shift_pat;
            MODE_RIDER:   led = rider_pat;
            MODE_COUNTER: led = count_pat;
            MODE_BREATH:  led = {8{pwm_out}};
            default:      led = 8'h00;
        endcase
    end

    always_ff @(posedge sys_clk) led_n <= ~led;

endmodule

// =============================================================================
// SC1602 ForgeFPGA スクロールデモ  v3
// ボード   : Shrike-lite (SLG47910V)
// LCDモジュール: Pmod_SC1602 (Lathe-Mariel/Pmod)
//
// ---- PMOD コネクタ ↔ FPGA GPIO 配線 (Shrike-lite 実基板より) --------------
//
//  PMOD Pin  FPGA GPIO  モジュール信号  SC1602 / 周辺    説明
//    1        GPIO 14    D0            DB4 (pin 11)     データビット4 (LSB)
//    2        GPIO 12    D2            DB6 (pin 13)     データビット6
//    3        GPIO 10    RS            RS  (pin  4)     Register Select
//    4        GPIO  8    R/W           R/W (pin  5)     Read/Write (常時 LOW = Write only)
//    5        GPIO 15    D3            DB7 (pin 14)     データビット7 (MSB)
//    6        GPIO 13    D1            DB5 (pin 12)     データビット5
//    7        GPIO 11    Co            Q1 ベース        コントラスト PWM 1kHz Duty20%
//    8        GPIO  9    E             E   (pin  6)     Enable パルス
//
// ⚠️  データバスは PMOD ピン順と DB ビット順が一致していない点に注意:
//       論理ビット  DB4  DB5  DB6  DB7
//       PMOD Pin    1    6    2    5
//       FPGA GPIO   14   13   12   15
//
// 表示内容 : "ForgeFPGA" + スペース7文字 = 16文字を左方向に連続スクロール
// クロック : SLG47910V 内蔵 50 MHz HSOSC
// =============================================================================

(* top *) module top (
  (* iopad_external_pin, clkbuf_inhibit *)    input  sys_clk,   // 内蔵 50 MHz オシレータ（IO Plannerで割り当て）
  (* iopad_external_pin *) output clk_en,    //
  (* iopad_external_pin *) output pmod1,     // GPIO 14  D0  → SC1602 DB4
  (* iopad_external_pin *) output pmod1_en,
  (* iopad_external_pin *) output pmod2,     // GPIO 12  D2  → SC1602 DB6
  (* iopad_external_pin *) output pmod2_en,
  (* iopad_external_pin *) output pmod3,     // GPIO 10  RS  → SC1602 RS
  (* iopad_external_pin *) output pmod3_en,
  (* iopad_external_pin *) output pmod4,     // GPIO  8  R/W → SC1602 R/W (常時 LOW)
  (* iopad_external_pin *) output pmod4_en,
  (* iopad_external_pin *) output pmod5,     // GPIO 15  D3  → SC1602 DB7
  (* iopad_external_pin *) output pmod5_en,
  (* iopad_external_pin *) output pmod6,     // GPIO 13  D1  → SC1602 DB5
  (* iopad_external_pin *) output pmod6_en,
  (* iopad_external_pin *) output pmod7,     // GPIO 11  Co  → Q1（コントラスト PWM 1kHz Duty20%）
  (* iopad_external_pin *) output pmod7_en,
  (* iopad_external_pin *) output pmod8,     // GPIO  9  E   → SC1602 E (pin 6)
  (* iopad_external_pin *) output pmod8_en,
  (* iopad_external_pin *) output led,           // GPIO 16  デバッグ用 LED（1秒間隔点滅）
  (* iopad_external_pin *) output led_en           // GPIO 16  デバッグ用 LED（1秒間隔点滅）  
);

    // -------------------------------------------------------------------------
    // 内蔵 50 MHz クロック
    // IO Planner で sys_clk に内蔵オシレータを割り当てること
    // -------------------------------------------------------------------------

    // -------------------------------------------------------------------------
    // 出力イネーブル: 全ピン常時ドライブ（常時 HIGH）
    // -------------------------------------------------------------------------
    assign clk_en   = 1'b1;
    assign pmod1_en = 1'b1;
    assign pmod2_en = 1'b1;
    assign pmod3_en = 1'b1;
    assign pmod4_en = 1'b1;
    assign pmod5_en = 1'b1;
    assign pmod6_en = 1'b1;
    assign pmod7_en = 1'b1;
    assign pmod8_en = 1'b1;
    assign led_en = 1'b1;
    
    // -------------------------------------------------------------------------
    // コントローラからの論理信号
    // -------------------------------------------------------------------------
    wire lcd_rs;
    wire lcd_e;
    wire [3:0] lcd_db;   // lcd_db[3:0] = {DB7, DB6, DB5, DB4}

    lcd_scroll_ctrl u_ctrl (
        .clk    (sys_clk),
        .lcd_rs (lcd_rs),
        .lcd_e  (lcd_e),
        .lcd_db (lcd_db)
    );

    // -------------------------------------------------------------------------
    // PMOD ピンへの物理マッピング
    //   論理         PMOD Pin  FPGA GPIO
    //   DB4 (db[0])  1         GPIO 14
    //   DB6 (db[2])  2         GPIO 12
    //   RS           3         GPIO 10
    //   R/W          4         GPIO  8
    //   DB7 (db[3])  5         GPIO 15
    //   DB5 (db[1])  6         GPIO 13
    //   Co (PWM)     7         GPIO 11
    //   E            8         GPIO  9
    // -------------------------------------------------------------------------
    assign pmod1 = lcd_db[0];   // DB4
    assign pmod2 = lcd_db[2];   // DB6
    assign pmod3 = lcd_rs;      // RS
    assign pmod4 = 1'b0;         // R/W 常時 LOW（Write only）
    assign pmod5 = lcd_db[3];   // DB7
    assign pmod6 = lcd_db[1];   // DB5

    // コントラスト: Duty 20% PWM（約 1 kHz）
    // 50 MHz / 50_000 = 1 kHz  → 周期 50_000 サイクル
    // Hi期間: 0 〜 9_999（10_000サイクル = 20%）
    // Lo期間: 10_000 〜 49_999（40_000サイクル = 80%）
    /*
    reg [15:0] pwm_cnt = 17'd0;
    reg        pwm_co  = 1'b1;
    always @(posedge sys_clk) begin
        if (pwm_cnt == 17'd49_999) begin
            pwm_cnt <= 17'd0;
            pwm_co  <= 1'b1;
        end else begin
            pwm_cnt <= pwm_cnt + 17'd1;
            if (pwm_cnt == 17'd45_999)
                pwm_co <= 1'b0;
        end
    end*/
    assign pmod7 = 1'b0;//pwm_co;      // Co（コントラスト）

    assign pmod8 = lcd_e;       // E

    // -------------------------------------------------------------------------
    // デバッグ用 LED: 1秒間隔点滅（0.5Hz トグル）
    // 50 MHz × 0.5s = 25_000_000 サイクルごとにトグル
    reg [24:0] led_cnt = 25'd0;
    reg        led_reg = 1'b0;
    always @(posedge sys_clk) begin
        if (led_cnt == 25'd14_999_999) begin
            led_cnt <= 25'd0;
            led_reg <= ~led_reg;
        end else
            led_cnt <= led_cnt + 25'd1;
    end
    assign led = led_reg;

endmodule


// =============================================================================
// lcd_scroll_ctrl
//  ・HD44780 4ビットモード初期化
//  ・"ForgeFPGA       " (16文字) を DDRAM 0x00 から書き込み
//  ・0x18 コマンド（Display Shift Left）を 500ms ごとに送信してスクロール
//
//  インタフェース:
//    lcd_db[3:0] = {DB7, DB6, DB5, DB4}  ← 論理バス（物理ピン並び替えはtopで行う）
// =============================================================================
module lcd_scroll_ctrl (
    input  wire       clk,
    output reg        lcd_rs,
    output reg        lcd_e,
    output reg  [3:0] lcd_db    // [3]=DB7 [2]=DB6 [1]=DB5 [0]=DB4
);

    // -------------------------------------------------------------------------
    // タイミング定数（50 MHz = 20 ns/cycle）
    // -------------------------------------------------------------------------
    localparam [26:0]
        T_15MS   = 27'd750_000,    // 15 ms  電源投入後待機
        T_5MS    = 27'd250_000,    // 5 ms   初期化ニブル1回目後
        T_1MS    = 27'd50_000,     // 1 ms   初期化ニブル2・3回目後
        T_2MS    = 27'd100_000,    // 2 ms   Clear Display 後待機
        T_40US   = 27'd2_000,      // 40 us  通常コマンド実行待ち
        T_EPW    = 27'd50,         // 500 ns Eパルス幅（最小230ns）
        T_SCROLL = 27'd12_500_000; // 500 ms スクロール間隔

    // -------------------------------------------------------------------------
    // ステート定義
    // -------------------------------------------------------------------------
    localparam [6:0]
        S_PWRON    = 7'd0,
        S_INIT1_HI = 7'd1,   // 0x3 ニブル 1回目 E High
        S_INIT1_LO = 7'd2,   // 0x3 ニブル 1回目 E Low → 5ms待機
        S_INIT2_HI = 7'd3,   // 0x3 ニブル 2回目 E High
        S_INIT2_LO = 7'd4,   // 0x3 ニブル 2回目 E Low → 1ms待機
        S_INIT3_HI = 7'd5,   // 0x3 ニブル 3回目 E High
        S_INIT3_LO = 7'd6,   // 0x3 ニブル 3回目 E Low → 1ms待機
        S_4BIT_HI  = 7'd7,   // 0x2 ニブル E High（4bitモード切替）
        S_4BIT_LO  = 7'd8,   // 0x2 ニブル E Low
        S_FUNC     = 7'd9,   // Function Set 0x28
        S_DISP     = 7'd10,  // Display ON   0x0C
        S_CLR      = 7'd11,  // Clear Display 0x01
        S_CLR_WAIT = 7'd12,  // Clear 完了待機
        S_ENTRY    = 7'd13,  // Entry Mode   0x06
        S_WR_ADDR  = 7'd14,  // DDRAM addr   0x80
        S_WR_CHAR  = 7'd15,  // 文字書き込みループ
        S_SC_WAIT  = 7'd16,  // スクロール間隔待機
        S_SC_CMD   = 7'd17,  // Display Shift Left 0x18
        S_TX       = 7'd20,  // バイト送信: ニブル分解
        S_TX_HI_E1 = 7'd21,  // 上位ニブル E High
        S_TX_HI_EW = 7'd26,  // 上位ニブル E High 幅待ち（T_EPW）
        S_TX_HI_E0 = 7'd22,  // 上位ニブル E Low
        S_TX_LO_E1 = 7'd23,  // 下位ニブル E High
        S_TX_LO_EW = 7'd27,  // 下位ニブル E High 幅待ち（T_EPW）
        S_TX_LO_E0 = 7'd24,  // 下位ニブル E Low
        S_TX_WAIT  = 7'd25,  // コマンド実行完了待ち
        S_WAIT     = 7'd30,  // 汎用タイマー待機
        
        S_STOP     = 7'd31,

        S_TX1      = 7'd37,
        S_TX11      = 7'd38,
        S_TX12      = 7'd39,
        S_TX13      = 7'd40,
        
        S_11        = 7'd41,
        S_12        = 7'd42,
        S_13        = 7'd43,
        S_14        = 7'd44,
        
        S_F2        = 7'd54,
        S_F3        = 7'd55,
        S_F4        = 7'd56,
        
        S_D2        = 7'd58,
        S_D3        = 7'd59,
        S_D4        = 7'd60,
        
        S_E2        = 7'd66,
        S_E3        = 7'd67,
        S_E4        = 7'd68,
 
        S_W2        = 7'd70,
        S_W3        = 7'd71,
        S_W4        = 7'd72,
        
        S_WRC1        = 7'd73,
        S_WRC2        = 7'd74,
        S_WRC3        = 7'd75,
        S_WRC4        = 7'd76,
        
        S_SC2        = 7'd78,
        S_SC3        = 7'd79,
        S_SC4        = 7'd80;
        
    reg [6:0]  state;
    reg [6:0]  ret_state;
    reg [26:0] timer;
    
    reg [7:0] reset_counter=0;

    // バイト送信パラメータ
    reg [7:0] tx_data;

    // 文字データ（"ForgeFPGA" + スペース7個 = 16文字）
    reg [7:0] msg [15:0]; //={8'h46, 8'h6F, 8'h72, 8'h67, 8'h65, 8'h46, 8'h50, 8'h47, 8'h41, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
    reg [4:0] cidx;

    // =========================================================================
    // ステートマシン
    // =========================================================================
    always @(posedge clk) begin
      if(reset_counter < 8'd254)begin
        reset_counter <= reset_counter + 8'd1;
            msg[0]  <= 8'h46; // 'F'
            msg[1]  <= 8'h6F; // 'o'
            msg[2]  <= 8'h72; // 'r'
            msg[3]  <= 8'h67; // 'g'
            msg[4]  <= 8'h65; // 'e'
            msg[5]  <= 8'h46; // 'F'
            msg[6]  <= 8'h50; // 'P'
            msg[7]  <= 8'h47; // 'G'
            msg[8]  <= 8'h41; // 'A'
            msg[9]  <= 8'h20; // ' '
            msg[10] <= 8'h20; // ' '
            msg[11] <= 8'h20; // ' '
            msg[12] <= 8'h20; // ' '
            msg[13] <= 8'h20; // ' '
            msg[14] <= 8'h20; // ' '
            msg[15] <= 8'h39; // '@'  
            timer   <= T_15MS;
            state   <= S_PWRON;
            ret_state <= S_PWRON;
            cidx      <= 5'd0;
            tx_data   <= 8'h00;
            lcd_e     <= 1'b0;
            lcd_db    <= 4'h0;
      end else begin
        case (state)

            // -----------------------------------------------------------------
            // 電源投入後 15ms 待機
            // -----------------------------------------------------------------
            S_PWRON: begin
                
                lcd_rs <= 1'b0;
                lcd_e  <= 1'b0;
                lcd_db <= 4'b0000;
                if (timer == 27'd0)
                    state <= S_INIT1_HI;
                else
                    timer <= timer - 27'd1;
            end

            // -----------------------------------------------------------------
            // 初期化: 0x3 ニブル 1回目
            //   _HI : データをバスに乗せて E High、T_EPW カウント開始
            //   _LO : E Low、所定時間待機後に次のステートへ
            // -----------------------------------------------------------------
            S_INIT1_HI: begin
                lcd_rs <= 1'b0;
                lcd_db <= 4'b0011;   // DB7〜DB4 = 0011（= 0x3）
                lcd_e  <= 1'b1;
                timer  <= T_EPW;
                state  <= S_INIT1_LO;
            end
            S_INIT1_LO: begin
                if (timer == 27'd0) begin
                    lcd_e     <= 1'b0;
                    timer     <= T_5MS;
                    ret_state <= S_INIT2_HI;
                    state     <= S_WAIT;
                end else
                    timer <= timer - 27'd1;
            end

            // 0x3 ニブル 2回目（→ 1ms待機）
            S_INIT2_HI: begin
                lcd_rs <= 1'b0;
                lcd_db <= 4'b0011;
                lcd_e  <= 1'b1;
                timer  <= T_EPW;
                state  <= S_INIT2_LO;
            end
            S_INIT2_LO: begin
                if (timer == 27'd0) begin
                    lcd_e     <= 1'b0;
                    timer     <= T_1MS;
                    state <= S_INIT3_HI;
                end else
                    timer <= timer - 27'd1;
            end

            // 0x3 ニブル 3回目（→ 1ms待機）
            S_INIT3_HI: begin
                if(timer == 27'd0)begin
                    lcd_e  <= 1'b1;
                    lcd_rs <= 1'b0;
                    lcd_db <= 4'b0011;
                    timer  <= T_EPW;
                    state  <= S_INIT3_LO;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            S_INIT3_LO: begin
                if (timer == 27'd0) begin
                    lcd_e     <= 1'b0;
                    timer     <= T_1MS;
                    ret_state <= S_4BIT_HI;
                    state     <= S_WAIT;
                end else
                    timer <= timer - 27'd1;
            end

            // -----------------------------------------------------------------
            // 4ビットモード切替: 0x2 ニブルのみ送信（上位ニブルのみ、E1パルス）
            // -----------------------------------------------------------------
            S_4BIT_HI: begin
                lcd_e  <= 1'b1;
                lcd_rs <= 1'b0;
                lcd_db <= 4'b0010;   // DB7〜DB4 = 0010（= 0x2）
                timer  <= T_EPW;
                state  <= S_4BIT_LO;
            end
                
            S_4BIT_LO: begin
                if (timer == 27'd0) begin
                    lcd_e     <= 1'b0;
                    timer     <= T_40US;
                    state     <= S_TX1;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
// -----------------------------------------------------------------
// FUNCTION SET
// -----------------------------------------------------------------
            S_TX1: begin  // 上位ニブル: DB7〜DB4 の論理値
                if(timer == 27'd0)begin
                lcd_rs <= 1'd0;
                lcd_db <= 4'h2;
                lcd_e  <= 1'b1;
                timer  <= T_EPW;
                state  <= S_TX11;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_TX11:begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_EPW;
                    state <= S_TX12;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            S_TX12: begin   // 下位ニブル E Low
                if (timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'h8;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state <= S_TX13;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_TX13:begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_40US;
                    state  <= S_11;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            // -----------------------------------------------------------------
            // 汎用タイマー待機
            // -----------------------------------------------------------------
            S_WAIT: begin
                if (timer == 27'd0)
                    state <= ret_state;
                else
                    timer <= timer - 27'd1;
            end

//------------------------
//DISPLAY OFF
//------------------------            
            S_11: begin  // 上位ニブル: DB7〜DB4 の論理値
                if(timer == 27'd0)begin
                lcd_rs <= 1'd0;
                lcd_db <= 4'h0;
                lcd_e  <= 1'b1;
                timer  <= T_EPW;
                state  <= S_12;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_12:begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_EPW;
                    state <= S_13;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            S_13: begin   // 下位ニブル E Low
                if (timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'h8;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state <= S_14;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_14: begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_40US;
                    state  <= S_FUNC;
                end else begin
                    timer <= timer -27'd1;
                end
            end          

// --------------------------------------
// Display ON / Cursor OFF / Blink OFF
// --------------------------------------
            S_FUNC: begin  // 上位ニブル: DB7〜DB4 の論理値
                if(timer == 27'd0)begin
                lcd_rs <= 1'd0;
                lcd_db <= 4'h0;
                lcd_e  <= 1'b1;
                timer  <= T_EPW;
                state  <= S_F2;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_F2: begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_EPW;
                    state <= S_F3;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            S_F3: begin   // 下位ニブル E Low
                if (timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'hc;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state <= S_F4;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_F4: begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_40US;
                    state  <= S_DISP;
                end else begin
                    timer <= timer -27'd1;
                end
            end
            
//----------------
// Clear Display（実行に1.64ms必要）
//----------------
            S_DISP: begin  // 上位ニブル: DB7〜DB4 の論理値
                if(timer == 27'd0)begin
                lcd_rs <= 1'd0;
                lcd_db <= 4'h0;
                lcd_e  <= 1'b1;
                timer  <= T_EPW;
                state  <= S_D2;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_D2: begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_EPW;
                    state <= S_D3;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            S_D3: begin   // 下位ニブル E Low
                if (timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'h1;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state <= S_D4;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_D4: begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_2MS;
                    state  <= S_ENTRY;
                end else begin
                    timer <= timer -27'd1;
                end
            end

//------------------
// Entry Mode: DDRAM++
//------------------
            S_ENTRY: begin  // 上位ニブル: DB7〜DB4 の論理値
                if(timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'h0;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state  <= S_E2;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_E2:begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_EPW;
                    state <= S_E3;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            S_E3: begin   // 下位ニブル E Low
                if (timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'h6;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state <= S_E4;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_E4: begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_40US;
                    state <= S_WR_ADDR;
                end else begin
                    timer <= timer - 27'd1;
                end
            end

// -----------------------------------------------------------------
//  set address// Set DDRAM Address = 0x00
// -----------------------------------------------------------------
            S_WR_ADDR: begin  // 上位ニブル
//                cidx      <= 5'd0;
                if(timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'h8;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state  <= S_W2;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_W2:begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_EPW;
                    state <= S_W3;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            S_W3: begin   // 下位ニブル
                if (timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= cidx[3:0];  // 4'hF;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state <= S_W4;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_W4: begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_40US;
                    state <= S_WR_CHAR;
                end else begin
                    timer <= timer - 27'd1;
                end
            end

// -----------------------------------------------------------------
// 文字書き込み
// -----------------------------------------------------------------
            S_WR_CHAR: begin
              if(timer == 27'd0)begin
                if (cidx < 5'd16) begin
                    tx_data   <= msg[cidx[3:0]];
                    cidx      <= cidx + 5'd1;
                    timer     <= T_EPW;
                    state     <= S_WRC1;
                end else begin
                    timer <= T_SCROLL;
                    state <= S_SC_WAIT;                    
                end
              end else begin
                  timer <= timer - 27'd1 ;
              end
            end
            
            S_WRC1: begin  // 上位ニブル: DB7〜DB4 の論理値
                if(timer == 27'd0)begin
                lcd_rs <= 1'd1;
                lcd_db <= tx_data[7:4];
                lcd_e  <= 1'b1;
                timer  <= T_EPW;
                state  <= S_WRC2;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_WRC2:begin
                if(timer == 27'd0) begin
                    lcd_rs <= 1'b1;
                    lcd_e <= 1'b0;
                    timer <= T_EPW;
                    state <= S_WRC3;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            S_WRC3: begin   // 下位ニブル E Low
                if (timer == 27'd0)begin
                    lcd_rs <= 1'd1;
                    lcd_db <= tx_data[3:0];
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state <= S_WRC4;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_WRC4: begin
                if(timer == 27'd0) begin
                    lcd_rs <= 1'b1;
                    lcd_e <= 1'b0;
                    timer <= T_40US;
//                  state <= S_WR_CHAR;
                    state <= S_WR_ADDR;
                end else begin
                    timer <= timer - 27'd1;
                end
            end

//Scroll Wait
            S_SC_WAIT: begin
                if (timer == 27'd0)
                    state <= S_SC_CMD;
                else
                    timer <= timer - 27'd1;
            end
// -----------------------------------------------------------------
// スクロール制御
// -----------------------------------------------------------------
            S_SC_CMD: begin  // 上位ニブル: DB7〜DB4 の論理値
                if(timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'h1;
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state  <= S_SC2;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_SC2:begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_EPW;
                    state <= S_SC3;
                end else begin
                    timer <= timer -27'd1;
                end
            end

            S_SC3: begin   // 下位ニブル E Low
                if (timer == 27'd0)begin
                    lcd_rs <= 1'd0;
                    lcd_db <= 4'h8;  // scroll direction(8:Left, c:Right)
                    lcd_e  <= 1'b1;
                    timer  <= T_EPW;
                    state <= S_SC4;
                end else begin
                    timer <= timer - 27'd1;
                end
            end
            
            S_SC4: begin
                if(timer == 27'd0) begin
                    lcd_e <= 1'b0;
                    timer <= T_SCROLL;
                    state <= S_SC_WAIT;
                end else begin
                    timer <= timer - 27'd1;
                end
            end

            default: state <= S_PWRON;
        endcase
      end
    end

    // =========================================================================
    // 初期値
    // =========================================================================
    initial begin

//        timer     = T_15MS;

    end

endmodule
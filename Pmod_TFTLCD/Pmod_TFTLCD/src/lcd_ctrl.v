// ============================================================
// lcd_ctrl.v - ILI9341 SPI LCD Controller
// Tang Primer 25K + PMOD-TFTLCD v1.1
//
// Display : 320 x 240, RGB565 (16-bit color)
// Interface: 4-wire SPI (CS, DC, MOSI, SCK)
// SPI clock: 50MHz / 4 = 12.5MHz
//
// RST : ボード側VCC固定 → SW Reset(0x01)コマンドで代替
// BLK : ボード側VCC固定 → FPGA未接続
// リセット: ユーザボタン H11 (押下=Low) で非同期リセット
//
// ★ initial文廃止: 初期化ROMをlocalparam + case文(関数)で実装
// ★ 全レジスタを always @(posedge clk or negedge rst_n) で統一
//
// 8色縦縞テストパターン (各40px × 8 = 320px):
//   col   0- 39 : 白       0xFFFF
//   col  40- 79 : 黄       0xFFE0
//   col  80-119 : シアン   0x07FF
//   col 120-159 : 緑       0x07E0
//   col 160-199 : マゼンタ 0xF81F
//   col 200-239 : 赤       0xF800
//   col 240-279 : 青       0x001F
//   col 280-319 : 黒       0x0000
// ============================================================

module lcd_ctrl (
    input  wire clk,       // 50 MHz
    input  wire btn_rst,   // ユーザボタン H11 (押下=Low, 非同期リセット)
    output reg  lcd_cs,    // G5  Chip Select (Low有効)
    output reg  lcd_dc,    // K11 Data/Command (RS)
    output reg  lcd_mosi,  // G8  SPI MOSI
    output reg  lcd_sck    // J5  SPI Clock
);

// ============================================================
// ユーザボタン 2段同期化 + リセット生成
//   ボタン押下=Low → rst_n=0 でリセット
// ============================================================
reg btn_r1, btn_r2;
always @(posedge clk) begin
    btn_r1 <= btn_rst;
    btn_r2 <= btn_r1;
end
wire rst_n = btn_r2;

// ============================================================
// 初期化シーケンス ROM  (initial文不使用)
//
//   localparam で全エントリを定数として定義し、
//   rom_read() 関数の case 文でアドレスに応じて返す。
//   合成ツールはこれをROM/MUXとして実装する。
//
//   bit[8]=0 → コマンド送信 (DC=Low)
//   bit[8]=1 → データ送信  (DC=High)
//
//   特殊コマンド後の待機 (ステートマシン側で対応):
//     0x01 (SW Reset)  → 5ms 待機
//     0x11 (Sleep Out) → 120ms 待機
// ============================================================
localparam [6:0] ROM_DEPTH = 7'd68;
//localparam [6:0] ROM_DEPTH = 7'd105;

localparam [8:0]
    ROM_00 = 9'h001,  // SW Reset        CMD
    ROM_01 = 9'h011,  // Sleep Out       CMD
    ROM_02 = 9'h0C0,  // Power Ctrl 1    CMD
    ROM_03 = 9'h123,  //                 DAT 0x23
    ROM_04 = 9'h0C1,  // Power Ctrl 2    CMD
    ROM_05 = 9'h110,  //                 DAT 0x10
    ROM_06 = 9'h0C5,  // VCOM Ctrl 1     CMD
    ROM_07 = 9'h13E,  //                 DAT 0x3E
    ROM_08 = 9'h128,  //                 DAT 0x28
    ROM_09 = 9'h0C7,  // VCOM Ctrl 2     CMD
    ROM_10 = 9'h186,  //                 DAT 0x86
    ROM_11 = 9'h036,  // Mem Access Ctrl CMD
    ROM_12 = 9'h1E8,  //                 DAT 0x28 (MV=1, BGR=1, 320x240)  !
    ROM_13 = 9'h03A,  // Pixel Format    CMD
    ROM_14 = 9'h155,  //                 DAT 0x55 (16bit RGB565)
    ROM_15 = 9'h0B1,  // Frame Rate      CMD
    ROM_16 = 9'h100,  //                 DAT 0x00
    ROM_17 = 9'h11B,  //                 DAT 0x1B  !
    ROM_18 = 9'h0B6,  // Disp Func Ctrl  CMD
    ROM_19 = 9'h108,  //                 DAT 0x08
    ROM_20 = 9'h182,  //                 DAT 0x82
    ROM_21 = 9'h127,  //                 DAT 0x27
    ROM_22 = 9'h026,  // Gamma Set       CMD
    ROM_23 = 9'h101,  //                 DAT 0x01
    ROM_24 = 9'h0E0,  // Pos Gamma       CMD (以下15バイト)
    ROM_25 = 9'h10F,  ROM_26 = 9'h131,  ROM_27 = 9'h12B,
    ROM_28 = 9'h10C,  ROM_29 = 9'h10E,  ROM_30 = 9'h108,
    ROM_31 = 9'h14E,  ROM_32 = 9'h1F1,  ROM_33 = 9'h137,
    ROM_34 = 9'h107,  ROM_35 = 9'h110,  ROM_36 = 9'h103,
    ROM_37 = 9'h10E,  ROM_38 = 9'h109,  ROM_39 = 9'h100,
    ROM_40 = 9'h0E1,  // Neg Gamma       CMD (以下15バイト)
    ROM_41 = 9'h100,  ROM_42 = 9'h10E,  ROM_43 = 9'h114,
    ROM_44 = 9'h103,  ROM_45 = 9'h111,  ROM_46 = 9'h107,
    ROM_47 = 9'h131,  ROM_48 = 9'h1C1,  ROM_49 = 9'h148,
    ROM_50 = 9'h108,  ROM_51 = 9'h10F,  ROM_52 = 9'h10C,
    ROM_53 = 9'h131,  ROM_54 = 9'h136,  ROM_55 = 9'h10F,
    ROM_56 = 9'h02A,  // Column Addr Set CMD (0~239)
    ROM_57 = 9'h100,  ROM_58 = 9'h100,
    ROM_59 = 9'h101,  ROM_60 = 9'h13F,
    ROM_61 = 9'h02B,  // Row Addr Set    CMD (0~319)
    ROM_62 = 9'h100,  ROM_63 = 9'h100,
    ROM_64 = 9'h100,  ROM_65 = 9'h1EF,
    ROM_66 = 9'h029,  // Display ON      CMD
    ROM_67 = 9'h02C;  // Memory Write    CMD (ピクセルデータ開始)

/*
localparam [8:0]
ROM_00 = 9'h0CA,
ROM_01 = 9'h1C3,
ROM_02 = 9'h108,
ROM_03 = 9'h150,
ROM_04 = 9'h0CF, //LCD_POWERB   Power control B
ROM_05 = 9'h100,
ROM_06 = 9'h1C1,
ROM_07 = 9'h130,
ROM_08 = 9'h0ED, //LCD_POWER_SEQ  6 Power on sequence control
ROM_09 = 9'h164,
ROM_10 = 9'h103,
ROM_11 = 9'h112,
ROM_12 = 9'h181,
ROM_13 = 9'h0E8, //LCD_DTCA  Driver timing control A
ROM_14 = 9'h185,
ROM_15 = 9'h100,
ROM_16 = 9'h178,
ROM_17 = 9'h0CB, //LCD_POWERA  Power control A
ROM_18 = 9'h139,
ROM_19 = 9'h12C,
ROM_20 = 9'h100,
ROM_21 = 9'h134,
ROM_22 = 9'h102,
ROM_23 = 9'h0F7, //LCD_PRC  Pump ratio control 
ROM_24 = 9'h120,
ROM_25 = 9'h0EA, //LCD_DTCB  Driver timing control B
ROM_26 = 9'h100,
ROM_27 = 9'h100,
ROM_28 = 9'h0B1, //LCD_FRMCTR1  Frame Rate Control (In Normal Mode/Full Colors) 
ROM_29 = 9'h100,
ROM_30 = 9'h11B,
ROM_31 = 9'h0B6, //LCD_DFC  Display Function Control 
ROM_32 = 9'h10A,
ROM_33 = 9'h1A2,
ROM_34 = 9'h0C0, //LCD_POWER1  Power Control 1
ROM_35 = 9'h110,
ROM_36 = 9'h0C1, //LCD_POWER2 
ROM_37 = 9'h110,
ROM_38 = 9'h0C5, //LCD_VCOM1  VCOM Control 1
ROM_39 = 9'h145,
ROM_40 = 9'h115,
ROM_41 = 9'h0C7, //LCD_VCOM2 
ROM_42 = 9'h190,
ROM_43 = 9'h036, //LCD_MAC  Memory Access Control 
ROM_44 = 9'h1C0, // C8
ROM_45 = 9'h0F2, //LCD_3GAMMA_EN 
ROM_46 = 9'h100,
ROM_47 = 9'h0B0, //LCD_RGB_INTERFACE 
ROM_48 = 9'h1C2,
ROM_49 = 9'h0B6, //LCD_DFC 
ROM_50 = 9'h10A,
ROM_51 = 9'h1A7,
ROM_52 = 9'h127,
ROM_53 = 9'h104,

ROM_54 = 9'h02A, //LCD_COLUMN_ADDR 
ROM_55 = 9'h100,
ROM_56 = 9'h100,
ROM_57 = 9'h100,
ROM_58 = 9'h1EF,

ROM_59 = 9'h02B, //LCD_PAGE_ADDR 
ROM_60 = 9'h100,
ROM_61 = 9'h100,
ROM_62 = 9'h101,
ROM_63 = 9'h13F,
ROM_64 = 9'h0F6, //LCD_INTERFACE 
ROM_65 = 9'h101,
ROM_66 = 9'h100,
ROM_67 = 9'h106,

ROM_68 = 9'h02C, //LCD_GRAM 

ROM_69 = 9'h026, //LCD_GAMMA 
ROM_70 = 9'h101, 

ROM_71 = 9'h0E0, //LCD_PGAMMA 
ROM_72 = 9'h10F,
ROM_73 = 9'h129,
ROM_74 = 9'h124,
ROM_75 = 9'h10C,
ROM_76 = 9'h10E,
ROM_77 = 9'h109,
ROM_78 = 9'h14E,
ROM_79 = 9'h178,
ROM_80 = 9'h13C,
ROM_81 = 9'h109,
ROM_82 = 9'h113,
ROM_83 = 9'h105,
ROM_84 = 9'h117,
ROM_85 = 9'h111,
ROM_86 = 9'h100,
ROM_87 = 9'h0E1, //LCD_NGAMMA 
ROM_88 = 9'h100,
ROM_89 = 9'h116,
ROM_90 = 9'h11B,
ROM_91 = 9'h104,
ROM_92 = 9'h111,
ROM_93 = 9'h107,
ROM_94 = 9'h131,
ROM_95 = 9'h133,
ROM_96 = 9'h142,
ROM_97 = 9'h105,
ROM_98 = 9'h10C,
ROM_99 = 9'h10A,
ROM_100 = 9'h128,
ROM_101 = 9'h12F,
ROM_102 = 9'h10F,

ROM_103 = 9'h029, //Display ON
ROM_104 = 9'h02C; //LCD_GRAM 
*/

// ROMアクセス関数 (合成時はMUX/LUTに展開される)
function [8:0] rom_read;
    input [6:0] addr;
    case (addr)
        7'd0 : rom_read=ROM_00; 7'd1 : rom_read=ROM_01;
        7'd2 : rom_read=ROM_02; 7'd3 : rom_read=ROM_03;
        7'd4 : rom_read=ROM_04; 7'd5 : rom_read=ROM_05;
        7'd6 : rom_read=ROM_06; 7'd7 : rom_read=ROM_07;
        7'd8 : rom_read=ROM_08; 7'd9 : rom_read=ROM_09;
        7'd10: rom_read=ROM_10; 7'd11: rom_read=ROM_11;
        7'd12: rom_read=ROM_12; 7'd13: rom_read=ROM_13;
        7'd14: rom_read=ROM_14; 7'd15: rom_read=ROM_15;
        7'd16: rom_read=ROM_16; 7'd17: rom_read=ROM_17;
        7'd18: rom_read=ROM_18; 7'd19: rom_read=ROM_19;
        7'd20: rom_read=ROM_20; 7'd21: rom_read=ROM_21;
        7'd22: rom_read=ROM_22; 7'd23: rom_read=ROM_23;
        7'd24: rom_read=ROM_24; 7'd25: rom_read=ROM_25;
        7'd26: rom_read=ROM_26; 7'd27: rom_read=ROM_27;
        7'd28: rom_read=ROM_28; 7'd29: rom_read=ROM_29;
        7'd30: rom_read=ROM_30; 7'd31: rom_read=ROM_31;
        7'd32: rom_read=ROM_32; 7'd33: rom_read=ROM_33;
        7'd34: rom_read=ROM_34; 7'd35: rom_read=ROM_35;
        7'd36: rom_read=ROM_36; 7'd37: rom_read=ROM_37;
        7'd38: rom_read=ROM_38; 7'd39: rom_read=ROM_39;
        7'd40: rom_read=ROM_40; 7'd41: rom_read=ROM_41;
        7'd42: rom_read=ROM_42; 7'd43: rom_read=ROM_43;
        7'd44: rom_read=ROM_44; 7'd45: rom_read=ROM_45;
        7'd46: rom_read=ROM_46; 7'd47: rom_read=ROM_47;
        7'd48: rom_read=ROM_48; 7'd49: rom_read=ROM_49;
        7'd50: rom_read=ROM_50; 7'd51: rom_read=ROM_51;
        7'd52: rom_read=ROM_52; 7'd53: rom_read=ROM_53;
        7'd54: rom_read=ROM_54; 7'd55: rom_read=ROM_55;
        7'd56: rom_read=ROM_56; 7'd57: rom_read=ROM_57;
        7'd58: rom_read=ROM_58; 7'd59: rom_read=ROM_59;
        7'd60: rom_read=ROM_60; 7'd61: rom_read=ROM_61;
        7'd62: rom_read=ROM_62; 7'd63: rom_read=ROM_63;
        7'd64: rom_read=ROM_64; 7'd65: rom_read=ROM_65;
        7'd66: rom_read=ROM_66; 7'd67: rom_read=ROM_67;
/*
        7'd68: rom_read=ROM_68; 7'd69: rom_read=ROM_69;
        7'd70: rom_read=ROM_70; 7'd71: rom_read=ROM_71;
        7'd72: rom_read=ROM_72; 7'd73: rom_read=ROM_73;
        7'd74: rom_read=ROM_74; 7'd75: rom_read=ROM_75;
        7'd76: rom_read=ROM_76; 7'd77: rom_read=ROM_77;
        7'd78: rom_read=ROM_78; 7'd79: rom_read=ROM_79;
        7'd80: rom_read=ROM_80; 7'd81: rom_read=ROM_81;
        7'd82: rom_read=ROM_82; 7'd83: rom_read=ROM_83;
        7'd84: rom_read=ROM_84; 7'd85: rom_read=ROM_85;
        7'd86: rom_read=ROM_86; 7'd87: rom_read=ROM_87;
        7'd88: rom_read=ROM_88; 7'd89: rom_read=ROM_89;
        7'd90: rom_read=ROM_90; 7'd91: rom_read=ROM_91;
        7'd92: rom_read=ROM_92; 7'd93: rom_read=ROM_93;
        7'd94: rom_read=ROM_94; 7'd94: rom_read=ROM_95;
        7'd96: rom_read=ROM_96; 7'd97: rom_read=ROM_97;
        7'd98: rom_read=ROM_98; 7'd99: rom_read=ROM_99;
        7'd100: rom_read=ROM_100; 7'd101: rom_read=ROM_101;
        7'd102: rom_read=ROM_102; 7'd103: rom_read=ROM_103;
        7'd104: rom_read=ROM_104;*/
        default: rom_read = 9'h000;
    endcase
endfunction

// ============================================================
// カラーパレット関数 (RGB565)
// ============================================================
function [15:0] get_color;
    input [8:0] col;
    begin
        if      (col < 9'd40)  get_color = 16'hFFFF; // 白
        else if (col < 9'd80)  get_color = 16'hFFE0; // 黄
        else if (col < 9'd120) get_color = 16'h07FF; // シアン
        else if (col < 9'd160) get_color = 16'h07E0; // 緑
        else if (col < 9'd200) get_color = 16'hF81F; // マゼンタ
        else if (col < 9'd240) get_color = 16'hF800; // 赤
        else if (col < 9'd280) get_color = 16'h001F; // 青
        else                   get_color = 16'h0000; // 黒
    end
endfunction

// ============================================================
// 電源ON後 150ms 待機
//   リセット解除後にカウント開始し、完了で init_start をアサート
//   150ms @ 50MHz = 7,500,000 サイクル
// ============================================================
localparam [23:0] POWERON_WAIT = 24'd7_500_000;

reg [23:0] poweron_cnt;
reg        init_start;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        poweron_cnt <= 24'd0;
        init_start  <= 1'b0;
    end else begin
        if (poweron_cnt == POWERON_WAIT) begin
            init_start <= 1'b1;   // 1クロックパルスで通知
        end else begin
            init_start  <= 1'b0;
            poweron_cnt <= poweron_cnt + 1'b1;
        end
    end
end

// ============================================================
// SPI バイト送信器
//   Mode 0 (CPOL=0, CPHA=0): 立ち上がりエッジでサンプル
//   1ビット=4クロック、1バイト=32クロック (2.56us @ 50MHz)
//
//   tx_cnt[5:2] : ビット番号 (0=MSB, 7=LSB)
//   tx_cnt[1:0] : フェーズ
//     00: MOSI セットアップ
//     01: SCK 立ち上がり (ILI9341 がサンプル)
//     10: SCK High 保持
//     11: SCK 立ち下がり、最終ビットなら送信完了
// ============================================================
reg [7:0] tx_byte;
reg       tx_dc_reg;
reg       tx_start;
reg       tx_busy;
reg [5:0] tx_cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_cs   <= 1'b1;
        lcd_sck  <= 1'b0;
        lcd_mosi <= 1'b0;
        lcd_dc   <= 1'b0;
        tx_busy  <= 1'b0;
        tx_cnt   <= 6'd0;
    end else if (tx_start && !tx_busy) begin
        // 送信開始
        tx_busy  <= 1'b1;
        tx_cnt   <= 6'd0;
        lcd_cs   <= 1'b0;
        lcd_dc   <= tx_dc_reg;
        lcd_sck  <= 1'b0;
        lcd_mosi <= tx_byte[7]; // MSB 先行
    end else if (tx_busy) begin
        tx_cnt <= tx_cnt + 1'b1;
        case (tx_cnt[1:0])
            2'b00: lcd_mosi <= tx_byte[7 - tx_cnt[5:2]]; // データ出力
            2'b01: lcd_sck  <= 1'b1;                     // 立ち上がり
            2'b10: ;                                      // High 保持
            2'b11: begin
                lcd_sck <= 1'b0;
                if (tx_cnt[5:2] == 4'd7) begin           // 8ビット完了
                    tx_busy <= 1'b0;
                    lcd_cs  <= 1'b1;
                end
            end
        endcase
    end
end

// ============================================================
// メインステートマシン
// ============================================================
localparam [3:0]
    S_WAIT       = 4'd0,   // 電源ON待機 (init_start 待ち)
    S_INIT_TX    = 4'd1,   // 初期化ROMエントリ送信要求
    S_INIT_WAIT  = 4'd2,   // SPI 送信完了待ち
    S_SWRST_DLY  = 4'd3,   // SW Reset 後 5ms 待機
    S_SLPOUT_DLY = 4'd4,   // Sleep Out 後 120ms 待機
    S_PIX_CALC   = 4'd5,   // ピクセル色決定
    S_PIX_HI_TX  = 4'd6,   // 上位バイト送信要求
    S_PIX_HI_W   = 4'd7,   // 上位バイト完了待ち
    S_PIX_LO_TX  = 4'd8,   // 下位バイト送信要求
    S_PIX_LO_W   = 4'd9,   // 下位バイト完了待ち
    S_DONE       = 4'd10;  // 表示完了・ボタンリセット待ち

reg [3:0]  state;
reg [6:0]  init_idx;
reg [23:0] dly_cnt;
reg [16:0] pix_cnt;    // 0 .. 76799  (320×240-1)
reg [8:0]  col_cnt;    // 0 .. 319
reg [15:0] cur_color;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state     <= S_WAIT;
        init_idx  <= 7'd0;
        dly_cnt   <= 24'd0;
        pix_cnt   <= 17'd0;
        col_cnt   <= 9'd0;
        cur_color <= 16'd0;
        tx_start  <= 1'b0;
        tx_byte   <= 8'd0;
        tx_dc_reg <= 1'b0;
    end else begin
        tx_start <= 1'b0; // デフォルト: 非アサート

        case (state)

            // ---- 電源ON 150ms 待機 ----
            S_WAIT: begin
                if (init_start) begin
                    init_idx <= 7'd0;
                    state    <= S_INIT_TX;
                end
            end

            // ---- 初期化シーケンス送信 ----
            S_INIT_TX: begin
                if (init_idx < ROM_DEPTH) begin
                    if (!tx_busy && !tx_start) begin
                        {tx_dc_reg, tx_byte} <= rom_read(init_idx);
//                        tx_dc_reg <= rom_read(init_idx)[8];
                        tx_start  <= 1'b1;
                        state     <= S_INIT_WAIT;
                    end
                end else begin
                    // 全エントリ送信完了 → ピクセル転送開始
                    pix_cnt <= 17'd0;
                    col_cnt <= 9'd0;
                    state   <= S_PIX_CALC;
                end
            end

            // ---- SPI 完了待ち & ディレイ判定 ----
            S_INIT_WAIT: begin
                if (!tx_busy && !tx_start) begin
                    case (tx_byte)
                        8'h01: begin    // SW Reset → 5ms 待機
                            dly_cnt <= 24'd0;
                            state   <= S_SWRST_DLY;
                        end
                        8'h11: begin    // Sleep Out → 120ms 待機
                            dly_cnt <= 24'd0;
                            state   <= S_SLPOUT_DLY;
                        end
                        default: begin
                            init_idx <= init_idx + 1'b1;
                            state    <= S_INIT_TX;
                        end
                    endcase
                end
            end

            // ---- SW Reset 後 5ms 待機 ----
            S_SWRST_DLY: begin
                if (dly_cnt == 24'd250_000) begin   // 5ms @ 50MHz
                    init_idx <= init_idx + 1'b1;
                    state    <= S_INIT_TX;
                end else
                    dly_cnt <= dly_cnt + 1'b1;
            end

            // ---- Sleep Out 後 120ms 待機 ----
            S_SLPOUT_DLY: begin
                if (dly_cnt == 24'd6_000_000) begin // 120ms @ 50MHz
                    init_idx <= init_idx + 1'b1;
                    state    <= S_INIT_TX;
                end else
                    dly_cnt <= dly_cnt + 1'b1;
            end

            // ---- ピクセル転送 ----
            S_PIX_CALC: begin
                cur_color <= get_color(col_cnt);
                state     <= S_PIX_HI_TX;
            end

            S_PIX_HI_TX: begin
                if (!tx_busy && !tx_start) begin
                    tx_byte   <= cur_color[15:8];
                    tx_dc_reg <= 1'b1;
                    tx_start  <= 1'b1;
                    state     <= S_PIX_HI_W;
                end
            end

            S_PIX_HI_W: begin
                if (!tx_busy && !tx_start)
                    state <= S_PIX_LO_TX;
            end

            S_PIX_LO_TX: begin
                if (!tx_busy && !tx_start) begin
                    tx_byte   <= cur_color[7:0];
                    tx_dc_reg <= 1'b1;
                    tx_start  <= 1'b1;
                    state     <= S_PIX_LO_W;
                end
            end

            S_PIX_LO_W: begin
                if (!tx_busy && !tx_start) begin
                    col_cnt <= (col_cnt == 9'd319) ? 9'd0 : col_cnt + 9'b1;
                    if (pix_cnt == 17'd76_799)
                        state <= S_DONE;
                    else begin
                        pix_cnt <= pix_cnt + 17'b1;
                        state   <= S_PIX_CALC;
                    end
                end
            end

            // ---- 完了: ボタンリセット待ち ----
            S_DONE: begin
                // パターンはLCD GRAMに保持
                // ユーザボタン押下 → rst_n=0 → 再スタート
            end

            default: state <= S_WAIT;
        endcase
    end
end

endmodule
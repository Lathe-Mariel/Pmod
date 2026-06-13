// ============================================================
// lcd_test_top.v - Top Module
// Tang Primer 25K + PMOD-TFTLCD v1.1
//
// LCD (ILI9341) - Port1 J2:
//   K11 → lcd_dc   (RS: Data/Command)
//   A10 → lcd_cs   (Chip Select, Low有効)
//   E10 → lcd_mosi (MOSI)
//   K5  → lcd_sck  (SCK)
//   ※ LCDのMISOは未接続 (LCD書き込みのみ)
//
// タッチ (XPT2046) - Port0:
//   G5  → tc_cs    (Chip Select, Low有効)
//   G8  → tc_mosi  (DIN)
//   H7  → tc_miso  (DOUT)
//   J5  → tc_clk   (DCLK)
//
// LCDとタッチは独立したSPIバス
// RST / BLK : ボード側VCC固定 → FPGA未接続
// ============================================================

module lcd_test_top (
    input  wire clk,        // 50MHz システムクロック  T10

    input  wire btn_rst,    // ユーザボタン (Low有効)  H11

    // LCD (ILI9341) SPI - Port1 J2
    output wire lcd_dc,     // K11 Data/Command (RS)
    output wire lcd_cs,     // A10 Chip Select
    output wire lcd_mosi,   // E10 MOSI
    output wire lcd_sck,    // K5  SCK

    // タッチ (XPT2046) SPI - Port0
    output wire tc_cs,      // G5  Touch Chip Select
    output wire tc_mosi,    // G8  Touch DIN
    input  wire tc_miso,    // H7  Touch DOUT
    output wire tc_clk      // J5  Touch DCLK
);

// ============================================================
// リセット同期化 (lcd_ctrl / touch_ctrl 共用)
// ============================================================
reg btn_r1, btn_r2;
always @(posedge clk) begin
    btn_r1 <= btn_rst;
    btn_r2 <= btn_r1;
end
wire rst_n = btn_r2;

// ============================================================
// タッチ座標 (touch_ctrl → lcd_ctrl)
// ============================================================
wire        touch_valid;
wire [8:0]  touch_x;
wire [7:0]  touch_y;

// ============================================================
// LCD コントローラ (ILI9341)
// ============================================================
lcd_ctrl u_lcd_ctrl (
    .clk         (clk),
    .btn_rst     (btn_rst),
    .lcd_cs      (lcd_cs),
    .lcd_dc      (lcd_dc),
    .lcd_mosi    (lcd_mosi),
    .lcd_sck     (lcd_sck),
    .touch_valid (touch_valid),
    .touch_x     (touch_x),
    .touch_y     (touch_y)
);

// ============================================================
// タッチコントローラ (XPT2046)
// ============================================================
touch_ctrl u_touch_ctrl (
    .clk         (clk),
    .rst_n       (rst_n),
    .tc_cs       (tc_cs),
    .tc_mosi     (tc_mosi),
    .tc_miso     (tc_miso),
    .tc_clk      (tc_clk),
    .touch_valid (touch_valid),
    .touch_x     (touch_x),
    .touch_y     (touch_y)
);

endmodule

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
//
// 8色縦縞テストパターン (各40px × 8 = 320px):
//   col   0- 39 : 白     0xFFFF
//   col  40- 79 : 黄     0xFFE0
//   col  80-119 : シアン 0x07FF
//   col 120-159 : 緑     0x07E0
//   col 160-199 : マゼンタ 0xF81F
//   col 200-239 : 赤     0xF800
//   col 240-279 : 青     0x001F
//   col 280-319 : 黒     0x0000
// ============================================================

module lcd_ctrl (
    input  wire clk,       // 50 MHz
    output reg  lcd_cs,    // G5  Chip Select (Low有効)
    output reg  lcd_dc,    // K11 Data/Command (RS)
    output reg  lcd_mosi,  // G8  SPI MOSI
    output reg  lcd_sck    // J5  SPI Clock
);

// ============================================================
// 電源ON後 150ms 待機 (@ 50MHz = 7,500,000サイクル)
// ============================================================
reg [23:0] poweron_cnt = 24'd0;
reg        init_enable = 1'b0;

always @(posedge clk) begin
    if (!init_enable) begin
        if (poweron_cnt == 24'd7_500_000)
            init_enable <= 1'b1;
        else
            poweron_cnt <= poweron_cnt + 1'b1;
    end
end

// ============================================================
// SPI バイト送信器
// Mode 0 (CPOL=0, CPHA=0): data sampled on rising SCK edge
// Each bit takes 4 clock cycles → 8 bits = 32 cycles
// ============================================================
reg [7:0]  tx_byte   = 8'd0;   // byte to transmit
reg        tx_dc     = 1'b0;   // DC level for this byte
reg        tx_start  = 1'b0;   // 1-cycle pulse to start
reg        tx_busy   = 1'b0;
reg [5:0]  tx_cnt    = 6'd0;   // bit×4 phase counter

always @(posedge clk) begin
    if (!init_enable) begin
        lcd_cs   <= 1'b1;
        lcd_sck  <= 1'b0;
        lcd_mosi <= 1'b0;
        lcd_dc   <= 1'b0;
        tx_busy  <= 1'b0;
        tx_cnt   <= 6'd0;
    end else if (tx_start && !tx_busy) begin
        tx_busy  <= 1'b1;
        tx_cnt   <= 6'd0;
        lcd_cs   <= 1'b0;
        lcd_dc   <= tx_dc;
        lcd_sck  <= 1'b0;
        lcd_mosi <= tx_byte[7];
    end else if (tx_busy) begin
        tx_cnt <= tx_cnt + 1'b1;
        case (tx_cnt[1:0])
            2'b00: begin
                // Setup: output bit
                lcd_mosi <= tx_byte[7 - tx_cnt[5:2]];
            end
            2'b01: begin
                lcd_sck <= 1'b1;  // Rising edge (sample)
            end
            2'b10: begin
                // Hold SCK high
            end
            2'b11: begin
                lcd_sck <= 1'b0;  // Falling edge
                if (tx_cnt[5:2] == 4'd7) begin
                    tx_busy <= 1'b0;
                    lcd_cs  <= 1'b1;
                end
            end
        endcase
    end
end

// ============================================================
// ILI9341 Initialization sequence ROM
// Bit[8]=0 → command, Bit[8]=1 → data
// ============================================================
reg [8:0] init_rom [0:79];
reg [6:0] init_len;

initial begin : INIT_ROM
    integer idx;
    idx = 0;

    // 0x01 Software Reset
    init_rom[idx] = 9'h001; idx=idx+1;
    // [delay 150ms handled by state machine]

    // 0x11 Sleep Out
    init_rom[idx] = 9'h011; idx=idx+1;
    // [delay 120ms]

    // 0xC0 Power Control 1
    init_rom[idx] = 9'h0C0; idx=idx+1;
    init_rom[idx] = 9'h123; idx=idx+1; // VRH=3.3V

    // 0xC1 Power Control 2
    init_rom[idx] = 9'h0C1; idx=idx+1;
    init_rom[idx] = 9'h110; idx=idx+1;

    // 0xC5 VCOM Control 1
    init_rom[idx] = 9'h0C5; idx=idx+1;
    init_rom[idx] = 9'h13E; idx=idx+1;
    init_rom[idx] = 9'h128; idx=idx+1;

    // 0xC7 VCOM Control 2
    init_rom[idx] = 9'h0C7; idx=idx+1;
    init_rom[idx] = 9'h186; idx=idx+1;

    // 0x36 Memory Access Control
    // MX=0, MY=0, MV=1, ML=0, BGR=1, MH=0 → 0x28 for landscape 320x240
    init_rom[idx] = 9'h036; idx=idx+1;
    init_rom[idx] = 9'h128; idx=idx+1;

    // 0x3A Pixel Format → RGB565
    init_rom[idx] = 9'h03A; idx=idx+1;
    init_rom[idx] = 9'h155; idx=idx+1;

    // 0xB1 Frame Rate Control (Normal Mode)
    init_rom[idx] = 9'h0B1; idx=idx+1;
    init_rom[idx] = 9'h100; idx=idx+1;
    init_rom[idx] = 9'h11B; idx=idx+1;

    // 0xB6 Display Function Control
    init_rom[idx] = 9'h0B6; idx=idx+1;
    init_rom[idx] = 9'h108; idx=idx+1;
    init_rom[idx] = 9'h182; idx=idx+1;
    init_rom[idx] = 9'h127; idx=idx+1;

    // 0x26 Gamma Set
    init_rom[idx] = 9'h026; idx=idx+1;
    init_rom[idx] = 9'h101; idx=idx+1;

    // 0xE0 Positive Gamma Correction (15 bytes)
    init_rom[idx] = 9'h0E0; idx=idx+1;
    init_rom[idx] = 9'h10F; idx=idx+1;
    init_rom[idx] = 9'h131; idx=idx+1;
    init_rom[idx] = 9'h12B; idx=idx+1;
    init_rom[idx] = 9'h10C; idx=idx+1;
    init_rom[idx] = 9'h10E; idx=idx+1;
    init_rom[idx] = 9'h108; idx=idx+1;
    init_rom[idx] = 9'h14E; idx=idx+1;
    init_rom[idx] = 9'h1F1; idx=idx+1;
    init_rom[idx] = 9'h137; idx=idx+1;
    init_rom[idx] = 9'h107; idx=idx+1;
    init_rom[idx] = 9'h110; idx=idx+1;
    init_rom[idx] = 9'h103; idx=idx+1;
    init_rom[idx] = 9'h10E; idx=idx+1;
    init_rom[idx] = 9'h109; idx=idx+1;
    init_rom[idx] = 9'h100; idx=idx+1;

    // 0xE1 Negative Gamma Correction (15 bytes)
    init_rom[idx] = 9'h0E1; idx=idx+1;
    init_rom[idx] = 9'h100; idx=idx+1;
    init_rom[idx] = 9'h10E; idx=idx+1;
    init_rom[idx] = 9'h114; idx=idx+1;
    init_rom[idx] = 9'h103; idx=idx+1;
    init_rom[idx] = 9'h111; idx=idx+1;
    init_rom[idx] = 9'h107; idx=idx+1;
    init_rom[idx] = 9'h131; idx=idx+1;
    init_rom[idx] = 9'h1C1; idx=idx+1;
    init_rom[idx] = 9'h148; idx=idx+1;
    init_rom[idx] = 9'h108; idx=idx+1;
    init_rom[idx] = 9'h10F; idx=idx+1;
    init_rom[idx] = 9'h10C; idx=idx+1;
    init_rom[idx] = 9'h131; idx=idx+1;
    init_rom[idx] = 9'h136; idx=idx+1;
    init_rom[idx] = 9'h10F; idx=idx+1;

    // 0x2A Column Address Set: 0x0000 to 0x00EF (0~239)
    init_rom[idx] = 9'h02A; idx=idx+1;
    init_rom[idx] = 9'h100; idx=idx+1;
    init_rom[idx] = 9'h100; idx=idx+1;
    init_rom[idx] = 9'h100; idx=idx+1;
    init_rom[idx] = 9'h1EF; idx=idx+1;

    // 0x2B Row Address Set: 0x0000 to 0x013F (0~319)
    init_rom[idx] = 9'h02B; idx=idx+1;
    init_rom[idx] = 9'h100; idx=idx+1;
    init_rom[idx] = 9'h100; idx=idx+1;
    init_rom[idx] = 9'h101; idx=idx+1;
    init_rom[idx] = 9'h13F; idx=idx+1;

    // 0x29 Display ON
    init_rom[idx] = 9'h029; idx=idx+1;

    // 0x2C Memory Write (start pixel data)
    init_rom[idx] = 9'h02C; idx=idx+1;

    init_len = idx;
end

// ============================================================
// Color palette (RGB565): 8 vertical stripes
// ============================================================
function [15:0] get_color;
    input [8:0] col;
    begin
        if      (col < 9'd40)  get_color = 16'hFFFF; // White
        else if (col < 9'd80)  get_color = 16'hFFE0; // Yellow
        else if (col < 9'd120) get_color = 16'h07FF; // Cyan
        else if (col < 9'd160) get_color = 16'h07E0; // Green
        else if (col < 9'd200) get_color = 16'hF81F; // Magenta
        else if (col < 9'd240) get_color = 16'hF800; // Red
        else if (col < 9'd280) get_color = 16'h001F; // Blue
        else                   get_color = 16'h0000; // Black
    end
endfunction

// ============================================================
// Main state machine
// ============================================================
localparam [3:0]
    S_WAIT       = 4'd0,   // Wait for init_enable
    S_SWRST_DLY  = 4'd1,   // Delay after SW reset
    S_SLPOUT_DLY = 4'd2,   // Delay after Sleep Out
    S_INIT_TX    = 4'd3,   // Send init byte
    S_INIT_WAIT  = 4'd4,   // Wait for SPI done
    S_PIX_CALC   = 4'd5,   // Calculate pixel color
    S_PIX_HI_TX  = 4'd6,   // Send high byte
    S_PIX_HI_W   = 4'd7,   // Wait for high byte
    S_PIX_LO_TX  = 4'd8,   // Send low byte
    S_PIX_LO_W   = 4'd9,   // Wait for low byte
    S_DONE       = 4'd10;  // Pattern complete

reg [3:0]  state = S_WAIT;
reg [6:0]  init_idx;
reg [23:0] dly_cnt;
reg [16:0] pix_cnt;   // 0..76799 (320*240)
reg [8:0]  col_cnt;   // 0..319
reg [15:0] cur_color;

// Special indices in ROM for SW reset and Sleep Out
localparam SW_RST_IDX   = 7'd0;  // 0x01 is at index 0
localparam SLPOUT_IDX   = 7'd1;  // 0x11 is at index 1

always @(posedge clk) begin
    tx_start <= 1'b0;

    case (state)
        S_WAIT: begin
            if (init_enable) begin
                init_idx <= 7'd0;
                state    <= S_INIT_TX;
            end
        end

        // ---- Send init byte ----
        S_INIT_TX: begin
            if (init_idx < init_len) begin
                if (!tx_busy && !tx_start) begin
                    tx_byte  <= init_rom[init_idx][7:0];
                    tx_dc    <= init_rom[init_idx][8];
                    tx_start <= 1'b1;
                    state    <= S_INIT_WAIT;
                end
            end else begin
                // Init done → start pixel output
                pix_cnt <= 17'd0;
                col_cnt <= 9'd0;
                state   <= S_PIX_CALC;
            end
        end

        S_INIT_WAIT: begin
            if (!tx_busy && !tx_start) begin
                // Check if we need post-command delay
                if (init_rom[init_idx][8:0] == 9'h001) begin
                    // SW Reset: 5ms delay
                    dly_cnt  <= 24'd0;
                    state    <= S_SWRST_DLY;
                end else if (init_rom[init_idx][8:0] == 9'h011) begin
                    // Sleep Out: 120ms delay
                    dly_cnt  <= 24'd0;
                    state    <= S_SLPOUT_DLY;
                end else begin
                    init_idx <= init_idx + 1'b1;
                    state    <= S_INIT_TX;
                end
            end
        end

        S_SWRST_DLY: begin
            // 5ms @ 50MHz = 250,000 cycles
            if (dly_cnt == 24'd250_000) begin
                init_idx <= init_idx + 1'b1;
                state    <= S_INIT_TX;
            end else
                dly_cnt <= dly_cnt + 1'b1;
        end

        S_SLPOUT_DLY: begin
            // 120ms @ 50MHz = 6,000,000 cycles
            if (dly_cnt == 24'd6_000_000) begin
                init_idx <= init_idx + 1'b1;
                state    <= S_INIT_TX;
            end else
                dly_cnt <= dly_cnt + 1'b1;
        end

        // ---- Send pixels ----
        S_PIX_CALC: begin
            cur_color <= get_color(col_cnt);
            state     <= S_PIX_HI_TX;
        end

        S_PIX_HI_TX: begin
            if (!tx_busy && !tx_start) begin
                tx_byte  <= cur_color[15:8];
                tx_dc    <= 1'b1;
                tx_start <= 1'b1;
                state    <= S_PIX_HI_W;
            end
        end

        S_PIX_HI_W: begin
            if (!tx_busy && !tx_start)
                state <= S_PIX_LO_TX;
        end

        S_PIX_LO_TX: begin
            if (!tx_busy && !tx_start) begin
                tx_byte  <= cur_color[7:0];
                tx_dc    <= 1'b1;
                tx_start <= 1'b1;
                state    <= S_PIX_LO_W;
            end
        end

        S_PIX_LO_W: begin
            if (!tx_busy && !tx_start) begin
                // Advance pixel/column counters
                if (col_cnt == 9'd319)
                    col_cnt <= 9'd0;
                else
                    col_cnt <= col_cnt + 1'b1;

                if (pix_cnt == 17'd76_799)
                    state <= S_DONE;
                else begin
                    pix_cnt <= pix_cnt + 1'b1;
                    state   <= S_PIX_CALC;
                end
            end
        end

        S_DONE: begin
            // Finished - pattern displayed, hold here
        end

        default: state <= S_WAIT;
    endcase
end

endmodule

// ============================================================
// lcd_controller.v
// ST7735S initialization + frame write state machine
// 4-wire SPI (CPOL=0, CPHA=0)
// ============================================================
module lcd_controller (
    input  wire        clk,        // 27 MHz system clock
    output  wire       spi_clk,    // SPI bit clock (~13.5 MHz)
    input  wire        rst_n,

    // LCD SPI signals
    output reg         lcd_cs,
    output reg         lcd_mosi,
    output reg         lcd_dc,
    output reg         lcd_rst,

    // Pixel interface
    output reg         pixel_req,
    output reg  [8:0]  pixel_x,
    output reg  [8:0]  pixel_y,
    input  wire [15:0] pixel_data
);

    Gowin_PLL instance_1(
        .clkout0(spi_clk), //output clkout0
        .clkin(clk) //input clkin
    );

// ----------------------------------------------------------
// LCD dimensions
// ----------------------------------------------------------
localparam LCD_W = 9'd132;
localparam LCD_H = 9'd162;

// ----------------------------------------------------------
// State machine
// ----------------------------------------------------------
localparam ST_POWER_ON  = 4'd0;
localparam ST_RESET     = 4'd1;
localparam ST_INIT_CMD  = 4'd2;
localparam ST_WRITE_RAM = 4'd3;
localparam ST_DONE      = 4'd4;

reg [3:0]  state;
reg [3:0]  next_state;

// ----------------------------------------------------------
// Reset timing: hold RESET low ≥ 10 ms
// At 27 MHz, 10 ms = 270 000 cycles  → use 20-bit counter
// Power-on delay: 120 ms = 3 240 000 → use 22-bit counter
// ----------------------------------------------------------
reg [21:0] delay_cnt;
reg        delay_done;

// ----------------------------------------------------------
// SPI transmit engine
// Sends 8 or 16 bits, MSB first on spi_clk rising edge
// ----------------------------------------------------------
// spi_clk domain edge detection
reg spi_clk_r0, spi_clk_r1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        spi_clk_r0 <= 0;
        spi_clk_r1 <= 0;
    end else begin
        spi_clk_r0 <= spi_clk;
        spi_clk_r1 <= spi_clk_r0;
    end
end
wire spi_rise = ( spi_clk_r0 & ~spi_clk_r1);
wire spi_fall = (~spi_clk_r0 &  spi_clk_r1);

reg        tx_start;
reg        tx_16bit;     // 1=16-bit, 0=8-bit
reg [15:0] tx_data;
reg [4:0]  tx_bit_cnt;
reg        tx_busy;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tx_busy    <= 1'b0;
        tx_bit_cnt <= 5'd0;
        lcd_mosi   <= 1'b0;
        lcd_cs     <= 1'b1;
    end else if (tx_start && !tx_busy) begin
        tx_busy    <= 1'b1;
        tx_bit_cnt <= tx_16bit ? 5'd16 : 5'd8;
        lcd_cs     <= 1'b0;
    end else if (tx_busy) begin
        if (spi_fall) begin
            // Output MSB
            lcd_mosi   <= tx_data[tx_bit_cnt - 1];
        end
        if (spi_rise) begin
            if (tx_bit_cnt == 5'd1) begin
                tx_busy <= 1'b0;
                lcd_cs  <= 1'b1;
            end
            tx_bit_cnt <= tx_bit_cnt - 5'd1;
        end
    end
end

// ----------------------------------------------------------
// Initialization command ROM
// Format: {dc[0], data[7:0]}  dc=0→command, dc=1→data
// Sentinel: 9'h1FF = end of table
// ----------------------------------------------------------
// Each entry: {is_data, byte_value}
// We also encode delays as special entries: 9'h1FE + count
localparam CMD = 1'b0;
localparam DAT = 1'b1;

reg [8:0] init_rom [0:63];
reg [6:0] rom_idx;
reg [6:0] rom_len;

initial begin
    // --- Software Reset ---
    init_rom[0]  = {CMD, 8'h01};   // SWRESET
    // delay 150 ms handled by state machine after SWRESET

    // --- Sleep Out ---
    init_rom[1]  = {CMD, 8'h11};   // SLPOUT
    // delay 120 ms

    // --- Pixel format: 16-bit RGB565 ---
    init_rom[2]  = {CMD, 8'h3A};   // COLMOD
    init_rom[3]  = {DAT, 8'h05};   // 16-bit/pixel

    // --- Memory data access control ---
    init_rom[4]  = {CMD, 8'h36};   // MADCTL
    init_rom[5]  = {DAT, 8'h00};   // Normal: RGB, no mirror

    // --- Frame rate (Normal mode) ---
    init_rom[6]  = {CMD, 8'hB1};
    init_rom[7]  = {DAT, 8'h01};
    init_rom[8]  = {DAT, 8'h2C};
    init_rom[9]  = {DAT, 8'h2D};

    // --- Frame rate (Idle mode) ---
    init_rom[10] = {CMD, 8'hB2};
    init_rom[11] = {DAT, 8'h01};
    init_rom[12] = {DAT, 8'h2C};
    init_rom[13] = {DAT, 8'h2D};

    // --- Frame rate (Partial mode) ---
    init_rom[14] = {CMD, 8'hB3};
    init_rom[15] = {DAT, 8'h01};
    init_rom[16] = {DAT, 8'h2C};
    init_rom[17] = {DAT, 8'h2D};
    init_rom[18] = {DAT, 8'h01};
    init_rom[19] = {DAT, 8'h2C};
    init_rom[20] = {DAT, 8'h2D};

    // --- Inversion control ---
    init_rom[21] = {CMD, 8'hB4};
    init_rom[22] = {DAT, 8'h07};

    // --- Power control 1 ---
    init_rom[23] = {CMD, 8'hC0};
    init_rom[24] = {DAT, 8'hA2};
    init_rom[25] = {DAT, 8'h02};
    init_rom[26] = {DAT, 8'h84};

    // --- Power control 2 ---
    init_rom[27] = {CMD, 8'hC1};
    init_rom[28] = {DAT, 8'hC5};

    // --- Power control 3 ---
    init_rom[29] = {CMD, 8'hC2};
    init_rom[30] = {DAT, 8'h0A};
    init_rom[31] = {DAT, 8'h00};

    // --- Power control 4 ---
    init_rom[32] = {CMD, 8'hC3};
    init_rom[33] = {DAT, 8'h8A};
    init_rom[34] = {DAT, 8'h2A};

    // --- Power control 5 ---
    init_rom[35] = {CMD, 8'hC4};
    init_rom[36] = {DAT, 8'h8A};
    init_rom[37] = {DAT, 8'hEE};

    // --- VCOM ---
    init_rom[38] = {CMD, 8'hC5};
    init_rom[39] = {DAT, 8'h0E};

    // --- Display inversion off ---
    init_rom[40] = {CMD, 8'h20};

    // --- Gamma (positive) ---
    init_rom[41] = {CMD, 8'hE0};
    init_rom[42] = {DAT, 8'h0F};
    init_rom[43] = {DAT, 8'h1A};
    init_rom[44] = {DAT, 8'h0F};
    init_rom[45] = {DAT, 8'h18};
    init_rom[46] = {DAT, 8'h2F};
    init_rom[47] = {DAT, 8'h28};
    init_rom[48] = {DAT, 8'h20};
    init_rom[49] = {DAT, 8'h22};
    init_rom[50] = {DAT, 8'h1F};
    init_rom[51] = {DAT, 8'h1B};
    init_rom[52] = {DAT, 8'h23};
    init_rom[53] = {DAT, 8'h37};
    init_rom[54] = {DAT, 8'h00};
    init_rom[55] = {DAT, 8'h07};
    init_rom[56] = {DAT, 8'h02};
    init_rom[57] = {DAT, 8'h10};

    // --- Gamma (negative) ---
    init_rom[58] = {CMD, 8'hE1};
    init_rom[59] = {DAT, 8'h0F};
    init_rom[60] = {DAT, 8'h1B};
    init_rom[61] = {DAT, 8'h0F};
    init_rom[62] = {DAT, 8'h17};
    init_rom[63] = {DAT, 8'h33};
    // (table continues in extended ROM below)
end

reg [8:0] init_rom2 [0:15];
initial begin
    init_rom2[0]  = {DAT, 8'h2C};
    init_rom2[1]  = {DAT, 8'h29};
    init_rom2[2]  = {DAT, 8'h2E};
    init_rom2[3]  = {DAT, 8'h30};
    init_rom2[4]  = {DAT, 8'h30};
    init_rom2[5]  = {DAT, 8'h39};
    init_rom2[6]  = {DAT, 8'h00};
    init_rom2[7]  = {DAT, 8'h07};
    init_rom2[8]  = {DAT, 8'h03};
    init_rom2[9]  = {DAT, 8'h10};

    // --- Column set (0..131) ---
    init_rom2[10] = {CMD, 8'h2A};
    init_rom2[11] = {DAT, 8'h00};
    init_rom2[12] = {DAT, 8'h00};
    init_rom2[13] = {DAT, 8'h00};
    init_rom2[14] = {DAT, 8'h83};   // 131

    // --- Row set (0..161) ---
    init_rom2[15] = {CMD, 8'h2B};
end

reg [8:0] init_rom3 [0:5];
initial begin
    init_rom3[0] = {DAT, 8'h00};
    init_rom3[1] = {DAT, 8'h00};
    init_rom3[2] = {DAT, 8'h00};
    init_rom3[3] = {DAT, 8'hA1};   // 161

    // --- Display ON ---
    init_rom3[4] = {CMD, 8'h29};

    // --- Memory Write ---
    init_rom3[5] = {CMD, 8'h2C};
end

// ----------------------------------------------------------
// State machine
// ----------------------------------------------------------
localparam PHASE_ROM1   = 3'd0;
localparam PHASE_ROM2   = 3'd1;
localparam PHASE_ROM3   = 3'd2;
localparam PHASE_PIXEL  = 3'd3;

reg [2:0]  phase;
reg [6:0]  byte_idx;
reg [21:0] wait_cnt;
reg        wait_active;

// Special indices in ROM1 that require delays after them
// Index 0 = SWRESET → need 150ms delay
// Index 1 = SLPOUT  → need 120ms delay
// 150ms @ 27MHz = 4_050_000 → 22 bits needed
// 120ms @ 27MHz = 3_240_000

reg        swreset_sent;
reg        slpout_sent;

// pixel counters
reg [16:0] pixel_cnt;   // 132*162 = 21384 → 15 bits enough

// ----------------------------------------------------------
// Main FSM
// ----------------------------------------------------------
reg [3:0]  fsm;
localparam F_RESET_LO  = 4'd0;
localparam F_RESET_HI  = 4'd1;
localparam F_WAIT      = 4'd2;
localparam F_SEND_BYTE = 4'd3;
localparam F_WAIT_TX   = 4'd4;
localparam F_NEXT_BYTE = 4'd5;
localparam F_DELAY     = 4'd6;
localparam F_PIXEL_REQ = 4'd7;
localparam F_PIXEL_TX  = 4'd8;
localparam F_PIXEL_NXT = 4'd9;
localparam F_IDLE      = 4'd15;

reg [8:0]  cur_entry;
reg        tx_start_r;
reg [21:0] dly_cnt;

// tx_start pulse
always @(posedge clk) tx_start <= tx_start_r & ~tx_busy;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fsm         <= F_RESET_LO;
        lcd_rst     <= 1'b0;
        lcd_dc      <= 1'b0;
        //lcd_cs      <= 1'b1;
        //lcd_mosi    <= 1'b0;
        tx_start_r  <= 1'b0;
        tx_16bit    <= 1'b0;
        tx_data     <= 16'd0;
        phase       <= PHASE_ROM1;
        byte_idx    <= 7'd0;
        dly_cnt     <= 22'd0;
        swreset_sent<= 1'b0;
        slpout_sent <= 1'b0;
        pixel_cnt   <= 17'd0;
        pixel_req   <= 1'b0;
        pixel_x     <= 9'd0;
        pixel_y     <= 9'd0;
    end else begin
        tx_start_r <= 1'b0;
        pixel_req  <= 1'b0;

        case (fsm)

        // ---- Hardware reset: RST low for 15 ms ----
        F_RESET_LO: begin
            lcd_rst <= 1'b0;
            dly_cnt <= dly_cnt + 22'd1;
            if (dly_cnt == 22'd405_000) begin   // 15 ms
                lcd_rst <= 1'b1;
                dly_cnt <= 22'd0;
                fsm     <= F_RESET_HI;
            end
        end

        // ---- RST high, wait 150 ms ----
        F_RESET_HI: begin
            dly_cnt <= dly_cnt + 22'd1;
            if (dly_cnt == 22'd4_050_000) begin // 150 ms
                dly_cnt  <= 22'd0;
                byte_idx <= 7'd0;
                phase    <= PHASE_ROM1;
                fsm      <= F_SEND_BYTE;
            end
        end

        // ---- Send next byte from init table ----
        F_SEND_BYTE: begin
            // Fetch entry from current phase/index
            case (phase)
                PHASE_ROM1:  cur_entry = init_rom [byte_idx];
                PHASE_ROM2:  cur_entry = init_rom2[byte_idx];
                PHASE_ROM3:  cur_entry = init_rom3[byte_idx];
                default:     cur_entry = 9'h1FF;
            endcase

            lcd_dc     <= cur_entry[8];  // 0=cmd, 1=data
            tx_data    <= {8'h00, cur_entry[7:0]};
            tx_16bit   <= 1'b0;
            tx_start_r <= 1'b1;
            fsm        <= F_WAIT_TX;
        end

        // ---- Wait for SPI to finish ----
        F_WAIT_TX: begin
            if (!tx_busy && !tx_start_r) begin
                fsm <= F_NEXT_BYTE;
            end
        end

        // ---- Advance index / handle phase transitions ----
        F_NEXT_BYTE: begin
            // Check if we just sent SWRESET or SLPOUT
            if (phase == PHASE_ROM1) begin
                if (byte_idx == 7'd0 && !swreset_sent) begin
                    swreset_sent <= 1'b1;
                    dly_cnt <= 22'd0;
                    fsm <= F_DELAY;      // 150ms
                    byte_idx <= byte_idx + 7'd1;
                end else if (byte_idx == 7'd1 && !slpout_sent) begin
                    slpout_sent <= 1'b1;
                    dly_cnt <= 22'd0;
                    fsm <= F_DELAY;      // 120ms
                    byte_idx <= byte_idx + 7'd1;
                end else begin
                    byte_idx <= byte_idx + 7'd1;
                    if (byte_idx == 7'd63) begin
                        byte_idx <= 7'd0;
                        phase    <= PHASE_ROM2;
                    end
                    fsm <= F_SEND_BYTE;
                end
            end else if (phase == PHASE_ROM2) begin
                byte_idx <= byte_idx + 7'd1;
                if (byte_idx == 7'd15) begin
                    byte_idx <= 7'd0;
                    phase    <= PHASE_ROM3;
                end
                fsm <= F_SEND_BYTE;
            end else if (phase == PHASE_ROM3) begin
                byte_idx <= byte_idx + 7'd1;
                if (byte_idx == 7'd5) begin
                    // Init done, start pixel write
                    pixel_cnt <= 17'd0;
                    pixel_x   <= 9'd0;
                    pixel_y   <= 9'd0;
                    fsm       <= F_PIXEL_REQ;
                end else begin
                    fsm <= F_SEND_BYTE;
                end
            end
        end

        // ---- Delay state (reused for SWRESET/SLPOUT) ----
        F_DELAY: begin
            dly_cnt <= dly_cnt + 22'd1;
            // SWRESET needs 150ms, SLPOUT 120ms
            // Use 150ms (conservative) for both
            if (dly_cnt == 22'd4_050_000) begin
                dly_cnt <= 22'd0;
                fsm     <= F_SEND_BYTE;
            end
        end

        // ---- Pixel: request color from pattern gen ----
        F_PIXEL_REQ: begin
            pixel_req <= 1'b1;
            fsm       <= F_PIXEL_TX;
        end

        // ---- Pixel: send 16-bit RGB565 ----
        F_PIXEL_TX: begin
            lcd_dc     <= 1'b1;
            //lcd_cs     <= 1'b0;
            tx_data    <= pixel_data;
            tx_16bit   <= 1'b1;
            tx_start_r <= 1'b1;
            fsm        <= F_PIXEL_NXT;
        end

        F_PIXEL_NXT: begin
            if (!tx_busy && !tx_start_r) begin
                pixel_cnt <= pixel_cnt + 17'd1;
                // Advance x,y
                if (pixel_x == LCD_W - 9'd1) begin
                    pixel_x <= 9'd0;
                    if (pixel_y == LCD_H - 9'd1)
                        pixel_y <= 9'd0;   // wrap
                    else
                        pixel_y <= pixel_y + 9'd1;
                end else begin
                    pixel_x <= pixel_x + 9'd1;
                end

                if (pixel_cnt == 17'd21383) begin
                    // Full frame done → loop forever
                    // Re-issue RAMWR (0x2C) and restart
                    lcd_dc     <= 1'b0;
                    tx_data    <= 16'h002C;
                    tx_16bit   <= 1'b0;
                    tx_start_r <= 1'b1;
                    pixel_cnt  <= 17'd0;
                    pixel_x    <= 9'd0;
                    pixel_y    <= 9'd0;
                    fsm        <= F_PIXEL_REQ;
                end else begin
                    fsm <= F_PIXEL_REQ;
                end
            end
        end

        F_IDLE: begin end
        default: fsm <= F_IDLE;
        endcase
    end
end

endmodule

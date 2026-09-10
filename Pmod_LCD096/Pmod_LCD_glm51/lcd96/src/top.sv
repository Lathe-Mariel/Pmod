module top (
    input  logic clk,        // 50MHz システムクロック
    output logic lcd_cs,     // Pmod1 (A11)
    output logic lcd_mosi,   // Pmod2 (E11)
    output logic lcd_dc,     // Pmod3 (K11)
    output logic lcd_clk,    // Pmod4 (L5)
    output logic lcd_reset,   // Pmod8 (K5)
    output logic led,
    input logic reset_n
);

    // --------------------------------------------------------
    // SPI Transmission Module
    // --------------------------------------------------------
    logic [7:0] tx_data;
    logic       tx_start;
    logic       tx_done;
    logic       tx_busy;

assign led = reset_n;

    localparam S_SPI_IDLE  = 0;
    localparam S_SPI_SHIFT = 1;
    localparam S_SPI_END   = 2;

    logic [1:0] spi_state;
    logic [2:0] bit_cnt;
    logic [7:0] shift_reg;
    logic [3:0] clk_cnt;

    always @(posedge clk) begin
        tx_done <= 0;
        case (spi_state)
            S_SPI_IDLE: begin
                if (tx_start) begin
                    shift_reg <= tx_data;
                    bit_cnt    <= 7;
                    clk_cnt    <= 0;
                    spi_state  <= S_SPI_SHIFT;
                    lcd_cs     <= 0;
                    lcd_mosi   <= tx_data[7];
                    lcd_clk    <= 0;
                    tx_busy    <= 1;
                end else begin
                    lcd_cs  <= 1;
                    tx_busy <= 0;
                end
            end
            S_SPI_SHIFT: begin
                clk_cnt <= clk_cnt + 1;
                if (clk_cnt == 7) begin // 50MHz / 16 = 約3.12MHz SPIクロック
                    clk_cnt <= 0;
                    if (lcd_clk == 0) begin
                        lcd_clk <= 1; // 立ち上がりエッジ：LCDがデータをサンプル
                    end else begin
                        lcd_clk <= 0; // 立ち下がりエッジ：FPGAが次のビットを準備
                        if (bit_cnt == 0) begin
                            spi_state <= S_SPI_END;
                        end else begin
                            bit_cnt    <= bit_cnt - 1;
                            shift_reg  <= shift_reg << 1;
                            lcd_mosi   <= shift_reg[6];
                        end
                    end
                end
            end
            S_SPI_END: begin
                lcd_cs    <= 1;
                tx_done   <= 1;
                tx_busy   <= 0;
                spi_state <= S_SPI_IDLE;
            end
        endcase
    end

    // --------------------------------------------------------
    // Color Pattern Generator (RGB565)
    // --------------------------------------------------------
    logic [7:0] x_coord;
    logic [6:0] y_coord;
    logic [15:0] pixel_color;

    always_comb begin
        if (x_coord < 23)       pixel_color = 16'hF800; // 赤
        else if (x_coord < 46) pixel_color = 16'hFC00; // 橙
        else if (x_coord < 69) pixel_color = 16'hFFE0; // 黄
        else if (x_coord < 92) pixel_color = 16'h07E0; // 緑
        else if (x_coord < 115)pixel_color = 16'h07FF; // シアン
        else if (x_coord < 138)pixel_color = 16'h001F; // 青
        else                   pixel_color = 16'hF81F; // 紫
    end

    // --------------------------------------------------------
    // Initialization ROM (0: CMD, 1: DATA, 2: DELAY_ms * 10)
    // --------------------------------------------------------
    logic [7:0] init_type [0:74];
    logic [7:0] init_data_rom [0:74];
    integer i;
    initial begin
        for (i = 0; i < 75; i = i + 1) begin
            init_type[i] = 0;
            init_data_rom[i] = 0;
        end

        // SLPOUT & Delay 120ms
        init_type[0] = 0; init_data_rom[0] = 8'h11;
        init_type[1] = 2; init_data_rom[1] = 12;

        // FRMCTR1
        init_type[2] = 0; init_data_rom[2] = 8'hB1;
        init_type[3] = 1; init_data_rom[3] = 8'h01;
        init_type[4] = 1; init_data_rom[4] = 8'h2C;
        init_type[5] = 1; init_data_rom[5] = 8'h2D;

        // FRMCTR2
        init_type[6] = 0; init_data_rom[6] = 8'hB2;
        init_type[7] = 1; init_data_rom[7] = 8'h01;
        init_type[8] = 1; init_data_rom[8] = 8'h2C;
        init_type[9] = 1; init_data_rom[9] = 8'h2D;

        // FRMCTR3
        init_type[10] = 0; init_data_rom[10] = 8'hB3;
        init_type[11] = 1; init_data_rom[11] = 8'h01;
        init_type[12] = 1; init_data_rom[12] = 8'h2C;
        init_type[13] = 1; init_data_rom[13] = 8'h2D;
        init_type[14] = 1; init_data_rom[14] = 8'h01;
        init_type[15] = 1; init_data_rom[15] = 8'h2C;
        init_type[16] = 1; init_data_rom[16] = 8'h2D;

        // INVCTR
        init_type[17] = 0; init_data_rom[17] = 8'hB4;
        init_type[18] = 1; init_data_rom[18] = 8'h07;

        // PWCTR1
        init_type[19] = 0; init_data_rom[19] = 8'hC0;
        init_type[20] = 1; init_data_rom[20] = 8'hA2;
        init_type[21] = 1; init_data_rom[21] = 8'h02;
        init_type[22] = 1; init_data_rom[22] = 8'h84;

        // PWCTR2
        init_type[23] = 0; init_data_rom[23] = 8'hC1;
        init_type[24] = 1; init_data_rom[24] = 8'hC5;

        // PWCTR3
        init_type[25] = 0; init_data_rom[25] = 8'hC2;
        init_type[26] = 1; init_data_rom[26] = 8'h0A;
        init_type[27] = 1; init_data_rom[27] = 8'h00;

        // PWCTR4
        init_type[28] = 0; init_data_rom[28] = 8'hC3;
        init_type[29] = 1; init_data_rom[29] = 8'h8A;
        init_type[30] = 1; init_data_rom[30] = 8'h2A;

        // PWCTR5
        init_type[31] = 0; init_data_rom[31] = 8'hC4;
        init_type[32] = 1; init_data_rom[32] = 8'h8A;
        init_type[33] = 1; init_data_rom[33] = 8'hEE;

        // VMCTR1
        init_type[34] = 0; init_data_rom[34] = 8'hC5;
        init_type[35] = 1; init_data_rom[35] = 8'h0E;

        // MADCTL (0x60: 横長 160x80 向き)
        init_type[36] = 0; init_data_rom[36] = 8'h36;
        init_type[37] = 1; init_data_rom[37] = 8'h60;

        // COLMOD (RGB565)
        init_type[38] = 0; init_data_rom[38] = 8'h3A;
        init_type[39] = 1; init_data_rom[39] = 8'h05;

        // GMCTRP1 (Gamma)
        init_type[40] = 0; init_data_rom[40] = 8'hE0;
        init_type[41] = 1; init_data_rom[41] = 8'h02;
        init_type[42] = 1; init_data_rom[42] = 8'h1c;
        init_type[43] = 1; init_data_rom[43] = 8'h07;
        init_type[44] = 1; init_data_rom[44] = 8'h12;
        init_type[45] = 1; init_data_rom[45] = 8'hb7;
        init_type[46] = 1; init_data_rom[46] = 8'h13;
        init_type[47] = 1; init_data_rom[47] = 8'h0b;
        init_type[48] = 1; init_data_rom[48] = 8'h10;
        init_type[49] = 1; init_data_rom[49] = 8'h08;
        init_type[50] = 1; init_data_rom[50] = 8'h04;
        init_type[51] = 1; init_data_rom[51] = 8'h05;
        init_type[52] = 1; init_data_rom[52] = 8'h1a;
        init_type[53] = 1; init_data_rom[53] = 8'h12;
        init_type[54] = 1; init_data_rom[54] = 8'h18;

        // GMCTRN1 (Gamma)
        init_type[55] = 0; init_data_rom[55] = 8'hE1;
        init_type[56] = 1; init_data_rom[56] = 8'h02;
        init_type[57] = 1; init_data_rom[57] = 8'h1c;
        init_type[58] = 1; init_data_rom[58] = 8'h07;
        init_type[59] = 1; init_data_rom[59] = 8'h12;
        init_type[60] = 1; init_data_rom[60] = 8'hb7;
        init_type[61] = 1; init_data_rom[61] = 8'h13;
        init_type[62] = 1; init_data_rom[62] = 8'h0b;
        init_type[63] = 1; init_data_rom[63] = 8'h10;
        init_type[64] = 1; init_data_rom[64] = 8'h08;
        init_type[65] = 1; init_data_rom[65] = 8'h04;
        init_type[66] = 1; init_data_rom[66] = 8'h05;
        init_type[67] = 1; init_data_rom[67] = 8'h1a;
        init_type[68] = 1; init_data_rom[68] = 8'h12;
        init_type[69] = 1; init_data_rom[69] = 8'h18;

        // INVON (IPSパネル用色反転)
        init_type[70] = 0; init_data_rom[70] = 8'h21;
        // NORON
        init_type[71] = 0; init_data_rom[71] = 8'h13;
        init_type[72] = 2; init_data_rom[72] = 10; // 100ms Delay
        // DISPON
        init_type[73] = 0; init_data_rom[73] = 8'h29;
        init_type[74] = 2; init_data_rom[74] = 10; // 100ms Delay
    end

    // --------------------------------------------------------
    // Main Controller FSM
    // --------------------------------------------------------
    localparam S_RESET1   = 0;
    localparam S_RESET2   = 1;
    localparam S_INIT     = 2;
    localparam S_CASET    = 3;
    localparam S_RASET    = 4;
    localparam S_RAMWR    = 5;
    localparam S_PIXEL_H  = 6;
    localparam S_PIXEL_L  = 7;

    logic [2:0] main_state;
    logic [6:0] init_idx;
    logic [3:0] draw_step;
    logic [31:0] delay_cnt;       // 50MHz対応のため32bitに拡張
    logic       in_delay;
    logic [31:0] delay_target;    // 50MHz対応のため32bitに拡張
    logic       dc_reg;

    always @(posedge clk) begin
        tx_start <= 0;
        lcd_dc <= dc_reg;

        case (main_state)
            S_RESET1: begin
                lcd_reset <= 0;
                if (delay_cnt == 32'd5000000) begin // 100ms @ 50MHz
                    delay_cnt <= 0;
                    main_state <= S_RESET2;
                end else delay_cnt <= delay_cnt + 1;
            end
            S_RESET2: begin
                lcd_reset <= 1;
                if (delay_cnt == 32'd5000000) begin // 100ms @ 50MHz
                    delay_cnt <= 0;
                    main_state <= S_INIT;
                    init_idx <= 0;
                    in_delay <= 0;
                end else delay_cnt <= delay_cnt + 1;
            end

            S_INIT: begin
                if (init_idx >= 75) begin
                    main_state <= S_CASET;
                    draw_step <= 0;
                end else if (in_delay) begin
                    if (delay_cnt == delay_target) begin
                        delay_cnt <= 0;
                        in_delay <= 0;
                        init_idx <= init_idx + 1;
                    end else delay_cnt <= delay_cnt + 1;
                end else begin
                    case (init_type[init_idx])
                        0: begin // CMD
                            if (~tx_busy) begin
                                tx_start <= 1;
                                tx_data <= init_data_rom[init_idx];
                                dc_reg <= 0;
                                init_idx <= init_idx + 1;
                            end
                        end
                        1: begin // DATA
                            if (~tx_busy) begin
                                tx_start <= 1;
                                tx_data <= init_data_rom[init_idx];
                                dc_reg <= 1;
                                init_idx <= init_idx + 1;
                            end
                        end
                        2: begin // DELAY (data * 10ms)
                            in_delay <= 1;
                            delay_target <= init_data_rom[init_idx] * 32'd500000; // 10ms @ 50MHz
                            delay_cnt <= 0;
                        end
                    endcase
                end
            end

            S_CASET: begin // Column Address Set (0 to 159)
                case (draw_step)
                    0: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h2A; dc_reg <= 0; draw_step <= 1; end
                    1: if (tx_done) draw_step <= 2;
                    2: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h00; dc_reg <= 1; draw_step <= 3; end
                    3: if (tx_done) draw_step <= 4;
                    4: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h00; dc_reg <= 1; draw_step <= 5; end
                    5: if (tx_done) draw_step <= 6;
                    6: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h00; dc_reg <= 1; draw_step <= 7; end
                    7: if (tx_done) draw_step <= 8;
                    8: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h9F; dc_reg <= 1; draw_step <= 9; end
                    9: if (tx_done) begin draw_step <= 0; main_state <= S_RASET; end
                endcase
            end

            S_RASET: begin // Row Address Set (0 to 79)
                case (draw_step)
                    0: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h2B; dc_reg <= 0; draw_step <= 1; end
                    1: if (tx_done) draw_step <= 2;
                    2: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h00; dc_reg <= 1; draw_step <= 3; end
                    3: if (tx_done) draw_step <= 4;
                    4: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h00; dc_reg <= 1; draw_step <= 5; end
                    5: if (tx_done) draw_step <= 6;
                    6: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h00; dc_reg <= 1; draw_step <= 7; end
                    7: if (tx_done) draw_step <= 8;
                    8: if (~tx_busy) begin tx_start <= 1; tx_data <= 8'h4F; dc_reg <= 1; draw_step <= 9; end
                    9: if (tx_done) begin draw_step <= 0; main_state <= S_RAMWR; end
                endcase
            end

            S_RAMWR: begin
                if (~tx_busy) begin
                    tx_start <= 1;
                    tx_data <= 8'h2C;
                    dc_reg <= 0;
                    x_coord <= 0;
                    y_coord <= 0;
                    main_state <= S_PIXEL_H;
                end
            end

            S_PIXEL_H: begin
                if (~tx_busy) begin
                    tx_start <= 1;
                    tx_data <= pixel_color[15:8];
                    dc_reg <= 1;
                end else if (tx_done) begin
                    main_state <= S_PIXEL_L;
                end
            end

            S_PIXEL_L: begin
                if (~tx_busy) begin
                    tx_start <= 1;
                    tx_data <= pixel_color[7:0];
                    dc_reg <= 1;
                end else if (tx_done) begin
                    if (x_coord == 159) begin
                        x_coord <= 0;
                        if (y_coord == 79) begin
                            y_coord <= 0;
                            main_state <= S_CASET; // フレーム描画完了、最初から繰り返し
                        end else begin
                            y_coord <= y_coord + 1;
                        end
                    end else begin
                        x_coord <= x_coord + 1;
                    end
                    main_state <= S_PIXEL_H;
                end
            end
        endcase
    end

endmodule
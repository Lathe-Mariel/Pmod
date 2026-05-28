// Rotary encoder counter for Tang Primer 25K
// Clock: 50 MHz
// Pmod ENC: i_enc_a, i_enc_b
// 6-digit 7-seg: o_seg_anode[7:0] (active-high), o_digit_cath[5:0] (active-low)

module rotary_encoder_rotary_encoder (
    input  var logic         i_clk       ,
    input  var logic         i_enc_a     ,
    input  var logic         i_enc_b     ,
    input  var logic         i_push_sw   ,
    input  var logic         i_slide_sw  ,
    output var logic [8-1:0] o_seg_anode ,
    output var logic [6-1:0] o_digit_cath
);
    localparam int unsigned DEBOUNCE_CYCLES = 50_000; // 1 ms at 50 MHz

    // ============================================================
    // Synchronizers
    // ============================================================
    logic [2-1:0] enc_a_sync;
    logic [2-1:0] enc_b_sync;

    always_ff @ (posedge i_clk) begin
        enc_a_sync[0] <= i_enc_a;
        enc_a_sync[1] <= enc_a_sync[0];

        enc_b_sync[0] <= i_enc_b;
        enc_b_sync[1] <= enc_b_sync[0];
    end

    // ============================================================
    // Debounce for A/B
    // ============================================================
    logic        enc_a_db ;
    logic        enc_b_db ;
    int unsigned enc_a_cnt;
    int unsigned enc_b_cnt;

    always_ff @ (posedge i_clk) begin
        // A
        if ((enc_a_sync[1] == enc_a_db)) begin
            enc_a_cnt <= 0;
        end else begin
            if ((enc_a_cnt == DEBOUNCE_CYCLES - 1)) begin
                enc_a_db  <= enc_a_sync[1];
                enc_a_cnt <= 0;
            end else begin
                enc_a_cnt <= enc_a_cnt + 1;
            end
        end

        // B
        if ((enc_b_sync[1] == enc_b_db)) begin
            enc_b_cnt <= 0;
        end else begin
            if ((enc_b_cnt == DEBOUNCE_CYCLES - 1)) begin
                enc_b_db  <= enc_b_sync[1];
                enc_b_cnt <= 0;
            end else begin
                enc_b_cnt <= enc_b_cnt + 1;
            end
        end
    end

    // ============================================================
    // Quadrature decoder with 4x accumulator
    // ============================================================
    logic [2-1:0] ab_prev    ;
    logic [2-1:0] ab_curr    ;
    byte          step_acc   ; // -4..+3 is enough
    logic         step_pulse ;
    logic         step_dir_up; // 1: up, 0: down

    always_ff @ (posedge i_clk) begin
        ab_curr <= {enc_a_db, enc_b_db};

        step_pulse  <= 0;
        step_dir_up <= step_dir_up;

        if ((ab_curr != ab_prev)) begin
            // Valid Gray transitions: 00,01,11,10
            // Direction table (prev -> curr):
            // 00->01,01->11,11->10,10->00 : +1
            // 00->10,10->11,11->01,01->00 : -1
            byte delta;
            delta = 0;

            case (ab_prev)
                00: begin
                    if ((ab_curr == 01)) begin
                        delta = 1;
                    end else if ((ab_curr == 10)) begin
                        delta = -1;
                    end
                end
                01: begin
                    if ((ab_curr == 11)) begin
                        delta = 1;
                    end else if ((ab_curr == 00)) begin
                        delta = -1;
                    end
                end
                11: begin
                    if ((ab_curr == 10)) begin
                        delta = 1;
                    end else if ((ab_curr == 01)) begin
                        delta = -1;
                    end
                end
                10: begin
                    if ((ab_curr == 00)) begin
                        delta = 1;
                    end else if ((ab_curr == 11)) begin
                        delta = -1;
                    end
                end
                default: begin
                    delta = 0;
                end
            endcase

            if ((delta != 0)) begin
                step_acc <= step_acc + delta;

                if ((step_acc + delta == 4)) begin
                    step_acc    <= 0;
                    step_pulse  <= 1;
                    step_dir_up <= 1;
                end else if ((step_acc + delta == -4)) begin
                    step_acc    <= 0;
                    step_pulse  <= 1;
                    step_dir_up <= 0;
                end
            end
        end

        ab_prev <= ab_curr;
    end

    // ============================================================
    // Push switch debounce (reset)
    // ============================================================
    logic        [2-1:0] push_sync;
    logic                push_db  ;
    int unsigned         push_cnt ;

    always_ff @ (posedge i_clk) begin
        push_sync[0] <= i_push_sw;
        push_sync[1] <= push_sync[0];

        if ((push_sync[1] == push_db)) begin
            push_cnt <= 0;
        end else begin
            if ((push_cnt == DEBOUNCE_CYCLES - 1)) begin
                push_db  <= push_sync[1];
                push_cnt <= 0;
            end else begin
                push_cnt <= push_cnt + 1;
            end
        end
    end

    // ============================================================
    // Slide switch (direction) – simple sync
    // ============================================================
    logic [2-1:0] slide_sync;
    logic         dir_rev   ;

    always_ff @ (posedge i_clk) begin
        slide_sync[0] <= i_slide_sw;
        slide_sync[1] <= slide_sync[0];
        dir_rev       <= slide_sync[1];
    end

    // ============================================================
    // 6-digit decimal counter (000000–999999)
    // ============================================================
    int unsigned count    ; // 0..999999
    logic        step_up  ;
    logic        step_down;

    always_comb begin
        // XOR with reverse switch
        logic dir_final;
        dir_final = step_dir_up ^ dir_rev;
        step_up   = step_pulse & dir_final;
        step_down = step_pulse & ~dir_final;
    end

    always_ff @ (posedge i_clk) begin
        if ((push_db)) begin
            count <= 0;
        end else begin
            if ((step_up)) begin
                if ((count == 999_999)) begin
                    count <= 0;
                end else begin
                    count <= count + 1;
                end
            end else if ((step_down)) begin
                if ((count == 0)) begin
                    count <= 999_999;
                end else begin
                    count <= count - 1;
                end
            end
        end
    end

    // ============================================================
    // BCD extraction (6 digits)
    // ============================================================
    logic bcd [6][4];

    rotary_encoder_bin2bcd6 b2b (
        .i_clk (i_clk),
        .i_bin (count),
        .o_bcd (bcd  )
    );


    // ============================================================
    // 7-seg multiplexing
    // ============================================================
    // Simple scan: ~1 kHz per digit (50 MHz / (6 * 8000) ≈ 1 kHz)
    shortint unsigned scan_cnt ;
    byte unsigned     digit_idx;

    always_ff @ (posedge i_clk) begin
        if ((scan_cnt == 7999)) begin
            scan_cnt  <= 0;
            digit_idx <= digit_idx + 1;
        end else begin
            scan_cnt <= scan_cnt + 1;
        end
    end

    // 7-seg decode (abcdefg, active-high)
    function automatic logic [7-1:0] seg7_decode(
        input var logic [4-1:0] d
    ) ;
        logic [7-1:0] seg;

        case (d)
            0      : seg = 7'b0111111;
            1      : seg = 7'b0000110;
            2      : seg = 7'b1011011;
            3      : seg = 7'b1001111;
            4      : seg = 7'b1100110;
            5      : seg = 7'b1101101;
            6      : seg = 7'b1111101;
            7      : seg = 7'b0000111;
            8      : seg = 7'b1111111;
            9      : seg = 7'b1101111;
            default: seg = 7'b0000000;
        endcase

        return seg;
    endfunction

    always_comb begin
        // Default: all digits off (active-low)
        logic [7-1:0] seg;
        o_digit_cath = 6'b111111;
        o_seg_anode  = 8'b00000000;

        seg = seg7_decode(bcd[digit_idx]);

        // Map to outputs: o_seg_anode[6:0] = g..a, [7] unused
        o_seg_anode[0] = seg[0]; // a
        o_seg_anode[1] = seg[1]; // b
        o_seg_anode[2] = seg[2]; // c
        o_seg_anode[3] = seg[3]; // d
        o_seg_anode[4] = seg[4]; // e
        o_seg_anode[5] = seg[5]; // f
        o_seg_anode[6] = seg[6]; // g
        o_seg_anode[7] = 0; // no decimal point

        // Enable one digit (active-low)
        case (digit_idx)
            3'd0: o_digit_cath[0] = 0;
            3'd1: o_digit_cath[1] = 0;
            3'd2: o_digit_cath[2] = 0;
            3'd3: o_digit_cath[3] = 0;
            3'd4: o_digit_cath[4] = 0;
            3'd5: o_digit_cath[5] = 0;

        endcase
    end
endmodule

module rotary_encoder_bin2bcd6 (
    input  var logic        i_clk       ,
    input  var int unsigned i_bin       , // 0..999999
    output var logic        o_bcd [6][4]
);
    int unsigned          shift_reg;
    logic         [4-1:0] bcd0     ;
    logic         [4-1:0] bcd1     ;
    logic         [4-1:0] bcd2     ;
    logic         [4-1:0] bcd3     ;
    logic         [4-1:0] bcd4     ;
    logic         [4-1:0] bcd5     ;
    byte unsigned         bit_cnt  ;
    logic                 busy     ;

    always_ff @ (posedge i_clk) begin
        if ((!busy)) begin
            // Start conversion
            shift_reg <= i_bin;
            bcd0      <= 0;
            bcd1      <= 0;
            bcd2      <= 0;
            bcd3      <= 0;
            bcd4      <= 0;
            bcd5      <= 0;
            bit_cnt   <= 20;
            busy      <= 1;
        end else begin
            // ---- Adjust each BCD digit (no loops) ----
            logic [44-1:0] big; // 6*4 + 20 = 44 bits
            if ((bcd0 >= 5)) begin
                bcd0 <= bcd0 + 3;
            end
            if ((bcd1 >= 5)) begin
                bcd1 <= bcd1 + 3;
            end
            if ((bcd2 >= 5)) begin
                bcd2 <= bcd2 + 3;
            end
            if ((bcd3 >= 5)) begin
                bcd3 <= bcd3 + 3;
            end
            if ((bcd4 >= 5)) begin
                bcd4 <= bcd4 + 3;
            end
            if ((bcd5 >= 5)) begin
                bcd5 <= bcd5 + 3;
            end

            // ---- Shift left (no loops) ----
            // Combine all BCD digits + shift_reg into one big shift

            big = {
                bcd5, bcd4, bcd3, bcd2, bcd1, bcd0,
                shift_reg
            };

            big = big << 1;

            // Unpack
            bcd5      <= big[43:40];
            bcd4      <= big[39:36];
            bcd3      <= big[35:32];
            bcd2      <= big[31:28];
            bcd1      <= big[27:24];
            bcd0      <= big[23:20];
            shift_reg <= big[19:0];

            bit_cnt <= bit_cnt - 1;

            if ((bit_cnt == 1)) begin
                busy <= 0;
            end
        end
    end

    always_comb begin
        o_bcd[0] = bcd0;
        o_bcd[1] = bcd1;
        o_bcd[2] = bcd2;
        o_bcd[3] = bcd3;
        o_bcd[4] = bcd4;
        o_bcd[5] = bcd5;
    end
endmodule
//# sourceMappingURL=rotary_encoder.sv.map

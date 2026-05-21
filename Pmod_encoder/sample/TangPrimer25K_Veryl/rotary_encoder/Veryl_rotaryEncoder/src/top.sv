module rotary_encoder_Top #(
    parameter int unsigned CLK_HZ           = 50_000_000,
    parameter int unsigned ENCODER_FILTER   = 16_384    ,
    parameter int unsigned SCAN_DIVIDER_MAX = 8_333 
) (
    input  var logic         i_clk       ,
    input  var logic         i_enc_a     ,
    input  var logic         i_enc_b     ,
    input  var logic         i_push_sw   ,
    input  var logic         i_slide_sw  ,
    output var logic [8-1:0] o_seg_anode ,
    output var logic [6-1:0] o_digit_cath
);
    logic          enc_a_meta      ;
    logic          enc_a_sync      ;
    logic          enc_b_meta      ;
    logic          enc_b_sync      ;
    logic          slide_meta      ;
    logic          slide_sync      ;
    logic [2-1:0]  enc_raw         ;
    logic [2-1:0]  enc_stable      ;
    logic [2-1:0]  enc_stable_prev ;
    logic [15-1:0] enc_filter_count;
    logic [14-1:0] scan_count      ;
    logic [3-1:0]  scan_digit      ;
    logic [4-1:0]  digit0          ;
    logic [4-1:0]  digit1          ;
    logic [4-1:0]  digit2          ;
    logic [4-1:0]  digit3          ;
    logic [4-1:0]  digit4          ;
    logic [4-1:0]  digit5          ;
    logic [4-1:0]  current_digit   ;
    logic          step_up         ;
    logic          step_down       ;

    always_comb enc_raw = {enc_a_sync, enc_b_sync};

    always_ff @ (posedge i_clk) begin
        if (i_push_sw) begin
            enc_a_meta <= 0;
            enc_a_sync <= 0;
            enc_b_meta <= 0;
            enc_b_sync <= 0;
            slide_meta <= 0;
            slide_sync <= 0;
        end else begin
            enc_a_meta <= i_enc_a;
            enc_a_sync <= enc_a_meta;
            enc_b_meta <= i_enc_b;
            enc_b_sync <= enc_b_meta;
            slide_meta <= i_slide_sw;
            slide_sync <= slide_meta;
        end
    end

    always_ff @ (posedge i_clk) begin
        if (i_push_sw) begin
            enc_stable       <= 0;
            enc_filter_count <= 0;
        end else if (enc_raw == enc_stable) begin
            enc_filter_count <= 0;
        end else if (enc_filter_count == (ENCODER_FILTER - 1)) begin
            enc_stable       <= enc_raw;
            enc_filter_count <= 0;
        end else begin
            enc_filter_count <= enc_filter_count + (1);
        end
    end

    always_comb begin
        step_up   = 0;
        step_down = 0;

        case ({enc_stable_prev, enc_stable})
            4'b0001, 4'b0111, 4'b1110, 4'b1000: step_up   = ~slide_sync;
            4'b0010, 4'b1011, 4'b1101, 4'b0100: step_down = ~slide_sync;
            default                           : begin
            end
        endcase
/*
        case ({enc_stable_prev, enc_stable})
            4'b0001, 4'b0111, 4'b1110, 4'b1000: step_down = slide_sync;
            4'b0010, 4'b1011, 4'b1101, 4'b0100: step_up   = slide_sync;
            default                           : begin
            end
        endcase
*/
    end

    always_ff @ (posedge i_clk) begin
        if (i_push_sw) begin
            enc_stable_prev <= 0;
            digit0          <= 0;
            digit1          <= 0;
            digit2          <= 0;
            digit3          <= 0;
            digit4          <= 0;
            digit5          <= 0;
        end else begin
            enc_stable_prev <= enc_stable;

            if (step_up) begin
                if (digit0 == 9) begin
                    digit0 <= 0;
                    if (digit1 == 9) begin
                        digit1 <= 0;
                        if (digit2 == 9) begin
                            digit2 <= 0;
                            if (digit3 == 9) begin
                                digit3 <= 0;
                                if (digit4 == 9) begin
                                    digit4 <= 0;
                                    if (digit5 == 9) begin
                                        digit5 <= 0;
                                    end else begin
                                        digit5 <= digit5 + (1);
                                    end
                                end else begin
                                    digit4 <= digit4 + (1);
                                end
                            end else begin
                                digit3 <= digit3 + (1);
                            end
                        end else begin
                            digit2 <= digit2 + (1);
                        end
                    end else begin
                        digit1 <= digit1 + (1);
                    end
                end else begin
                    digit0 <= digit0 + (1);
                end
            end else if (step_down) begin
                if (digit0 == 0) begin
                    digit0 <= 9;
                    if (digit1 == 0) begin
                        digit1 <= 9;
                        if (digit2 == 0) begin
                            digit2 <= 9;
                            if (digit3 == 0) begin
                                digit3 <= 9;
                                if (digit4 == 0) begin
                                    digit4 <= 9;
                                    if (digit5 == 0) begin
                                        digit5 <= 9;
                                    end else begin
                                        digit5 <= digit5 - (1);
                                    end
                                end else begin
                                    digit4 <= digit4 - (1);
                                end
                            end else begin
                                digit3 <= digit3 - (1);
                            end
                        end else begin
                            digit2 <= digit2 - (1);
                        end
                    end else begin
                        digit1 <= digit1 - (1);
                    end
                end else begin
                    digit0 <= digit0 - (1);
                end
            end
        end
    end

    always_ff @ (posedge i_clk) begin
        if (i_push_sw) begin
            scan_count <= 0;
            scan_digit <= 0;
        end else if (scan_count == (SCAN_DIVIDER_MAX - 1)) begin
            scan_count <= 0;
            if (scan_digit == 5) begin
                scan_digit <= 0;
            end else begin
                scan_digit <= scan_digit + (1);
            end
        end else begin
            scan_count <= scan_count + (1);
        end
    end

    always_comb begin
        current_digit = 0;
        o_digit_cath  = 6'b111111;

        case (scan_digit)
            0: begin
                current_digit = digit0;
                o_digit_cath  = 6'b111110;
            end
            1: begin
                current_digit = digit1;
                o_digit_cath  = 6'b111101;
            end
            2: begin
                current_digit = digit2;
                o_digit_cath  = 6'b111011;
            end
            3: begin
                current_digit = digit3;
                o_digit_cath  = 6'b110111;
            end
            4: begin
                current_digit = digit4;
                o_digit_cath  = 6'b101111;
            end
            5: begin
                current_digit = digit5;
                o_digit_cath  = 6'b011111;
            end
            default: begin
            end
        endcase

        case (current_digit)
            0      : o_seg_anode = 8'b00111111;
            1      : o_seg_anode = 8'b00000110;
            2      : o_seg_anode = 8'b01011011;
            3      : o_seg_anode = 8'b01001111;
            4      : o_seg_anode = 8'b01100110;
            5      : o_seg_anode = 8'b01101101;
            6      : o_seg_anode = 8'b01111101;
            7      : o_seg_anode = 8'b00000111;
            8      : o_seg_anode = 8'b01111111;
            9      : o_seg_anode = 8'b01101111;
            default: o_seg_anode = 8'b00000000;
        endcase
    end
endmodule
//# sourceMappingURL=top.sv.map

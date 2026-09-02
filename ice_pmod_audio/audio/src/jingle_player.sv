// =============================================================================
// jingle_player.sv
// Plays a short 5-tone chime in the style of the well-known "Intel Inside"
// audio sonic logo (xylo-marimba "bong" motif), as a single-bit square wave
// suitable for PMOD-AUDIO v1.2's onboard RC filter + PAM8403 amplifier
// (IL input, board Port1). Loops with a 2 s gap between repeats.
//
// Note table is a synthesis-safe combinational ROM (case statement) -- no
// `initial` blocks are used for content, matching project convention.
// =============================================================================
module jingle_player #(
    parameter int CLK_HZ = 50_000_000
) (
    input  logic clk,
    input  logic rst,
    output logic audio
);

    // -------------------------------------------------------------------
    // Step table (5 tones + trailing rest/gap before the loop repeats)
    //
    //  step | note            | freq (Hz) | half-period (cyc @50MHz) | dur (ms)
    //   0   | F#         |  739.989   | 33784               |  600
    //   1   | C#         |  554.365   | 45096               |  200
    //   2   | F#         |  739.989   | 33784               |  200
    //   3   | C#         |  554.365   | 45096               |  200
    //   4   | G#         |  830.609   | 30098               |  200
    //   5   | (rest / gap)  |    --   |      0              | 2000
    // -------------------------------------------------------------------
    localparam int NUM_STEPS = 7;

    logic [2:0]  step;
    logic [17:0] half_period;
    logic [26:0] duration_cyc;

    always_comb begin
        unique case (step)
            3'd0: begin half_period = 18'd67568; duration_cyc = 27'd10_000_000; end // 600ms
            3'd1: begin half_period = 18'd0;     duration_cyc = 27'd20_000_000; end //
            3'd2: begin half_period = 18'd90193; duration_cyc = 27'd10_000_000; end // 200ms
            3'd3: begin half_period = 18'd67568; duration_cyc = 27'd10_000_000; end // 200ms
            3'd4: begin half_period = 18'd90193; duration_cyc = 27'd10_000_000; end // 200ms
            3'd5: begin half_period = 18'd60196; duration_cyc = 27'd15_000_000; end //
            default: begin half_period = 18'd0;  duration_cyc = 27'd200_000_000; end // 3000ms rest
        endcase
    end

    // ---------------------------------------------------------------
    // Step/duration sequencer
    // ---------------------------------------------------------------
    logic [26:0] dur_cnt;
    logic        step_done;

    assign step_done = (dur_cnt == duration_cyc - 27'd1);

    always_ff @(posedge clk) begin
        if (rst) begin
            dur_cnt <= '0;
            step    <= '0;
        end else if (step_done) begin
            dur_cnt <= '0;
            step    <= (step == NUM_STEPS - 1) ? 3'd0 : step + 3'd1;
        end else begin
            dur_cnt <= dur_cnt + 27'd1;
        end
    end

    // ---------------------------------------------------------------
    // Square-wave tone generator
    // ---------------------------------------------------------------
    logic [17:0] tone_cnt;
    logic        tone_bit;
    logic        note_active;

    assign note_active = (half_period != 18'd0);

    always_ff @(posedge clk) begin
        if (rst) begin
            tone_cnt <= '0;
            tone_bit <= 1'b0;
        end else if (!note_active) begin
            tone_cnt <= '0;
            tone_bit <= 1'b0;                  // silence during the rest step
        end else if (tone_cnt == half_period - 18'd1) begin
            tone_cnt <= '0;
            tone_bit <= ~tone_bit;
        end else begin
            tone_cnt <= tone_cnt + 18'd1;
        end
    end

    assign audio = tone_bit;

endmodule

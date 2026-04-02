// =============================================================================
// led_matrix_tb.v  -  シミュレーション用テストベンチ
// iverilog + GTKWave で動作確認
// 使い方:
//   iverilog -o sim.vvp led_matrix_tb.v led_matrix_top.v && vvp sim.vvp
// =============================================================================
`timescale 1ns/1ps
`default_nettype none

module led_matrix_tb;

    // DUT信号
    reg  clk;
    wire sr_clk, sr_lat, sr_dat_red, sr_dat_grn, sr_dat_row;

    // DUT インスタンス
    led_matrix_top dut (
        .clk        (clk),
        .sr_clk     (sr_clk),
        .sr_lat     (sr_lat),
        .sr_dat_red (sr_dat_red),
        .sr_dat_grn (sr_dat_grn),
        .sr_dat_row (sr_dat_row)
    );

    // 50MHz クロック生成 (周期 20ns)
    initial clk = 0;
    always #10 clk = ~clk;

    // 受信シフトレジスタ (74LS595シミュレーション)
    reg [7:0] sim_reg_red, sim_reg_grn, sim_reg_row;
    reg [7:0] sim_lat_red, sim_lat_grn, sim_lat_row;
    reg       sr_clk_prev;

    always @(posedge clk) begin
        sr_clk_prev <= sr_clk;
        // 立ち上がりエッジ検出
        if (sr_clk && !sr_clk_prev) begin
            sim_reg_red <= {sim_reg_red[6:0], sr_dat_red};
            sim_reg_grn <= {sim_reg_grn[6:0], sr_dat_grn};
            sim_reg_row <= {sim_reg_row[6:0], sr_dat_row};
        end
        // ラッチパルス
        if (sr_lat) begin
            sim_lat_red <= sim_reg_red;
            sim_lat_grn <= sim_reg_grn;
            sim_lat_row <= sim_reg_row;
            $display("t=%0t  ROW=%08b  RED=%08b  GRN=%08b",
                     $time, sim_reg_row, sim_reg_red, sim_reg_grn);
        end
    end

    // シミュレーション期間: 10ms (2フレームスキャン分)
    initial begin
        $dumpfile("led_matrix.vcd");
        $dumpvars(0, led_matrix_tb);
        #10_000_000; // 10ms
        $display("Simulation done.");
        $finish;
    end

endmodule
`default_nettype wire

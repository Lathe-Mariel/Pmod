`timescale 1ns/1ps

module tb_top;
    localparam int CLK_FREQ = 8000;
    localparam int STEP_HZ  = 1000;              // 8 クロックごとにパターン更新
    localparam int STEP     = CLK_FREQ / STEP_HZ;

    logic       sys_clk = 0;
    logic       reset   = 1;
    logic       mode_btn = 0;
    logic [7:0] led_n;
    wire  [7:0] led = ~led_n;

    int errors = 0;

    top #(.CLK_FREQ(CLK_FREQ), .STEP_HZ(STEP_HZ), .DEBOUNCE_MS(1)) dut (.*);

    always #5 sys_clk = ~sys_clk;

    task automatic wait_steps(int n);
        repeat (n * STEP) @(posedge sys_clk);
    endtask

    task automatic press_button();
        // チャタリング付きで押下 -> 解放
        repeat (3) begin
            mode_btn = 1; repeat (2) @(posedge sys_clk);
            mode_btn = 0; repeat (2) @(posedge sys_clk);
        end
        mode_btn = 1; repeat (40) @(posedge sys_clk);
        mode_btn = 0; repeat (40) @(posedge sys_clk);
    endtask

    task automatic check(string name, logic [7:0] got, logic [7:0] exp);
        if (got !== exp) begin
            $display("FAIL %s: got %b exp %b", name, got, exp);
            errors++;
        end
    endtask

    // パターンが更新された直後の LED 値を n 回分取得
    task automatic capture(int n, output logic [7:0] seq [32]);
        logic [7:0] prev;
        int i;
        i = 0;
        prev = led;
        while (i < n) begin
            @(posedge sys_clk);
            if (led !== prev) begin
                seq[i] = led;
                prev   = led;
                i++;
            end
        end
    endtask

    logic [7:0] seq [32];

    initial begin
        repeat (5) @(posedge sys_clk);
        reset = 0;
        repeat (4) @(posedge sys_clk);

        // モード0: 流れるLED (1 個だけ点灯し L1 -> L8 -> L1 と回る)
        check("shift init", led, 8'b0000_0001);
        capture(9, seq);
        for (int i = 0; i < 9; i++)
            check($sformatf("shift[%0d]", i), seq[i], 8'b1 << ((i + 1) % 8));

        // モード1: ナイトライダー (1 個だけ点灯し端で折り返す)
        press_button();
        check("mode", dut.mode, 2'd1);
        capture(20, seq);
        begin
            int pos [20];
            for (int i = 0; i < 20; i++) begin
                if ($countones(seq[i]) != 1) begin
                    $display("FAIL rider[%0d]: not one-hot %b", i, seq[i]);
                    errors++;
                end
                for (int b = 0; b < 8; b++) if (seq[i][b]) pos[i] = b;
            end
            for (int i = 1; i < 20; i++) begin
                if (pos[i] - pos[i-1] != 1 && pos[i] - pos[i-1] != -1) begin
                    $display("FAIL rider[%0d]: jump %0d -> %0d", i, pos[i-1], pos[i]);
                    errors++;
                end
                if (i >= 2 && pos[i] == pos[i-2] && pos[i-1] != 0 && pos[i-1] != 7) begin
                    $display("FAIL rider[%0d]: turned at %0d", i, pos[i-1]);
                    errors++;
                end
            end
        end

        // モード2: バイナリカウンタ (更新ごとに +1)
        press_button();
        check("mode", dut.mode, 2'd2);
        capture(20, seq);
        for (int i = 1; i < 20; i++)
            check($sformatf("count[%0d]", i), seq[i], seq[i-1] + 8'd1);

        // モード3: ホタル (全LED同じ値で PWM)
        press_button();
        check("mode", dut.mode, 2'd3);
        repeat (2000) begin
            @(posedge sys_clk);
            if (led != 8'h00 && led != 8'hFF) begin
                $display("FAIL breath: led=%b", led);
                errors++;
                break;
            end
        end

        // モード3 -> 0 に戻る
        press_button();
        check("mode wrap", dut.mode, 2'd0);

        // リセットでモード0, 初期パターン
        press_button();
        reset = 1; repeat (4) @(posedge sys_clk);
        reset = 0; repeat (4) @(posedge sys_clk);
        check("mode after reset", dut.mode, 2'd0);
        check("led after reset", led, 8'b0000_0001);

        if (errors == 0) $display("PASS");
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end

    initial begin
        #10ms;
        $display("FAIL: timeout");
        $finish;
    end
endmodule

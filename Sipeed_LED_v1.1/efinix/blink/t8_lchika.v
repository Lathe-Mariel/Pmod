module t8_lchika (
    input  wire clk,     // 25MHz clock input (GPIOL_16)
    output reg  led_d1,  // D1 LED output (GPIOR_12)
    output reg  led_d2,  // D2 LED output (GPIOR_11)
    output reg  led_d3,  // D3 LED output (GPIOR_10)
    output reg  led_d4,  // D4 LED output (GPIOR_08)
    
    // Pmod1(J7) LEDs
    output reg  led0,    // led0 (GPIOR_26)
    output reg  led1,    // led1 (GPIOR_24)
    output reg  led2,    // led2 (GPIOR_21)
    output reg  led3,    // led3 (GPIOR_19)
    output reg  led4,    // led4 (GPIOR_27)
    output reg  led5,    // led5 (GPIOR_25)
    output reg  led6,    // led6 (GPIOR_22)
    output reg  led7     // led7 (GPIOR_20)
);

    // 25MHz clk -> 1Hz blink frequency (50% duty cycle)
    localparam CNT_MAX = 25000000 / 2 - 1; // 12,499,999
    
    // 25MHz clk -> 5Hz shift frequency (200ms step)
    localparam SHIFT_CNT_MAX = 25000000 / 5 - 1; // 4,999,999

    reg [23:0] counter;
    reg        blink;

    reg [22:0] shift_counter;
    reg [7:0]  led_shift;

    // Power-up initialization for FPGA registers
    initial begin
        counter       = 24'd0;
        blink         = 1'b0;
        shift_counter = 23'd0;
        led_shift     = 8'b00000001; // Start with led0 ON
    end

    // 1Hz blink timer for on-board LEDs
    always @(posedge clk) begin
        if (counter == CNT_MAX) begin
            counter <= 24'd0;
            blink   <= ~blink;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    // 5Hz shift timer for flowing LEDs
    always @(posedge clk) begin
        if (shift_counter == SHIFT_CNT_MAX) begin
            shift_counter <= 23'd0;
            led_shift     <= {led_shift[6:0], led_shift[7]}; // Shift with wrap-around
        end else begin
            shift_counter <= shift_counter + 1'b1;
        end
    end

    // On-board LEDs alternating pattern
    always @(*) begin
        led_d1 = blink;      // D1: ON when blink is 1
        led_d2 = ~blink;     // D2: ON when blink is 0
        led_d3 = blink;      // D3: ON when blink is 1
        led_d4 = ~blink;     // D4: ON when blink is 0
    end

    // Pmod1 LEDs flowing mapping
    always @(*) begin
        led0 = led_shift[0];
        led1 = led_shift[1];
        led2 = led_shift[2];
        led3 = led_shift[3];
        led4 = led_shift[4];
        led5 = led_shift[5];
        led6 = led_shift[6];
        led7 = led_shift[7];
    end

endmodule
module top (
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    output reg [5:0] led,   // 6 LEDS pin
    output sc1602_vo,
    output sc1602_rs,
    output sc1602_rw,
    output sc1602_enable,
    output [3:0] sc1602_data
);

logic [23:0] counter;
logic contrast;
logic sc1602_clk;
logic clkout;
logic locked;
logic sc1602_drawing;
logic [7:0] word_counter;
logic [7:0] word[4] = {8'h46, 8'h50, 8'h47, 8'h41};

assign contrast = 0;
//assign contrast = counter[6] & counter[5] & counter[4] & counter[3] & counter[2] & counter[1] & counter[0] ;

TBUF u0(
    .O(sc1602_vo),
    .I(1'b0),
    .OEN(~contrast)
);


always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        led[0] <= 0;
    else if (counter < 24'd1349_9999)       // 0.5s delay
        begin
            counter <= counter + 1'd1;
            led[0] <= 1;
        end
    else
        counter <= 24'd0;
end

Gowin_rPLL your_instance_name(
    .clkout(clkout),   //output clkout
    .clkoutd(sc1602_clk), //output clkoutd
    .clkin(sys_clk),    //input clkin
    .lock(locked)
);

always @(negedge sc1602_drawing)begin
    word_counter <= word_counter + 8'b1;
end

lcd_driver_8 driver0(
.clk(sc1602_clk),
.resetn(sys_rst_n & locked),
.character(word[word_counter]),
.sc1602_en(sc1602_enable),
.sc1602_rs(sc1602_rs),
.sc1602_rw(sc1602_rw),
.sc1602_db(sc1602_data),
.drawing(sc1602_drawing)
//.frame_rate()
);

endmodule
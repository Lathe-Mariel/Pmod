module top (
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    output reg [5:0] led,   // 6 LEDS pin
    output sc1608_vo,
    output sc1608_rs,
    output sc1608_rw,
    output sc1608_enable,
    output [3:0] sc1608_data
);

reg [23:0] counter;
wire contrast;
wire sc1602_clk;
wire clkout;
wire locked;

assign contrast = 0;
//assign contrast = counter[6] & counter[5] & counter[4] & counter[3] & counter[2] & counter[1] & counter[0] ;

TBUF u0(
    .O(sc1608_vo),
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

lcd_driver_8 driver0(
.clk(sc1602_clk),
.resetn(sys_rst_n & locked),
//.addr(),
.data(8'h42),
//.rd(),
.sc1602_en(sc1608_enable),
.sc1602_rs(sc1608_rs),
.sc1602_rw(sc1608_rw),
.sc1602_data(sc1608_data)
//.rfrsh_rate()
);

endmodule
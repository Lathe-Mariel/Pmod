module top (
    input sys_clk,          // clk input
    input sys_rst_n,        // reset input
    input sw,
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
logic [7:0] word[8] = {8'h20, 8'h46, 8'h50, 8'h47, 8'h41, 8'h20, 8'h20, 8'h20};

logic sc1602_valid, sc1602_ready;
logic [2:0] sc1602_command; // {2'b command, 1'b LR}

assign contrast = 0;

TBUF u0(
    .O(sc1602_vo),
    .I(1'b0),
    .OEN(~contrast)
);


always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)begin
        led[0] <= 0;
        counter <= 0;
    end else if (counter < 24'd1349_9999)begin      // 0.5s delay
        counter <= counter + 1'd1;
        led[0] <= 1;  //on board LED for debug
        if(sc1602_ready)begin
            if(!sw)begin
                led[1] <= 0;  // on board LED for debug
                sc1602_command <= {2'b01, 1'b0};    // Window shift, left
            end else begin
                led[1] <= 1;  // on board LED for bebug
            end
        end else begin
            sc1602_command <= 3'b0;
        end
    end else begin
        counter <= 24'd0;
    end

end

Gowin_rPLL your_instance_name(
    .clkout(clkout),      //output clkout
    .clkoutd(sc1602_clk), //output clkoutd
    .clkin(sys_clk),      //input clkin
    .lock(locked)
);

always @(negedge sc1602_drawing or negedge sys_rst_n)begin
    if(!sys_rst_n)begin
        word_counter <= 0;
    end else begin
        word_counter <= word_counter + 8'b1;
    end
end

lcd_driver_8 driver0(
.clk(sc1602_clk),
.resetn(sys_rst_n & locked),
.character(word[word_counter]),
.sc1602_en(sc1602_enable),
.sc1602_rs(sc1602_rs),
.sc1602_rw(sc1602_rw),
.sc1602_db(sc1602_data),
.drawing(sc1602_drawing),
.command_in(sc1602_command),
.ready_o(sc1602_ready)
//.frame_rate()
);

endmodule
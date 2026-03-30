// ============================================================
// top.v  –  Tang Primer 25K  /  Pmod-LCD-0.96 (ST7735S)
// 7-color vertical stripe test pattern  RGB565
// ============================================================
module top (
    input  wire clk,        // 50 MHz onboard oscillator
    input  wire rst_n,      // active-low reset (onboard button)

    // Pmod connector (Port1)
    output wire lcd_cs,     // A11  – Pmod1
    output wire lcd_mosi,   // E11  – Pmod2
    output wire lcd_dc,     // K11  – Pmod3
    output wire lcd_clk,    // L5   – Pmod4
    output wire lcd_rst     // K5   – Pmod8
);

// ----------------------------------------------------------
// Instantiate LCD controller
// ----------------------------------------------------------
wire       ctrl_cs, ctrl_mosi, ctrl_dc, ctrl_rst;
wire       pixel_req;
wire [8:0] pixel_x;
wire [8:0] pixel_y;
wire [15:0] pixel_data;

lcd_controller u_ctrl (
    .clk        (clk),
    .spi_clk    (spi_clk),
    .rst_n      (rst_n),
    .lcd_cs     (ctrl_cs),
    .lcd_mosi   (ctrl_mosi),
    .lcd_dc     (ctrl_dc),
    .lcd_rst    (ctrl_rst),
    .pixel_req  (pixel_req),
    .pixel_x    (pixel_x),
    .pixel_y    (pixel_y),
    .pixel_data (pixel_data)
);

assign lcd_cs   = ctrl_cs;
assign lcd_mosi = ctrl_mosi;
assign lcd_dc   = ctrl_dc;
assign lcd_rst  = ctrl_rst;
assign lcd_clk  = ctrl_cs ? 1'b1 : spi_clk;  // freeze clk when CS deasserted

// ----------------------------------------------------------
// Test pattern: 7-color vertical stripes  (RGB565)
// Width = 132 pixels  → each stripe ≈ 18–19 px
// Colors: Black Red Green Blue Cyan Magenta Yellow White
// Using 7 colors: Red Green Blue Cyan Magenta Yellow White
// ----------------------------------------------------------
// Stripe boundaries (132 / 7 ≈ 18.86)
// 0..18 | 19..37 | 38..56 | 57..75 | 76..94 | 95..113 | 114..131
// Red   | Green  | Blue   | Cyan   | Magenta| Yellow  | White

function [15:0] stripe_color;
    input [8:0] x;
    begin
        if      (x < 9'd19)  stripe_color = 16'hF800; // Red
        else if (x < 9'd38)  stripe_color = 16'h07E0; // Green
        else if (x < 9'd57)  stripe_color = 16'h001F; // Blue
        else if (x < 9'd76)  stripe_color = 16'h07FF; // Cyan
        else if (x < 9'd95)  stripe_color = 16'hF81F; // Magenta
        else if (x < 9'd114) stripe_color = 16'hFFE0; // Yellow
        else                 stripe_color = 16'hFFFF; // White
    end
endfunction

assign pixel_data = stripe_color(pixel_x);

endmodule

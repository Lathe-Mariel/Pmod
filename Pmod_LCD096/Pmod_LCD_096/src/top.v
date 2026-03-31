// ============================================================
// top.v  -  Tang Primer 25K  /  Pmod-LCD-0.96 (ST7735S)
// 7-color vertical stripe test pattern  RGB565
// Resolution: 160x80
// Clocks: 27 MHz (board) -> PLL -> 50 MHz system / 25 MHz SPI
// ============================================================
module top (
    input  wire clk,      // 27 MHz onboard oscillator (H11)
    input  wire rst_n,  // active-low reset button

    // Pmod connector (Port1)
    output wire lcd_cs,     // A11  - Pmod1
    output wire lcd_mosi,   // E11  - Pmod2
    output wire lcd_dc,     // K11  - Pmod3
    output wire lcd_clk,    // L5   - Pmod4
    output wire lcd_rst     // K5   - Pmod8
);



// ----------------------------------------------------------
// Reset: release only after PLL locked AND button released
// ----------------------------------------------------------


// ----------------------------------------------------------
// Clock divider: 50 MHz -> 25 MHz SPI clock
// ----------------------------------------------------------
reg clk_div;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) clk_div <= 1'b0;
    else        clk_div <= ~clk_div;
end

wire spi_clk = clk_div;   // 25 MHz

// ----------------------------------------------------------
// Instantiate LCD controller
// ----------------------------------------------------------
wire        ctrl_cs, ctrl_mosi, ctrl_dc, ctrl_rst;
wire        pixel_req;
wire [7:0]  pixel_x;   // 0..159
wire [6:0]  pixel_y;   // 0..79
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
assign lcd_clk  = ctrl_cs ? 1'b1 : spi_clk;  // hold clk HIGH when CS deasserted

// ----------------------------------------------------------
// Test pattern: 7-color vertical stripes (RGB565)
// Width = 160 px  ->  each stripe ~22-23 px  (160/7 = 22.86)
// Boundaries: 0..22|23..45|46..68|69..91|92..114|115..137|138..159
// Colors:     Red  |Green |Blue  |Cyan  |Magenta|Yellow  |White
// ----------------------------------------------------------
function [15:0] stripe_color;
    input [7:0] x;
    begin
        if      (x < 8'd23)  stripe_color = 16'hF800; // Red
        else if (x < 8'd46)  stripe_color = 16'h07E0; // Green
        else if (x < 8'd69)  stripe_color = 16'h001F; // Blue
        else if (x < 8'd92)  stripe_color = 16'h07FF; // Cyan
        else if (x < 8'd115) stripe_color = 16'hF81F; // Magenta
        else if (x < 8'd138) stripe_color = 16'hFFE0; // Yellow
        else                 stripe_color = 16'hFFFF; // White
    end
endfunction

assign pixel_data = stripe_color(pixel_x);

endmodule
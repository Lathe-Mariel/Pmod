// ============================================================
// lcd_test_top.v - LCD Test Pattern Top Module
// Tang Primer 25K + PMOD-TFTLCD v1.1 (ILI9341, 320x240)
//
// Hardware Connection:
//   Port0 Pmod5 (G5)  → CS   (Chip Select, active low)
//   Port0 Pmod6 (G8)  → MOSI (SPI Data)
//   Port0 Pmod8 (J5)  → CLK  (SPI Clock)
//   Port1 Pmod3 (K11) → RS   (Data/Command = DC)
//
//   RST : ボード側でVCCに固定 (FPGA未接続)
//   BLK : ボード側でVCCに固定 (FPGA未接続)
// ============================================================

module lcd_test_top (
    input  wire clk,       // 50 MHz system clock
    output wire lcd_cs,    // SPI Chip Select (active low)  → G5
    output wire lcd_mosi,  // SPI MOSI                     → G8
    output wire lcd_sck,   // SPI Clock                    → J5
    output wire lcd_dc     // Data/Command (RS)             → K11
);

lcd_ctrl u_lcd_ctrl (
    .clk      (clk),
    .lcd_cs   (lcd_cs),
    .lcd_mosi (lcd_mosi),
    .lcd_sck  (lcd_sck),
    .lcd_dc   (lcd_dc)
);

endmodule

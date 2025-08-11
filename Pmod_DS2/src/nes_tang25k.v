//
// NES top level for Sipeed Tang 25K
// 
//

// `timescale 1ns / 100ps
`default_nettype none

module NES_Tang25k(
    input wire sys_clk,

    input wire s1,
    input wire reset,
    // UART
    input wire UART_RXD,
    output wire UART_TXD,
    // LEDs
    output wire [1:0] led,
    // Dualshock game controller
    output wire joystick_clk,
    output wire joystick_mosi,
    input wire joystick_miso,
    output reg joystick_cs,
    output wire joystick_clk2,
    output wire joystick_mosi2,
    input wire joystick_miso2,
    output reg joystick_cs2, 

    // HDMI TX
    output wire  O_tmds_clk_n,
    output wire  O_tmds_clk_p,
    output wire [2:0] O_tmds_data_n,
    output wire [2:0] O_tmds_data_p,
    output wire [7:0] pmod_led,

    // SDRAM
    output wire O_sdram_clk,
    output wire O_sdram_cke,
    output wire O_sdram_cs_n,            // chip select
    output wire O_sdram_cas_n,           // columns address select
    output wire O_sdram_ras_n,           // row address select
    output wire O_sdram_wen_n,           // write enable
    inout wire [15:0] IO_sdram_dq,       // 16 bit bidirectional data bus
    output wire [12:0] O_sdram_addr,     // 13 bit multiplexed address bus
    output wire [1:0] O_sdram_ba,        // two banks
    output wire [1:0] O_sdram_dqm        // 32/4

);

`include "nes_tang25k.vh"

//memory interface
wire                   memory_clk         ;
wire                   memory_clk45;
wire                   fb_clk;
wire                   clk32_5;
//wire                   dma_clk       	  ;

wire                   sdrc_busy_n        ;
wire[2:0]              cmd                ;
wire                   cmd_en             ;
wire[7:0]              sdrc_data_len      ;
wire[20:0]             sdrc_addr          ;
wire                   wr_data_rdy        ;
wire                   sdrc_wr_n         ;//
wire                   wr_data_end        ;//
wire[15:0]   wr_data;  
wire                   sdrc_rd_valid;
wire                   rd_data_end        ;//unused   
wire [15:0] sdrc_data;
wire                   sdrc_init_done;

reg sys_resetn = 0;
reg [7:0] reset_cnt = 255;
always@(posedge clk3)    begin
    reset_cnt <= reset_cnt == 0 ? 0 : reset_cnt -1;
    if(reset_cnt == 0)
        sys_resetn <= ~reset & ~s1;
end

`ifndef VERILATOR

  wire clk3;

    Gowin_PLL pll_clk(
        .lock(pll_lock), //output lock
        .clkout0(), //output clkout0 12MHz
        .clkout1(), //output clkout1 25MHz phase270
        .clkout2(clk_p5), //output clkout2 371.25MHz
        .clkout3(clk3), //output clkout3 25MHz
        .clkin(sys_clk) //input clkin
    );

  // HDMI domain clocks
  wire clk_p;     // 720p pixel clock: 74.25 Mhz
  wire clk_p5;    // 5x pixel clock: 371.25 Mhz
  wire pll_lock;

    Gowin_CLKDIV clk_div (
      .clkout(clk_p),
      .hclkin(clk_p5),
      .resetn(sys_resetn & pll_lock)
    );

`else   // VERILATOR
  // dummy clocks for verilator
`endif

  wire [5:0] color;
  wire [15:0] sample;
  wire [8:0] scanline;
  wire [8:0] cycle;

  // internal wiring and state
  wire joypad_strobe;
  wire [1:0] joypad_clock;

  reg [7:0] joypad_bits, joypad_bits2;
  reg [1:0] last_joypad_clock;
  wire [31:0] dbgadr;
  wire [1:0] dbgctr;
  reg [3:0] nes_ce = 0;
  wire [15:0] SW = 16'b1111_1111_1111_1111;   // every switch is on

  // UART
  wire [7:0] uart_data;
  wire [7:0] uart_addr;
  wire       uart_write;
  wire       uart_error;
`ifndef VERILATOR
UartDemux #(.FREQ(FREQ), .BAUDRATE(BAUDRATE)) uart_demux(
    clk3, 1'b0, UART_RXD, uart_data, uart_addr, uart_write, uart_error
);
`endif

  // ROM loader
  reg  [7:0] loader_conf;     // bit 0 is reset

  reg  [7:0] loader_btn, loader_btn_2;
  always @(posedge clk3) begin
    if (uart_addr == 8'h35 && uart_write)
      loader_conf <= uart_data;
    if (uart_addr == 8'h40 && uart_write)
      loader_btn <= uart_data;
    if (uart_addr == 8'h41 && uart_write)
      loader_btn_2 <= uart_data;
  end

  /*
  joy_rx[0:1] dualshock buttons: 0:(L D R U St R3 L3 Se)  1:(□ X O △ R1 L1 R2 L2)
  nes_btn[0:1] NES buttons:      (R L D U START SELECT B A)
  O is A, X is B
  */
  wire [7:0] joy_rx[0:1], joy_rx2[0:1];     // 6 RX bytes for all button/axis state

  wire auto_square, auto_triangle, auto_square2, auto_triangle2;
  wire [7:0] nes_btn = {~joy_rx[0][5], ~joy_rx[0][7], ~joy_rx[0][6], ~joy_rx[0][4], 
                        ~joy_rx[0][3], ~joy_rx[0][0], ~joy_rx[1][6] | auto_square, ~joy_rx[1][5] | auto_triangle} ;
  wire [7:0] nes_btn2 = {~joy_rx2[0][5], ~joy_rx2[0][7], ~joy_rx2[0][6], ~joy_rx2[0][4], 
                         ~joy_rx2[0][3], ~joy_rx2[0][0], ~joy_rx2[1][6] | auto_square2, ~joy_rx2[1][5] | auto_triangle2} ;
  
assign pmod_led = {joy_rx[0][4],joy_rx[1][3:0],joy_rx[1][7:5]}; //for test

  // Joypad handling
  always @(posedge clk3) begin
    if (joypad_strobe) begin
      joypad_bits <= loader_btn | nes_btn;
      joypad_bits2 <= loader_btn_2 | nes_btn2;
    end
    if (!joypad_clock[0] && last_joypad_clock[0])
      joypad_bits <= {1'b0, joypad_bits[7:1]};
    if (!joypad_clock[1] && last_joypad_clock[1])
      joypad_bits2 <= {1'b0, joypad_bits2[7:1]};
    last_joypad_clock <= joypad_clock;
  end

  wire loader_done;

  // The NES machine
  // nes_ce  / 0 \___/ 1 \___/ 2 \___/ 3 \___/ 4 \___/ 0 \___
  // MemCtrl |mem_cmd|ACTIVE | RD/WR |       |  Dout |run_mem|
  // NES                                     |run_nes|
  //                 `-------- read delay = 4 -------'
  wire reset_nes = !loader_done;
  wire run_mem = (nes_ce == 0) && !reset_nes;       // memory runs at clock cycle #0
  wire run_nes = (nes_ce == 4) && !reset_nes;       // nes runs at clock cycle #4

  // For debug
  reg last_write;   // if 0, then we did a read
  reg last_idle;

/*verilator tracing_off*/
/*verilator tracing_on*/

`ifndef VERILATOR

// HDMI output


// Dualshock controller
reg sclk;                   // controller main clock at 250Khz
localparam  SCLK_DELAY = FREQ / 200_000;
reg [$clog2(SCLK_DELAY)-1:0] sclk_cnt;         

// Generate sclk
always @(posedge clk3) begin
    sclk_cnt <= sclk_cnt + 1;
    if (sclk_cnt == SCLK_DELAY-1) begin
        sclk = ~sclk;
        sclk_cnt <= 0;
    end
end

dualshock_controller controller (
    .I_CLK250K(sclk), .I_RSTn(1'b1),
    .O_psCLK(joystick_clk), .O_psSEL(joystick_cs), .O_psTXD(joystick_mosi),
    .I_psRXD(joystick_miso),
    .O_RXD_1(joy_rx[0]), .O_RXD_2(joy_rx[1]), .O_RXD_3(),
    .O_RXD_4(), .O_RXD_5(), .O_RXD_6(),
    // config=1, mode=1(analog), mode_en=1
    .I_CONF_SW(1'b0), .I_MODE_SW(1'b1), .I_MODE_EN(1'b0),
    .I_VIB_SW(2'b00), .I_VIB_DAT(8'hff)     // no vibration
);

dualshock_controller controller2 (
    .I_CLK250K(sclk), .I_RSTn(1'b1),
    .O_psCLK(joystick_clk2), .O_psSEL(joystick_cs2), .O_psTXD(joystick_mosi2),
    .I_psRXD(joystick_miso2),
    .O_RXD_1(joy_rx2[0]), .O_RXD_2(joy_rx2[1]), 
    .O_RXD_3(), .O_RXD_4(), .O_RXD_5(), .O_RXD_6(),
    .I_CONF_SW(1'b0), .I_MODE_SW(1'b1), .I_MODE_EN(1'b0),
    .I_VIB_SW(2'b00), .I_VIB_DAT(8'hff)     // no vibration
);

Autofire af_square (.clk(clk3), .resetn(sys_resetn), .btn(~joy_rx[1][7] ), .out(auto_square));            // B
Autofire af_triangle (.clk(clk3), .resetn(sys_resetn), .btn(~joy_rx[1][4] ), .out(auto_triangle));        // A
Autofire af_square2 (.clk(clk3), .resetn(sys_resetn), .btn(~joy_rx2[1][7] ), .out(auto_square2));
Autofire af_triangle2 (.clk(clk3), .resetn(sys_resetn), .btn(~joy_rx2[1][4] ), .out(auto_triangle2));

//
// Print control
//
`include "print.v"
defparam tx.uart_freq=BAUDRATE;
defparam tx.clk_freq=FREQ;

assign UART_TXD = uart_txp;


reg tick;       // pulse every 0.01 second
reg print_stat; // pulse every 2 seconds

reg [19:0] timer;           // 37 times per second
always @(posedge clk3) timer <= timer + 1;


reg [19:0] tick_counter;
reg [9:0] stat_counter;
always @(posedge clk3) begin
    tick <= tick_counter == 0;
    tick_counter <= tick_counter == 0 ? FREQ/100 : tick_counter - 1;

    print_stat <= 0;
    if (tick) begin
        print_stat <= stat_counter == 0;
        stat_counter <= stat_counter == 0 ? 200 : stat_counter - 1;
    end
end

`endif

wire camera_de;
wire out_de;
wire monitor_en;
  //-------------------
  //Timing Generator
  //-------------------

//wire [9:0] lcd_x,lcd_y;
vga_timing vga_timing_m0(
    .clk (clk_p),
    .rst (sys_resetn),

    .hs(syn_off0_hs),
    .vs(syn_off0_vs),
    .de(out_de),
    .rd(camera_de)
//    .monitor_en(monitor_en)
);

logic[1:0] sdrc_dqm;
logic sdrc_rd_n;

	Video_Frame_Buffer_SDRAM frameBuffer_SDRAM(
		.I_rst_n(sys_resetn),     //input I_rst_n
		.I_dma_clk(memory_clk45   ), //input I_dma_clk

		.I_wr_halt(         ),    //input [0:0] I_wr_halt
		.I_rd_halt(           ),  //input [0:0] I_rd_halt

		.I_vin0_clk(),               //input I_vin0_clk               cmos_16bit_clk
		.I_vin0_vs_n(  ),            //input I_vin0_vs_n              ~cmos_vsync
		.I_vin0_de(),                //input I_vin0_de                cmos_16bit_wr
		.I_vin0_data(   ),           //input [15:0] I_vin0_data       write_data
		.O_vin0_fifo_full(        ), //output O_vin0_fifo_full

		.I_vout0_clk(clk_p    ),    //input I_vout0_clk              video_clk
		.I_vout0_vs_n(~syn_off0_vs), //input I_vout0_vs_n
		.I_vout0_de(     ), //input I_vout0_de                        camera_de
		.O_vout0_den(off0_syn_de  ), //output O_vout0_den
		.O_vout0_data(off0_syn_data), //output [15:0] O_vout0_data
		.O_vout0_fifo_empty(       ), //output O_vout0_fifo_empty

		.I_sdrc_busy_n(sdrc_busy_n   ), //input I_sdrc_busy_n
		.O_sdrc_wr_n(sdrc_wr_n    ), //output O_sdrc_wr_n
		.O_sdrc_rd_n(sdrc_rd_n     ), //output O_sdrc_rd_n
		.O_sdrc_addr(sdrc_addr          ), //output [20:0] O_sdrc_addr
		.O_sdrc_data_len(sdrc_data_len), //output [7:0] O_sdrc_data_len
		.O_sdrc_data(wr_data       ), //output [15:0] O_sdrc_data
		.O_sdrc_dqm(sdrc_dqm       ), //output [1:0] O_sdrc_dqm
		.I_sdrc_rd_valid(sdrc_rd_valid), //input I_sdrc_rd_valid
		.I_sdrc_data_out(sdrc_data ), //input [15:0] I_sdrc_data_out
		.I_sdrc_init_done(sdrc_init_done) //input I_sdrc_init_done
	);

SDRAM_controller_top_SIP sdram_controller0( // IPUG279-1.3J  P.7
		.O_sdram_clk(O_sdram_clk    ),      //output O_sdram_clk
		.O_sdram_cke(O_sdram_cke    ),      //output O_sdram_cke
		.O_sdram_cs_n(O_sdram_cs_n  ),      //output O_sdram_cs_n
		.O_sdram_cas_n(O_sdram_cas_n),      //output O_sdram_cas_n
		.O_sdram_ras_n(O_sdram_ras_n),      //output O_sdram_ras_n
		.O_sdram_wen_n(O_sdram_wen_n),      //output O_sdram_wen_n
		.O_sdram_dqm(O_sdram_dqm    ),      //output [1:0] O_sdram_dqm
		.O_sdram_addr(O_sdram_addr  ),      //output [12:0] O_sdram_addr
		.O_sdram_ba(O_sdram_ba      ),      //output [1:0] O_sdram_ba
		.IO_sdram_dq(IO_sdram_dq    ),              // [15:0] IO_sdram_dq
		.I_sdrc_rst_n(sys_resetn    ),              // リセット
		.I_sdrc_clk(memory_clk45    ),              // I_sdrc_clk コントローラ動作クロック
        .I_sdram_clk(memory_clk     ),              // I_sdram_clk SDRAM動作クロック
		.I_sdrc_selfrefresh(1'b0 ),                 // I_sdrc_selfrefresh セルフリフレッシュ制御(1:有効, 0:無効)
		.I_sdrc_power_down(1'b0  ),                 // I_sdrc_power_down 低消費電力制御(1:有効, 0:無効)
		.I_sdrc_wr_n(sdrc_wr_n  ),                 // I_sdrc_wr_n 書込イネーブル
		.I_sdrc_rd_n(sdrc_rd_n   ),                 // I_sdrc_rd_n 読取イネーブル
		.I_sdrc_addr({2'b00,sdrc_addr}  ),                 // [22:0] I_sdrc_addr アドレス
		.I_sdrc_data_len(sdrc_data_len),         // [7:0] I_sdrc_data_len 読み書きデータ長
		.I_sdrc_dqm(sdrc_dqm     ),                 // [1:0] I_sdrc_dqm データマスク制御
		.I_sdrc_data(wr_data     ),                 // [15:0] I_sdrc_data 書込データ
		.O_sdrc_data(sdrc_data     ),                 // [15:0] O_sdrc_data 読取データ
		.O_sdrc_init_done(sdrc_init_done),     // O_sdrc_init_done パワーアップ初期化完了(1:完了, 0:未完)
		.O_sdrc_busy_n(sdrc_busy_n ),                 // O_sdrc_busy_n コントローラアイドル表示．アイドル時に読み書きトリガ可能(1:アイドル, 0:ビジー)
		.O_sdrc_rd_valid(sdrc_rd_valid),            // O_sdrc_rd_valid 読み取りデータ有効．(1:有効)
		.O_sdrc_wrd_ack(         )                // O_sdrc_wrd_ack 読み書きリクエスト応答
);

//According to IP parameters to choose
`define	    WR_VIDEO_WIDTH_16
`define	DEF_WR_VIDEO_WIDTH 16

`define	    RD_VIDEO_WIDTH_16
`define	DEF_RD_VIDEO_WIDTH 16

`define	USE_THREE_FRAME_BUFFER

`define	DEF_ADDR_WIDTH 28 
`define	DEF_SRAM_DATA_WIDTH 128
parameter WR_VIDEO_WIDTH      = `DEF_WR_VIDEO_WIDTH;  
parameter RD_VIDEO_WIDTH      = `DEF_RD_VIDEO_WIDTH;  
wire                      syn_off0_re;  // ofifo read enable signal
wire                      syn_off0_vs;
wire                      syn_off0_hs;
                          
wire                      off0_syn_de  ;
wire [RD_VIDEO_WIDTH-1:0] off0_syn_data;

wire lcd_vs,lcd_de,lcd_hs;

    // -----------------------------
    //  表示画像オーバーレイ
    // -----------------------------

    logic           prev_de;
    logic   [11:0]  dvi_x;
    logic   [10:0]  dvi_y;

    always_ff @(posedge clk_p ) begin
        prev_de <= lcd_de;

        if ( ~lcd_de ) begin
            dvi_x <= 0;
        end
        else begin
            dvi_x <= dvi_x + 1;
        end

        if ( lcd_vs ) begin
            dvi_y <= 0;
        end
        else begin
            if ( {prev_de, lcd_de} == 2'b10 ) begin
                dvi_y <= dvi_y + 1;
            end
        end
    end

  // ----------------------
  // HDMI出力 Output HDMI signal(by IP)
  // ----------------------

DVI_TX_Top DVI_TX_Top_inst
(
    .I_rst_n       (sys_resetn   ),  //asynchronous reset, low active
    .I_serial_clk  (clk_p5       ),

    .I_rgb_clk     (clk_p      ),  //pixel clock
    .I_rgb_vs      (lcd_vs        ), 
    .I_rgb_hs      (lcd_hs        ),    
    .I_rgb_de      (lcd_de        ), 
    .I_rgb_r       ( off0_syn_de? {off0_syn_data[4:0],3'b0}: dvi_x),  //tp0_data_r
    .I_rgb_g       ( off0_syn_de? {off0_syn_data[10:5],2'b0}: dvi_y),  //,  
    .I_rgb_b       ( off0_syn_de? {off0_syn_data[15:11],3'b0}: 8'hff),  //,
/*
    .I_rgb_r       ( off0_syn_de? {off0_syn_data[4:0],3'b0}: bin_en?{8{bin_view}}: mnist_en? {8{mnist_view}}: dvi_x),  //tp0_data_r
    .I_rgb_g       ( off0_syn_de? {off0_syn_data[10:5],2'b0}: bin_en?{8{bin_view}}: mnist_en? {8{mnist_view}}: dvi_y),  //,  
    .I_rgb_b       ( off0_syn_de? {off0_syn_data[15:11],3'b0}: bin_en?{8{bin_view}}: mnist_en? {8{mnist_view}}: 8'hff),  //,
*/
    .O_tmds_clk_p  (O_tmds_clk_p  ),
    .O_tmds_clk_n  (O_tmds_clk_n  ),
    .O_tmds_data_p (O_tmds_data_p ),  //{r,g,b}
    .O_tmds_data_n (O_tmds_data_n )
);

endmodule
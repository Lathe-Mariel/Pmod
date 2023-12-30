`default_nettype none

module top (
  input  wire       clk,

  input  wire sw1,
  input  wire sw2,
  output wire AD_CLK,
  output logic CS,
  output logic DIN,
  input reg DOUT,
  output wire[5:0] boardLED,
  output wire P3_SEG_SER,
  output wire P9_SEG_SRCLK,
  output wire P4_SEG_RCLK,
  output wire P10_SEG_OE,
  output wire P1_COM_SER,
  output wire P7_COM_SRCLK,
  output wire P2_COM_RCLK,
  output wire P8_COM_OE,
  output wire clear,
  output wire sclk,
  output wire rclk,
  output wire serial_data
);

  logic  controlCLK;

  logic[15:0] processCounter;  // general counter 

  logic[3:0] display7seg[8] = {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0}; //000000-999999

  logic[9:0] recieveADC;

  logic P1_COM_SER;
  logic P2_COM_RCLK;

  logic P3_SEG_SER;
  logic P4_SEG_RCLK;

  timer #(
    .COUNT_MAX()
  ) inst_1 (
    .clk (clk),
    .overflow(controlCLK)
  );

  frameBuffer_16x16 fb_inst(
    .clk(clk),
    .sclk(sclk),
    .rclk(rclk),
    .clear(clear),
    .serial_data(serial_data),
    .set_busy(set_busy),
    .set_request(set_request),
    .set_row(set_row),
    .set_value(set_value)
);

  always @(posedge controlCLK)begin

    processCounter <= processCounter + 1;

//ADC
    if(processCounter[4:0] == 5'd0)begin
      CS <= 0;
      DIN <= 0;
    end else if(processCounter[4:0] < 5'd8)begin
      CS <=0;
    end else if(processCounter[4:0] == 5'd8)begin  // START(always: 1)
      DIN <= 1;
      CS <= 0;
    end else if(processCounter[4:0] == 5'd9)begin  //SINGLE or DIFFERENTIAL(SGL: 1)
      DIN <= 1;
      CS <= 0;
    end else if(processCounter[4:0] == 5'd10)begin  // D2
      DIN <= 0;
      CS <= 0;
    end else if(processCounter[4:0] == 5'd11)begin  // D1
      DIN <= 0;
      CS <= 0;
    end else if(processCounter[4:0] == 5'd12)begin  // D0
      DIN <= 0;
      CS <= 0;
    end else if(processCounter[4:0] < 5'd15)begin  // 0
      CS <= 0;
    end else if(processCounter[4:0] > 5'd14 && processCounter[4:0] < 25)begin  // recieve data
      recieveADC[24 - processCounter[4:0]] <= DOUT;
      DIN <= 0;
      CS <= 0;
    end else begin
 
      DIN <= 0;
      CS <= 1;
    end
    display7seg[5 - processCounter[7:5]] <= (recieveADC >> (processCounter[7:5]*4))& 4'b1111;

//7seg
    if(processCounter[2:0] == 3'b000)begin
      P2_COM_RCLK <= 1;
      P4_SEG_RCLK <= 1;
    end else begin
      P2_COM_RCLK <= 0;
      P4_SEG_RCLK <= 0;
    end

    if(processCounter[5:3] == (7 - processCounter[2:0]))begin
      P1_COM_SER <= 0;
    end else begin
      P1_COM_SER <= 1;
    end

    P3_SEG_SER <= currentBit(decode7seg(display7seg[processCounter[5:3]]));

//    P3_SEG_SER <= currentBit(decode7seg(display7seg[processCounter[5:3]]));

//showing frame buffer
    if(opd_o)begin
//    if(processCounter[10])begin
      set_row <= idx_o;
//      set_row <= processCounter[8:5];
      set_value <= 3+ xk_re_o/64;
//      set_value <= 4'd7;
      if(!set_request & !set_busy)begin
        set_request <= 1'b1;
      end
      if(set_busy)begin
        set_request <= 1'b0;
      end
    end

  end

  function currentBit;
  input [7:0] in;
    currentBit = in[processCounter[2:0]];
  endfunction

  //assign P3_SEG_SER = currentBit(decode7seg(display7seg[processCounter[5:3]]));

  assign P9_SEG_SRCLK = ~controlCLK;
  assign P10_SEG_OE = 1'b0;

  assign P7_COM_SRCLK = ~controlCLK;
  assign P8_COM_OE = 1'b0;

  assign AD_CLK = controlCLK;

  function [7:0] decode7seg;
  input [3:0] in1;
    case(in1)
      4'h0:  decode7seg = 8'b11111100;
      4'h1:  decode7seg = 8'b01100000;
      4'h2:  decode7seg = 8'b11011010;
      4'h3:  decode7seg = 8'b11110010;
      4'h4:  decode7seg = 8'b01100110;
      4'h5:  decode7seg = 8'b10110110;
      4'h6:  decode7seg = 8'b10111110;
      4'h7:  decode7seg = 8'b11100000;
      4'h8:  decode7seg = 8'b11111110;
      4'h9:  decode7seg = 8'b11110110;
      4'ha:  decode7seg = 8'b11101110;
      4'hb:  decode7seg = 8'b00111110;
      4'hc:  decode7seg = 8'b10011100;
      4'hd:  decode7seg = 8'b01111000;
      4'he:  decode7seg = 8'b10011110;
      4'hf:  decode7seg = 8'b10001110;
      default:decode7seg = 8'b11111111;
    endcase
  endfunction

  wire [9:0] idx;
  logic [3:0] idx_o;
  logic [9:0] xk_re_o;
  logic [9:0] xk_im_o;
  logic sod_o, ipd_o, eod_o, soud_o, opd_o, eoud_o;
  logic set_busy, set_request;
  logic[3:0] set_row, set_value;

	FFT_Top fft_inst(
		.idx(idx_o), //output [3:0] idx
		.xk_re(xk_re_o), //output [9:0] xk_re
		.xk_im(xk_im_o), //output [9:0] xk_im
		.sod(boardLED[2]), //output sod,  start of domain sequence(starting data input)
		.ipd(boardLED[3]), //output ipd,  this signal is High during input data sampling
		.eod(boardLED[4]), //output eod,  end of domain sequence(ending data input)
		.busy(boardLED[0]), //output busy,  this signal is High durting translate data
		.soud(soud_o), //output soud,  start of unload data
		.opd(opd_o), //output opd,  during output data
		.eoud(boardLED[5]), //output eoud,  stop of unload data
		.xn_re(recieveADC & 10'b1000000000), //input [9:0] xn_re
		.xn_im(recieveADC & 10'b1000000000), //input [9:0] xn_im
		.start(processCounter[7]), //input start
		.clk(processCounter[4]), //input clk(fftClk)
		.rst(0) //input rst
	);

assign boardLED[1] = opd_o;
endmodule

module timer #(
  parameter COUNT_MAX = 300
) (
  input  wire  clk,
  output logic overflow
);

  logic [$clog2(COUNT_MAX+1)-1:0] counter = 'd0;

  always_ff @ (posedge clk) begin
    if(counter == COUNT_MAX)begin
      counter  <= 'd0;
      overflow <= 'd0;
    end else if(counter > COUNT_MAX/2) begin
      counter  <= counter + 'd1;
      overflow <= 'd1;
    end else begin
      counter  <= counter + 'd1;
      overflow <= 'd0;
    end
  end

endmodule

`default_nettype wire

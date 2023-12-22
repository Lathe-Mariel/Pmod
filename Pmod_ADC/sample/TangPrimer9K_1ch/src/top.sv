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
  output wire P8_COM_OE
);

  logic  controlCLK;

  logic[15:0] processCounter;  // general counter 

  logic[3:0] display7seg[6] = {4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2}; //000000-999999

  logic[9:0] recieveADC;
  logic[9:0] accel;

  logic P1_COM_SER;
  logic P2_COM_RCLK;

  logic P4_SEG_RCLK;

  timer #(
    .COUNT_MAX()
  ) inst_1 (
    .clk (clk),
    .overflow(controlCLK)
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
      DIN <= 1;
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
      if(recieveADC < 'd280)begin
        accel <= 'd0;
      end else if(recieveADC > 'd780) begin
        accel <= 'd1000;
      end else begin
        accel <= (recieveADC - 'd280) * 2;  // for Mini Cart Accel     //origin 270 - 780  to 0 - 16
      end

      DIN <= 0;
      CS <= 1;
    end

//7seg
    if(processCounter[2:0] == 3'b011)begin
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
  end

  function currentBit;
  input [7:0] in;
    currentBit = (in >> processCounter[2:0]) & 1'b1;
  endfunction

  assign P3_SEG_SER = currentBit(decode7seg(display7seg[processCounter[5:3]]));

  assign P9_SEG_SRCLK = ~controlCLK;
  assign P10_SEG_OE = 1'b0;

  assign P7_COM_SRCLK = ~controlCLK;
  assign P8_COM_OE = 1'b0;

  assign AD_CLK = controlCLK;

  function [7:0] decode7seg;
  input [3:0] in1;
    case(in1)
      4'h0:  decode7seg = 8'b00111111;
      4'h1:  decode7seg = 8'b00000110;
      4'h2:  decode7seg = 8'b01011011;
      4'h3:  decode7seg = 8'b01001111;
      4'h4:  decode7seg = 8'b01100110;
      4'h5:  decode7seg = 8'b01101101;
      4'h6:  decode7seg = 8'b01111101;
      4'h7:  decode7seg = 8'b00000111;
      4'h8:  decode7seg = 8'b01111111;
      4'h9:  decode7seg = 8'b11101111;
      4'ha:  decode7seg = 8'b01110111;
      4'hb:  decode7seg = 8'b01111100;
      4'hc:  decode7seg = 8'b00111001;
      4'hd:  decode7seg = 8'b00011110;
      4'he:  decode7seg = 8'b01111001;
      4'hf:  decode7seg = 8'b01110001;
      default:decode7seg = 8'b11111111;
    endcase
  endfunction
endmodule

module timer #(
  parameter COUNT_MAX = 2700  //1000us
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

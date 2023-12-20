`default_nettype none

module top (
  input  wire       clk,

  input  wire sw1,
  input  wire sw2,
  input wire[3:0] tacSW,
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
  logic rotateCLK;

  logic[15:0] processCounter;  // general counter 

  logic[5:0] display7seg[5]; //0000-9999

  logic[9:0] recieveADC;
  logic[9:0] accel;
  logic[9:0] disp_speed;  // store rotation speed for display

  logic[8:0] anode_data=9'b000000001;


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

//7seg cathode

//7seg anode
    if(processCounter[3] == 1)begin
      anode_data <= {anode_data[7:0],anode_data[8]};
    end
      
  end

  assign P3_SEG_SER = 1'b0;
  assign P9_SEG_SRCLK = processCounter[0];
  assign P4_SEG_RCLK = P9_SEG_SRCLK;
  assign P10_SEG_OE = 1'b0;

  assign P1_COM_SER = anode_data[0];
  assign P7_COM_SRCLK = processCounter[2];
  assign P2_COM_RCLK = ~P7_COM_SRCLK;
  assign P8_COM_OE = 1'b0;

  assign AD_CLK = controlCLK;

  function [7:0] decode7seg;
  input [3:0] in;
    case(in)
      4'h0:  decode7seg = 8'b00000011;
      4'h1:  decode7seg = 8'b10011111;
      4'h2:  decode7seg = 8'b00100101;
      4'h3:  decode7seg = 8'b00001101;
      4'h4:  decode7seg = 8'b10011001;
      4'h5:  decode7seg = 8'b01001001;
      4'h6:  decode7seg = 8'b01000001;
      4'h7:  decode7seg = 8'b00011111;
      4'h8:  decode7seg = 8'b00000001;
      4'h9:  decode7seg = 8'b00001001;
      4'ha:  decode7seg = 8'b00010001;
      4'hb:  decode7seg = 8'b11000001;
      4'hc:  decode7seg = 8'b01100011;
      4'hd:  decode7seg = 8'b10000101;
      4'he:  decode7seg = 8'b01100001;
      4'hf:  decode7seg = 8'b01110001;
      default:decode7seg = 8'b11111111;
    endcase
  endfunction
endmodule

module timer #(
  parameter COUNT_MAX = 27000  //1000us
) (
  input  wire  clk,
  output logic overflow
);

  logic [$clog2(COUNT_MAX+1)-1:0] counter = 'd0;

  always_ff @ (posedge clk) begin
    if(counter == COUNT_MAX)begin
      counter  <= 'd0;
    end else begin
      counter  <= counter + 'd1;
      overflow <= 'd1;
    end
  end

endmodule

`default_nettype wire

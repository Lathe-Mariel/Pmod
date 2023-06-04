module top(
input wire clk,
input wire sw,
input wire rotary1_a,
input wire rotary1_b,
input wire slide_sw,

output logic [7:0] ROW2,
output logic [7:0] COL2,

output reg [5:0] onboard_led
);

logic overflow;
reg [5:0] DIGIT;
//reg [5:0] reg_numbers [5:0]={6'h21, 6'h22, 6'h23, 6'h24, 6'h25, 6'h36};
reg [5:0] reg_numbers [5:0];
reg [23:0] value = 24'h0;

timer1 timer_instance(clk, overflow);
seven_segment_with_dp(overflow, 0, 1, reg_numbers, COL2, ROW2);

reg[4:0] antiChatter_rotary1 = 0;
reg[4:0] antiChatter_slide = 0;

always @(posedge overflow)begin
    if(rotary1_a == 0)begin
      if(antiChatter_rotary1 == 10)begin

        antiChatter_rotary1 <= antiChatter_rotary1 + 1;
        if(rotary1_b == 0)begin
          value <= value - 1;
        end else begin
          value <= value + 1;
        end
      end else if(antiChatter_rotary1 == 11)begin
        //
      end else begin
        antiChatter_rotary1 <= antiChatter_rotary1 + 1;
      end
    end else begin
      antiChatter_rotary1 <= 0;
      if(slide_sw == 1)begin
        if(antiChatter_slide < 10)begin
          antiChatter_slide <= antiChatter_slide + 1;
        end else if(antiChatter_slide == 10)begin
          value <= 0;
          antiChatter_slide <= antiChatter_slide + 1;
        end
      end else begin
      antiChatter_slide <= 0;
      end
    end

end

//assign COL = 8'b11111111;
//assign ROW = ~DIGIT;
  always_comb begin
    reg_numbers[5] = {4'h2,value[23:20]};
    reg_numbers[4] = {4'h2,value[19:16]};
    reg_numbers[3] = {4'h2,value[15:12]};
    reg_numbers[2] = {4'h2,value[11:8]};
    reg_numbers[1] = {4'h2,value[7:4]};
    reg_numbers[0] = {4'h2,value[3:0]};
  end

endmodule

module timer1 #(
  parameter COUNT_MAX = 2700
) (
  input  wire  clk,
  output logic overflow
);

  logic [$clog2(COUNT_MAX+1)-1:0] counter = 'd0;

  always_ff @ (posedge clk) begin
    if (counter == COUNT_MAX) begin
      counter  <= 'd0;
      overflow <= 'd1;
    end else begin
      counter  <= counter + 'd1;
      overflow <= 'd0;
    end
  end
endmodule

`default_nettype wire
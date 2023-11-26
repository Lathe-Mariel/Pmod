module top(
input wire clk,
input wire t5,
input wire sw1,
output logic ch1a,
output logic ch1b,
output logic ch2a,
output logic ch2b,
output logic ch3a,
output logic ch3b,
output logic[5:0] onboard_led,
input logic rotary1_a,
input logic rotary1_b,
input logic slide_sw,
output logic[5:0] ROW2,
output logic[7:0] COL2
);

logic overflow;
logic overflow2;

reg [5:0] reg_numbers [5:0];
reg [15:0] value = 16'd0;
timer1 timer_instance(338, clk, value, overflow);
timer1 timer_keypolling(2700, clk, 16'd0, keypolling);
timer1 timer_instance3(338, clk, 16'd0, overflow3);

seven_segment_with_dp nanaseg(keypolling, 1'b0, 1'b1, reg_numbers, COL2, ROW2);

reg[4:0] antiChatter_rotary1 = 0;
reg[4:0] antiChatter_slide = 0;

always @(posedge keypolling)begin
    if(rotary1_a == 0)begin
      if(antiChatter_rotary1 == 10)begin

        antiChatter_rotary1 <= antiChatter_rotary1 + 5'b1;
        if(rotary1_b == 0)begin
          value <= value - 16'b1;
        end else begin
          value <= value + 16'b1;
        end
      end else if(antiChatter_rotary1 == 11)begin
        //
      end else begin
        antiChatter_rotary1 <= antiChatter_rotary1 + 5'b1;
      end
    end else begin
      antiChatter_rotary1 <= 0;
      if(slide_sw == 1)begin
        if(antiChatter_slide < 10)begin
          antiChatter_slide <= antiChatter_slide + 5'b1;
        end else if(antiChatter_slide == 10)begin
          value <= 0;
          antiChatter_slide <= antiChatter_slide + 5'b1;
        end
      end else begin
      antiChatter_slide <= 0;
      end
    end

end

  always_comb begin
    reg_numbers[5] = {4'h2,value[23:20]};
    reg_numbers[4] = {4'h2,value[19:16]};
    reg_numbers[3] = {4'h2,value[15:12]};
    reg_numbers[2] = {4'h2,value[11:8]};
    reg_numbers[1] = {4'h2,value[7:4]};
    reg_numbers[0] = {4'h2,value[3:0]};
  end


assign led0 = ch1a;
assign ch2a = ch1a;
assign ch3a = ch1a;

assign ch2b = ch1b;
assign ch3b = ch1b;

always @(posedge overflow)begin
  if(!t5)begin
    ch1a <= ~ch1a;
  end
end

always @(posedge overflow3)begin
  if(!t5)begin
    ch1b <= ~ch1b;
  end
end

endmodule

module timer1 #(
) (
  input [15:0]COUNT_MAX,
  input  wire  clk,
  input logic[15:0] value,
  output logic overflow
);

  logic [15:0] counter = 0;

  always_ff @ (posedge clk) begin
    if (counter == COUNT_MAX) begin
      counter  <= 0;
      overflow <= 'd0;
    end else if(counter == value)begin
      overflow <= 'd1;
      counter <= counter + 16'd1;
    end else begin
      counter  <= counter + 16'd1;
      overflow <= 'd0;
    end
  end
endmodule

`default_nettype wire
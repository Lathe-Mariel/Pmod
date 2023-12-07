module top(
input wire clk,
input wire t5,
input wire sw1,
input wire sw2,
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

logic lower_speaker;
logic upper_speaker;
logic keypolling;
logic swpolling;

reg [5:0] reg_numbers [5:0];
reg [23:0] value;
timer1 timer_instance(338, clk, value, lower_speaker);
timer1 timer_keypolling(54000, clk, 16'd0, keypolling);
timer1 timer_swpolling(84000, clk, 16'd0, swpolling);
timer1 timer_instance3(338, clk, 16'd0, upper_speaker);

logic [3:0] upper_duty = 4'd4;
logic [3:0] lower_duty = 4'd4;
logic [3:0] upper_counter;
logic [3:0] lower_counter;

seven_segment_with_dp nanaseg(keypolling, 1'b0, 1'b1, reg_numbers, COL2, ROW2);

reg[4:0] antiChatter_rotary1 = 0;
reg[4:0] antiChatter_slide = 0;

logic [15:0] key_value;
logic [15:0] rotary_value;

assign value = (key_value + rotary_value) % 338;

always @(posedge swpolling)begin
  if(sw1 == 0)begin
    key_value <= key_value - 16'b1;
  end else if(sw2 == 0)begin
    key_value <= key_value + 16'b1;
  end
end

always @(posedge keypolling)begin

    if(rotary1_a == 0)begin
      if(antiChatter_rotary1 == 2)begin

        antiChatter_rotary1 <= antiChatter_rotary1 + 5'b1;
        if(rotary1_b == 0)begin
          rotary_value <= rotary_value - 16'b1;
        end else begin
          rotary_value <= rotary_value + 16'b1;
        end
      end else if(antiChatter_rotary1 == 3)begin
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
          rotary_value <= 0;
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

always @(posedge lower_speaker)begin
  if(t5)begin
    ch1a <= ~ch1a;
  end else begin
    if(lower_counter > 4'd9)begin
      lower_counter <= 4'd0;
    end else begin
      lower_counter <= lower_counter + 4'b1;
    end
    if(lower_duty < lower_counter)begin
      ch1a <= 1;
    end else begin
      ch1a <= 0;
    end
  end
end

always @(posedge upper_speaker)begin
  if(t5)begin
    ch1b <= ~ch1b;
  end else begin
    if(upper_counter > 4'd9)begin
      upper_counter <= 4'd0;
    end else begin
      upper_counter <= upper_counter + 4'b1;
    end
    if(upper_duty < upper_counter)begin
      ch1b <= 1;
    end else begin
      ch1b <= 0;
    end
  end
end
endmodule

module timer1 #(
) (
  input [23:0]COUNT_MAX,
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
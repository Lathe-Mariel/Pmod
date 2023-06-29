module top(
input wire clk,
input wire sw,
input wire red,
input wire blue,
input wire green

);

logic overflow;

//reg red=0;
//reg blue=0;
//reg  green=0;
//reg printf;

timer1 timer_instance(clk, overflow);
reg[3:0] pwm_counter;
assign red = 1;
assign blue = 1;
assign green = 0;

always @(posedge overflow)begin
//    if(pwm_counter == 0)begin
//        printf <= 1;
//        red <= 1'd1;
//        green <= 1'd1;
//        blue <= 1'd1;
//    end else begin
//        printf <= 0;
//        red <= 1'd0;
//        green <= 1'd1;
//        blue <= 1'd1;
//    end
    pwm_counter <= pwm_counter + 4'd1;

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
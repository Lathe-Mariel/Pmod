module top(
input wire clk,
input wire sw,
output logic red,
output logic blue,
output logic green

);

logic overflow;

//reg red=0;
//reg blue=0;
//reg green=0;
//reg printf;

timer1 timer_instance(clk, overflow);
reg[7:0] pwm_counter;
reg[7:0] max=8'd128;
reg inc = 0;

always @(posedge overflow)begin
    if(pwm_counter == max)begin
        red <= 1'd1;
        green <= 1'd1;
        blue <= 1'd1;
        pwm_counter <= 8'd0;
        if(inc == 0)begin
            max = max - 8'd1;
            if(max == 8'd0)begin
                inc <= 1;
            end
        end else begin
            max = max + 8'd1;
            if(max == 8'd128)begin
                inc <= -1;
            end
        end
    end else begin
        red <= 1'd0;
        green <= 1'd0;
        blue <= 1'd0;
        pwm_counter <= pwm_counter + 'd1;
    end

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
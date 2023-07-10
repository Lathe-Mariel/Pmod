module top(
input wire clk,
input wire sw,
output logic p1,
output logic p2,
output logic p3,
output logic p4,

output logic p7,
output logic p8,
output logic p9,
output logic p10
);

logic overflow;

//reg red=0;
//reg blue=0;
//reg green=0;
//reg printf;

timer1 timer_instance(clk, overflow);
reg[7:0] leds=0;
reg[7:0] change_pwm=0;

assign {p10,p9,p8,p7,p4,p3,p2,p1} = leds;

always @(posedge overflow)begin
if(!sw)begin
    leds <= 8'hff;
end else begin
    if(leds == 8'hff || leds == 8'h00)begin
        leds <= 8'h01;
    end else begin

        if(change_pwm == 0)begin
            leds <= leds << 'd1;
        end else begin
            change_pwm <= change_pwm + 'd1;
        end
    end
end
end

endmodule

module timer1 #(
  parameter COUNT_MAX = 8000000
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
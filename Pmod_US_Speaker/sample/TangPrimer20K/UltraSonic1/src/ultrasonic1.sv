module top(
input wire clk,
input wire s4,
output logic ch1a,
output logic ch1b,
output logic ch2a,
output logic ch2b,
output logic ch3a,
output logic ch3b,
output logic led0
);

logic overflow;

//reg red=0;
//reg blue=0;
//reg green=0;
//reg printf;

timer1 timer_instance(clk, overflow);

assign led0 = ch1a;
assign ch2a = ch1a;
assign ch3a = ch1a;
assign ch1b = ch1a;
assign ch2b = ch1a;
assign ch3b = ch1a;

always @(posedge overflow)begin
  if(!s4)begin
    ch1a <= ~ch1a;
  end
end

endmodule

module timer1 #(
  parameter COUNT_MAX = 35
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
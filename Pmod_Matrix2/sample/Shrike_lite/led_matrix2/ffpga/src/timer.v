// Custom Module

module timer(
  input wire clk,
  output wire clk_out
);

reg[15:0] timer_counter;
reg clk_out_reg;

assign clk_out = clk_out_reg;

    always@ (posedge clk)begin
      if (timer_counter == 6_250) begin  // 1000Hz
          timer_counter <= 16'b0;
          clk_out_reg <= ~clk_out_reg;
      end else begin
          timer_counter <= timer_counter + 16'b1;
      end
    end
endmodule

module top(
input wire clk,
input wire sw,
output wire CLR1,
output wire CLR2,
output wire CLR3,
output wire COL_Red,
output wire COL_Green,
output wire ROW,
output wire mat_RCLOCK,
output wire mat_CLOCK,
output wire [5:0] onboard_led
);

logic overflow;

reg [5:0] onboard_led;
reg mat_CLOCK;
reg mat_RCLOCK;
reg ROW;
reg COL_Red;
reg COL_Green;

reg [7:0] ledFrameBuffer [1:0][7:0] = '{
                                      '{8'b00001111,
                                       8'b00001111,
                                       8'b00001111,
                                       8'b00001111,
                                       8'b00001111,
                                       8'b00001111,
                                       8'b00001111,
                                       8'b00001111},
                                      '{8'b11110000,
                                       8'b11110000,
                                       8'b11110000,
                                       8'b11110000,
                                       8'b11110000,
                                       8'b11110000,
                                       8'b11110000,
                                       8'b11110000}};

//parameter FULL_STROKE_STEP = 16'd32768;


timer1 timer_instance(clk, overflow);

initial begin
    rowCounter = 3'b0;
    

end


//reg [2:0] step;
reg [2:0] rowCounter;
reg [2:0] currentStep;

//reg [2:0] colRed_step;
//reg [7:0] rowBuffer;
//reg [7:0] colRedBuffer;
//reg [7:0] colGreenBuffer;
reg [7:0] cycleCounter;
//reg transitionBit;

always @(posedge overflow)begin
    mat_CLOCK <= ~mat_CLOCK;
    if(mat_CLOCK == 1)begin
        if(currentStep == 7)begin
            rowCounter <= rowCounter + 3'b1;
            mat_RCLOCK <= 1'b1;
        end else begin
            mat_RCLOCK <= 1'b0;
        end

        if(rowCounter == currentStep)begin
            ROW <= 1'b1;
        end else begin
            ROW <= 1'b0;
        end
        currentStep <= currentStep + 3'b1;
        COL_Red <= ~ledFrameBuffer[0][rowCounter][currentStep];
        COL_Green <= ~ledFrameBuffer[1][rowCounter][currentStep];

    end else begin

    end
end

//assign mat_RCLOCK = ~mat_CLOCK;
assign CLR1 = 1;
assign CLR2 = 1;
assign CLR3 = 1;

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
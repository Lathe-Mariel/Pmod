module top(
input wire clk,
input wire sw,
output wire CLR1,
output wire CLR2,
output wire CLR3,
output wire COL_Red,
output wire COL_Green,
output wire ROW,         //serial data
output wire mat_RCLOCK,  //transfering value of shift register to storage register
output wire mat_CLOCK,
output wire ch2_CLR1,
output wire ch2_CLR2,
output wire ch2_CLR3,
output wire ch2_COL_Red,
output wire ch2_COL_Green,
output wire ch2_ROW,         //serial data
output wire ch2_mat_RCLOCK,  //transfering value of shift register to storage register
output wire ch2_mat_CLOCK,
output wire [5:0] onboard_led
);

//assign F10 = 'b1;

assign ch2_CLR1 = CLR1;
assign ch2_CLR2 = CLR2;
assign ch2_CLR3 = CLR3;
assign ch2_COL_Red = COL_Red;
assign ch2_COL_Green = COL_Green;
assign ch2_ROW = ROW;
assign ch2_mat_RCLOCK = mat_RCLOCK;
assign ch2_mat_CLOCK = mat_CLOCK;

logic overflow;

reg [5:0] onboard_led;
reg mat_CLOCK;
reg mat_RCLOCK;
reg ROW;
reg COL_Red;
reg COL_Green;

reg [7:0] ledFrameBuffer [1:0][7:0] = '{
                                      '{8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000},
                                      '{8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000,
                                        8'b00000000}};

//parameter FULL_STROKE_STEP = 16'd32768;


timer1 timer_instance(clk, overflow);

initial begin
    rowCounter = 3'b0;
    

end


//reg [2:0] step;
reg [2:0] rowCounter;
reg [2:0] currentStep;

reg [13:0] cycleCounter;
logic colorSelector;

always @(posedge overflow)begin
    mat_CLOCK <= ~mat_CLOCK;
    if(mat_CLOCK == 1)begin

        if(currentStep == 7)begin
            colorSelector <= colorSelector + 1;
            if(colorSelector == 0)begin
                rowCounter <= rowCounter + 3'b1;
                cycleCounter <= cycleCounter + 'b1;
                if(!cycleCounter[7])begin
                  ledFrameBuffer[0][cycleCounter[13:8]/8][cycleCounter[13:8]%8] <= 1'b1;
                  ledFrameBuffer[1][((cycleCounter[13:8]/8)+4)%8][cycleCounter[13:8]%8] <= 1'b1;
                end else begin
                  ledFrameBuffer[0][cycleCounter[13:8]/8][cycleCounter[13:8]%8] <= 1'b0;
                  ledFrameBuffer[1][((cycleCounter[13:8]/8)+4)%8][cycleCounter[13:8]%8] <= 1'b0;
                end
            end
            mat_RCLOCK <= 1'b0;
        end else if(currentStep == 0) begin
            mat_RCLOCK <= 1'b1;
        end else begin
            mat_RCLOCK <= 1'b0;
        end

        if(ledFrameBuffer[colorSelector][rowCounter][currentStep] == 1)begin
            ROW <= 1'b1;
        end else begin
            ROW <= 1'b0;
        end

        currentStep <= currentStep + 3'b1;


        if(currentStep == rowCounter)begin
           if(colorSelector)begin
              COL_Red <= 0;
              COL_Green <= 1;
           end else begin
              COL_Red <= 1;
              COL_Green <= 0;
           end
        end else begin
              COL_Red <= 1;
              COL_Green <= 1;
        end

    end else begin

    end
end

//assign mat_RCLOCK = ~mat_CLOCK;
assign CLR1 = 1;
assign CLR2 = 1;
assign CLR3 = 1;

endmodule

module timer1 #(
  parameter COUNT_MAX = 1350
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
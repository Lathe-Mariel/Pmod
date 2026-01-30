(* top *) module top(
(* iopad_external_pin, clkbuf_inhibit *) input wire clk,
(* iopad_external_pin *) output wire clk_en,
(* iopad_external_pin *) input wire sw,
(* iopad_external_pin *) output wire sw_en,
(* iopad_external_pin *) output wire CLR1,
(* iopad_external_pin *) output wire CLR1_en,
(* iopad_external_pin *) output wire CLR2,
(* iopad_external_pin *) output wire CLR2_en,
(* iopad_external_pin *) output wire CLR3,
(* iopad_external_pin *) output wire CLR3_en,
(* iopad_external_pin *) output wire COL_Red,
(* iopad_external_pin *) output wire COL_Green,
(* iopad_external_pin *) output wire ROW,         //serial data
(* iopad_external_pin *) output wire mat_Ratch,  //transfering value of shift register to storage register
(* iopad_external_pin *) output wire mat_CLOCK
);

assign CLR1_en = 1;
assign CLR2_en = 1;
assign CLR3_en = 1;
assign CLR1 = 1;
assign CLR2 = 1;
assign CLR3 = 1;
assign mat_CLOCK = mat_CLOCK_reg;

reg mat_CLOCK_reg;
reg mat_RCLOCK_reg;
reg ROW_reg;
reg COL_Red_reg;
reg COL_Green_reg;


reg[383:0] fb;
//parameter FULL_STROKE_STEP = 16'd32768;

timer timer_inst(
  .clk(clk),
  .clk_out(clk_1k)
);

reg clk_1k;

//reg [2:0] step;
reg [2:0] rowCounter;
reg [2:0] currentStep;

reg [7:0] cycleCounter;
reg colorSelector;

always @(posedge clk_1k)begin
    mat_CLOCK_reg <= ~mat_CLOCK_reg;
    if(mat_CLOCK_reg == 1)begin

        if(currentStep == 7)begin
            colorSelector <= colorSelector + 1;
            if(colorSelector == 0)begin
                rowCounter <= rowCounter + 3'b1;
            end
            mat_RCLOCK_reg <= 1'b0;
        end else if(currentStep == 0) begin
            mat_RCLOCK_reg <= 1'b1;
        end else begin
            mat_RCLOCK_reg <= 1'b0;
        end

        if(fb[rowCounter*8+currentStep] == 1)begin
            ROW_reg <= 1'b1;
        end else begin
            ROW_reg <= 1'b0;
        end

        currentStep <= currentStep + 3'b1;


        if(currentStep == rowCounter)begin
           if(colorSelector)begin
              COL_Red_reg <= 0;
              COL_Green_reg <= 1;
           end else begin
              COL_Red_reg <= 1;
              COL_Green_reg <= 0;
           end
        end else begin
              COL_Red_reg <= 1;
              COL_Green_reg <= 1;
        end

    end else begin

    end
end

endmodule

`default_nettype wire
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
(* iopad_external_pin *) output wire COL_Red_en,
(* iopad_external_pin *) output wire COL_Green,
(* iopad_external_pin *) output wire COL_Green_en,
(* iopad_external_pin *) output wire ROW,         //serial data
(* iopad_external_pin *) output wire ROW_en,
(* iopad_external_pin *) output wire mat_Ratch,  //transfering value of shift register to storage register
(* iopad_external_pin *) output wire mat_Ratch_en,
(* iopad_external_pin *) output wire mat_CLOCK,
(* iopad_external_pin *) output wire mat_CLOCK_en,
(* iopad_external_pin *) output wire clk_1k,
(* iopad_external_pin *) input wire clk0,
(* iopad_external_pin *) output wire clk0_en
);

assign clk0_en = 1;
assign CLR1_en = 1;
assign CLR2_en = 1;
assign CLR3_en = 1;
assign CLR1 = 1;
assign CLR2 = 1;
assign CLR3 = 1;
assign mat_CLOCK = mat_CLOCK_reg;

reg mat_CLOCK_reg;
reg mat_Ratch_reg;
reg ROW_reg;
reg COL_Red_reg;
reg COL_Green_reg;


reg[383:0] fb={6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,
               6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,
               6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,
               6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,6'o11,
               6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,
               6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,
               6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,
               6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00,6'o00
};
//parameter FULL_STROKE_STEP = 16'd32768;

timer timer_inst(
  .clk(clk),
  .clk_out(clk_1k)
);

reg [2:0] rowCounter;
reg [2:0] columnCounter;
reg [8:0] address;

always @(posedge clk0)begin
    mat_CLOCK_reg <= ~mat_CLOCK_reg;
    if(mat_CLOCK_reg == 0)begin

    if(columnCounter == 7) begin
        mat_Ratch_reg <= 1'b1;
        rowCounter <= rowCounter + 3'b1;
    end else begin
        mat_Ratch_reg <= 1'b0;
    end
    
    if(columnCounter == rowCounter)begin
      COL_Red_reg <= 1;
      COL_Green_reg <= 1;
    end else begin
      COL_Red_reg <= 0;
      COL_Green_reg <= 0;
    end
//red
    address = rowCounter*9'd8+columnCounter*9'd6;
    if({fb[address+2],fb[address+1],fb[address]} == 1)begin
        ROW_reg <= 1'b1;
    end else begin
        ROW_reg <= 1'b0;
    end
/*green    
    if(fb[rowCounter*8+columnCounter] == 1)begin
        ROW_reg <= 1'b1;
    end else begin
        ROW_reg <= 1'b0;
    end
*/
    
    columnCounter <= columnCounter + 3'b1;

    end else begin

    end
end

endmodule

`default_nettype wire
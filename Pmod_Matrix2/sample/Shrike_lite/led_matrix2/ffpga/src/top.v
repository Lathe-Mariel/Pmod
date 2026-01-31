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

reg mat_CLOCK_reg=0;
reg mat_Ratch_reg=0;
reg ROW_reg=0;
reg COL_Red_reg=0;
reg COL_Green_reg=0;


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

reg [2:0] rowCounter=0;
reg [5:0] columnCounter=0;  // [5:3] pwm  [2:0] columnCounter
reg [8:0] address=0;

reg [8:0] process_address=0;
reg [5:0] tmp=0;
reg [5:0] tmp2=0;

always @(posedge clk)begin
    process_address <= process_address + 9'd6;
    tmp = {fb[process_address+5],fb[process_address+4],fb[process_address+3],fb[process_address+2],fb[process_address+1],fb[process_address]};

    case(tmp)
      6'd1:tmp2 = 6'd0;
      6'd2:tmp2 = 6'd1;
      6'd3:tmp2 = 6'd2;
      6'd4:tmp2 = 6'd3;
      6'd5:tmp2 = 6'd4;
      6'd6:tmp2 = 6'd5;
      6'd7:tmp2 = 6'd6;
      default:;
    endcase
    {fb[process_address+5],fb[process_address+4],fb[process_address+3],fb[process_address+2],fb[process_address+1],fb[process_address]} <= tmp2;
      
end

always @(posedge clk0)begin
    mat_CLOCK_reg <= ~mat_CLOCK_reg;
    if(mat_CLOCK_reg == 0)begin

    if(columnCounter[2:0] == 3'b111) begin
        mat_Ratch_reg <= 1'b1;
        if(columnCounter[5:3] == 3'b111)begin
          rowCounter <= rowCounter + 3'b1;
        end
    end else begin
        mat_Ratch_reg <= 1'b0;
    end
    
    if(columnCounter[2:0] == rowCounter)begin
      COL_Red_reg <= 1;
      COL_Green_reg <= 1;
    end else begin
      COL_Red_reg <= 0;
      COL_Green_reg <= 0;
    end
//red
    address = rowCounter*9'd8+columnCounter*9'd6;
    if({fb[address+2],fb[address+1],fb[address]} > columnCounter[5:3])begin
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
    
    columnCounter <= columnCounter + 6'b1;

    end else begin

    end
end

endmodule

`default_nettype wire
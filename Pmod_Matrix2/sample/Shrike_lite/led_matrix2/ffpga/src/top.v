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
(* iopad_external_pin *) output wire COL_Red,     // serial data
(* iopad_external_pin *) output wire COL_Red_en,
(* iopad_external_pin *) output wire COL_Green,   // serial data
(* iopad_external_pin *) output wire COL_Green_en,
(* iopad_external_pin *) output wire ROW,         //serial data
(* iopad_external_pin *) output wire ROW_en,
(* iopad_external_pin *) output wire mat_Ratch,   //transfering value of shift register to storage register
(* iopad_external_pin *) output wire mat_Ratch_en,
(* iopad_external_pin *) output wire mat_CLOCK,
(* iopad_external_pin *) output wire mat_CLOCK_en,
(* iopad_external_pin *) output wire clk_1k,
(* iopad_external_pin, clkbuf_inhibit *) input wire clk0,
(* iopad_external_pin *) output wire clk0_en,
(* iopad_external_pin *) output wire led_en,
(* iopad_external_pin *) output wire led
);

assign led_en = 1; assign led =sw;

assign clk0_en = 1;
assign CLR1_en = 1; assign CLR2_en = 1; assign CLR3_en = 1;
assign CLR1 = 1;    assign CLR2 = 1;    assign CLR3 = 1;

assign mat_CLOCK = mat_CLOCK_reg; assign mat_CLOCK_en = 1;
assign clk_en = 1;
assign mat_Ratch = mat_Ratch_reg; assign mat_Ratch_en = 1;
assign ROW = ROW_reg;             assign ROW_en = 1;
assign COL_Red = COL_Red_reg;     assign COL_Red_en = 1;
assign COL_Green = COL_Green_reg; assign COL_Green_en = 1;
assign sw_en = 0;

reg mat_CLOCK_reg=0;
reg mat_Ratch_reg=0;
reg ROW_reg=0;
reg COL_Red_reg=1;
reg COL_Green_reg=1;

reg[383:0] fb={6'b001001,6'b001001,6'b001001,6'b001001,6'b001001,6'b001001,6'b001001,6'b001001,
               6'b001001,6'b001001,6'b001001,6'b001001,6'b001001,6'b001001,6'b001001,6'b001001,
               6'b111000,6'b000000,6'b000000,6'b000000,6'b000000,6'b000000,6'b000000,6'b000000,
               6'b011001,6'b101001,6'b001001,6'b000001,6'b101001,6'b111001,6'b011001,6'b001001,
               6'b000000,6'b000000,6'b000000,6'b000000,6'b000000,6'b000000,6'b000000,6'b000000,
               6'b111111,6'b111111,6'b111111,6'b111111,6'b000000,6'b000000,6'b000000,6'b000000,
               6'b000000,6'b000000,6'b000000,6'b000000,6'b000000,6'b000100,6'b000100,6'b000100,
               6'b000001,6'b000001,6'b000001,6'b000001,6'b000010,6'b000010,6'b000010,6'b000010
};

timer timer_inst(
  .clk(clk),
  .clk_out(clk_1k)
);

reg [2:0] rowCounter=0;
reg [5:0] columnCounter=0;  // [5:3] pwm  [2:0] columnCounter
reg [8:0] address=0;

reg [8:0] process_address=0;
reg [5:0] tmp=0;
//reg [5:0] tmp2=0;


/* dumper */
/*
always @(posedge clk)begin
    
    if(sw)begin
        fb[197:192] <= 6'b000111;
    end else begin
      if(process_address == 9'd378)begin
        process_address <= 9'b0;
      end else begin
        process_address <= process_address + 9'd6;
      end
      
      case({fb[process_address+2],fb[process_address+1],fb[process_address]})
        3'd1:{fb[process_address+2],fb[process_address+1],fb[process_address]} <= 3'd0;
        3'd2:{fb[process_address+2],fb[process_address+1],fb[process_address]} <= 3'd1;
        3'd3:{fb[process_address+2],fb[process_address+1],fb[process_address]} <= 3'd2;
        3'd4:{fb[process_address+2],fb[process_address+1],fb[process_address]} <= 3'd3;
        3'd5:{fb[process_address+2],fb[process_address+1],fb[process_address]} <= 3'd4;
        3'd6:{fb[process_address+2],fb[process_address+1],fb[process_address]} <= 3'd5;
        3'd7:{fb[process_address+2],fb[process_address+1],fb[process_address]} <= 3'd6;
        default: ;
      endcase
    
//      {fb[process_address+5],fb[process_address+4],fb[process_address+3],fb[process_address+2],fb[process_address+1],fb[process_address]} <= tmp2;
    end  
end
*/
always @(posedge clk0)begin
address <= (rowCounter-3'b1)*9'd48+columnCounter[2:0]*9'd6;
    mat_CLOCK_reg <= ~mat_CLOCK_reg;
    if(mat_CLOCK_reg == 0)begin
        if(columnCounter[5:0] == 6'b111111) begin
           rowCounter <= rowCounter + 3'b1;
        end
    
/* Column (Anode)  Selecting Row */
        if((columnCounter[2:0]+3'd2) == rowCounter)begin
          ROW_reg <= 1;
        end else begin
          ROW_reg <= 0;
        end
    
// Column Red (Cathode)

        if({fb[address+2],fb[address+1],fb[address]} > columnCounter[5:3])begin
          COL_Red_reg <= 0;
        end else begin
          COL_Red_reg <= 1;
        end
/*green*/
        if({fb[address+5],fb[address+4],fb[address+3]} > columnCounter[5:3])begin
          COL_Green_reg <= 0;
        end else begin
          COL_Green_reg <= 1;
        end
    
        columnCounter <= columnCounter + 6'b1;

    end else begin
        if(columnCounter[2:0] == 3'b111) begin
            mat_Ratch_reg <= 1'b1;
        end else begin
            mat_Ratch_reg <= 1'b0;
        end
    end
end

endmodule

`default_nettype wire
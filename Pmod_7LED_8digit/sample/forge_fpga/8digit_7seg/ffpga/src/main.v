(* top *) module digit8_7seg(
  (* iopad_external_pin, clkbuf_inhibit *) input clk,
  (* iopad_external_pin *) output LED,
  (* iopad_external_pin *) output LED_en,
  (* iopad_external_pin *) output clk_en,
  (* iopad_external_pin *) output sclk,
  (* iopad_external_pin *) output sclk_en,
  (* iopad_external_pin *) output rclk,
  (* iopad_external_pin *) output rclk_en,
  (* iopad_external_pin *) output srclr,
  (* iopad_external_pin *) output srclr_en,
  (* iopad_external_pin *) output serial_data,
  (* iopad_external_pin *) output serial_data_en
);
// only single dimension. multi dimensional resistor is prohibited
  wire [127:0] segment_map = {8'b1000_1110,     //F
                              8'b1111_0010,
                              8'b0111_1010,
                              8'b1001_1100,     //C
                              8'b0011_1110,
                              8'b1110_1110,     //A
                              8'b1111_0110,     //9
                              8'b1111_1110,
                              8'b1110_0000,
                              8'b1011_1110,
                              8'b1011_0110,     //5
                              8'b0110_0110,
                              8'b1111_0010,     //3
                              8'b1101_1010,
                              8'b0110_0000,
                              8'b1111_1100};    //0

  reg [3:0] counter_16bit=0;
  reg [1:0] digit_select=0;   // for 4digit
  reg [3:0] segment_select=0; // for 8segment LED(this is index of segment_map)  
  reg [15:0] target_number = 16'h0000;
  reg [9:0] number=0;
  reg data=0;
  reg sclk_reg=0;
  reg rclk_reg=0;

  assign LED_en = 1'b1;   assign clk_en = 1'b1;
  assign sclk_en = 1'b1;  assign rclk_en = 1'b1;
  assign serial_data_en = 1'b1;
  assign srclr_en = 1'b1;
  assign LED = 1;
  assign serial_data = data;
  assign rclk = rclk_reg;
  assign srclr = 1;
  assign sclk = sclk_reg;

  reg [15:0] counter=0;

  always @ (posedge clk)begin
    
    if (counter == 6_250) begin  // 1000Hz
        counter <= 16'b0;
        sclk_reg <= ~sclk_reg;
        number <= number + 10'b1;
        if(number == 10'd1023)begin
            target_number <= target_number + 16'b1;
        end
        
        if(sclk_reg)begin
          if(counter_16bit == 4'd0)begin
              rclk_reg <= 1;
          end else begin
              rclk_reg <= 0;
          end

          counter_16bit <= counter_16bit + 4'b1;
    
          if(counter_16bit == 4'd0)begin          // submitting of every digit data uses 16 clocks
              digit_select <= digit_select + 2'b1;  // for next digit
          end
  
          if(counter_16bit[3])begin
              segment_select = target_number >>(digit_select*4);
//            data <= segment_map[segment_select * 8 + counter_16bit[2:0]];
              data <= segment_map[segment_select * 7'd8 + counter_16bit[2:0]];
          end else begin
            if(counter_16bit[2] && (counter_16bit[1:0] == digit_select))begin
              data <= 1'b0;
            end else begin
              data <= 1'b1;
            end

          end
        end else begin
        end
    end else if(counter == 6000)begin
        rclk_reg <= 0;
        counter <= counter + 1'b1;
    end else begin
        counter <= counter + 1'b1;
    end
  end
  
endmodule
(* top *) module digit8_7seg(
  (* iopad_external_pin, clkbuf_inhibit *) input clk,
  (* iopad_external_pin *) output LED,
  (* iopad_external_pin *) output LED_en,
  (* iopad_external_pin *) output clk_en,
  (* iopad_external_pin *) output pmod_s,
  (* iopad_external_pin *) output pmod_s_en,
  (* iopad_external_pin *) output rclk,
  (* iopad_external_pin *) output rclk_en,
  (* iopad_external_pin *) output srclr,
  (* iopad_external_pin *) output srclr_en,
  (* iopad_external_pin *) output serial_data,
  (* iopad_external_pin *) output serial_data_en
);

  wire [79:0] segment_map = { 8'b0110_1111,     //9
                              8'b0111_1011,
                              8'b0111_1101,
                              8'b1011_1100,
                              8'b1000_0001,     //5
                              8'b1000_0001,
                              8'b1000_0001,     //3
                              8'b1000_0001,
                              8'b1000_0001,
                              8'b0011_1111};    //0

  reg [3:0] counter_16bit=0;
  reg sys_clk;
  reg [1:0] digit_select=0;   // for 4digit
  reg [3:0] segment_select=0; // for 8segment LED(this is index of segment_map)  
  wire [13:0] target_number = 14'h1234;
  reg [13:0] temp_number=0;
  reg data=0;
  reg sclk_reg=0;
  reg rclk_reg=0;
//  reg LED_status;

  assign LED_en = 1'b1;   assign clk_en = 1'b1;
  assign pmod_s_en = 1'b1;  assign rclk_en = 1'b1;
  assign serial_data_en = 1'b1;
  assign srclr_en = 1'b1;
  assign LED = 1;
  assign serial_data = data;
  assign rclk = rclk_reg;
  assign srclr = 1;
  assign pmod_s = sclk_reg;

  reg [15:0] counter=0;

  always @ (posedge clk)begin

    if (counter == 12_500) begin  // 2000Hz
        counter <= 16'b0;
        sclk_reg <= ~sclk_reg;
        
        if(!sclk_reg)begin
          rclk_reg <= 0;
          counter_16bit <= counter_16bit + 4'b1;
    
          if(counter_16bit == 4'd15)begin  // submitting of every digit data uses 16 clocks
            digit_select <= digit_select + 2'b1;  // next digit
//          segment_select <= 1;
            
            segment_select <= temp_number[3:0];
            
            if(digit_select == 2'd3)begin
              temp_number <= target_number;
            end else begin
//              temp_number <= temp_number / 10;  // right shift in decimal(for next digit)
                temp_number <= {4'b0000, temp_number[13:4]};
            end
          end
  
          if(counter_16bit[3])begin
            data <= segment_map[segment_select*8 + counter_16bit[2:0]];
          end else begin
            if(!counter_16bit[2] && (counter_16bit[1:0] == digit_select))begin
              data <= 1'b0;
            end else begin
              data <= 1'b1;
            end

          end
        end else begin
          if(counter_16bit == 4'd0)begin
            rclk_reg <= 1;
          end else begin
            rclk_reg <= 0;
          end
        end
    end else begin
        counter <= counter + 1'b1;
    end
  end
  
endmodule

module bcd_counter(
  input clk,
  input in,
  output out,
  output carry
);

reg[3:0] out_reg;

assign out = out_reg;

  always (posedge clk)begin
    if(in)begin

      if(out_reg == 4'd9)begin
        carry <= 1;
        out_reg <= 0;
      end else begin
        carry <= 0;
        out_reg <= out_reg +4'b1;
      end
    end else begin
      carry <= 1;
    end
  end
endmodule
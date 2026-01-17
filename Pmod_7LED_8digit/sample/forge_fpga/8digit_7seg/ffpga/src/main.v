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

  wire [79:0] segment_map = {8'b1000_0000, 8'b1000_0000, 8'b1000_0000, 8'b0111_1111, 8'b1000_0000, 8'b0111_1101, 8'b1000_0000, 8'b1000_0000, 8'b1000_0000, 8'b0011_1111};


  reg [3:0] counter_16bit;
  reg sys_clk;
  
  reg [2:0] digit_select;  // for 8digit
  reg [3:0] segment_select; // for 8segment LED(this is index of segment_map)  
  
  reg [29:0] target_number = 30'd80868086;
  reg [29:0] temp_number;
  
  reg data;
  reg sclk_reg;
  
  reg LED_status;

  assign LED_en = 1'b1;
  assign clk_en = 1'b1;

  assign serial_data_en = 1'b1;
  assign pmod_s_en = 1'b1;
  assign rclk_en = 1'b1;
  assign srclr_en = 1'b1;
  
  assign LED = LED_status;
  assign serial_data = data;
//  assign target_number = 30'd80868086;
  assign rclk = ~pmod_s;
  assign srclr = 1;
  assign pmod_s = sclk_reg;
  
  reg [15:0] counter;
    
  always @ (posedge clk)begin

    if (counter == 50_000) begin  // 500Hz
//      LED_status <= !LED_status;
        counter <= 16'b0;

        sclk_reg <= ~sclk_reg;
        counter_16bit <= counter_16bit + 4'b1;
    
        if(counter_16bit == 4'd15)begin  // submitting of every digit data uses 16 clocks
          digit_select <= digit_select + 3'b1;  // next digit
          segment_select <= 4'b1;
//      segment_select <= temp_number % 10;
          temp_number <= temp_number / 10;  // right shift in decimal(for next digit)
        end
    
        if(digit_select == 3'd7)begin  // return to digit 0
          temp_number <= target_number;
        end    
  
        if(counter_16bit[3])begin
      
          if(counter_16bit[2:0] == digit_select[2:0])begin
            data <= 1'b0;
          end else begin
            data <= 1'b1;
          end

        end else begin
//        data <= segment_map[segment_select*8 + counter_16bit];
          data <= segment_map[segment_select*8];
      end
    
    end else begin
        counter <= counter + 1'b1;
    end
  end
  
endmodule
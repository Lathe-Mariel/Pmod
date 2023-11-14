module top(
input wire clk,
input wire sw1,sw2,
output wire CLR1,
output wire CLR2,
output wire CLR3,
output wire COL_Red,
output wire COL_Green,
output wire ROW,         //serial data
output wire mat_RCLOCK,  //transfering value of shift register to storage register
output wire mat_CLOCK,
output wire [5:0] onboard_led,
output logic sclk,
output logic serial_data,
output logic rclk,
output logic clear
);

logic overflow;

reg [5:0] onboard_led;
reg mat_CLOCK;
reg mat_RCLOCK;
reg ROW;
reg COL_Red;
reg COL_Green;

logic [4:0] serial_count;    // serial counter  for 32bit serial data
logic [5:0] column_count; // 4density(2bit) + 16row(4bit)
logic [24:0] scroll_count;

reg [7:0] ledFrameBuffer [1:0][7:0] = '{
                                      '{8'b01110000,
                                        8'b10001000,
                                        8'b10000000,
                                        8'b10000000,
                                        8'b10001000,
                                        8'b01110000,
                                        8'b00000000,
                                        8'b00000000},
                                      '{8'b00000000,
                                        8'b00000000,
                                        8'b00001110,
                                        8'b00010001,
                                        8'b00010001,
                                        8'b00001111,
                                        8'b00000001,
                                        8'b00000001}};

//parameter FULL_STROKE_STEP = 16'd32768;


timer1 timer_instance(clk, overflow);

initial begin
    rowCounter = 3'b0;
    

end


//reg [2:0] step;
reg [2:0] rowCounter;
reg [2:0] currentStep;

reg [7:0] cycleCounter;
logic colorSelector;

logic m_clk;

logic [1:0] fb[15:0][15:0] = {
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d2,'d0},  //0
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d2,  'd0,'d0,'d0,'d0,'d0,'d0,'d2,'d0},  //1
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d2,  'd0,'d0,'d0,'d0,'d0,'d0,'d2,'d0},  //2
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd2,'d0,'d0,'d0,'d0,'d0,'d2,'d0},  //3
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd2,'d0,'d0,'d0,'d0,'d0,'d2,'d0},  //4
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d2,'d0,'d0,'d0,'d0,'d2,'d0},  //5
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d2,'d0,'d0,'d0,'d0,'d2,'d0},  //6
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d2,'d0,'d0,'d0,'d2,'d0},  //7
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d2,'d0,'d0,'d0,'d2,'d0},  //8
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d0,'d2,'d0,'d0,'d2,'d0},  //9
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d0,'d2,'d0,'d0,'d2,'d0},  //10
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d0,'d0,'d2,'d0,'d2,'d0},  //11
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d0,'d0,'d2,'d0,'d2,'d0},  //12
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d0,'d0,'d0,'d2,'d2,'d0},  //13
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d0,'d0,'d0,'d2,'d2,'d0},  //14
                            '{'d0,'d0,'d2,'d0,'d0,'d0,'d2,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d2,'d0}};  //15

logic [2:0] block_x = 3'd3;
logic [3:0] block_y = 4'd15;
logic down_flag = 'b0;

always @(posedge overflow)begin
  if(serial_count == 'd31)begin
    rclk <= 1'b0;
    serial_count <= 'd0;
    column_count <= column_count + 'd1;
  end else if (serial_count == 'd0)begin
    rclk <= 1'b1;
    serial_count <= serial_count + 'b1;
  end else begin
    rclk <= 1'b0;
    serial_count <= serial_count + 'b1;
  end

  if(serial_count < 'd16)begin
  //for row data(anode)
    if((fb[column_count[3:0]]['d15 - (serial_count)]) > column_count[5:4])begin
      serial_data <= 'b1;
    end else begin
      serial_data <= 'b0;
    end
  end else begin
  //for column data(cathode)
    if((serial_count - column_count[3:0] - 'd16) == 0)begin
      serial_data <= 'b0;
    end else begin
      serial_data <= 'b1;
    end
  end
end

assign clear = 1'b1;
assign sclk = overflow;

always @(posedge overflow)begin
    mat_CLOCK <= ~mat_CLOCK;
    if(mat_CLOCK == 1)begin

        if(currentStep == 7)begin
            colorSelector <= colorSelector + 1;
            if(colorSelector == 0)begin
                rowCounter <= rowCounter + 3'b1;
            end
            mat_RCLOCK <= 1'b0;
        end else if(currentStep == 0) begin
            mat_RCLOCK <= 1'b1;
        end else begin
            mat_RCLOCK <= 1'b0;
        end

        if(ledFrameBuffer[colorSelector][currentStep][rowCounter] == 1)begin
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
  parameter COUNT_MAX = 100
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
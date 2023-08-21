module frameBuffer_16x16(
input wire clk,
input wire sw,
output wire sclk,
output logic rclk,
output wire _srclr,
output logic serial_data
);


//[row][column][density]
logic [1:0] fb[7:0][7:0] = {
                            '{'d0,'d3,'d3,'d3,'d3,'d3,'d0,'d3},  //6
                            '{'d0,'d3,'d3,'d3,'d3,'d3,'d3,'d3},  //8
                            '{'d0,'d0,'d3,'d3,'d3,'d3,'d3,'d3},  //0
                            '{'d0,'d3,'d3,'d3,'d3,'d3,'d3,'d3},  //8
                            '{'d0,'d0,'d0,'d0,'d0,'d3,'d3,'d3},  //6
                            '{'d0,'d3,'d3,'d3,'d3,'d3,'d3,'d3},  //8
                            '{'d0,'d0,'d3,'d3,'d3,'d3,'d3,'d3},  //0
                            '{'d0,'d3,'d3,'d3,'d3,'d3,'d3,'d3}}; //8

logic [4:0] s_counter;    //serial counter  for serial data
logic [4:0] line_counter; //  4density(2bit) + 8row(3bit)
logic [15:0] line_data;   // data for this time
logic signal_clk;
logic m_clk;

timer ti(clk, m_clk);

always @(posedge m_clk)begin
    signal_clk = ~signal_clk;
end

always @(posedge signal_clk)begin
  if(s_counter == 'd0)begin
    rclk <= 'd1;
  end else begin
    rclk <= 'd0;
  end

  if(s_counter == 'd15)begin
    line_counter = line_counter + 5'd1;
//    line_data[15:8] <= 8'b00000011;
    line_data[15:8] <= ~{8'b00000001 << line_counter[2:0]};

    for(int i=0; i<8; i=i+1)begin
    if(fb[line_counter[2:0]][i] > line_counter[4:3])begin
      line_data[i] <= 1'b1;
    end else begin
      line_data[i] <= 1'b0;
    end
  end

    s_counter <= 'd0;
    serial_data <= line_data['d15 - s_counter];
  end else begin
    s_counter <= s_counter + 4'd1;
    serial_data <= line_data['d15 - s_counter];
  end
end

//  fb[16'd1 << main_counter[9:6]]

//assign serial_data = line_data[s_counter];
assign sclk = signal_clk;
assign _srclr = 1;

endmodule


module timer #(
  parameter COUNT_MAX = 1600
)(
  input wire clk,
  output logic m_clk
);

  logic [$clog2(COUNT_MAX+1)-1:0] counter = 'd0;

  always @(posedge clk)begin
    if(counter == COUNT_MAX)begin
      counter <= 'd0;
      m_clk <= 'd1;
    end else begin
      counter <= counter + 'd1;
      m_clk <= 'd0;
    end
  end
  

endmodule
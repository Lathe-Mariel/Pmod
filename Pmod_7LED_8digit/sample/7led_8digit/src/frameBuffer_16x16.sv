module frameBuffer_16x16(
input wire clk,
input wire sw,
output wire sclk,
output wire rclk,
output wire _srclr,
output wire serial_data
);


//[row][column][density]
logic [1:0] fb[7:0][7:0] = {
                            {2,2,2,2,2,2,2,0},
                            {0,0,0,0,0,0,0,0},
                            {2,2,2,2,2,2,2,0},
                            {2,0,2,2,2,2,2,0},
                            {2,2,2,2,2,2,2,0},
                            {0,0,0,0,0,0,0,0},
                            {2,2,2,2,2,2,2,0},
                            {2,2,2,0,0,0,0,0}}
;
logic [5:0] s_counter;    //serial counter  for 32bit serial data
logic [4:0] line_counter; //  4density(2bit) + 8row(3bit)
logic [15:0] line_data;   // data for this time
logic signal_clk;
timer(clk, m_clk);

always @(posedge m_clk)begin
    signal_clk = ~signal_clk;
end

always @(posedge signal_clk)begin
  if(s_counter == 4'd15)begin
    s_counter <= 4'd0;
    line_counter <= line_counter + 4'd1;
  end else begin
    s_counter <= s_counter + 4'd1;
  end

end

//  fb[16'd1 << main_counter[9:6]]

always @(posedge line_counter)begin
  line_data[15:8] <= 8'd1 << line_counter[2:0];
  for(int i=0; i<8; i=i+1)begin
    if(fb[8'd1 << line_counter[2:0]][i] > line_counter[4:3])begin
      line_data[i] <= 1'b1;
    end
  end

//density process
end

assign serial_data = line_data[s_counter];
assign sclk = rclk;
assign _srclr = 0;

endmodule


module timer #(
  parameter COUNT_MAX = 100
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
module frameBuffer_16x16(
input wire clk;
output wire sclk;
output wire serial_data;
);

logic [5:0][7:0][1:0] fb;       //[row][column][density]
logic [3:0] s_counter;    //serial counter  for 16bit serial data
logic [4:0] line_counter; //  4density(2bit) + 6row(3bit)
logic [15:0] line_data;   // data for this time
wire ori_clock;

always @(posedge ori_clock)begin
  m_clk ~= m_clk;
end

always @(posedge m_clk)begin
  if(s_counter == 'd15)begin
    s_counter <= 'd0;
    line_counter <= line_counter + 4'd1;
  end else begin
    s_counter <= s_counter + 4'd1;
  end

  serial_data <= line_data[s_counter];
end

//  fb[16'd1 << main_counter[9:6]]

always @(posedge line_counter)begin
  line_data[13:8] <= 6'd1 << line_counter[2:0];
  for(int i=0; i<8 ; i++)begin
    if(fb[line_counter[2:0]][i] > line_counter[4:3])begin
      line_data[i] <= 1'b1;
    end
  end
  line_data[7:0] <= fb[16'd1 << line_counter[2:0]];
//density process
end

endmodule

assign sclk = m_clk;

module timer #(
  prameter COUNT_MAX = 50
)(
  input wire clk,
  output logic ori_clk
);

  logic [$clog2(COUNT_MAX+1)-1:0] counter = 'd0;

  always @(posedge clk)begin
    if(counter == COUNT_MAX)begin
      counter <= 'd0;
      ori_clk <= 'd1;
    end else begin
      counter <= counter + 'd1;
      ori_clk <= 'd0;
    end
  end
  

endmodule
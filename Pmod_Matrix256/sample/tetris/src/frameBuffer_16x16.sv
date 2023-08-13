module frameBuffer_16x16(
input wire clk;
output wire sclk;
output wire serial_data;
);

logic [16:0][16:0][1:0] fb;       //[row][column][density]
logic [5:0] s_counter;    //serial counter  for 32bit serial data
logic [5:0] line_counter; //  4density(2bit) + 16row(4bit)
logic [31:0] line_data;   // data for this time

always @(posedge m_clk)begin
  if(s_counter == 5'd31)begin
    s_counter <= 5'd0;
    line_counter <= line_counter + 6'd1;
  end else begin
    s_counter <= s_counter + 5'd1;
  end

  serial_data <= line_data[s_counter];
end

//  fb[16'd1 << main_counter[9:6]]

always @(posedge line_counter)begin
  line_data[31:16] <= 16'd1 << line_counter[3:0];
  for(int i=0; i<16; i++)begin
    if(fb[16'd1 << line_counter[3:0]][i] > line_counter[5:4])begin
      line_data[i] <= 1'b1;
    end
  end

//density process
end

endmodule

assign sclk = m_clk;
assign serial_data = line_data[s_counter];

module timer #(
  prameter COUNT_MAX = 100
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
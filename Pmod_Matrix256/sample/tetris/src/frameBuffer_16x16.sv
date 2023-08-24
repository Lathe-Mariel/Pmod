module frameBuffer_16x16(
input wire clk,
output logic sclk,
output logic serial_data,
output logic rclk,
output logic clear,
input sw
);

logic [4:0] serial_count;    // serial counter  for 32bit serial data
logic [5:0] column_count; // 4density(2bit) + 16row(4bit)

logic [24:0] scroll_count;

// serial_clk ;clock for serial data that is be sending
// serial_count; 
// column_count(16 x4) ; number for column that is procecced at now
// serial_data ; data bit to send at this clock

logic m_clk;

logic [1:0] fb[15:0][15:0] = {
                            '{'d3,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //0
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //1
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //2
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //3
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //4
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //5
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //6
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd3,'d0,'d0,'d0,'d3,'d0,'d0,'d0},  //7
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d3,'d3,'d3,'d0,'d3,'d3,'d3},  //8
                            '{'d0,'d0,'d3,'d3,'d3,'d3,'d3,'d0,  'd0,'d3,'d0,'d3,'d0,'d3,'d0,'d3},  //9
                            '{'d0,'d0,'d0,'d0,'d3,'d0,'d0,'d0,  'd0,'d3,'d3,'d3,'d0,'d3,'d3,'d3},  //10
                            '{'d0,'d0,'d0,'d0,'d3,'d0,'d0,'d0,  'd0,'d3,'d0,'d3,'d0,'d3,'d0,'d3},  //11
                            '{'d0,'d0,'d3,'d3,'d3,'d3,'d3,'d0,  'd0,'d3,'d3,'d3,'d0,'d3,'d3,'d3},  //12
                            '{'d0,'d0,'d0,'d0,'d3,'d0,'d0,'d0,  'd0,'d3,'d0,'d0,'d0,'d0,'d0,'d3},  //13
                            '{'d0,'d0,'d0,'d0,'d3,'d0,'d0,'d0,  'd0,'d3,'d0,'d0,'d0,'d0,'d0,'d3},  //14
                            '{'d0,'d0,'d0,'d0,'d3,'d3,'d3,'d0,  'd0,'d3,'d0,'d0,'d0,'d0,'d0,'d3}};  //15

logic [2:0] block_x = 3'd3;
logic [3:0] block_y = 4'd15;
logic down_flag = 'b0;
logic serial_clk;

//timer ti(clk, m_clk);
timer ti(clk, serial_clk);

//always @(posedge m_clk)begin
//  serial_clk <= ~serial_clk;
//end

//always @(down_flag)begin
//  if(fb[block_y - 4'd1][block_x] == 2'd3)begin
//    block_y <= 4'd15;
//    fb[block_y][block_x] <= 'd3;
//  end else begin
//    fb[block_y][block_x] <= 'd0;
//    block_y <= block_y - 'd1;
//  end
//  fb[block_y - 4'd1][block_x] <= 'd3;
//end

always @(posedge serial_clk)begin
//  if(scroll_count > 800000)begin
//    scroll_count <= 'd0;
//    down_flag <= ~down_flag;
//  end else begin
//    scroll_count <= scroll_count + 'd1;
//  end

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
assign sclk = serial_clk;
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
      m_clk <= ~m_clk;
    end else begin
      counter <= counter + 'd1;
      m_clk <= 'd0;
    end
  end
endmodule

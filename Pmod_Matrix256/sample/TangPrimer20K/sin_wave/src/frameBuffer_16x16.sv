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

logic [7:0][3:0] sin;
assign sin = {4'd1, 4'd4, 4'd6, 4'd7, 4'd7, 4'd6, 4'd4, 4'd1};
                            
logic [2:0] block_x = 3'd3;
logic [3:0] block_y = 4'd15;
//logic down_flag = 'b0;
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

function [1:0] sin_shader_1bit(
    logic[3:0] x,
    logic[3:0] y
);
    x = x + scroll_count[18:15];

    if(x > 7)begin
        x = 15 - x;
        y = 8 - y;
    end else begin
        x = x;
        y = y + 8;
    end

    if(y < sin[x])begin 
        sin_shader_1bit = 2'd1;
    end else if(y == sin[x])begin
        sin_shader_1bit = 2'd3;
    end else begin
        sin_shader_1bit = 2'd0;
    end
endfunction


always @(posedge serial_clk)begin

  scroll_count <= scroll_count + 'd1;

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
//    if((fb[column_count[3:0]]['d15 - (serial_count)]) > column_count[5:4])begin  //column_count[5:4] represents brightness
    if(sin_shader_1bit(column_count[3:0], serial_count) > column_count[5:4])begin
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

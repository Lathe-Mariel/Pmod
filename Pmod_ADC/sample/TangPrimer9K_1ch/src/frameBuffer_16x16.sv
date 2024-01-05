module frameBuffer_16x16(
input wire clk,
output logic sclk,
output logic serial_data,
output logic rclk,
output logic clear,
output reg set_busy,
input logic set_request,
input reg[3:0] set_row,
input reg[3:0] set_value
);

logic [4:0] serial_count;    // serial counter  for 32bit serial data
logic [5:0] column_count; // 4density(2bit) + 16row(4bit)

// serial_clk ;clock for serial data that is be sending
// serial_count; 
// column_count(16 x4) ; number for column that is procecced at now
// serial_data ; data bit to send at this clock

logic m_clk;

logic[1:0] frameBuffer[15:0][15:0]= {
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d3,'d3,'d3,'d3,'d3},  //0
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d2,'d2,'d2,'d2},  //1
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d1,'d1,'d1},  //2
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //3
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //4
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //5
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //6
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //7
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //8
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //9
                            '{'d0,'d0,'d0,'d3,'d3,'d3,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //10
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //11
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //12
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //13
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0},  //14
                            '{'d0,'d0,'d0,'d0,'d0,'d0,'d0,'d0,  'd0,'d0,'d0,'d0,'d0,'d0,'d0,'d0}};  //15;

logic serial_clk;

//timer ti(clk, m_clk);
timer2 ti(clk, serial_clk);
logic[4:0] temp;

logic[3:0] value_buffer;

always @(negedge serial_clk)begin


  if(set_request)begin
    set_busy <= 1'b1;

  end

  if(set_busy || set_request)begin
    value_buffer <= set_value;
    for(int i=0;i<16;i++)begin
      if(value_buffer == i)begin
        frameBuffer[i][set_row] <= 2'd3;
      end else if(value_buffer >= i)begin
        frameBuffer[i][set_row] <= 2'd1;
      end else begin
        frameBuffer[i][set_row] <= 2'd0;
      end
    end
    set_busy <= 0;
  end

  if(serial_count == 'd31)begin
    serial_count <= 'd0;
    column_count <= column_count + 'd1;
    rclk <= 1'b1;
  end else begin
    rclk <= 1'b0;
    serial_count <= serial_count + 'b1;
  end

   temp = serial_count[4:0]+1;


  if(temp[4:0] < 'd16)begin
  //for row data(anode)
    if(frameBuffer[temp][column_count[3:0]] > column_count[5:4])begin
      serial_data <= 'b1;
    end else begin
      serial_data <= 'b0;
    end
  end else begin
  //for column data(cathode)
    if(temp[3:0] == column_count[3:0])begin
      serial_data <= 'b0;
    end else begin
      serial_data <= 'b1;
    end
  end
end

assign clear = 1'b1;
assign sclk = serial_clk;

endmodule


module timer2 #(
  parameter COUNT_MAX = 100
)(
  input wire clk,
  output logic m_clk
);

  logic [$clog2(COUNT_MAX+1)-1:0] counter = 'd0;

  always @(posedge clk)begin
    if(counter == COUNT_MAX/2)begin
      counter <= counter + 'd1;
      m_clk <= ~m_clk;
    end else if(counter == COUNT_MAX) begin
      counter <= 'd0;
    end else begin
      counter <= counter + 'd1;
    end
  end
endmodule

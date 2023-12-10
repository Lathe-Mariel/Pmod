/***********************************************
64x64 = 8192 Byte
5bit per color, 15bit per pixel
2pix in a 32bit Word: R1G1B1 in 0th line, R2G2B2 in 32th line

***********************************************/
`define ROW_CNT      16'd32  //32x2
`define ROW_BITS      6'd5 

`define COL_CNT      16'd64   //64
`define COL_BITS      6'd6     //6
`define COL_CNT_FULL 16'd64   
`define COL_CNT_REST 16'd0   //COLS补齐到次幂的数量
//ram_addr 存储按次幂对齐

`define PWM_BITS      6'd5

/*
from PIL import Image
import numpy as np
im = Image.open("S.bmp")
img = np.array(im)
shape=img.shape
print("#File_format=Hex")
print("#Address_depth=%d"%(shape[0]*shape[1]/2))
print("#Data_width=32")
for y in range(32):
    for x in range(shape[1]):
        rgb1 = (img[y,x,2]>>3)|((img[y,x,1]>>3)<<5)|((img[y,x,0]>>3)<<10)
        rgb2 = (img[y+32,x,2]>>3)|((img[y+32,x,1]>>3)<<5)|((img[y+32,x,0]>>3)<<10)
        print("%04X%04X"%(rgb1, rgb2))
*/

module TOP (
	       input wire 	 CLK_IN,  //OSC : E2
	       input wire 	 USER_KEY,//S1  : H11
	       output wire 	 hub_R1,  //G10
	       output wire 	 hub_G1,  //G11
	       output wire 	 hub_B1,  //D10
	       output wire 	 hub_R2,  //B10
	       output wire 	 hub_G2,  //B11
	       output wire 	 hub_B2,  //C10
	       output wire 	 hub_E,   //C11
	       output wire 	 hub_A,   //A10
	       output wire 	 hub_B,   //A11
	       output wire 	 hub_C,   //E10
	       output wire 	 hub_D,   //E11
	       output wire 	 hub_CK,  //L11
	       output wire 	 hub_ST,  //K11
	       output wire 	 hub_OE,  //K5
           output wire 	 dbg0,    //K2
           output wire 	 dbg1,    //L1
           output wire 	 dbg2     //K4
);

   // Power-on and user reset
   reg [5:0] reset_cnt = 0;
   wire      presetn = &reset_cnt;
   reg 	     uresetn = 0;
   wire      resetn = presetn & uresetn;

   always @(posedge CLK_IN) begin
      reset_cnt <= reset_cnt + !presetn;
      uresetn <= USER_KEY;
   end

   wire   clock;
   wire   extlock;
   //pll pll0(CLK_IN, 1'b0, extlock, clock);
   //assign clock = CLK_IN;

   reg [5:0] clkn = 0;

   always @(posedge CLK_IN) begin
      if ((!resetn)) begin
        clkn <= 0;
      end
      else begin
        clkn <= clkn + 6'd1;
      end
   end
   assign clock = clkn[0];


   wire [31:0] ram_wdata;
   wire [`ROW_BITS+`COL_BITS-1:0] ram_raddr;
   wire [15:0] ram_rdata1;
   wire [15:0] ram_rdata2;


   wire frame_clk;
   assign dbg0 = ram_rdata2[9];
   assign dbg1 = ram_rdata2[8];
   assign dbg2 = ram_rdata2[7];

   // Pixel 2-port ram
   //pixram pram(clock, 1'b1, 1'b0, ram_raddr, 0, {ram_rdata2, ram_rdata1}, ram_wdata);
   Gowin_pROM logo_rom(
        .dout({ram_rdata1, ram_rdata2}), 
        .clk(clock), 
        .oce(1'b1), 
        .ce(1'b1), 
        .reset(!resetn), 
        .ad(ram_raddr));

   // Generate IF signals
   wire [`ROW_BITS-1:0] rows; 
   assign { hub_E, hub_D, hub_C, hub_B, hub_A } = rows;
 
   hub75e_if hubif(clock, resetn, rows, hub_CK, hub_ST, hub_OE, ram_raddr, frame_clk);

   // 5 bit PWM + 5 bit ROW
   reg [`PWM_BITS+`ROW_BITS-1:0] frame_count;
   always @(posedge frame_clk) begin
      if (!resetn) begin
        frame_count <= 0;
      end
      else begin
        frame_count <= frame_count + 1;
      end
   end

   // Enable display
   wire [4:0] threshold = frame_count[`PWM_BITS+`ROW_BITS-1:`ROW_BITS];

   always @(posedge clock)begin
     pixel <= square(ram_raddr[10:6], ram_raddr[5:0], 8'd12, 8'd12, 8'd8);
   end

   logic[7:0] pixel;

   assign hub_R1 = 0;  //((ram_rdata1[14:10]) > threshold) ;
   assign hub_G1 = (pixel > threshold);
   assign hub_B1 = hub_G1;  //((ram_rdata1[ 9: 5]) > threshold) ;
//   assign hub_R2 = ((ram_rdata2[14:10]) > threshold) ;
//   assign hub_G2 = ((ram_rdata2[ 4: 0]) > threshold) ;
//   assign hub_B2 = ((ram_rdata2[ 9: 5]) > threshold) ;

function [7:0] min(
  input logic[7:0] in_a,
  input logic[7:0] in_b
);
  min = (in_a < in_b) ? in_a : in_b;
endfunction

function [7:0] max(
  input logic[7:0] in_a,
  input logic[7:0] in_b
);
  max = (in_a > in_b) ? in_a : in_b;
endfunction

function [7:0] abs(
  input logic[7:0] in
);
  abs = (in ^ -in) & -in;
endfunction

function [7:0] step(
  input logic[7:0] notch,
  input logic[7:0] in
);
  step = in % notch;
endfunction

function[7:0] square(
  input logic[7:0] pos_x,
  input logic[7:0] pos_y,
  input logic[7:0] center_x,
  input logic[7:0] center_y,
  input logic[7:0] size
);
  logic [7:0] temp;
  temp = (abs(pos_x - center_x) + abs(pos_y - center_y));
  if(temp < size)begin
    square = size - temp;
  end else begin
    square = 0;
  end
endfunction

function[7:0] circle(
  input logic[7:0] pos_x,
  input logic[7:0] pos_y,
  input logic[7:0] center_x,
  input logic[7:0] center_y,
  input logic[7:0] radius
);
  logic[15:0] temp;

  temp = radius^2 -((pos_x - center_x)^2 + (pos_y - center_y)^2);
  if(temp[15] == 1)begin
    circle <= 0;
  end else begin
    circle = temp[9:2];
  end
endfunction

function[7:0] mix(
  input logic[7:0] start,
  input logic[7:0] goal,
  input logic[7:0] proportion
);
  mix = start + (abs(start - goal) * proportion);

endfunction

endmodule // hub75e

// 50M/50 = 1M
// 1us x (64+3) = 67us / line
// 67x32 = 2144us / pic
//rows -> ABCDE

module hub75e_if (
		  input 	clk,
		  input 	resetn,
		  output [`ROW_BITS-1:0] 	     rows,  //5bit, 32line
		  output     hub_ck,     //CLK
		  output     hub_st,     //LAT
		  output reg hub_oe,     //OE
		  output [`ROW_BITS+`COL_BITS-1:0] ram_addr,//2048x32bit
		  output reg frame_clk   // L shift, H store
);
   reg [`ROW_BITS+`COL_BITS-1:0] hub_addr;//H5bit is line addr, L6bit is col addr
   reg [`ROW_BITS-1:0] row;
   reg [1:0] state = 0;
   assign ram_addr = hub_addr;
   assign hub_ck   = clk & ~frame_clk;
   assign hub_st   = clk & frame_clk;
   assign rows     = hub_addr[`ROW_BITS+`COL_BITS-1:`COL_BITS] - 1;

   always @(negedge clk) begin
      if (!resetn) begin
         state     <= 0;
         hub_addr  <= 0;
         row       <= 0;
         frame_clk <= 0;
         hub_oe    <= 0;
      end
      if (state == 0) begin //in scan
         if (hub_addr[`COL_BITS-1:0] == (`COL_CNT-1)) begin  //finish one frame
            frame_clk <= 1; //output frame
            hub_oe    <= 1;    //output OE
            state     <= 1;
         end else begin
            hub_addr  <= hub_addr + 1; //col+1
            frame_clk <= 0;
            state     <= 0;
         end
      end
      else if (state == 1) begin
        state <= 2;
      end
      else if (state == 2) begin
         frame_clk <= 0;
         hub_addr  <= hub_addr + 1 + `COL_CNT_REST;
         state     <= 3;
      end
      else if (state == 3) begin
         hub_oe <= 0;
         state  <= 0;
      end
   end // always @ (negedge pin_clk)

endmodule // hub75e_if

/*
module pixram (
	       input wire 	 clk,
	       input wire 	 read,
	       input wire 	 write,
	       input wire [ROW_BITS+COL_BITS-1:0] raddr,
	       input wire [ROW_BITS+COL_BITS-1:0] waddr,
	       output reg [31:0] data_out,
	       input wire [31:0] data_in
);

   reg [31:0] 			 mem[0:COL_CNT_FULL*ROW_CNT-1];

   always @(posedge clk) begin
      if (write) begin
         mem[waddr] <= data_in;
      end
      if (read) begin
	 data_out <= mem[raddr];
      end
   end // always @ (posedge clk)

endmodule // pixram */






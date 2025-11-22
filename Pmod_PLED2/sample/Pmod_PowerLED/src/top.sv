`default_nettype none

module top(
input wire sys_clk,
input wire switch1,
input wire switch2,
input wire reset,
output logic led,
output logic fan,
output logic color[2:0]
);

logic pll_lock;
logic clkout_10m;
logic reset_n;

/*
//138k pro
    Gowin_PLL your_instance_name(
        .lock(pll_lock), //output lock
        .clkout0(clkout_10m), //output clkout0
        .clkin(sys_clk), //input clkin
        .reset(!reset) //input reset
    );
*/

//primer25k
    Gowin_PLL your_instance_name(
        .lock(pll_lock), //output lock
        .clkout0(clkout_10m), //output clkout0
        .clkin(sys_clk), //input clkin
        .reset(~reset_n) //input reset
    );

assign reset_n = ~reset;

logic[19:0] counter;
logic clk_10k;


always @(posedge clkout_10m)begin
    if(counter >= 9999)begin
        counter <= 0;
        clk_10k <= 1;
    end else begin
        counter <= counter + 'b1;
        clk_10k <= 0;
    end

end

always @(posedge clk_10k)begin
    if(~reset_n)begin
        color <= {1,1,0};
    end else begin
        color <= {color[1:0], color[2]};
    end
end
endmodule

`default_nettype wire
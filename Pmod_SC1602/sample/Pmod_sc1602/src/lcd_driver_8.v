module lcd_driver_8(clk,resetn,addr,data,rd,sc1602_en,sc1602_rs,sc1602_rw,sc1602_data,rfrsh_rate);
input clk,resetn;
output [7:0] addr;
reg [7:0] addr;
input [7:0] data;
output rd;
reg rd;
output sc1602_en,sc1602_rs,sc1602_rw;
reg sc1602_en,sc1602_rs,sc1602_rw;
output [3:0] sc1602_data;
reg [3:0] sc1602_data;

output rfrsh_rate;
reg rfrsh_rate;

reg [7:0] state, next, didx, hold_time;

parameter RESET=0;
parameter WAIT=1;
parameter HOLD=2;
parameter FNCSET=3;
parameter DSPOFF1=4;
parameter DSPOFF2=5;
parameter CLRDSP1=6;
parameter CLRDSP2=7;
parameter DSPON1=8;
parameter DSPON2=9;
parameter ENMODST1=10;
parameter ENMODST2=11;
parameter RETHOM1=12;
parameter RETHOM2=13;
parameter REDCHR=14;
parameter WRTCHR1=15;
parameter WRTCHR2=16;
parameter DDRMADSET1=17;
parameter DDRMADSET2=18;

// DL=1:8bit, N=1:2-line, F=0:5x8 dot, D=0:disp off
// C=0:Cursor off, B=0:Blinking off
// I/D=1:Increment by 1, S=0:No shift

// clk = 37us

always @(posedge clk or negedge resetn) begin

    if (!resetn)
        begin
            state <= RESET;
            didx <= 0;
        end
    else
        begin
            case (state)
                RESET:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h3;    // DL=1, N=1, F=0
                        didx = didx + 1;
                        if (didx > 3)
                            next <= FNCSET;
                        else 
                            next <= RESET;
                        state <= WAIT;
                        hold_time = 0;
                    end
                WAIT:
                    begin
                        sc1602_en <= 0;
                        state <= HOLD;
                    end
                HOLD:
                    begin
                        if (hold_time == 0)
                            state <= next;
                        else 
                            begin
                                hold_time = hold_time - 1;
                            end
                    end
                FNCSET: // Function set
                    // Sets interface data length(DL)
                    // number of display lines (N)
                    // and character font (F).
                    // DL : 1=8 bits, 0=4 bits
                    // N : 1=2-lines, 0=1-line
                    // F : 5x10 dots, 0=5x8 dots
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h3;    // 1, DL=1, N=1, F=0, 0, 0
                        state <= WAIT;
                        next <= DSPOFF1;
                        hold_time = 0;
                    end
                DSPOFF1:    // Display on/off
                    // D: 1=Display on, 0=off, C: 1=Cursor on, 0=off, B: 1=Cursor blinking, 0=off
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h0;    // Display on/off=0, Block cursor =0, Blink =0
                        state <= WAIT;
                        next <= DSPOFF2;
                        hold_time = 0;
                    end
                DSPOFF2:    // Display on/off
                    // D: 1=Display on, 0=off, C: 1=Cursor on, 0=off, B: 1=Cursor blinking, 0=off
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h8;    // Display on/off=0, Block cursor =0, Blink =0
                        state <= WAIT;
                        next <= CLRDSP1;
                        hold_time = 0;
                    end
                CLRDSP1: // Clear display / 1.52ms
                    // Clear entire display and sets DDRAM address 0 in address counter.
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h0;    // Clear Display
                        state <= WAIT;
                        next <= CLRDSP2;
                        hold_time = 0;
                    end
                CLRDSP2: //
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h1;    //
                        state <= WAIT;
                        next <= DSPON1;
                        hold_time = 42;
                    end
                DSPON1: // Display on/off
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h0;    // D=1, C=0, B=0
                        state <= WAIT;
                        next <= DSPON2;
                        hold_time = 0;
                    end
                DSPON2: //
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'hC;    //
                        state <= WAIT;
                        next <= ENMODST1;
                        hold_time = 0;
                    end
                ENMODST1:    // Entry Mode
                    // Sets cursor move direction and specifies display shift. 
                    // These operations are performed during data write and read.
                    // I/D : 1=Increment, 0=Decrement, S : 1=Accompanies display shift
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h0;    // 1, I/D=1, S=0
                        state <= WAIT;
                        next <= ENMODST2;
                        hold_time = 0;
                    end
                ENMODST2:    // Entry Mode
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h6;    //
                        state <= WAIT;
                        next <= RETHOM1;
                        hold_time = 0;
                    end
                RETHOM1: // Return Home / 1.52ms
                    // Set DDRAM address to "00H" 
                    // from AC and return cursor to its
                    // original position if shifted. The
                    // contents of DDRAM are not changed.
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h0;
                        state <= WAIT;
                        next <= RETHOM2;
                        didx <= 0;
                        //rfrsh_rate <= ~rfrsh_rate;    // output refresh rate;
                        hold_time = 0;
                    end
                RETHOM2: // Return Home / 1.52ms
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h2;
                        state <= WAIT;
                        next <= REDCHR;
                        didx <= 0;
                        rfrsh_rate <= ~rfrsh_rate;    // output refresh rate;
                        hold_time = 42;
                    end
                DDRMADSET1:    // Set DDRAM address
                    // Sets DDRAM address. DDRAM data is sent and 
                    // received after this setting.
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 4'h8 | (didx >> 4);
                        state <= WAIT;
                        next <= REDCHR;
                        hold_time = 0;
                    end
                DDRMADSET2:    // Set DDRAM address
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= didx;
                        state <= WAIT;
                        next <= REDCHR;
                        hold_time = 0;
                    end
                REDCHR:
                    begin 
                        addr <= didx;
                        rd <= 1;
                        state <= WRTCHR1;
                    end
                WRTCHR1:
                    begin
                        sc1602_data <= (data >> 4);
                        rd <= 0;
                        sc1602_rs <= 1;
                        sc1602_rw <= 0;
                        sc1602_en <= 1;
                        didx = didx + 1;
                        if (didx == 16)
                            begin
                                didx = 8'H40;
                                next <= DDRMADSET1;
                            end
                        else if (didx > 8'H4F)
                            begin
                                didx = 8'H00;
                                next <= RETHOM1;
                            end
                        else
                            next <= WRTCHR2;
                        state <= WAIT;
                        hold_time = 0;
                    end
                WRTCHR2:
                    begin
                        sc1602_data <= data;
                        rd <= 0;
                        sc1602_rs <= 1;
                        sc1602_rw <= 0;
                        sc1602_en <= 1;
                        next <= REDCHR;
                        state <= WAIT;
                        hold_time = 0;
                    end
            endcase
        end
end

endmodule
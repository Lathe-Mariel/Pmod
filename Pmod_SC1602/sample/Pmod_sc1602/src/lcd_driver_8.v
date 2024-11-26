module lcd_driver_8(clk,resetn,addr,data,rd,sc1602_en,sc1602_rs,sc1602_rw,sc1602_data,rfrsh_rate);
input clk,resetn;
output [7:0] addr;
reg [7:0] addr;
input [7:0] data;
output rd;
reg rd;
output sc1602_en,sc1602_rs,sc1602_rw;
reg sc1602_en,sc1602_rs,sc1602_rw;
output [7:0] sc1602_data;
reg [7:0] sc1602_data;

output rfrsh_rate;
reg rfrsh_rate;

reg [7:0] state, next, didx, hold_time;

parameter RESET=0;
parameter WAIT=1;
parameter HOLD=2;
parameter FNCSET=3;
parameter DSPOFF=4;
parameter CLRDSP=5;
parameter DSPON=6;
parameter ENMODST=7;
parameter RETHOM=8;
parameter REDCHR=9;
parameter WRTCHR=10;
parameter DDRMADSET=11;

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
                        sc1602_data <= 8'h38;    // DL=1, N=1, F=0
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
                        sc1602_data <= 8'h38;    // 1, DL=1, N=1, F=0, 0, 0
                        state <= WAIT;
                        next <= DSPOFF;
                        hold_time = 0;
                    end
                DSPOFF:    // Display on/off
                    // D: 1=Display on, 0=off, C: 1=Cursor on, 0=off, B: 1=Cursor blinking, 0=off
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 8'h08;    // D=0,C=0,B=0
                        state <= WAIT;
                        next <= CLRDSP;
                        hold_time = 0;
                    end
                CLRDSP: // Clear display / 1.52ms
                    // Clear entire display and sets DDRAM address 0 in address counter.
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 8'h01;    // Clear Display
                        state <= WAIT;
                        next <= DSPON;
                        hold_time = 42;
                    end
                DSPON: // Display on/off
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 8'h0C;    // D=1, C=0, B=0
                        state <= WAIT;
                        next <= ENMODST;
                        hold_time = 0;
                    end
                ENMODST:    // Entry Mode
                    // Sets cursor move direction and specifies display shift. 
                    // These operations are performed during data write and read.
                    // I/D : 1=Increment, 0=Decrement, S : 1=Accompanies display shift
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 8'h06;    // 1, I/D=1, S=0
                        state <= WAIT;
                        next <= RETHOM;
                        hold_time = 0;
                    end
                RETHOM: // Return Home / 1.52ms
                    // Set DDRAM address to "00H" 
                    // from AC and return cursor to its
                    // original position if shifted. The
                    // contents of DDRAM are not changed.
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 8'h02;
                        state <= WAIT;
                        next <= REDCHR;
                        didx <= 0;
                        rfrsh_rate <= ~rfrsh_rate;    // output refresh rate;
                        hold_time = 42;
                    end
                DDRMADSET:    // Set DDRAM address
                    // Sets DDRAM address. DDRAM data is sent and 
                    // received after this setting.
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_data <= 8'h80 | didx;
                        state <= WAIT;
                        next <= REDCHR;
                        hold_time = 0;
                    end

                REDCHR:
                    begin 
                        addr <= didx;
                        rd <= 1;
                        state <= WRTCHR;
                    end

                WRTCHR:
                    begin
                        sc1602_data <= data;
                        rd <= 0;
                        sc1602_rs <= 1;
                        sc1602_rw <= 0;
                        sc1602_en <= 1;
                        didx = didx + 1;
                        if (didx == 16)
                            begin
                                didx = 8'H40;
                                next <= DDRMADSET;
                            end
                        else if (didx > 8'H4F)
                            begin
                                didx = 8'H00;
                                next <= RETHOM;
                            end
                        else
                            next <= REDCHR;
                        state <= WAIT;
                        hold_time = 0;
                    end
            endcase
        end
end

endmodule
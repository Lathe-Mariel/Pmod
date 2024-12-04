module lcd_driver_8(clk,resetn, character, sc1602_en, sc1602_rs, sc1602_rw, sc1602_db, frame_rate);
input clk, resetn;
input [7:0] character;
output sc1602_en,sc1602_rs,sc1602_rw;
reg sc1602_en,sc1602_rs,sc1602_rw;
output [3:0] sc1602_db;
reg [3:0] sc1602_db;

output frame_rate;
reg frame_rate;

reg [7:0] state, next_state, locate;
reg [11:0] wait_counter;

localparam RST=0;
localparam RST1=1;
localparam RST2=2;
localparam WAIT1=3;
localparam WAIT2=4;
localparam FUNC_SET0=5;
localparam FUNC_SET1=6;
localparam FUNC_SET2=7;
localparam DSPOFF1=8;
localparam DSPOFF2=9;
localparam CLEAR1=10;
localparam CLEAR2=11;
localparam DSPON1=12;
localparam DSPON2=13;
localparam MODE1=14;
localparam MODE2=15;
localparam RETURN1=16;
localparam RETURN2=17;
localparam WRIGHT1=19;
localparam WRIGHT2=20;
localparam DDRAM1=21;
localparam DDRAM2=22;
localparam RST3=23;

localparam JUST_MOMENT=1;


always @(posedge clk or negedge resetn) begin

    if (!resetn)
        begin
            state <= RST;
            locate <= 8'b0;
        end
    else
        begin
            case (state)
                RST:
                    begin
                        sc1602_en <= 0;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h3;
                        next_state <= RST1;
                        state <= WAIT1;
                        wait_counter = 12'd4000; // more than 40ms
                    end
                RST1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h3;
                        next_state <= RST2;
                        state <= WAIT1;
                        wait_counter = 12'd400;  // more than 4.1ms
                    end
                RST2:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h3;
                        next_state <= RST3;
                        state <= WAIT1;
                        wait_counter = 12'd140; // more than 100us
                    end
                RST3:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h3;
                        next_state <= FUNC_SET0;
                        state <= WAIT1;
                        wait_counter = JUST_MOMENT; // more than 38us
                    end
                WAIT1:
                    begin
                        sc1602_en <= 0;
                        state <= WAIT2;
                    end
                WAIT2:
                    begin
                        if (wait_counter == 0)
                            state <= next_state;
                        else 
                            begin
                                wait_counter <= wait_counter - 1;
                            end
                    end
               FUNC_SET0:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h2;
                        state <= WAIT1;
                        next_state <= FUNC_SET1;
                        wait_counter = JUST_MOMENT;
                    end
                FUNC_SET1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h2;
                        state <= WAIT1;
                        next_state <= FUNC_SET2;
                        wait_counter = JUST_MOMENT;
                    end
                FUNC_SET2: // Function set
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h8;
                        state <= WAIT1;
                        next_state <= DSPOFF1;
                        wait_counter = JUST_MOMENT;
                    end
                DSPOFF1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0;
                        state <= WAIT1;
                        next_state <= DSPOFF2;
                        wait_counter = JUST_MOMENT;
                    end
                DSPOFF2:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h8;
                        state <= WAIT1;
                        next_state <= CLEAR1;
                        wait_counter = JUST_MOMENT;
                    end
                CLEAR1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0;
                        state <= WAIT1;
                        next_state <= CLEAR2;
                        wait_counter = JUST_MOMENT;
                    end
                CLEAR2: //
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h1;
                        state <= WAIT1;
                        next_state <= MODE1;
                        wait_counter = 12'd200; // more than 1.52ms
                    end

                MODE1: // Entry Mode
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0;
                        state <= WAIT1;
                        next_state <= MODE2;
                        wait_counter = JUST_MOMENT;
                    end
                MODE2: //
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h6;
                        state <= WAIT1;
                        next_state <= DSPON1;
                        wait_counter = JUST_MOMENT;
                    end

                DSPON1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0;
                        state <= WAIT1;
                        next_state <= DSPON2;
                        wait_counter = JUST_MOMENT;
                    end
                DSPON2:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'hc;
                        state <= WAIT1;
                        next_state <= RETURN1;
                        wait_counter = JUST_MOMENT;
                    end
                RETURN1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0;
                        state <= WAIT1;
                        next_state <= RETURN2;
                        wait_counter = JUST_MOMENT;
                    end
                RETURN2:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h2;
                        state <= WAIT1;
                        next_state <= WRIGHT1;
                        locate <= 8'b0;
                        frame_rate <= ~frame_rate;
                        wait_counter = 12'd200; // more than 1.52ms
                    end
                DDRAM1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= {1'b1, locate[6:4]};
                        state <= WAIT1;
                        next_state <= DDRAM2;
                        wait_counter = JUST_MOMENT;
                    end
                DDRAM2:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= locate[3:0];
                        state <= WAIT1;
                        next_state <= WRIGHT1;
                        wait_counter = JUST_MOMENT;
                    end
                WRIGHT1:
                    begin
                        sc1602_db <= character[7:4];
                        sc1602_rs <= 1;
                        sc1602_rw <= 0;
                        sc1602_en <= 1;
                        locate <= locate + 8'b1;
                        next_state <= WRIGHT2;
                        state <= WAIT1;
                        wait_counter = JUST_MOMENT;
                    end
                WRIGHT2:
                    begin
                        sc1602_db <= character[3:0];
                        sc1602_rs <= 1;
                        sc1602_rw <= 0;
                        sc1602_en <= 1;

                        if (locate == 16)
                            begin
                                locate <= 8'h40;
                                next_state <= DDRAM1;
                            end
                        else if (locate > 8'h4F)
                            begin
                                next_state <= RETURN1;
                            end
                        else
                            next_state <= WRIGHT1;
                        state <= WAIT1;
                        wait_counter = JUST_MOMENT;
                    end
            endcase
        end
end

endmodule
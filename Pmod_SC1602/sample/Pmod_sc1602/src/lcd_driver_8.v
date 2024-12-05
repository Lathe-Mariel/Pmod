module lcd_driver_8(
input logic clk, 
input logic resetn,
input logic[7:0] character,
output logic sc1602_en,
output logic sc1602_rs,
output logic sc1602_rw,
output logic[3:0] sc1602_db,
output logic drawing
);

logic [7:0] state;
logic [7:0] next_state;
logic [7:0] locate;
logic [11:0] wait_counter;

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
localparam ENT_MODE1=14;
localparam ENT_MODE2=15;
localparam RETURN1=16;
localparam RETURN2=17;
localparam WRITE1=19;
localparam WRITE2=20;
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
                        if(sc1602_en == 1)begin
                            sc1602_en <= 0;
                        end else begin
                            if (wait_counter == 0)
                                state <= next_state;
                            else begin
                                wait_counter <= wait_counter - 1;
                            end
                        end
                    end
               FUNC_SET0: // FUNCTION SET for SC1602
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
                        sc1602_db <= 4'h0; // MSB of 8bit
                        state <= WAIT1;
                        next_state <= DSPOFF2;
                        wait_counter = JUST_MOMENT;
                    end
                DSPOFF2:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h8; // LSB of 8bit
                        state <= WAIT1;
                        next_state <= CLEAR1;
                        wait_counter = JUST_MOMENT;
                    end
                CLEAR1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0; // MSB of 8bit
                        state <= WAIT1;
                        next_state <= CLEAR2;
                        wait_counter = JUST_MOMENT;
                    end
                CLEAR2: //
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h1;  // LSB of 8bit
                        state <= WAIT1;
                        next_state <= ENT_MODE1;
                        wait_counter = 12'd200; // more than 1.52ms
                    end

                ENT_MODE1: // Entry Mode
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0;  // MSB of 8bit
                        state <= WAIT1;
                        next_state <= ENT_MODE2;
                        wait_counter = JUST_MOMENT;
                    end
                ENT_MODE2: //
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h6; // LSB of 8bit
                        state <= WAIT1;
                        next_state <= DSPON1;
                        wait_counter = JUST_MOMENT;
                    end

                DSPON1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0; // MSB of 8bit
                        state <= WAIT1;
                        next_state <= DSPON2;
                        wait_counter = JUST_MOMENT;
                    end
                DSPON2:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'hc; // LSB of 8bit
                        state <= WAIT1;
                        next_state <= RETURN1;
                        wait_counter = JUST_MOMENT;
                    end
                RETURN1:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h0; // MSB of 8bit
                        state <= WAIT1;
                        next_state <= RETURN2;
                        wait_counter = JUST_MOMENT;
                    end
                RETURN2:
                    begin
                        sc1602_en <= 1;
                        sc1602_rs <= 0;
                        sc1602_rw <= 0;
                        sc1602_db <= 4'h2; // LSB of 8bit
                        state <= WAIT1;
                        next_state <= WRITE1;
                        locate <= 8'b0;         // character insert location 0 set
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
                        next_state <= WRITE1;
                        wait_counter = JUST_MOMENT;
                    end
                WRITE1:
                    begin
                        drawing <= 1; // showing it's in a draw process
                        sc1602_db <= character[7:4]; //MSB of 8bit code that represents a character
                        sc1602_rs <= 1;
                        sc1602_rw <= 0;
                        sc1602_en <= 1;
                        locate <= locate + 8'b1; // increment position for character on LCD RAM
                        next_state <= WRITE2;
                        state <= WAIT1;
                        wait_counter = JUST_MOMENT;
                    end
                WRITE2:
                    begin
                        sc1602_db <= character[3:0]; // LSB of 8bit code that represents a character
                        sc1602_rs <= 1;
                        sc1602_rw <= 0;
                        sc1602_en <= 1;

                        if (locate == 16)
                            begin
                                locate <= 8'h40; // increment row
                                next_state <= DDRAM1;
                            end
                        else if (locate > 8'h4F)
                            begin
                                next_state <= RETURN1;
                            end
                        else
                            next_state <= WRITE1;
                        state <= WAIT1;
                        drawing <= 0;
                        wait_counter = JUST_MOMENT;
                    end
            endcase
        end
end

endmodule
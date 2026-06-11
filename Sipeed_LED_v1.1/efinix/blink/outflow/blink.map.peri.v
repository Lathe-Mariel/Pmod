// Efinix verilog description of module t8_lchika
// Date : Jun 11 2026  4:1
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.

module t8_lchika (clk, led_d1, led_d2, led_d3, led_d4, led0, led1, led2, led3, led4, led5, led6, led7);
    input clk;
    output led_d1;
    output led_d2;
    output led_d3;
    output led_d4;
    output led0;
    output led1;
    output led2;
    output led3;
    output led4;
    output led5;
    output led6;
    output led7;


    \t8_lchika~core  \t8_lchika~core~inst  (.clk(\clk~EFX_IBUF~O ), .led_d1(\led_d1~EFX_OBUF~I ), .led_d2(\led_d2~EFX_OBUF~I ), .led_d3(\led_d3~EFX_OBUF~I ), .led_d4(\led_d4~EFX_OBUF~I ), .led0(\led0~EFX_OBUF~I ), .led1(\led1~EFX_OBUF~I ), .led2(\led2~EFX_OBUF~I ), .led3(\led3~EFX_OBUF~I ), .led4(\led4~EFX_OBUF~I ), .led5(\led5~EFX_OBUF~I ), .led6(\led6~EFX_OBUF~I ), .led7(\led7~EFX_OBUF~I ));
    EFX_IBUF \clk~EFX_IBUF  (.I(clk), .O(\clk~EFX_IBUF~O )) /* EFX_ATTRIBUTE_CELL_NAME=EFX_IBUF, PULL_OPTION="NONE" */ ;
    defparam \clk~EFX_IBUF .PULL_OPTION = "NONE";
    EFX_OBUF \led_d1~EFX_OBUF  (.I(\led_d1~EFX_OBUF~I ), .O(led_d1)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led_d2~EFX_OBUF  (.I(\led_d2~EFX_OBUF~I ), .O(led_d2)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led_d3~EFX_OBUF  (.I(\led_d3~EFX_OBUF~I ), .O(led_d3)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led_d4~EFX_OBUF  (.I(\led_d4~EFX_OBUF~I ), .O(led_d4)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led0~EFX_OBUF  (.I(\led0~EFX_OBUF~I ), .O(led0)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led1~EFX_OBUF  (.I(\led1~EFX_OBUF~I ), .O(led1)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led2~EFX_OBUF  (.I(\led2~EFX_OBUF~I ), .O(led2)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led3~EFX_OBUF  (.I(\led3~EFX_OBUF~I ), .O(led3)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led4~EFX_OBUF  (.I(\led4~EFX_OBUF~I ), .O(led4)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led5~EFX_OBUF  (.I(\led5~EFX_OBUF~I ), .O(led5)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led6~EFX_OBUF  (.I(\led6~EFX_OBUF~I ), .O(led6)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
    EFX_OBUF \led7~EFX_OBUF  (.I(\led7~EFX_OBUF~I ), .O(led7)) /* EFX_ATTRIBUTE_CELL_NAME=EFX_OBUF */ ;
endmodule// t8_lchika
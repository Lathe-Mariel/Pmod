
//
// Verific Verilog Description of module \t8_lchika~core 
//

module \t8_lchika~core  (clk, led_d1, led_d2, led_d3, led_d4, led0, 
            led1, led2, led3, led4, led5, led6, led7) /* verific EFX_ATTRIBUTE_NETLIST__EFINITY_VERSION=2026.1.132 */ ;
    input clk /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_INPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(2)
    output led_d1 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(3)
    output led_d2 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(4)
    output led_d3 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(5)
    output led_d4 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(6)
    output led0 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(9)
    output led1 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(10)
    output led2 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(11)
    output led3 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(12)
    output led4 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(13)
    output led5 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(14)
    output led6 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(15)
    output led7 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(16)
    
    wire [23:0]n8_12;
    wire [22:0]n88_22;
    wire [22:0]n88_20;
    wire [22:0]n88_18;
    wire [22:0]n88_16;
    wire [22:0]n88_13;
    wire [22:0]n88_11;
    wire [22:0]n88_9;
    wire [22:0]n88_7;
    wire [22:0]n88_5;
    wire [22:0]n88_3;
    wire [23:0]n8_20;
    wire [23:0]n8_19;
    wire [23:0]n8_15;
    wire [23:0]n8_14;
    wire [23:0]n8_2;
    wire [23:0]n8_3;
    wire [23:0]n8_4;
    wire [23:0]n8_5;
    wire [23:0]n8_7;
    wire [23:0]n8_8;
    wire [23:0]n8_9;
    wire [23:0]n8_10;
    wire [23:0]n8_11;
    
    wire \add_34/n2 ;
    wire [23:0]counter;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(25)
    wire [22:0]n88_2;
    
    wire \add_36/n2 , \add_34/n4 ;
    wire [22:0]shift_counter;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(28)
    wire [22:0]n88_21;
    
    wire \add_36/n40 , \led_shift[0] , \add_34/n6 , \add_34/n8 , \add_34/n10 , 
        \add_36/n42 ;
    wire [22:0]n88_23;
    
    wire \add_36/n38 ;
    wire [22:0]n88_19;
    
    wire \add_36/n36 , \add_36/n34 ;
    wire [22:0]n88_17;
    
    wire \add_36/n32 , \add_36/n30 ;
    wire [22:0]n88_15;
    
    wire \add_36/n28 ;
    wire [22:0]n88_14;
    
    wire \add_36/n26 , \add_36/n24 ;
    wire [22:0]n88_12;
    
    wire \add_36/n22 , \add_36/n20 ;
    wire [22:0]n88_10;
    
    wire \add_36/n18 , \add_36/n16 ;
    wire [22:0]n88_8;
    
    wire \add_36/n14 , \add_36/n12 ;
    wire [22:0]n88_6;
    
    wire \add_36/n10 , \add_36/n8 ;
    wire [22:0]n88_4;
    
    wire \add_36/n6 , \add_36/n4 , \add_34/n44 ;
    wire [23:0]n8_18;
    
    wire \add_34/n42 ;
    wire [23:0]n8_17;
    
    wire \add_34/n40 ;
    wire [23:0]n8_16;
    
    wire \add_34/n38 , \add_34/n36 , \add_34/n34 ;
    wire [23:0]n8_13;
    
    wire \add_34/n32 ;
    wire [23:0]n8_6;
    
    wire \add_34/n30 , \add_34/n28 , \add_34/n26 , \add_34/n24 , \add_34/n22 , 
        \add_34/n20 , \add_34/n18 , \add_34/n16 , \add_34/n14 , \add_34/n12 , 
        \clk~O , n162_q, n164_q, n165_q, n166_q, n154_q, n156_q, 
        n157_q, n158_q, \equal_4/n47 , \equal_12/n45 , n154, n155, 
        n156, n157, n158, n159, n160, n161, n162, n163, n164, 
        n165, n166, n167;
    
    assign led_d3 = led_d1 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(5)
    assign led_d4 = led_d2 /* verific EFX_ATTRIBUTE_PORT__IS_PRIMARY_OUTPUT=TRUE, EFX_ATTRIBUTE_PORT__TOP_PORT_COPIED_TO_PERI_NL=1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(6)
    EFX_LUT4 LUT__425 (.I0(n154_q), .I1(shift_counter[0]), .I2(shift_counter[1]), 
            .O(n155)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;
    defparam LUT__425.LUTMASK = 16'h8080;
    EFX_FF \counter[14]~FF  (.D(n8_2[14]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[14])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[14]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[14]~FF .CE_POLARITY = 1'b1;
    defparam \counter[14]~FF .SR_POLARITY = 1'b0;
    defparam \counter[14]~FF .D_POLARITY = 1'b1;
    defparam \counter[14]~FF .SR_SYNC = 1'b1;
    defparam \counter[14]~FF .SR_VALUE = 1'b0;
    defparam \counter[14]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[13]~FF  (.D(n8_3[13]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[13])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[13]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[13]~FF .CE_POLARITY = 1'b1;
    defparam \counter[13]~FF .SR_POLARITY = 1'b0;
    defparam \counter[13]~FF .D_POLARITY = 1'b1;
    defparam \counter[13]~FF .SR_SYNC = 1'b1;
    defparam \counter[13]~FF .SR_VALUE = 1'b0;
    defparam \counter[13]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[12]~FF  (.D(n8_4[12]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[12])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[12]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[12]~FF .CE_POLARITY = 1'b1;
    defparam \counter[12]~FF .SR_POLARITY = 1'b0;
    defparam \counter[12]~FF .D_POLARITY = 1'b1;
    defparam \counter[12]~FF .SR_SYNC = 1'b1;
    defparam \counter[12]~FF .SR_VALUE = 1'b0;
    defparam \counter[12]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[0]~FF  (.D(shift_counter[0]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[0])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[0]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[0]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[0]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[0]~FF .D_POLARITY = 1'b0;
    defparam \shift_counter[0]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[0]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led_d3~FF  (.D(led_d1), .CE(\equal_4/n47 ), .CLK(\clk~O ), 
           .SR(1'b0), .Q(led_d1)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \led_d3~FF .CLK_POLARITY = 1'b1;
    defparam \led_d3~FF .CE_POLARITY = 1'b0;
    defparam \led_d3~FF .SR_POLARITY = 1'b1;
    defparam \led_d3~FF .D_POLARITY = 1'b0;
    defparam \led_d3~FF .SR_SYNC = 1'b1;
    defparam \led_d3~FF .SR_VALUE = 1'b0;
    defparam \led_d3~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[11]~FF  (.D(n8_5[11]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[11])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[11]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[11]~FF .CE_POLARITY = 1'b1;
    defparam \counter[11]~FF .SR_POLARITY = 1'b0;
    defparam \counter[11]~FF .D_POLARITY = 1'b1;
    defparam \counter[11]~FF .SR_SYNC = 1'b1;
    defparam \counter[11]~FF .SR_VALUE = 1'b0;
    defparam \counter[11]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led_shift[0]~FF  (.D(led7), .CE(\equal_12/n45 ), .CLK(\clk~O ), 
           .SR(1'b0), .Q(\led_shift[0] )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \led_shift[0]~FF .CLK_POLARITY = 1'b1;
    defparam \led_shift[0]~FF .CE_POLARITY = 1'b0;
    defparam \led_shift[0]~FF .SR_POLARITY = 1'b1;
    defparam \led_shift[0]~FF .D_POLARITY = 1'b0;
    defparam \led_shift[0]~FF .SR_SYNC = 1'b1;
    defparam \led_shift[0]~FF .SR_VALUE = 1'b0;
    defparam \led_shift[0]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[15]~FF  (.D(n8_6[15]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[15])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[15]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[15]~FF .CE_POLARITY = 1'b1;
    defparam \counter[15]~FF .SR_POLARITY = 1'b0;
    defparam \counter[15]~FF .D_POLARITY = 1'b1;
    defparam \counter[15]~FF .SR_SYNC = 1'b1;
    defparam \counter[15]~FF .SR_VALUE = 1'b0;
    defparam \counter[15]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[10]~FF  (.D(n8_7[10]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[10])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[10]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[10]~FF .CE_POLARITY = 1'b1;
    defparam \counter[10]~FF .SR_POLARITY = 1'b0;
    defparam \counter[10]~FF .D_POLARITY = 1'b1;
    defparam \counter[10]~FF .SR_SYNC = 1'b1;
    defparam \counter[10]~FF .SR_VALUE = 1'b0;
    defparam \counter[10]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[9]~FF  (.D(n8_8[9]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[9])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[9]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[9]~FF .CE_POLARITY = 1'b1;
    defparam \counter[9]~FF .SR_POLARITY = 1'b0;
    defparam \counter[9]~FF .D_POLARITY = 1'b1;
    defparam \counter[9]~FF .SR_SYNC = 1'b1;
    defparam \counter[9]~FF .SR_VALUE = 1'b0;
    defparam \counter[9]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[8]~FF  (.D(n8_9[8]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[8]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[8]~FF .CE_POLARITY = 1'b1;
    defparam \counter[8]~FF .SR_POLARITY = 1'b0;
    defparam \counter[8]~FF .D_POLARITY = 1'b1;
    defparam \counter[8]~FF .SR_SYNC = 1'b1;
    defparam \counter[8]~FF .SR_VALUE = 1'b0;
    defparam \counter[8]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[7]~FF  (.D(n8_10[7]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[7])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[7]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[7]~FF .CE_POLARITY = 1'b1;
    defparam \counter[7]~FF .SR_POLARITY = 1'b0;
    defparam \counter[7]~FF .D_POLARITY = 1'b1;
    defparam \counter[7]~FF .SR_SYNC = 1'b1;
    defparam \counter[7]~FF .SR_VALUE = 1'b0;
    defparam \counter[7]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[6]~FF  (.D(n8_11[6]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[6]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[6]~FF .CE_POLARITY = 1'b1;
    defparam \counter[6]~FF .SR_POLARITY = 1'b0;
    defparam \counter[6]~FF .D_POLARITY = 1'b1;
    defparam \counter[6]~FF .SR_SYNC = 1'b1;
    defparam \counter[6]~FF .SR_VALUE = 1'b0;
    defparam \counter[6]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[5]~FF  (.D(n8_12[5]), .CE(1'b1), .CLK(\clk~O ), .SR(\equal_4/n47 ), 
           .Q(counter[5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[5]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[5]~FF .CE_POLARITY = 1'b1;
    defparam \counter[5]~FF .SR_POLARITY = 1'b0;
    defparam \counter[5]~FF .D_POLARITY = 1'b1;
    defparam \counter[5]~FF .SR_SYNC = 1'b1;
    defparam \counter[5]~FF .SR_VALUE = 1'b0;
    defparam \counter[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[16]~FF  (.D(n8_13[16]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(counter[16])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[16]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[16]~FF .CE_POLARITY = 1'b1;
    defparam \counter[16]~FF .SR_POLARITY = 1'b0;
    defparam \counter[16]~FF .D_POLARITY = 1'b1;
    defparam \counter[16]~FF .SR_SYNC = 1'b1;
    defparam \counter[16]~FF .SR_VALUE = 1'b0;
    defparam \counter[16]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[17]~FF  (.D(n8_14[17]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(counter[17])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[17]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[17]~FF .CE_POLARITY = 1'b1;
    defparam \counter[17]~FF .SR_POLARITY = 1'b0;
    defparam \counter[17]~FF .D_POLARITY = 1'b1;
    defparam \counter[17]~FF .SR_SYNC = 1'b1;
    defparam \counter[17]~FF .SR_VALUE = 1'b0;
    defparam \counter[17]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[18]~FF  (.D(n8_15[18]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(counter[18])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[18]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[18]~FF .CE_POLARITY = 1'b1;
    defparam \counter[18]~FF .SR_POLARITY = 1'b0;
    defparam \counter[18]~FF .D_POLARITY = 1'b1;
    defparam \counter[18]~FF .SR_SYNC = 1'b1;
    defparam \counter[18]~FF .SR_VALUE = 1'b0;
    defparam \counter[18]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[19]~FF  (.D(n8_16[19]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(counter[19])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[19]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[19]~FF .CE_POLARITY = 1'b1;
    defparam \counter[19]~FF .SR_POLARITY = 1'b0;
    defparam \counter[19]~FF .D_POLARITY = 1'b1;
    defparam \counter[19]~FF .SR_SYNC = 1'b1;
    defparam \counter[19]~FF .SR_VALUE = 1'b0;
    defparam \counter[19]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[20]~FF  (.D(n8_17[20]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(counter[20])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[20]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[20]~FF .CE_POLARITY = 1'b1;
    defparam \counter[20]~FF .SR_POLARITY = 1'b0;
    defparam \counter[20]~FF .D_POLARITY = 1'b1;
    defparam \counter[20]~FF .SR_SYNC = 1'b1;
    defparam \counter[20]~FF .SR_VALUE = 1'b0;
    defparam \counter[20]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[21]~FF  (.D(n8_18[21]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(counter[21])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[21]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[21]~FF .CE_POLARITY = 1'b1;
    defparam \counter[21]~FF .SR_POLARITY = 1'b0;
    defparam \counter[21]~FF .D_POLARITY = 1'b1;
    defparam \counter[21]~FF .SR_SYNC = 1'b1;
    defparam \counter[21]~FF .SR_VALUE = 1'b0;
    defparam \counter[21]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[22]~FF  (.D(n8_19[22]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(counter[22])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[22]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[22]~FF .CE_POLARITY = 1'b1;
    defparam \counter[22]~FF .SR_POLARITY = 1'b0;
    defparam \counter[22]~FF .D_POLARITY = 1'b1;
    defparam \counter[22]~FF .SR_SYNC = 1'b1;
    defparam \counter[22]~FF .SR_VALUE = 1'b0;
    defparam \counter[22]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[23]~FF  (.D(n8_20[23]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(counter[23])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[23]~FF .CLK_POLARITY = 1'b1;
    defparam \counter[23]~FF .CE_POLARITY = 1'b1;
    defparam \counter[23]~FF .SR_POLARITY = 1'b0;
    defparam \counter[23]~FF .D_POLARITY = 1'b1;
    defparam \counter[23]~FF .SR_SYNC = 1'b1;
    defparam \counter[23]~FF .SR_VALUE = 1'b0;
    defparam \counter[23]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[1]~FF  (.D(n88_2[1]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[1])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[1]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[1]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[1]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[1]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[1]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[1]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[1]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[2]~FF  (.D(n88_3[2]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[2])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[2]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[2]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[2]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[2]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[2]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[2]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[2]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[3]~FF  (.D(n88_4[3]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[3])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[3]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[3]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[3]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[3]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[3]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[3]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[3]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[4]~FF  (.D(n88_5[4]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[4])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[4]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[4]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[4]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[4]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[4]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[4]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[4]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[5]~FF  (.D(n88_6[5]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[5])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[5]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[5]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[5]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[5]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[5]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[5]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[5]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[6]~FF  (.D(n88_7[6]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[6])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[6]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[6]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[6]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[6]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[6]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[6]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[6]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[7]~FF  (.D(n88_8[7]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[7])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[7]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[7]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[7]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[7]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[7]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[7]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[7]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[8]~FF  (.D(n88_9[8]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[8])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[8]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[8]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[8]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[8]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[8]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[8]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[8]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[9]~FF  (.D(n88_10[9]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[9])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[9]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[9]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[9]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[9]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[9]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[9]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[9]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[10]~FF  (.D(n88_11[10]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[10])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[10]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[10]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[10]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[10]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[10]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[10]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[10]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[11]~FF  (.D(n88_12[11]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[11])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[11]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[11]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[11]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[11]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[11]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[11]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[11]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[12]~FF  (.D(n88_13[12]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[12])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[12]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[12]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[12]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[12]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[12]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[12]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[12]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[13]~FF  (.D(n88_14[13]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[13])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[13]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[13]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[13]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[13]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[13]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[13]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[13]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[14]~FF  (.D(n88_15[14]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[14])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[14]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[14]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[14]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[14]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[14]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[14]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[14]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[15]~FF  (.D(n88_16[15]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[15])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[15]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[15]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[15]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[15]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[15]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[15]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[15]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[16]~FF  (.D(n88_17[16]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[16])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[16]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[16]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[16]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[16]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[16]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[16]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[16]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[17]~FF  (.D(n88_18[17]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[17])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[17]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[17]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[17]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[17]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[17]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[17]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[17]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[18]~FF  (.D(n88_19[18]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[18])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[18]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[18]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[18]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[18]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[18]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[18]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[18]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[19]~FF  (.D(n88_20[19]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[19])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[19]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[19]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[19]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[19]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[19]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[19]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[19]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[20]~FF  (.D(n88_21[20]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[20])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[20]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[20]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[20]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[20]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[20]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[20]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[20]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[21]~FF  (.D(n88_22[21]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[21])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[21]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[21]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[21]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[21]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[21]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[21]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[21]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[22]~FF  (.D(n88_23[22]), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(shift_counter[22])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[22]~FF .CLK_POLARITY = 1'b1;
    defparam \shift_counter[22]~FF .CE_POLARITY = 1'b1;
    defparam \shift_counter[22]~FF .SR_POLARITY = 1'b0;
    defparam \shift_counter[22]~FF .D_POLARITY = 1'b1;
    defparam \shift_counter[22]~FF .SR_SYNC = 1'b1;
    defparam \shift_counter[22]~FF .SR_VALUE = 1'b0;
    defparam \shift_counter[22]~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led1~FF  (.D(\led_shift[0] ), .CE(\equal_12/n45 ), .CLK(\clk~O ), 
           .SR(1'b0), .Q(led1)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \led1~FF .CLK_POLARITY = 1'b1;
    defparam \led1~FF .CE_POLARITY = 1'b0;
    defparam \led1~FF .SR_POLARITY = 1'b1;
    defparam \led1~FF .D_POLARITY = 1'b0;
    defparam \led1~FF .SR_SYNC = 1'b1;
    defparam \led1~FF .SR_VALUE = 1'b0;
    defparam \led1~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led2~FF  (.D(led1), .CE(\equal_12/n45 ), .CLK(\clk~O ), .SR(1'b0), 
           .Q(led2)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \led2~FF .CLK_POLARITY = 1'b1;
    defparam \led2~FF .CE_POLARITY = 1'b0;
    defparam \led2~FF .SR_POLARITY = 1'b1;
    defparam \led2~FF .D_POLARITY = 1'b1;
    defparam \led2~FF .SR_SYNC = 1'b1;
    defparam \led2~FF .SR_VALUE = 1'b0;
    defparam \led2~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led3~FF  (.D(led2), .CE(\equal_12/n45 ), .CLK(\clk~O ), .SR(1'b0), 
           .Q(led3)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \led3~FF .CLK_POLARITY = 1'b1;
    defparam \led3~FF .CE_POLARITY = 1'b0;
    defparam \led3~FF .SR_POLARITY = 1'b1;
    defparam \led3~FF .D_POLARITY = 1'b1;
    defparam \led3~FF .SR_SYNC = 1'b1;
    defparam \led3~FF .SR_VALUE = 1'b0;
    defparam \led3~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led4~FF  (.D(led3), .CE(\equal_12/n45 ), .CLK(\clk~O ), .SR(1'b0), 
           .Q(led4)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \led4~FF .CLK_POLARITY = 1'b1;
    defparam \led4~FF .CE_POLARITY = 1'b0;
    defparam \led4~FF .SR_POLARITY = 1'b1;
    defparam \led4~FF .D_POLARITY = 1'b1;
    defparam \led4~FF .SR_SYNC = 1'b1;
    defparam \led4~FF .SR_VALUE = 1'b0;
    defparam \led4~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led5~FF  (.D(led4), .CE(\equal_12/n45 ), .CLK(\clk~O ), .SR(1'b0), 
           .Q(led5)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \led5~FF .CLK_POLARITY = 1'b1;
    defparam \led5~FF .CE_POLARITY = 1'b0;
    defparam \led5~FF .SR_POLARITY = 1'b1;
    defparam \led5~FF .D_POLARITY = 1'b1;
    defparam \led5~FF .SR_SYNC = 1'b1;
    defparam \led5~FF .SR_VALUE = 1'b0;
    defparam \led5~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led6~FF  (.D(led5), .CE(\equal_12/n45 ), .CLK(\clk~O ), .SR(1'b0), 
           .Q(led6)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \led6~FF .CLK_POLARITY = 1'b1;
    defparam \led6~FF .CE_POLARITY = 1'b0;
    defparam \led6~FF .SR_POLARITY = 1'b1;
    defparam \led6~FF .D_POLARITY = 1'b1;
    defparam \led6~FF .SR_SYNC = 1'b1;
    defparam \led6~FF .SR_VALUE = 1'b0;
    defparam \led6~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \led7~FF  (.D(led6), .CE(\equal_12/n45 ), .CLK(\clk~O ), .SR(1'b0), 
           .Q(led7)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b0, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \led7~FF .CLK_POLARITY = 1'b1;
    defparam \led7~FF .CE_POLARITY = 1'b0;
    defparam \led7~FF .SR_POLARITY = 1'b1;
    defparam \led7~FF .D_POLARITY = 1'b1;
    defparam \led7~FF .SR_SYNC = 1'b1;
    defparam \led7~FF .SR_VALUE = 1'b0;
    defparam \led7~FF .SR_SYNC_PRIORITY = 1'b1;
    EFX_ADD \add_34/i1  (.I0(shift_counter[1]), .I1(shift_counter[0]), .CI(1'b0), 
            .CO(\add_34/n2 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i1 .I0_POLARITY = 1'b1;
    defparam \add_34/i1 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i1  (.I0(shift_counter[1]), .I1(shift_counter[0]), .CI(1'b0), 
            .O(n88_2[1]), .CO(\add_36/n2 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i1 .I0_POLARITY = 1'b1;
    defparam \add_36/i1 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i2  (.I0(shift_counter[2]), .I1(1'b0), .CI(\add_34/n2 ), 
            .CO(\add_34/n4 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i2 .I0_POLARITY = 1'b1;
    defparam \add_34/i2 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i20  (.I0(shift_counter[20]), .I1(1'b0), .CI(\add_36/n38 ), 
            .O(n88_21[20]), .CO(\add_36/n40 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i20 .I0_POLARITY = 1'b1;
    defparam \add_36/i20 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i3  (.I0(shift_counter[3]), .I1(1'b0), .CI(\add_34/n4 ), 
            .CO(\add_34/n6 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i3 .I0_POLARITY = 1'b1;
    defparam \add_34/i3 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i4  (.I0(shift_counter[4]), .I1(1'b0), .CI(\add_34/n6 ), 
            .CO(\add_34/n8 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i4 .I0_POLARITY = 1'b1;
    defparam \add_34/i4 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i5  (.I0(counter[5]), .I1(1'b0), .CI(\add_34/n8 ), 
            .O(n8_12[5]), .CO(\add_34/n10 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i5 .I0_POLARITY = 1'b1;
    defparam \add_34/i5 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i21  (.I0(shift_counter[21]), .I1(1'b0), .CI(\add_36/n40 ), 
            .O(n88_22[21]), .CO(\add_36/n42 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i21 .I0_POLARITY = 1'b1;
    defparam \add_36/i21 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i22  (.I0(shift_counter[22]), .I1(1'b0), .CI(\add_36/n42 ), 
            .O(n88_23[22])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i22 .I0_POLARITY = 1'b1;
    defparam \add_36/i22 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i19  (.I0(shift_counter[19]), .I1(1'b0), .CI(\add_36/n36 ), 
            .O(n88_20[19]), .CO(\add_36/n38 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i19 .I0_POLARITY = 1'b1;
    defparam \add_36/i19 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i18  (.I0(shift_counter[18]), .I1(1'b0), .CI(\add_36/n34 ), 
            .O(n88_19[18]), .CO(\add_36/n36 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i18 .I0_POLARITY = 1'b1;
    defparam \add_36/i18 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i17  (.I0(shift_counter[17]), .I1(1'b0), .CI(\add_36/n32 ), 
            .O(n88_18[17]), .CO(\add_36/n34 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i17 .I0_POLARITY = 1'b1;
    defparam \add_36/i17 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i16  (.I0(shift_counter[16]), .I1(1'b0), .CI(\add_36/n30 ), 
            .O(n88_17[16]), .CO(\add_36/n32 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i16 .I0_POLARITY = 1'b1;
    defparam \add_36/i16 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i15  (.I0(shift_counter[15]), .I1(1'b0), .CI(\add_36/n28 ), 
            .O(n88_16[15]), .CO(\add_36/n30 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i15 .I0_POLARITY = 1'b1;
    defparam \add_36/i15 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i14  (.I0(shift_counter[14]), .I1(1'b0), .CI(\add_36/n26 ), 
            .O(n88_15[14]), .CO(\add_36/n28 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i14 .I0_POLARITY = 1'b1;
    defparam \add_36/i14 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i13  (.I0(shift_counter[13]), .I1(1'b0), .CI(\add_36/n24 ), 
            .O(n88_14[13]), .CO(\add_36/n26 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i13 .I0_POLARITY = 1'b1;
    defparam \add_36/i13 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i12  (.I0(shift_counter[12]), .I1(1'b0), .CI(\add_36/n22 ), 
            .O(n88_13[12]), .CO(\add_36/n24 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i12 .I0_POLARITY = 1'b1;
    defparam \add_36/i12 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i11  (.I0(shift_counter[11]), .I1(1'b0), .CI(\add_36/n20 ), 
            .O(n88_12[11]), .CO(\add_36/n22 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i11 .I0_POLARITY = 1'b1;
    defparam \add_36/i11 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i10  (.I0(shift_counter[10]), .I1(1'b0), .CI(\add_36/n18 ), 
            .O(n88_11[10]), .CO(\add_36/n20 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i10 .I0_POLARITY = 1'b1;
    defparam \add_36/i10 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i9  (.I0(shift_counter[9]), .I1(1'b0), .CI(\add_36/n16 ), 
            .O(n88_10[9]), .CO(\add_36/n18 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i9 .I0_POLARITY = 1'b1;
    defparam \add_36/i9 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i8  (.I0(shift_counter[8]), .I1(1'b0), .CI(\add_36/n14 ), 
            .O(n88_9[8]), .CO(\add_36/n16 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i8 .I0_POLARITY = 1'b1;
    defparam \add_36/i8 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i7  (.I0(shift_counter[7]), .I1(1'b0), .CI(\add_36/n12 ), 
            .O(n88_8[7]), .CO(\add_36/n14 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i7 .I0_POLARITY = 1'b1;
    defparam \add_36/i7 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i6  (.I0(shift_counter[6]), .I1(1'b0), .CI(\add_36/n10 ), 
            .O(n88_7[6]), .CO(\add_36/n12 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i6 .I0_POLARITY = 1'b1;
    defparam \add_36/i6 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i5  (.I0(shift_counter[5]), .I1(1'b0), .CI(\add_36/n8 ), 
            .O(n88_6[5]), .CO(\add_36/n10 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i5 .I0_POLARITY = 1'b1;
    defparam \add_36/i5 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i4  (.I0(shift_counter[4]), .I1(1'b0), .CI(\add_36/n6 ), 
            .O(n88_5[4]), .CO(\add_36/n8 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i4 .I0_POLARITY = 1'b1;
    defparam \add_36/i4 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i3  (.I0(shift_counter[3]), .I1(1'b0), .CI(\add_36/n4 ), 
            .O(n88_4[3]), .CO(\add_36/n6 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i3 .I0_POLARITY = 1'b1;
    defparam \add_36/i3 .I1_POLARITY = 1'b1;
    EFX_ADD \add_36/i2  (.I0(shift_counter[2]), .I1(1'b0), .CI(\add_36/n2 ), 
            .O(n88_3[2]), .CO(\add_36/n4 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(55)
    defparam \add_36/i2 .I0_POLARITY = 1'b1;
    defparam \add_36/i2 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i23  (.I0(counter[23]), .I1(1'b0), .CI(\add_34/n44 ), 
            .O(n8_20[23])) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i23 .I0_POLARITY = 1'b1;
    defparam \add_34/i23 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i22  (.I0(counter[22]), .I1(1'b0), .CI(\add_34/n42 ), 
            .O(n8_19[22]), .CO(\add_34/n44 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i22 .I0_POLARITY = 1'b1;
    defparam \add_34/i22 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i21  (.I0(counter[21]), .I1(1'b0), .CI(\add_34/n40 ), 
            .O(n8_18[21]), .CO(\add_34/n42 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i21 .I0_POLARITY = 1'b1;
    defparam \add_34/i21 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i20  (.I0(counter[20]), .I1(1'b0), .CI(\add_34/n38 ), 
            .O(n8_17[20]), .CO(\add_34/n40 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i20 .I0_POLARITY = 1'b1;
    defparam \add_34/i20 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i19  (.I0(counter[19]), .I1(1'b0), .CI(\add_34/n36 ), 
            .O(n8_16[19]), .CO(\add_34/n38 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i19 .I0_POLARITY = 1'b1;
    defparam \add_34/i19 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i18  (.I0(counter[18]), .I1(1'b0), .CI(\add_34/n34 ), 
            .O(n8_15[18]), .CO(\add_34/n36 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i18 .I0_POLARITY = 1'b1;
    defparam \add_34/i18 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i17  (.I0(counter[17]), .I1(1'b0), .CI(\add_34/n32 ), 
            .O(n8_14[17]), .CO(\add_34/n34 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i17 .I0_POLARITY = 1'b1;
    defparam \add_34/i17 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i16  (.I0(counter[16]), .I1(1'b0), .CI(\add_34/n30 ), 
            .O(n8_13[16]), .CO(\add_34/n32 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i16 .I0_POLARITY = 1'b1;
    defparam \add_34/i16 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i15  (.I0(counter[15]), .I1(1'b0), .CI(\add_34/n28 ), 
            .O(n8_6[15]), .CO(\add_34/n30 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i15 .I0_POLARITY = 1'b1;
    defparam \add_34/i15 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i14  (.I0(counter[14]), .I1(1'b0), .CI(\add_34/n26 ), 
            .O(n8_2[14]), .CO(\add_34/n28 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i14 .I0_POLARITY = 1'b1;
    defparam \add_34/i14 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i13  (.I0(counter[13]), .I1(1'b0), .CI(\add_34/n24 ), 
            .O(n8_3[13]), .CO(\add_34/n26 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i13 .I0_POLARITY = 1'b1;
    defparam \add_34/i13 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i12  (.I0(counter[12]), .I1(1'b0), .CI(\add_34/n22 ), 
            .O(n8_4[12]), .CO(\add_34/n24 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i12 .I0_POLARITY = 1'b1;
    defparam \add_34/i12 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i11  (.I0(counter[11]), .I1(1'b0), .CI(\add_34/n20 ), 
            .O(n8_5[11]), .CO(\add_34/n22 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i11 .I0_POLARITY = 1'b1;
    defparam \add_34/i11 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i10  (.I0(counter[10]), .I1(1'b0), .CI(\add_34/n18 ), 
            .O(n8_7[10]), .CO(\add_34/n20 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i10 .I0_POLARITY = 1'b1;
    defparam \add_34/i10 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i9  (.I0(counter[9]), .I1(1'b0), .CI(\add_34/n16 ), 
            .O(n8_8[9]), .CO(\add_34/n18 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i9 .I0_POLARITY = 1'b1;
    defparam \add_34/i9 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i8  (.I0(counter[8]), .I1(1'b0), .CI(\add_34/n14 ), 
            .O(n8_9[8]), .CO(\add_34/n16 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i8 .I0_POLARITY = 1'b1;
    defparam \add_34/i8 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i7  (.I0(counter[7]), .I1(1'b0), .CI(\add_34/n12 ), 
            .O(n8_10[7]), .CO(\add_34/n14 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i7 .I0_POLARITY = 1'b1;
    defparam \add_34/i7 .I1_POLARITY = 1'b1;
    EFX_ADD \add_34/i6  (.I0(counter[6]), .I1(1'b0), .CI(\add_34/n10 ), 
            .O(n8_11[6]), .CO(\add_34/n12 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_ADD, I0_POLARITY=1'b1, I1_POLARITY=1'b1 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(45)
    defparam \add_34/i6 .I0_POLARITY = 1'b1;
    defparam \add_34/i6 .I1_POLARITY = 1'b1;
    EFX_LUT4 LUT__426 (.I0(n8_14[17]), .I1(n8_15[18]), .I2(n8_16[19]), 
            .I3(n8_17[20]), .O(n156)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8000 */ ;
    defparam LUT__426.LUTMASK = 16'h8000;
    EFX_LUT4 LUT__427 (.I0(n8_2[14]), .I1(n8_10[7]), .I2(n8_12[5]), .I3(n8_13[16]), 
            .O(n157)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0001 */ ;
    defparam LUT__427.LUTMASK = 16'h0001;
    EFX_LUT4 LUT__428 (.I0(n8_19[22]), .I1(n8_18[21]), .I2(n8_20[23]), 
            .O(n158)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4040 */ ;
    defparam LUT__428.LUTMASK = 16'h4040;
    EFX_LUT4 LUT__429 (.I0(n156_q), .I1(n157_q), .I2(n158_q), .O(n159)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h2020 */ ;
    defparam LUT__429.LUTMASK = 16'h2020;
    EFX_LUT4 LUT__430 (.I0(counter[6]), .I1(counter[12]), .I2(counter[11]), 
            .I3(counter[13]), .O(n160)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4000 */ ;
    defparam LUT__430.LUTMASK = 16'h4000;
    EFX_LUT4 LUT__431 (.I0(counter[9]), .I1(counter[8]), .I2(counter[15]), 
            .I3(counter[10]), .O(n161)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1000 */ ;
    defparam LUT__431.LUTMASK = 16'h1000;
    EFX_LUT4 LUT__432 (.I0(n155), .I1(n159), .I2(n160), .I3(n161), .O(\equal_4/n47 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7fff */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(41)
    defparam LUT__432.LUTMASK = 16'h7fff;
    EFX_LUT4 LUT__433 (.I0(n88_11[10]), .I1(n88_10[9]), .I2(n88_9[8]), 
            .I3(n88_15[14]), .O(n162)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h4000 */ ;
    defparam LUT__433.LUTMASK = 16'h4000;
    EFX_LUT4 LUT__434 (.I0(shift_counter[6]), .I1(shift_counter[7]), .I2(n162_q), 
            .O(n163)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1010 */ ;
    defparam LUT__434.LUTMASK = 16'h1010;
    EFX_LUT4 LUT__435 (.I0(n88_21[20]), .I1(n88_22[21]), .I2(n88_20[19]), 
            .I3(n88_23[22]), .O(n164)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1000 */ ;
    defparam LUT__435.LUTMASK = 16'h1000;
    EFX_LUT4 LUT__436 (.I0(n88_16[15]), .I1(n88_17[16]), .I2(n88_18[17]), 
            .I3(n88_19[18]), .O(n165)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h0100 */ ;
    defparam LUT__436.LUTMASK = 16'h0100;
    EFX_LUT4 LUT__437 (.I0(n88_13[12]), .I1(n88_14[13]), .I2(n88_6[5]), 
            .I3(n88_12[11]), .O(n166)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h1000 */ ;
    defparam LUT__437.LUTMASK = 16'h1000;
    EFX_LUT4 LUT__438 (.I0(n164_q), .I1(n165_q), .I2(n166_q), .O(n167)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;
    defparam LUT__438.LUTMASK = 16'h8080;
    EFX_LUT4 LUT__439 (.I0(n155), .I1(n163), .I2(n167), .O(\equal_12/n45 )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h7f7f */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(51)
    defparam LUT__439.LUTMASK = 16'h7f7f;
    EFX_LUT4 LUT__441 (.I0(led_d1), .O(led_d2)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h5555, EFX_ATTRIBUTE_INSTANCE__IS_LUT_SOP_INF_INV=TRUE */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(64)
    defparam LUT__441.LUTMASK = 16'h5555;
    EFX_LUT4 LUT__442 (.I0(\led_shift[0] ), .O(led0)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h5555, EFX_ATTRIBUTE_INSTANCE__IS_LUT_SOP_INF_INV=TRUE */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam LUT__442.LUTMASK = 16'h5555;
    EFX_LUT4 LUT__424 (.I0(n88_3[2]), .I1(n88_4[3]), .I2(n88_5[4]), .O(n154)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_LUT4, LUTMASK=16'h8080 */ ;
    defparam LUT__424.LUTMASK = 16'h8080;
    EFX_GBUFCE CLKBUF__0 (.CE(1'b1), .I(clk), .O(\clk~O )) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_GBUFCE, CE_POLARITY=1'b1 */ ;
    defparam CLKBUF__0.CE_POLARITY = 1'b1;
    EFX_FF \shift_counter[10]~FF_rt_7  (.D(n162), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(n162_q)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0, INIT_VALUE=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[10]~FF_rt_7 .CLK_POLARITY = 1'b1;
    defparam \shift_counter[10]~FF_rt_7 .CE_POLARITY = 1'b1;
    defparam \shift_counter[10]~FF_rt_7 .SR_POLARITY = 1'b0;
    defparam \shift_counter[10]~FF_rt_7 .D_POLARITY = 1'b1;
    defparam \shift_counter[10]~FF_rt_7 .SR_SYNC = 1'b1;
    defparam \shift_counter[10]~FF_rt_7 .SR_VALUE = 1'b0;
    defparam \shift_counter[10]~FF_rt_7 .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[20]~FF_rt_6  (.D(n164), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(n164_q)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0, INIT_VALUE=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[20]~FF_rt_6 .CLK_POLARITY = 1'b1;
    defparam \shift_counter[20]~FF_rt_6 .CE_POLARITY = 1'b1;
    defparam \shift_counter[20]~FF_rt_6 .SR_POLARITY = 1'b0;
    defparam \shift_counter[20]~FF_rt_6 .D_POLARITY = 1'b1;
    defparam \shift_counter[20]~FF_rt_6 .SR_SYNC = 1'b1;
    defparam \shift_counter[20]~FF_rt_6 .SR_VALUE = 1'b0;
    defparam \shift_counter[20]~FF_rt_6 .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[15]~FF_rt_5  (.D(n165), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(n165_q)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0, INIT_VALUE=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[15]~FF_rt_5 .CLK_POLARITY = 1'b1;
    defparam \shift_counter[15]~FF_rt_5 .CE_POLARITY = 1'b1;
    defparam \shift_counter[15]~FF_rt_5 .SR_POLARITY = 1'b0;
    defparam \shift_counter[15]~FF_rt_5 .D_POLARITY = 1'b1;
    defparam \shift_counter[15]~FF_rt_5 .SR_SYNC = 1'b1;
    defparam \shift_counter[15]~FF_rt_5 .SR_VALUE = 1'b0;
    defparam \shift_counter[15]~FF_rt_5 .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[12]~FF_rt_4  (.D(n166), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(n166_q)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0, INIT_VALUE=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[12]~FF_rt_4 .CLK_POLARITY = 1'b1;
    defparam \shift_counter[12]~FF_rt_4 .CE_POLARITY = 1'b1;
    defparam \shift_counter[12]~FF_rt_4 .SR_POLARITY = 1'b0;
    defparam \shift_counter[12]~FF_rt_4 .D_POLARITY = 1'b1;
    defparam \shift_counter[12]~FF_rt_4 .SR_SYNC = 1'b1;
    defparam \shift_counter[12]~FF_rt_4 .SR_VALUE = 1'b0;
    defparam \shift_counter[12]~FF_rt_4 .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \shift_counter[2]~FF_rt_3  (.D(n154), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_12/n45 ), .Q(n154_q)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0, INIT_VALUE=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(57)
    defparam \shift_counter[2]~FF_rt_3 .CLK_POLARITY = 1'b1;
    defparam \shift_counter[2]~FF_rt_3 .CE_POLARITY = 1'b1;
    defparam \shift_counter[2]~FF_rt_3 .SR_POLARITY = 1'b0;
    defparam \shift_counter[2]~FF_rt_3 .D_POLARITY = 1'b1;
    defparam \shift_counter[2]~FF_rt_3 .SR_SYNC = 1'b1;
    defparam \shift_counter[2]~FF_rt_3 .SR_VALUE = 1'b0;
    defparam \shift_counter[2]~FF_rt_3 .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[17]~FF_rt_2  (.D(n156), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(n156_q)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0, INIT_VALUE=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[17]~FF_rt_2 .CLK_POLARITY = 1'b1;
    defparam \counter[17]~FF_rt_2 .CE_POLARITY = 1'b1;
    defparam \counter[17]~FF_rt_2 .SR_POLARITY = 1'b0;
    defparam \counter[17]~FF_rt_2 .D_POLARITY = 1'b1;
    defparam \counter[17]~FF_rt_2 .SR_SYNC = 1'b1;
    defparam \counter[17]~FF_rt_2 .SR_VALUE = 1'b0;
    defparam \counter[17]~FF_rt_2 .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[14]~FF_rt_1  (.D(n157), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(n157_q)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b0, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[14]~FF_rt_1 .CLK_POLARITY = 1'b1;
    defparam \counter[14]~FF_rt_1 .CE_POLARITY = 1'b1;
    defparam \counter[14]~FF_rt_1 .SR_POLARITY = 1'b0;
    defparam \counter[14]~FF_rt_1 .D_POLARITY = 1'b0;
    defparam \counter[14]~FF_rt_1 .SR_SYNC = 1'b1;
    defparam \counter[14]~FF_rt_1 .SR_VALUE = 1'b0;
    defparam \counter[14]~FF_rt_1 .SR_SYNC_PRIORITY = 1'b1;
    EFX_FF \counter[22]~FF_rt_0  (.D(n158), .CE(1'b1), .CLK(\clk~O ), 
           .SR(\equal_4/n47 ), .Q(n158_q)) /* verific EFX_ATTRIBUTE_CELL_NAME=EFX_FF, CLK_POLARITY=1'b1, D_POLARITY=1'b1, CE_POLARITY=1'b1, SR_SYNC=1'b1, SR_SYNC_PRIORITY=1'b1, SR_VALUE=1'b0, SR_POLARITY=1'b0, INIT_VALUE=1'b0 */ ;   // H:\git\Pmod\Sipeed_LED_v1.1\efinix\blink\t8_lchika.v(47)
    defparam \counter[22]~FF_rt_0 .CLK_POLARITY = 1'b1;
    defparam \counter[22]~FF_rt_0 .CE_POLARITY = 1'b1;
    defparam \counter[22]~FF_rt_0 .SR_POLARITY = 1'b0;
    defparam \counter[22]~FF_rt_0 .D_POLARITY = 1'b1;
    defparam \counter[22]~FF_rt_0 .SR_SYNC = 1'b1;
    defparam \counter[22]~FF_rt_0 .SR_VALUE = 1'b0;
    defparam \counter[22]~FF_rt_0 .SR_SYNC_PRIORITY = 1'b1;
    
endmodule

//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_0
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_ff3c3d44_0
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_ff3c3d44_1
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_ff3c3d44_2
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_FF_ff3c3d44_3
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_ADD_ff3c3d44_0
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_1
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_2
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_3
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_4
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_5
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_6
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_7
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_8
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_9
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_10
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_LUT4_ff3c3d44_11
// module not written out since it is a black box. 
//


//
// Verific Verilog Description of module EFX_GBUFCE_ff3c3d44_0
// module not written out since it is a black box. 
//


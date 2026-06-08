module \t8_lchika~chip  (
	input clk,
	output led0,
	output led1,
	output led2,
	output led3,
	output led4,
	output led5,
	output led6,
	output led7,
	output led_d1,
	output led_d2,
	output led_d3,
	output led_d4
);




t8_lchika \t8_lchika~inst (
	.clk ( clk ),
	.led0 ( led0 ),
	.led1 ( led1 ),
	.led2 ( led2 ),
	.led3 ( led3 ),
	.led4 ( led4 ),
	.led5 ( led5 ),
	.led6 ( led6 ),
	.led7 ( led7 ),
	.led_d1 ( led_d1 ),
	.led_d2 ( led_d2 ),
	.led_d3 ( led_d3 ),
	.led_d4 ( led_d4 )
);



endmodule

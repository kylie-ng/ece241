// Part 4: 7-segment decoder module that has the two-bit input c1c0
module lab1 (SW, LEDR, HEX0);
	input [1:0] SW; // toggle switches
	output [9:0] LEDR; // red LEDs
	output [6:0] HEX0; // 7-seg display
	
	wire c1 = SW[1];
	wire c0 = SW[0]; 
	
	assign HEX0[0] = ~c0 | c1;
	assign HEX0[1] = c0;
	assign HEX0[2] = c0;
	assign HEX0[3] = c1;
	assign HEX0[4] = c1;
	assign HEX0[5] = ~c0 | c1;
	assign HEX0[6] = c1;
	
	assign LEDR[1] = c1;
	assign LEDR[0] = c0;
	assign LEDR[9:2] = 0;
endmodule

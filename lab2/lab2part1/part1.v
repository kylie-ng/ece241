module part1 (SW, LEDR, HEX1, HEX0);
	input [7:0] SW;
	output [7:0] LEDR;
	output [6:0] HEX1, HEX0;
	
	digitDisplay u1(SW[3:0], HEX0);
	digitDisplay u2(SW[7:4], HEX1);
	
	assign LEDR[7:0] = SW;
endmodule

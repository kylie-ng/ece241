// Part 1: Simple module that connects the SW switches to the LEDR lights
module lab1 (SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	assign LEDR = SW;
endmodule
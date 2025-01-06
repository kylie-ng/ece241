module part1 (SW, LEDR, HEX1, HEX0);
	input [7:0] SW;
	output [7:0] LEDR;
	output [6:0] HEX1, HEX0;
	
	wire [3:0] x;
	
	// HEX1
	assign x = SW[7:4];
	assign HEX1[0] = ~x[1] & ~x[3];
	assign HEX1[1] = ~x[1] & x[0] & x[2] | x[1] & ~x[0] & x[2];
	assign HEX1[2] = x[1] & ~x[0] & ~x[2];
	assign HEX1[3] = ~x[1] & ~x[3] | x[1];
	assign HEX1[4] = ~x[0] | ~x[1] & ~x[0] & x[2];
	assign HEX1[5] = x[1] & x[0] | x[0] | ~x[3] & x[2] & x[1];
	assign HEX1[6] = ~x[3] & ~x[2] & ~x[1] | x[1] & x[0] & x[2];
		
	// HEX0
	assign x = SW[3:0];
	assign HEX1[0] = ~x[1] & ~x[3];
	assign HEX1[1] = ~x[1] & x[0] & x[2] | x[1] & ~x[0] & x[2];
	assign HEX1[2] = x[1] & ~x[0] & ~x[2];
	assign HEX1[3] = ~x[1] & ~x[3] | x[1];
	assign HEX1[4] = ~x[0] | ~x[1] & ~x[0] & x[2];
	assign HEX1[5] = x[1] & x[0] | x[0] | ~x[3] & x[2] & x[1];
	assign HEX1[6] = ~x[3] & ~x[2] & ~x[1] | x[1] & x[0] & x[2];
	
	assign LEDR[7:0] = SW;
endmodule

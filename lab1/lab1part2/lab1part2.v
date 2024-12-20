// Part 2: SOP circuit that implements a 2-to-1 multiplexer with a select input s
module lab1 (SW, LEDR);
	input [9:0] SW; 
	output [9:0] LEDR;
	
	wire [3:0] X = SW[3:0];
	wire [3:0] Y = SW[7:4];
	wire s = SW[9]; // Selector switch is switch #9

	wire [3:0] M;
	assign M[0] = (~s & X[0]) | (s & Y[0]);
	assign M[1] = (~s & X[1]) | (s & Y[1]);
	assign M[2] = (~s & X[2]) | (s & Y[2]);
	assign M[3] = (~s & X[3]) | (s & Y[3]);
	
	assign LEDR = M;
endmodule
// Part 3: SOP circuit that implements a 3-to-1 multiplexer with a select input s0 s1
module lab1 (SW, LEDR); 
	input [9:0] SW;
	output [9:0] LEDR;
	
	// Assigning wires
	wire [1:0] s1 = SW[9];
	wire [1:0] s0 = SW[8];
	wire [1:0] U = SW[5:4];
	wire [1:0] V = SW[3:2];
	wire [1:0] W = SW[1:0];
	
    // Output M
	wire [1:0] M;
	assign M[1:0] = (~s1 & ~s0 & U[1:0]) | (~s1 & s0 & V[1:0]) | (s1 & ~s0 & W[1:0]) | (s1 & s0 & W[1:0]);
	
	assign LEDR[1:0] = M;
endmodule
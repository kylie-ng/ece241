module part2 (SW, KEY, HEX3, HEX2, HEX1, HEX0);
	input [1:0] SW; // Enable and Clear
	input [0:0]KEY; // Clock input
	output [6:0] HEX1, HEX0, HEX3, HEX2; // 7-seg displays
	
	wire enable, clear; // clear is equivalent to saying resetn
	assign enable = SW[1];
	assign clear = SW[0];
	
	wire [15:0] Q;
	
	// TFF instantiated eight times to create the counter
	TFlipFlop u0 (enable, KEY[0], clear, Q); // Always toggle the first FF

	// HEX0 nibble (lower 4 bits)
	eachhex v0 (Q[3:0], HEX0);
	eachhex v1 (Q[7:4], HEX1);
	eachhex v2 (Q[11:8], HEX2);
	eachhex v3 (Q[15:12], HEX3);

endmodule

module TFlipFlop (T, clk, clr, Q);
	input T;
	input clk, clr;
	output reg [15:0] Q;
	
	always @ (posedge clk)
		if (clr==0)//if clr == 0, it will clear it (!clr == 1)
			Q <= 16'b0;
		else if (T==1)
			Q <= Q + 1'b1; // toggles
endmodule

module eachhex(X, HEX);

	input [3:0]X;
	output [6:0]HEX;
	
	assign HEX[0] = (~X[3] & X[2] & ~X[1] & ~X[0]) | (~X[3] & ~X[2] & ~X[1] & X[0])	
	| (X[3] & X[2] & ~X[1] & X[0]) | (X[3] & ~X[2] & X[1] & X[0]); 
	
	assign HEX[1] = (X[3] & X[2] & ~X[1] & ~X[0]) | (~X[3] & X[2] & ~X[1] & X[0]) | 
	(X[3] & X[1] & X[0]) | (X[2] & X[1] & ~X[0]);
	
	assign HEX[2] = (X[3] & X[2] & ~X[1] & ~X[0]) | (~X[3] & ~X[2] & X[1] & ~X[0]) |
	(X[3] & X[2] & X[1]);
	
	assign HEX[3] = (X[2] & X[1] & X[0]) | (~X[2] & ~X[1] & X[0]) | 
	(~X[3] & X[2] & ~X[1] & ~X[0]) | (X[3] & ~X[2] & X[1] & ~X[0]);
	
	assign HEX[4] = (~X[3] & X[0]) | (~X[3] & X[2] & ~X[1]) |
	(X[3] & ~X[2] & ~X[1] & X[0]);
	
	assign HEX[5] = (~X[3] & ~X[2] & X[0]) | (~X[3] & X[1] & X[0]) | 
	(~X[3] & ~X[2] & X[1]) | (X[3] & X[2] & ~X[1] & X[0]);
	
	
	assign HEX[6] = (~X[3] & ~X[2] & ~X[1]) | (X[3] & X[2] & ~X[1] & ~X[0]) |
	(~X[3] & X[2] & X[1] & X[0]); 
	
endmodule
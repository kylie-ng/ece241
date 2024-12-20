module part1 (SW, KEY, HEX1, HEX0);
	input [1:0] SW; // Enable and Clear
	input [0:0] KEY; // Clock input
	output [6:0] HEX1, HEX0; // 7-seg displays
	
	wire enable, clear; // clear is equivalent to saying resetn
	assign enable = SW[1];
	assign clear = SW[0];
	
	wire [7:0] Q;
	
	// TFF instantiated eight times to create the counter
	TFlipFlop u0 (enable, KEY, clear, Q[0]); // Always toggle the first FF
	TFlipFlop u1 (Q[0] & enable, KEY, clear, Q[1]);
	TFlipFlop u2 (Q[1] & Q[0] & enable, KEY, clear, Q[2]);
	TFlipFlop u3 (Q[2] & Q[1] & Q[0] & enable, KEY, clear, Q[3]);
	TFlipFlop u4 (Q[3] & Q[2] & Q[1] & Q[0] & enable, KEY, clear, Q[4]);
	TFlipFlop u5 (Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & enable, KEY, clear, Q[5]);
	TFlipFlop u6 (Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & enable, KEY, clear, Q[6]);
	TFlipFlop u7 (Q[6] & Q[5] & Q[4] & Q[3] & Q[2] & Q[1] & Q[0] & enable, KEY, clear, Q[7]);
	
	// HEX0 nibble (lower 4 bits)
	eachhex v0 (Q[3:0], HEX0);
	
	// HEX1 nibble (upper 4 bits)
	eachhex v1 (Q[7:4], HEX1);

endmodule

module TFlipFlop (T, clk, clr, Q);
	input [7:0] T;
	input clk, clr;
	output reg [7:0] Q;
	
	always @ (posedge clk)
		if (!clr)//if clr == 0, it will clear it (!clr == 1)
			Q <= 8'b0;
		else if (T)
			Q <= ~Q; // toggles
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




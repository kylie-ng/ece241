module part4 (KEY, CLOCK_50, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

	input [0:0] KEY; 
	input CLOCK_50;
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	
	wire [2:0]cycle;
	wire [25:0] Qc;
	wire enable, clr;
	wire [1:0] out1, out2, out3, out4, out5, out6;
	wire [1:0] b,d,e,l;
	
	assign clr = KEY[0];
	assign d[1] = 0; 
	assign d[0] = 0;
	assign e[1] = 0;
	assign e[0] = 1;
	assign l[1] = 1;
	assign l[0] = 0;
	assign b[1] = 1;
	assign b[0] = 1;
	
	TflipflopCLOCK  f1 (CLOCK_50, clr, Qc, enable); 
	TflipflopCOUNT f2 (enable, CLOCK_50, clr, cycle); 
	mux n1 (cycle, b, b, b, d, e, l, out1);
	mux n2 (cycle, b, b, d, e, l, b, out2);
	mux n3 (cycle, b, d, e, l, b, b, out3);
	mux n4 (cycle, d, e, l, b, b, b, out4);
	mux n5 (cycle, e, l, b, b, b, d, out5);
	mux n6 (cycle, l, b, b, b, d, e, out6);
	
	display u1 (out1, HEX5);
	display u2 (out2, HEX4);
	display u3 (out3, HEX3);
	display u4 (out4, HEX2);
	display u5 (out5, HEX1);
	display u6 (out6, HEX0);

	
endmodule 



module TflipflopCLOCK (CLOCK_50, clr, Q, A);
	input CLOCK_50, clr;
	output reg [25:0] Q;
	output reg A; 
	
	always @ (posedge CLOCK_50)
		if (clr==0)//if clr == 0, it will clear it (!clr == 1)
			Q <= 26'b0;
		else if (Q == 26'd50000000)
		begin
			A <= 1'b1; 
			Q <= 26'b0;
		end
		else
		begin
			A <= 1'b0;
			Q <= Q + 1'b1; // toggles
		end
			
endmodule


module TflipflopCOUNT (T, clk, clr, Q);
	input T, clk, clr;
	output reg [2:0] Q;
	
	always @ (posedge clk)
		if (clr==0)//if clr == 0, it will clear it (!clr == 1)
			Q <= 3'b0;
		else if (Q == 3'd6)
			Q <= 3'b0;
		else if (T==1)
			Q <= Q + 1'b1; // toggles
			
endmodule

module mux (S, A, B, C, D, E, F, out);

	input [2:0]S;
	input [1:0] A, B, C, D, E, F;
	output [1:0] out;
	
	assign out[0] = (~S[2] & ~S[1] & ~S[0] & A[0]) | (~S[2] & ~S[1] & S[0] & B[0]) | (~S[2] & S[1] & ~S[0] & C[0]) | (~S[2] & S[1] & S[0] & D[0]) |
		(S[2] & ~S[1] & ~S[0] & E[0]) | (S[2] & ~S[1] & S[0] & F[0]);
	assign out[1] = (~S[2] & ~S[1] & ~S[0] & A[1]) | (~S[2] & ~S[1] & S[0] & B[1]) | (~S[2] & S[1] & ~S[0] & C[1]) | (~S[2] & S[1] & S[0] & D[1]) |
		(S[2] & ~S[1] & ~S[0] & E[1]) | (S[2] & ~S[1] & S[0] & F[1]);
	
	
endmodule

module display (x, HEX);
	input [1:0] x;
	output [6:0]HEX;
	
	assign HEX[0] = x[1] & x[0] | x[1] & ~x[0] | ~x[1] & ~x[0];
	assign HEX[1] = x[0]; 
	assign HEX[2] = x[0]; 
	assign HEX[3] = x[1]; 
	assign HEX[4] = x[1]; 
	assign HEX[5] = x[1] & x[0] | x[1] & ~x[0] | ~x[1] & ~x[0];
	assign HEX[6] = x[1]; 
	
endmodule
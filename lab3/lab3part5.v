module part5 (SW, KEY, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, LEDR);

	input [7:0] SW;
	input [1:0] KEY;
	output [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	output [9:0] LEDR;

	wire D, Clk, Resetn;
	wire Cout; 
	wire [7:0] A, B, C, S; //S = A plus B
	
	assign Resetn = KEY[0];
	assign Clk = KEY[1]; 
	
	assign B = SW[7:0]; 
	R8 t1(SW[7:0],Clk,Resetn,A);

	
	FA input1(A[0],B[0],C[0],S[0],C[1]);
	FA input2(A[1],B[1],C[1],S[1],C[2]);
	FA input3(A[2],B[2],C[2],S[2],C[3]);
	FA input4(A[3],B[3],C[3],S[3],C[4]); 
	FA input5(A[4],B[4],C[4],S[4],C[5]); 
	FA input6(A[5],B[5],C[5],S[5],C[6]); 
	FA input7(A[6],B[6],C[6],S[6],C[7]); 
	FA input8(A[7],B[7],C[7],S[7],Cout); 
	
	eachhex A1(A[7:4], HEX3);
	eachhex A2(A[3:0], HEX2);
	eachhex B1(B[7:4], HEX1);
	eachhex B2(B[3:0], HEX0);
	eachhex S1(S[7:4], HEX5);
	eachhex S2(S[3:0], HEX4);
	
	assign LEDR[0] = Cout;
	assign LEDR[9:1] = 9'b0; 
    		
endmodule


module R8(D,Clk,Resetn,Q);

	input [7:0]D;
	input Clk, Resetn;
	output reg [7:0] Q;
	
	always @ (negedge Resetn, posedge Clk)
		if (!Resetn)
			Q <= 8'b0;
			
		else 
			Q <= D;

endmodule 

module FA (a,b,Cin,S,Cout);
	input [3:0]a,b,Cin;
	output S, Cout;
	
	assign S = a^b^Cin;
	assign Cout = (a & b) | (a & Cin) | (b & Cin);
	
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
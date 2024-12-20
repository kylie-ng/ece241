module part3 (KEY, CLOCK_50, HEX0);
	input [0:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0; 
	
	wire clr;
	
	assign clr = KEY[0];
	
	wire [25:0]Qc; 
	wire [3:0]Q;
	wire enable; 
	
	TflipflopCLOCK  u1 (CLOCK_50, clr, Qc, enable); 
	TflipflopCOUNT u2 (enable, CLOCK_50, clr, Q); 
	eachhex u3 (Q, HEX0); 
	

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
	output reg [3:0] Q;
	
	always @ (posedge clk)
		if (clr==0)//if clr == 0, it will clear it (!clr == 1)
			Q <= 4'b0;
		else if (Q == 4'b1010)
			Q <= 4'b0;
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
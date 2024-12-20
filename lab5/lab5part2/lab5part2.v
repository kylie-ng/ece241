module part2 (SW, KEY, LEDR);
	
	input [1:0] SW;
	input [0:0] KEY;
	output [9:0] LEDR;
	
	wire clk, reset, w, z;
	assign reset = SW[0];
	assign w = SW[1];
	assign clk = KEY[0]; 
	
	reg [3:0] y, Y;
	parameter A = 4'b0000;
	parameter B = 4'b0001;
	parameter C = 4'b0010;
	parameter D = 4'b0011;
	parameter E = 4'b0100;
	parameter F = 4'b0101;
	parameter G = 4'b0110;
	parameter H = 4'b0111;
	parameter I = 4'b1000;
	
	always @ (w,y) 
	begin: state_table
		case (y)
			A: if (w) Y = F;
				else Y = B; 
			B: if (w) Y = F;
				else Y = C; 
			C: if (w) Y = F;
				else Y = D; 
			D: if (w) Y = F;
				else Y = E; 
			E: if (w) Y = F;
				else Y = E; 
			F: if (w) Y = G;
				else Y = B;
			G: if (w) Y = H;
				else Y = B; 
			H: if (w) Y = I;
				else Y = B;
			I: if (w) Y = I;
				else Y = B; 
			default: Y = 4'bxxxx;
		endcase
	end
	
	always @ (posedge clk) 
	begin: state_FFs 
		if (!reset)
			y <= A;
		else 
			y <= Y; 
	
	end 

	assign z = (y == I) | (y == E); 
	
	assign LEDR[3:0] = y;
	assign LEDR[4] = z;
	assign LEDR[9:5] = 1'b0;
	
endmodule
module part1 (SW, KEY, LEDR);
	input [1:0] SW;
	input [0:0] KEY;
	output [9:0] LEDR;
	
	wire [8:0]y,Y; //Y = output, y = input
	wire w,z,reset,clk;
	
	assign w = SW[1];
	assign clk = KEY[0];
	assign reset = SW[0];
	
	assign Y[0] = ~reset; 
	assign Y[1] = reset & ~w & (y[0] | y[5] | y[6] | y[7] | y[8]);
	assign Y[2] = reset & ~w & y[1];
	assign Y[3] = reset & ~w & y[2];
	assign Y[4] = reset & ~w & (y[3] | y[4]);
	assign Y[5] = reset & w & (y[0] | y[1] | y[2] | y[3] | y[4]);
	assign Y[6] = reset & w & y[5];
	assign Y[7] = reset & w & y[6];
	assign Y[8] = reset & w & (y[7] | y[8]);
	
	assign z = y[4] | y[8];
	
	DFlF p1 (y[0], clk, Y[0]);
	DFlF p2 (y[1], clk, Y[1]);
	DFlF p3 (y[2], clk, Y[2]);
	DFlF p4 (y[3], clk, Y[3]);
	DFlF p5 (y[4], clk, Y[4]);
	DFlF p6 (y[5], clk, Y[5]);
	DFlF p7 (y[6], clk, Y[6]);
	DFlF p8 (y[7], clk, Y[7]);
	DFlF p9 (y[8], clk, Y[8]);
	
	assign LEDR[8:0] = y;
	assign LEDR[9] = z; 
	
endmodule

module DFlF (Q, Clk, D);

	input D, Clk;
	output reg Q;

	always @ (posedge Clk)
		Q <= D;

endmodule
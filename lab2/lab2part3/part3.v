module part3(SW[8:0], LEDR[9:0]);
	input[8:0] SW;
	output[9:0] LEDR;
	
	wire[3:0] A, B, S;
	wire Cin, Cout;
	
	assign A = SW[7:4];
	assign B = SW[3:0];
	assign Cin = SW[8];
	assign Cout = LEDR[4]; 
	assign S = LEDR[3:0];
	
	// call function 4 times
	
	
endmodule

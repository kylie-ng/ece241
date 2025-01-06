module part2 (SW[3:0], HEX0, HEX1);
	input[3:0] SW; 
	output[6:0] HEX1, HEX0;
	
	// Comparator
	wire z, s0, s1, s2, s3;

	assign s0 = SW[0]; 
	assign s1 = SW[1];
	assign s2 = SW[2];
	assign s3 = SW[3];
	
	assign z = s3 & s2 | s3 & ~s2 & s1;
	
	// Block above - Ten's digit display
	assign HEX1[0] = z;
	assign HEX1[1] = 1'b0;
	assign HEX1[2] = 1'b0;
	assign HEX1[3] = z;
	assign HEX1[4] = z;
	assign HEX1[5] = z;
	assign HEX1[6] = 1'b1;
	
	// Circuit A
	wire[3:0] A;
	
	assign A[3] = 1'b0;
	assign A[2] = s3 & s2 & s1;
	assign A[1] = s3 & s2 & ~s1;
	assign A[0] = s3 & s0;
	
	// 2 to 1 4 bit Multiplexer
	wire[3:0] f;
	assign f = SW & {~z, ~z, ~z, ~z} | {z, z, z, z} & A; // z is 1 bit while everything else 4 bit, so do "bit concatination"
	
	digitDisplay(f, HEX0);
	
endmodule

	
	
	

module digitDisplay(S, M);

	input [3:0] S;
	output [6:0] M;

	wire s3, s2, s1, s0;

	assign s3 = S[3];
	assign s2 = S[2];
	assign s1 = S[1];
	assign s0 = S[0];

	assign M[0] = ~s3 & ~s2 & ~s1 & s0 | s1 & ~s0 & s2 | ~s1 & ~s0 & s2;
	assign M[1] = ~s1 & s0 & s2 | s1 & ~s0 & s2;
	assign M[2] = s1 & ~s0 & ~s2;
	assign M[3] = ~s1 & ~s0 & s2 | s1 & s0 & s2 | ~s1 & s0 & ~s2;
	assign M[4] = s0 | ~s1 & ~s0 & s2;
	assign M[5] = s1 & s0 | ~s3 & ~s2 & s0 | ~s3 & ~s2 & s1;
	assign M[6] = ~s3 & ~s2 & ~s1 | s1 & s0 & s2;
endmodule

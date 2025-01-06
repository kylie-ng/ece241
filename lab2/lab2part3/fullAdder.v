module fullAdder(a, b, Cin, S, Cout);
	input a, b, Cin;
	output S, Cout;
		
	assign S = a ^ b ^ Cin; // exclusive OR
	assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

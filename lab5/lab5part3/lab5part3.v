module part3 (SW, CLOCK_50, KEY, LEDR);
	input CLOCK_50;
	input [2:0] SW;
	input [1:0] KEY;
	output [9:0] LEDR;
	
	wire [24:0] cycle; //clock cycle count 
	wire half_sec_enable, go, Resetn, z, b0, L, light, enable;
	wire [2:0] S; //choosing which letter
	wire [3:0] A,B,C,D,E,F,G,H,Letter, Q1;
	wire [2:0] lenA,lenB,lenC,lenD,lenE,lenF,lenG,lenH,Length,count;
	reg [2:0] y_Q,state;
	
	assign S = SW;
	assign go = KEY[1];
	assign Resetn = KEY[0];
	
	//holding the Letters
	//dot = 0, dash = 1
	assign A = 4'b0100;//ignore last 2
	assign B = 4'b1000;
	assign C = 4'b1010;
	assign D = 4'b1000;//ignore last 
	assign E = 4'b0000; //ignore last 3
	assign F = 4'b0010;
	assign G = 4'b1100;//ignore last
	assign H = 4'b0000; 
	
	//holding the lengths 
	assign lenA = 3'b010;
	assign lenB = 3'b100;
	assign lenC = 3'b100;
	assign lenD = 3'b011;
	assign lenE = 3'b001;
	assign lenF = 3'b100;
	assign lenG = 3'b011;
	assign lenH = 3'b100;
	
	//holding states 
	parameter SA = 3'b000, SB = 3'b001, Dot = 3'b010, D1 = 3'b011, D2 = 3'b100, D3 = 3'b101, pause = 3'b110;
	
	//CHANGED FOR MODELSIM
	TflipflopCLOCK u1 (CLOCK_50, Resetn, cycle, half_sec_enable);
	
	mux_4bit m1 (S, A, B, C, D, E, F, G, H, Letter);
	mux_3bit m2 (S, lenA, lenB, lenC, lenD, lenE, lenF, lenG, lenH, Length);
	
	
	//FSM 
	always @(*)
	begin: state_table 
		case(y_Q)
			SA: if (!go) state = SB; 
				 else state = SA;
				 
			SB: if (half_sec_enable & !b0) state = Dot; 
				 else if (half_sec_enable & b0) state = D1; 
				 else state = SB;
				 
			Dot: if (half_sec_enable) state = pause;
				  else state = Dot;
				  
			D1: if (half_sec_enable) state = D2;
				 else state = D1;
				 
			D2: if (half_sec_enable) state = D3;
				 else state = D2;
				 
			D3: if (half_sec_enable) state = pause; 
				 else state = D3;
				 
			pause: if (!z & !b0 & half_sec_enable) state = Dot;
					 else if (!z & b0 & half_sec_enable) state = D1;
					 else if (z & half_sec_enable) state = SA; 
					 else state = pause;		
			default: state = 3'bxxx;	 
		endcase
	end 
	
	//update present state 
	always @ (posedge CLOCK_50) 
	begin: state_FFs 
		if (!Resetn) 
			y_Q <= SA;
		else 
			y_Q <= state;
	end 
			
	//outputs for the FSM
	assign L = (y_Q == SB); 
	assign enable = (y_Q == Dot) | (y_Q == D3) ;
	assign light = (y_Q == Dot) | (y_Q == D1) | (y_Q == D2) | (y_Q == D3); 

	assign z = ~count[2] & ~count[1] & ~count[0]; //z=1 when count=000
	assign b0 = ( (y_Q == SB) & Letter[3] ) | ( (y_Q == pause) & Q1[3] ); 
	
	Shiftreg s1 (L, enable, half_sec_enable, Letter, Q1); //go = L
	downcounter d1 (L, enable, half_sec_enable, Length, count);
	
	assign LEDR[0] = light;	
	assign LEDR[9:1] = 1'b0;
	
	
endmodule 

module Shiftreg (L,E,clk,letter,Q);
	input [3:0] letter;
	input L, E, clk;
	output reg [3:0] Q;
	
	always @ (posedge clk) 
		if (L) //load the register with the letter choosen 
			Q <= letter;
		else if (E) //shift only when in pause state
		begin 
			Q[0] <= 1'b0; //assign to anything at the end
			Q[1] <= Q[0]; 
			Q[2] <= Q[1];
			Q[3] <= Q[2];
		end 	
 
endmodule 

module downcounter (L,E,clk,length,Q);
	input L,E,clk;
	input [2:0] length;
	output reg [2:0] Q; 
	
	always @ (posedge clk)
	begin 
		if (L == 1'b1) //if go is pressed, length is loaded 
			Q <= length;
		else if (E == 1'b1) //if in state pause, count down 
			Q <= Q - 1'b1; 
	end 
	
endmodule 


module TflipflopCLOCK (CLOCK_50, clr, Q, A);
	input CLOCK_50, clr;
	output reg [24:0] Q;
	output reg A; //A is the half_sec_enable
	
	always @ (posedge CLOCK_50)
		if (clr==0)//if clr == 0, it will clear it (!clr == 1)
			Q <= 25'b0;
		else if (Q == 25'd250000000) //"when you hit posedge" of a half sec
		begin
			A <= 1'b1; 
			Q <= 25'b0;
		end
		else
		begin
			A <= 1'b0;
			Q <= Q + 1'b1; // toggles
		end
			
endmodule

module mux_4bit (s,A,B,C,D,E,F,G,H,Out);
	input [2:0] s;
	input [3:0] A,B,C,D,E,F,G,H;
	output reg [3:0] Out;
	
	always @ (*)
	begin 
		case(s)
			3'b000: Out = A;
			3'b001: Out = B;
			3'b010: Out = C;
			3'b011: Out = D; 
			3'b100: Out = E; 
			3'b101: Out = F;
			3'b110: Out = G;
			3'b111: Out = H; 
		endcase
	end

endmodule 

module mux_3bit (s,A,B,C,D,E,F,G,H,Out);
	input [2:0] s;
	input [2:0] A,B,C,D,E,F,G,H;
	output reg [2:0] Out;
	
	always @ (*)
	begin 
		case(s)
			3'b000: Out = A;
			3'b001: Out = B;
			3'b010: Out = C;
			3'b011: Out = D; 
			3'b100: Out = E; 
			3'b101: Out = F;
			3'b110: Out = G;
			3'b111: Out = H; 
		endcase
	end 
	
endmodule
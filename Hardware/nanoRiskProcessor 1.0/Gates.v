//Modulo de Controle de fluxo:
//Entradas: 	
//		branch: sinal de controle de branch
//		jump: sinal de controle de jump
//Saidas:	
//		out: saida
module nR_FluxCtrl(branch,jump,out);
	input branch,jump;
	output out;
	assign out = branch | jump;
endmodule


//Modulo de NOT:
//Entradas: 	
//		in: entrada
//Saidas:	
//		out: saida
module nR_NOT(in,out);
	input in;
	output out;
	assign out = ~in;
endmodule


//Modulo de AND2:
//Entradas: 	
//		in0: entrada 0
//		in1: entrada 1
//Saidas:	
//		out: saida
module nR_AND2(in0,in1,out);
	input in0,in1;
	output out;
	assign out = in0&in1;
endmodule


//Modulo de 8AND2:
//Entradas: 	
//		in0: entrada 0
//		in1: entrada 1
//Saidas:	
//		out: saida
module nR_8AND2(in0,in1,out);
	input[7:0] in0;
	input in1;
	output reg[7:0] out;
	always@(*)
	 if(in1)
	   out<=in0;
	 else
	   out<=0;
endmodule

//Modulo de AND4:
//Entradas: 	
//		in0: entrada 0
//		in1: entrada 1
//		in2: entrada 2
//		in3: entrada 3
//Saidas:	
//		out: saida
module nR_AND4(in0,in1,in2,in3,out);
	input in0,in1,in2,in3;
	output out;
	assign out = in0&in1&in2&in3;
endmodule

//Modulo de OR4:
//Entradas: 	
//		in0: entrada 0
//		in1: entrada 1
//		in2: entrada 2
//		in3: entrada 3
//Saidas:	
//		out: saida
module nR_OR4(in0,in1,in2,in3,out);
	input in0,in1,in2,in3;
	output out;
	assign out = in0|in1|in2|in3;
endmodule

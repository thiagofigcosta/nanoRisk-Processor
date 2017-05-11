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
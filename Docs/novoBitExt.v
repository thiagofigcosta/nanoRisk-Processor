//Modulo de Extensor de Bit:
//Entradas: 	
//		in: entrada
//Saidas:	
//		out: saida
module nR_BitExt(in,out);
	input[3:0] in;
	output[7:0] out;
	assign out = {4'b0000,in};
endmodule

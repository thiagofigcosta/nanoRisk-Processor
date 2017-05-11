//Modulo de Multiplexacao:
//Entradas: 	
//		in0: entrada 0
//		in1: entrada 1
//		sel: selecao
//Saidas:	
//		out: saida
module nR_MUX2(in0,in1,sel,m_out);
	input[7:0] in0,in1;
	input sel;
	output [7:0] m_out;

	assign m_out = (in0&~sel) | (in1&sel);
endmodule

//Modulo de Multiplexacao:
//Entradas: 	
//		in0: entrada 0
//		in1: entrada 1
//		in2: entrada 2
//		in3: entrada 3
//		sel: selecao
//Saidas:	
//		out: saida
module nR_MUX4(in0,in1,in2,in3,sel,out);
	input[7:0] in0,in1,in2,in3;
	input[1:0] sel;
	output reg[7:0] out;
	always@(*)
	case(sel)
		0: out<=in0;
		1: out<=in1;
		2: out<=in2;
		3: out<=in3;
	endcase
endmodule


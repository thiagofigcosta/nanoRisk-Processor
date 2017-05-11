//Modulo dos registrador de deslocamento:
//Entradas: 	
//		clk: clock
//		set: define o valor inicial caso seja 1
//Saidas:	
//		out0: primeiro bit
//		out1: segundo bit
module nR_BitShifter(clk,s_out0,s_out1,set);
	input clk,set;
	output reg s_out0,s_out1;

	initial 
	begin 
		s_out0<=1;
		s_out1<=0;
	end
	
	always @ (posedge clk | set) begin
		if(~set) begin
			s_out0<=s_out1;
			s_out1<=s_out0;
		end
	end
	always @ (set) begin
		s_out0<=1;
		s_out1<=0;
	end
endmodule

//Modulo dos registradores: ghost0,ghost1,next
//Entradas: 	
//		clk: clock(escrita apenas em borda de subida)
//		clr: limpa a memoria caso seja 1
//		in0: valor a ser gravado
//Saidas:	
//		out: valor registrado
module nR_Register(clk,in0,r_out0,clr);
	input clk,clr;
	input[7:0] in0;
	output reg[7:0] r_out0;
	
	initial 
	begin 
		r_out0<=8'b00000000;
	end

	always @ (posedge clk) begin
		if(~clr)
			r_out0<=in0;
	end

	always @ (clr) begin
		r_out0<=0;
	end
endmodule

//Modulo memory: dataMem, instrMem
//Entradas: 	
//		clk: clock(escrita=borda de subida,leitura=borda de descida)
//		clr: limpa a memoria caso seja 1
//		adrIn0: endereco onde deve gravar um valor
//		in0: valor a ser gravado
//		adrOut0: endereco de leitura do valor 0
//		canWrt: habilita escrita
//		canRd: habilita leitura

//Saidas:	
//		out0: valor lido em 0
module nR_Memory(clk,in0,m_out0,adrIn0,adrOut0,canWrt,canRd,clr);
	input clk,clr,canWrt,canRd;
	input[7:0] in0;
	input[3:0]adrIn0,adrOut0;
	output reg[7:0] m_out0;

	reg [7:0]m_mem[255:0];

	integer m_i;
	
	initial 
	begin 
			m_out0<=0;
	end

	always @ ( posedge clk & canWrt ) begin
		if(~clr)
			m_mem[adrIn0]<=in0;
	end

	always @ (clr) begin
		for (m_i=0;m_i<256;m_i=m_i+1)
			m_mem[m_i]<=0;
		m_out0<=0;
	end

	always @ (negedge clk & canRd) begin
		m_out0<=m_mem[adrOut0];
	end
endmodule

//Modulo registradores: dataMem, instrMem
//Entradas: 	
//		clk: clock(escrita=borda de subida,leitura=borda de descida)
//		clr: limpa a memoria caso seja 1
//		adrIn0: endereco onde deve gravar um valor
//		in0: valor a ser gravado
//		adrOut0: endereco de leitura do valor 0
//		adrOut1: endereco de leitura do valor 1
//		adrOut2: endereco de leitura do valor 1
//		canWrt: habilita escrita
//		canRd: habilita leitura
//      ovrflw: define overflow positivo ou negativo

//Saidas:	
//		out0: valor lido em 0
//		out1: valor lido em 1
//		out2: valor lido em 2
module nR_RegisterBank(clk,in0,rb_out0,rb_out1,rb_out2,adrIn0,adrOut0,adrOut1,adrOut2,canWrt,canRd,clr,ovrflw);
	input clk,clr,canWrt,canRd;
	input[1:0] ovrflw;
	input[7:0] in0;
	input[3:0] adrIn0,adrOut0,adrOut1,adrOut2;
	output reg[7:0] rb_out0,rb_out1,rb_out2;

	reg[7:0]rb_mem[15:0];
	
	integer rb_i;
	
	initial 
	begin 
		for (rb_i=0;rb_i<16;rb_i=rb_i+1) begin
				rb_mem[rb_i]<=0;
			end
		rb_out0<=0;
		rb_out1<=0;
		rb_out2<=0;
	end

	always @ (posedge clk & canWrt) begin
		if(~clr)
			rb_mem[adrIn0]<=in0;
	end

	always @ (negedge clk & canRd) begin
		rb_out0<=rb_mem[adrOut0];
		rb_out1<=rb_mem[adrOut1];
		rb_out2<=rb_mem[adrOut2];
	end

	always @ (clr) begin
		for (rb_i=0;rb_i<16;rb_i=rb_i+1) begin
			rb_mem[rb_i]<=0;
		end
		rb_out0<=0;
		rb_out1<=0;
		rb_out2<=0;
	end

	always @ (ovrflw[0]|ovrflw[1])begin//[0]=positive overflow, [1]=negative overflow
		rb_mem[1][0]<=rb_mem[1][0]|ovrflw[0];
		rb_mem[1][1]<=rb_mem[1][1]|ovrflw[1];
	end

endmodule

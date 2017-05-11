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
//Modulo de Controle de instrucoes:
//Entradas: 	
//		clk: clocks
//		inst: codigo da instrucao
//Saidas:	
//		tmpwr: Bit de controle escrita temporaria
//		hlt: Bit de controle sleep
//		jmp: Bit de controle de desvio incondicional
//		brc: Bit de controle de desvio condicional
//		rgw: Bits de controle de escrita em registrador
//		ioc: Bits de controle de I/O de dados(banco e memoria)
//		rgr: Bit de controle de leitura em registrador
//		alo: Bits de controle da ALU
//		ala: Bit de controle de entrada da ALU
module nR_Control(clk,inst,tmpwr,hlt,jmp,brc,rgw,ioc,rgr,alo,ala);
	input clk;
	input[3:0]inst;
	output reg tmpwr,hlt,jmp,brc,rgr,ala;
	output reg[1:0] rgw;
	output reg[3:0] ioc,alo;

	initial 
	begin 
		tmpwr<=0;
		hlt<=1;
		jmp<=0;
		brc<=0;
		rgw<=0;
		ioc<=0;
		rgr<=0;
		alo<=0;
		ala<=0;
	end

	always @ (posedge clk) begin
		case (inst)
		  4'b0000: begin//slp
		  	hlt<=0;
			jmp<=0;
			brc<=0;
			ioc<=4'b0100;
			rgr<=0;
			end
		  4'b0001: begin//brq
		  	hlt<=1;
			jmp<=0;
			brc<=1;
			ioc<=4'b0100;
			rgr<=0;
			alo<=4'b0001;
			ala<=0;
			end
		  4'b0010: begin//brf
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=1;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=0;
			alo<=4'b0010;
			ala<=0;
			end
		  4'b0011: begin//add
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=1;
			alo<=4'b0000;
			ala<=0;
			end
		  4'b0100: begin//sub
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=1;
			alo<=4'b0001;
			ala<=0;
			end
		  4'b0101: begin//and
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=1;
			alo<=4'b0011;
			ala<=0;
			end
		  4'b0110: begin//or
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=1;
			alo<=4'b0100;
			ala<=0;
			end
		  4'b0111: begin//nor
		  	tmpwr<=0;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=0;
			alo<=4'b0101;
			ala<=0;
			end
		  4'b1000: begin//slt
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=1;
			alo<=4'b0110;
			ala<=0;
			end
		  4'b1001: begin//sr
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=1;
			alo<=4'b1000;
			ala<=0;
			end
		  4'b1010: begin//sl
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b00;
			ioc<=4'b1100;
			rgr<=1;
			alo<=4'b0111;
			ala<=0;
			end
		  4'b1011: begin//jr
		  	tmpwr<=0;
			hlt<=1;
			jmp<=1;
			brc<=0;
			rgw<=2'b01;
			ioc<=4'b1100;
			rgr<=0;
			end
		  4'b1100: begin//la
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b11;
			ioc<=4'b1000;
			end
		  4'b1101: begin//lc
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b11;
			ioc<=4'b1000;
			end
		  4'b1110: begin//lw
		  	tmpwr<=1;
			hlt<=1;
			jmp<=0;
			brc<=0;
			rgw<=2'b10;
			ioc<=4'b1101;
			rgr<=0;
			alo<=4'b0000;
			ala<=1;
			end
		  4'b1111: begin//sw
			hlt<=1;
			jmp<=0;
			brc<=0;
			ioc<=4'b0110;
			rgr<=0;
			alo<=4'b0000;
			ala<=1;
			end
		endcase
	end
endmodule
//Modulo de ALU:
//Entradas: 	
//		in0: entrada0 da ALU
//		in1: entrada1 da ALU
//		alo: Bits de controle da ALU
//Saidas:	
//		zero: saida de controle da ALU
//		out0: saida da ALU
//		ovrflw: overflow da ALU
module nR_ALU(in0,in1,alo,u_zero,u_out0,ovrflw);
	input[7:0] in0,in1;
	input[3:0]alo;
	output reg [1:0] ovrflw;
	output reg u_zero;
	output reg [7:0] u_out0;
	
	initial begin 
		ovrflw<=0;
		u_zero<=0;
		u_out0<=0;
	end
		
	always@(*)
		case(alo)
		  4'b0000: begin//add-0
			u_zero<=0;
			if(in0+in1>8'b11111111) begin//negative overflow
				 u_out0<=128+(in0+in1);
				 ovrflw<=2'b10;
			end
			else if(in0+in1>8'b01111111 & in0<=8'b0111111 & in1<=8'b0111111) begin//positive overflow
				 u_out0<=(128-(in0+in1));
				 ovrflw<=2'b01;
			end 
			else begin
				 u_out0<=in0+in1;
				 ovrflw<=0;
			end
		    end
		  4'b0001: begin//sub-1
		    u_zero<=0;
			if(in0-in1>8'b11111111) begin//negative overflow
				 u_out0<=128+(in0-in1);
				 ovrflw<=2'b01;
			end else if(in0-in1>8'b01111111 & in0>8'b01111111 & in1>8'b01111111) begin//positive overflow
				 u_out0<=128-(in0-in1);
				 ovrflw<=2'b10;
			end
			else begin
				 u_out0<=in0-in1;
				 ovrflw<=0;
			end
			end
		  4'b0010: begin//flag test-2
			ovrflw<=0;
			if((in0&in1)==in1 & in0>0) begin
				 u_out0<=in0-in1;
				 u_zero<=1;
			end	else u_zero=0;
			end
		  4'b0011: begin//and-3
		     ovrflw<=0;
			 u_zero<=0;
			 u_out0<=in0&in1;
		 end
		  4'b0100: begin//or-4
		     ovrflw<=0;
			 u_zero<=0;
			 u_out0<=(in0|in1);
		  end
		  4'b0101: begin//nor-5
		     ovrflw<=0;
			 u_zero<=0;
			 u_out0<=~(in0|in1);
			 end
		  4'b0110: begin//less-6
		     ovrflw<=0;
		     u_out0<=0;
			 u_zero<=(in0>in1);
			 end
		  4'b0111: begin//sl-7
		     ovrflw<=0;
			 u_zero<=0;
			 u_out0<=in0<<in1;
			 end
		  4'b1000: begin//sr-8
		     ovrflw<=0;
		     u_zero<=0;
			 u_out0<=in0>>in1;
			 end
		endcase
endmodule
 
//Modulo de Somador:
//Entradas: 	
//		in0: entrada0 do somador
//		in1: entrada1 do somador
//Saidas:	
//		out0: saida do somador

module nR_Adder(in0,in1,add_out0);
	input[7:0] in0,in1;
	output[7:0] add_out0;
	
	assign add_out0=in0+in1;
endmodule
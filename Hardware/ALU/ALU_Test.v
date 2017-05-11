//MODULOS DE TESTE

 module nR_ALU_Test();
	integer u_in0=0;
	integer u_in1=0;
	integer u_alo=0;
	wire zero;
	wire[7:0] out0;
	wire[1:0] ovrflw;
	always
	begin
		#1 u_in0<=u_in0+1; if(u_in0>3) begin u_in0<=0; u_in1=u_in1+1; end if(u_in1>3) begin u_in1<=0; u_alo=u_alo+1; end if(u_alo>4'b0001) $stop;
	end

	initial
	begin
		$monitor("ALU: Alo = %0d In0 = %0d In1 = %0d Out = %0d Zero = %b Overflow = %b",u_alo,u_in0,u_in1,out0,zero,ovrflw);
	end

	nR_ALU ULA(u_in0,u_in1,u_alo,zero,out0,ovrflw);
endmodule 

module nR_Adder_Test();
	integer a_in0=0;
	integer a_in1=0;
	wire[7:0] a_out;
	always
	begin
		#1 a_in0<=a_in0+1; if(a_in0>15) begin a_in0<=0; a_in1=a_in1+1; end if(a_in1>15) $stop;
	end

	initial
	begin
		$monitor("Adder: In0 = %0d In1 = %0d Out = %0d",a_in0,a_in1,a_out);
		#80 $stop;
	end

	nR_Adder Add(a_in0,a_in1,a_out);
endmodule
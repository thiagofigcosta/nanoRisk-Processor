//MODULOS DE TESTE

module nR_MemoryComponents_BS_Test();
	reg bs_clk;
	reg bs_set;
	wire bs_out0,bs_out1;
	always
	begin
		#1 bs_clk <= ~bs_clk;
	end

	initial
	begin
		bs_clk <= 1'b0;
		bs_set <= 1'b0;
		$monitor("BitShifter: Clock %b Out0 = %0d Out1 = %0d Set = %b",bs_clk,bs_out0,bs_out1,bs_set);
		#15 bs_set <= 1'b1;
		#2 bs_set <= 1'b1;
		#10 $stop;
	end

	nR_BitShifter Deslocador(bs_clk,bs_out0,bs_out1,bs_set);
endmodule

module nR_MemoryComponents_Reg_Test();
	reg reg_clk;
	integer reg_in=0;
	wire[7:0] reg_out;
	reg reg_clr;
	always
	begin
		#1 reg_in<=reg_in+1; if(reg_in>15) reg_in<=0;
		#1 reg_clk <= ~reg_clk;
	end

	initial
	begin
		reg_clk <= 1'b0;
		reg_clr <= 1'b0;
		$monitor("Register: Clock = %b In = %0d Out  = %0d Clr = %b",reg_clk,reg_in,reg_out,reg_clr);
		#27 reg_clr <= 1'b1;
		#5 reg_clr <= 1'b0;
		#10 $stop;
	end

	nR_Register Register(reg_clk,reg_in,reg_out,reg_clr);
endmodule

module nR_MemoryComponents_RegBank_Test();
	reg rb_clk;
	reg rb_canWr;
	reg rb_canRd;
	reg rb_clr;
	reg[1:0] rb_over;
	integer rb_in=1;
	integer rb_Adrin=2;
	integer rb_Adrout0=2;
	integer rb_Adrout1=0;
	integer rb_Adrout2=0;
	wire[7:0] rb_out0;
	wire[7:0] rb_out1;
	wire[7:0] rb_out2;
	always
	begin
		#1 rb_in<=rb_in+1; if(rb_in>255) rb_in=0;
		#1 rb_Adrin<=rb_in;
		#1 rb_Adrout0<=rb_Adrout0+1; if(rb_Adrout0>255) rb_Adrout0<=2;
		#1 rb_Adrout1<=rb_Adrout0-1;
		#1 rb_Adrout2<=rb_Adrout0-2;
		#1 rb_clk <= ~rb_clk;
	end

	initial
	begin
		rb_clk <= 1'b0;
		rb_canWr<= 1'b1;
		rb_canRd<= 1'b1;
		rb_clr<= 1'b0;
		rb_over<=0;
		$monitor("Register Bank: Clock = %b Out0 = %0d Out1 = %0d Out2 = %0d AdrIn = %0d Adr(out0/out1+1/out2+2) = %0d CWr = %b CRd = %b Clr = %b OverFlow = %b",rb_clk,rb_out0,rb_out1,rb_out2,rb_Adrin,rb_Adrout0,rb_canWr,rb_canRd,rb_clr,rb_over);
		#27 rb_clr <= 1'b1;
		#1 rb_clr <= 1'b0;
		
		#5 rb_Adrout0<=2; rb_over<=3;
		#5 rb_Adrout0<=2; rb_over<=2;
		#5 rb_Adrout0<=2; rb_over<=1;
		#1 rb_over<=0;

		#3 rb_canWr <= 1'b0;
		#1 rb_canWr <= 1'b1;

		#10 rb_canRd <= 1'b0;
		#1 rb_canRd <= 1'b1;

		#4 $stop;
	end

	nR_RegisterBank Bank(rb_clk,rb_in,rb_out0,rb_out1,rb_out2,rb_Adrin,rb_Adrout0,rb_Adrout1,rb_Adrout2,rb_canWr,rb_canRd,rb_clr,rb_over);
endmodule

module nR_MemoryComponents_RAM_Test();
	reg mem_clk;
	reg mem_canWr;
	reg mem_canRd;
	reg mem_clr;
	integer mem_in=1;
	integer mem_Adrin=0;
	integer mem_Adrout=0;
	wire[7:0] mem_out;
	always
	begin
		#1 mem_in<=mem_in+1; if(mem_in>255) mem_in<=0;
		#1 mem_Adrin<=mem_in;
		#1 mem_Adrout<=mem_Adrout+1; if(mem_Adrout>255) mem_Adrout<=0;
		#1 mem_clk <= ~mem_clk;
	end

	initial
	begin
		mem_clk <= 1'b0;
		mem_canWr<= 1'b1;
		mem_canRd<= 1'b1;
		mem_clr<= 1'b0;
		$monitor("Memory: Clock = %b Out = %0d AdrIn = %0d AdrOut = %0d CWr = %b CRd = %b Clr = %b",mem_clk,mem_out,mem_Adrin,mem_Adrout,mem_canWr,mem_canRd,mem_clr);
		#27 mem_clr <= 1'b1;
		#1 mem_clr <= 1'b0;

		#10 mem_canWr <= 1'b0;

		#10 mem_canRd <= 1'b0;

		#7 $stop;
	end

	nR_Memory RAM(mem_clk,mem_in,mem_out,mem_Adrin,mem_Adrout,mem_canWr,mem_canRd,mem_clr);
endmodule
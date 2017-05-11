//MODULOS DE TESTE

module nR_MUX_Test();
	integer mux_in0=2;
	integer mux_in1=3;
	wire[7:0] mux_out;
	reg mux_sel0;
	always
	begin
		#1 mux_sel0 <= ~mux_sel0;
	end

	initial
	begin
		mux_sel0 <= 1'b0;
		$monitor("MUX2: In0 = %0d In1 = %0d Sel = %b Out = %0d",mux_in0,mux_in1,mux_sel0,mux_out);
		#60 $stop;
	end

	nR_MUX2 M2(mux_in0,mux_in1,mux_sel0,mux_out);
endmodule

module nR_MUX4_Test();
	integer mux_in0=11;
	integer mux_in1=12;
	integer mux_in2=13;
	integer mux_in3=14;
	wire[7:0] mux1_out;
	integer mux_sel1=0;
	always
	begin
		#1 mux_sel1<=mux_sel1+1; if(mux_sel1>=3) mux_sel1<=0;
	end

	initial
	begin
		$monitor("MUX4: In0 = %0d In1 = %0d In2 = %0d In3 = %0d Sel = %2b Out = %0d",mux_in0,mux_in1,mux_in2,mux_in3,mux_sel1,mux1_out);
		#60 $stop;
	end

	nR_MUX4 M4(mux_in0,mux_in1,mux_in2,mux_in3,mux_sel1,mux1_out);
endmodule

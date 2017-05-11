//MODULOS DE TESTE

module nR_Control_Test();
	reg cc_clk;
	integer cc_inst=0;
	wire cc_tmpwr,cc_hlt,cc_jmp,cc_brc,cc_rgr,cc_ala;
	wire[1:0] cc_rgw;
	wire[3:0] cc_ioc,cc_alo;
	always
	begin
		#1 cc_inst<=cc_inst+1; if(cc_inst>15) cc_inst<=0;
		#1 cc_clk <= ~cc_clk;
	end

	initial
	begin
		cc_clk <= 1'b0;
		$monitor("Control: Clock = %b Inst = %0d Tmpwr = %b Hlt = %b Jmp = %b Brc = %b Rgw = %b Ioc = %b Rgr = %b Alo = %b Ala = %b",cc_clk,cc_inst,cc_tmpwr,cc_hlt,cc_jmp,cc_brc,cc_rgw,cc_ioc,cc_rgr,cc_alo,cc_ala);
		#60 $stop;
	end

	nR_Control CC(cc_clk,cc_inst,cc_tmpwr,cc_hlt,cc_jmp,cc_brc,cc_rgw,cc_ioc,cc_rgr,cc_alo,cc_ala);
endmodule
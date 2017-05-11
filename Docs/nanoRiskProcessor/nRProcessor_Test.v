module nRProcessor_Test();
	reg deviceClock;
	initial
		deviceClock<=1'b0;
		
	always@(*)
		#1 deviceClock<=~deviceClock;
		
	always@(*)
		$monitor("Posicao do plagioclasio %0d",nanoRisk.Registers.rb_mem[4'b1101]);
	nRProcessor nanoRisk(deviceClock,1'b0);
endmodule
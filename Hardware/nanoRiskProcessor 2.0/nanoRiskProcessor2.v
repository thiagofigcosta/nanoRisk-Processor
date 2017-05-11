module nanoRiskProcessor2(clk,rst,finish,plagioclasio);
	input clk, rst;
	output finish;
	output[7:0] plagioclasio;
	nanoRiskProcessor nRp(clk,rst,finish,plagioclasio);
	
endmodule

module nanoRiskProcessor(RealClock, Reset, Done,plagioclasio);
	integer i;
	input RealClock, Reset;
	output Done;
	output[7:0] plagioclasio;
	reg[7:0] registers[0:15];
	reg[7:0] data_memory[0:255];
	reg[7:0] inst_memory[0:255];

	reg Clock;

	reg[7:0] next;
	reg[7:0] ghost[1:0];


	reg[3:0] instruction;
	reg[3:0] R0_id,R1_id,R2_id;
	reg[7:0] Extra,Memaddr;
	
	assign plagioclasio = registers[13];
  assign Done = instruction==0;
	always@(posedge RealClock)
	begin
		ghost[Clock]=inst_memory[next];
		Clock=~Clock;
		next=next+1;
		


		if(next[0]==0)
		begin
		instruction=ghost[0][7:4];
		R0_id=ghost[0][3:0];
		R1_id=ghost[1][7:4];
		R2_id=ghost[1][3:0];
		Extra=ghost[1];
		Memaddr=registers[R1_id]+R2_id;
		case(instruction)
			4'b0000://SLP
			begin
				if(registers[R0_id]==0)
					next=next-2;
			end


			4'b0001://BRQ
			begin
				if(registers[R0_id]==registers[R1_id])
					next=registers[R2_id];
			end

			4'b0010://BRF
			begin
				if(registers[R0_id]&registers[R1_id]>0)
				begin
					registers[R0_id]=registers[R0_id]-registers[R1_id];
					next=registers[R2_id];
				end
			end

			4'b0011://ADD
			begin
				if(registers[R1_id]>=8'b10000000 && registers[R2_id]>=8'b10000000 && registers[R1_id]+registers[R2_id]<8'b10000000)
					registers[1][1]=1;//negative overflow
				if(registers[R1_id]<8'b10000000 && registers[R2_id]<8'b10000000 && registers[R1_id]+registers[R2_id]>=8'b10000000)
					registers[1][0]=1;//positive overflow

				registers[R0_id]=registers[R1_id]+registers[R2_id];
			end


			4'b0100://SUB
			begin
				if(registers[R1_id]<8'b10000000 && registers[R2_id]>=8'b10000000 && registers[R1_id]-registers[R2_id]>=8'b10000000)
					registers[1][1]=1;//negative overflow

				registers[R0_id]=registers[R1_id]-registers[R2_id];
			end

			4'b0101://AND
			begin
				registers[R0_id]=registers[R1_id]&registers[R2_id];
			end


			4'b0110://OR
			begin
				registers[R0_id]=registers[R1_id]|registers[R2_id];
			end

			4'b0111://NOR
			begin
				registers[R0_id]=~(registers[R1_id]|registers[R2_id]);
			end

			4'b1000://SLT
			begin
				if(registers[R1_id]<registers[R2_id])
					registers[R0_id]=8'b11111111;
				else
					registers[R0_id]=8'b00000000;
			end


			4'b1001://SR
			begin
				registers[R0_id]=registers[R1_id]>>registers[R2_id];
			end

			4'b1010://SL
			begin
				registers[R0_id]=registers[R1_id]<<registers[R2_id];
			end

			4'b1011://JR
			begin
				if(inst_memory[next][7:4]==4'b0011&&inst_memory[next+1]==8'b00100000)//jal
				begin
					registers[inst_memory[next][3:0]]<=next+2;
					if(R0_id==0)
						next<=Extra;
					else
						next<=registers[R0_id];
				end
				else
				begin
					registers[2]<=next;
					if(R0_id==0)
						next<=Extra;
					else
						next<=registers[R0_id];
				end
			end


			4'b1100://LA
			begin
				registers[R0_id]=Extra;
			end

			4'b1101://LC
			begin
				registers[R0_id]=Extra;
			end


			4'b1110://LW
			begin
				registers[R0_id]=data_memory[Memaddr];
			end

			4'b1111://SW
			begin
				data_memory[Memaddr]=registers[R0_id];
			end

		endcase
		end
	end

	initial //or always@(Reset)
	begin
		next=0;
		ghost[0]=0;
		ghost[1]=0;
		Clock=0;
		instruction=0;
		R0_id=0;
		R1_id=0;
		R2_id=0;
		Extra=0;
		Memaddr=0;
		for(i=0;i<16;i=i+1)
			registers[i]=0;
		for(i=0;i<256;i=i+1)
			data_memory[i]=0;
		for(i=0;i<256;i=i+1)
			inst_memory[i]=0;
		// code down here	

data_memory[0]=8'b00000001;
data_memory[1]=8'b00101100;
data_memory[2]=8'b00000000;
data_memory[3]=8'b10010110;
data_memory[4]=8'b00000010;
data_memory[5]=8'b10011010;
data_memory[6]=8'b00000001;
data_memory[7]=8'b01100101;
data_memory[8]=8'b00000000;
data_memory[9]=8'b11011100;
data_memory[10]=8'b00000001;
data_memory[11]=8'b11100000;
data_memory[12]=8'b00000001;
data_memory[13]=8'b00010100;
data_memory[14]=8'b00000010;
data_memory[15]=8'b10011010;
data_memory[16]=8'b00000001;
data_memory[17]=8'b00000010;
data_memory[18]=8'b00000010;
data_memory[19]=8'b00001000;
data_memory[20]=8'b00101000;
data_memory[21]=8'b00011010;
data_memory[22]=8'b00011100;
data_memory[23]=8'b00010000;









inst_memory[0]=8'b11000111;
inst_memory[1]=8'b00010000;
inst_memory[2]=8'b11001000;
inst_memory[3]=8'b00010100;
inst_memory[4]=8'b11100111;
inst_memory[5]=8'b01110000;
inst_memory[6]=8'b11101000;
inst_memory[7]=8'b10000000;
inst_memory[8]=8'b11010010;
inst_memory[9]=8'b10000000;
inst_memory[10]=8'b10110010;
inst_memory[11]=8'b00000000;
inst_memory[12]=8'b00110100;
inst_memory[13]=8'b00100000;
inst_memory[14]=8'b00111011;
inst_memory[15]=8'b01010000;
inst_memory[16]=8'b00111100;
inst_memory[17]=8'b01100000;
inst_memory[18]=8'b11000111;
inst_memory[19]=8'b00010001;
inst_memory[20]=8'b11001000;
inst_memory[21]=8'b00010101;
inst_memory[22]=8'b11100111;
inst_memory[23]=8'b01110000;
inst_memory[24]=8'b11101000;
inst_memory[25]=8'b10000000;
inst_memory[26]=8'b11010010;
inst_memory[27]=8'b10000000;
inst_memory[28]=8'b10110010;
inst_memory[29]=8'b00000000;
inst_memory[30]=8'b00110100;
inst_memory[31]=8'b00100000;
inst_memory[32]=8'b00111011;
inst_memory[33]=8'b01011011;
inst_memory[34]=8'b00111100;
inst_memory[35]=8'b01101100;
inst_memory[36]=8'b11000111;
inst_memory[37]=8'b00010010;
inst_memory[38]=8'b11001000;
inst_memory[39]=8'b00010110;
inst_memory[40]=8'b11100111;
inst_memory[41]=8'b01110000;
inst_memory[42]=8'b11101000;
inst_memory[43]=8'b10000000;
inst_memory[44]=8'b11010010;
inst_memory[45]=8'b10000000;
inst_memory[46]=8'b10110010;
inst_memory[47]=8'b00000000;
inst_memory[48]=8'b00110100;
inst_memory[49]=8'b00100000;
inst_memory[50]=8'b00111011;
inst_memory[51]=8'b01011011;
inst_memory[52]=8'b00111100;
inst_memory[53]=8'b01101100;
inst_memory[54]=8'b11000111;
inst_memory[55]=8'b00010011;
inst_memory[56]=8'b11001000;
inst_memory[57]=8'b00010111;
inst_memory[58]=8'b11100111;
inst_memory[59]=8'b01110000;
inst_memory[60]=8'b11101000;
inst_memory[61]=8'b10000000;
inst_memory[62]=8'b11010010;
inst_memory[63]=8'b10000000;
inst_memory[64]=8'b10110010;
inst_memory[65]=8'b00000000;
inst_memory[66]=8'b00110100;
inst_memory[67]=8'b00100000;
inst_memory[68]=8'b00111100;
inst_memory[69]=8'b01101100;
inst_memory[70]=8'b00111011;
inst_memory[71]=8'b01011011;
inst_memory[72]=8'b11010111;
inst_memory[73]=8'b00000010;
inst_memory[74]=8'b11010010;
inst_memory[75]=8'b01010000;
inst_memory[76]=8'b00100001;
inst_memory[77]=8'b01110010;
inst_memory[78]=8'b10110000;
inst_memory[79]=8'b01010100;
inst_memory[80]=8'b11010010;
inst_memory[81]=8'b00000001;
inst_memory[82]=8'b00111100;
inst_memory[83]=8'b11000010;
inst_memory[84]=8'b00110001;
inst_memory[85]=8'b00000000;
inst_memory[86]=8'b11011101;
inst_memory[87]=8'b00000000;
inst_memory[88]=8'b11001110;
inst_memory[89]=8'b00000000;
inst_memory[90]=8'b11010010;
inst_memory[91]=8'b00001000;
inst_memory[92]=8'b10000111;
inst_memory[93]=8'b11010010;
inst_memory[94]=8'b11010010;
inst_memory[95]=8'b01111010;
inst_memory[96]=8'b00010111;
inst_memory[97]=8'b00000010;
inst_memory[98]=8'b11101001;
inst_memory[99]=8'b11100000;
inst_memory[100]=8'b11101000;
inst_memory[101]=8'b11100001;
inst_memory[102]=8'b01001001;
inst_memory[103]=8'b10011100;
inst_memory[104]=8'b01001000;
inst_memory[105]=8'b10001011;
inst_memory[106]=8'b00110111;
inst_memory[107]=8'b10011000;
inst_memory[108]=8'b11010010;
inst_memory[109]=8'b01111010;
inst_memory[110]=8'b00010000;
inst_memory[111]=8'b01110010;
inst_memory[112]=8'b11010010;
inst_memory[113]=8'b00000001;
inst_memory[114]=8'b00111101;
inst_memory[115]=8'b11010010;
inst_memory[116]=8'b11010010;
inst_memory[117]=8'b00000010;
inst_memory[118]=8'b00111110;
inst_memory[119]=8'b11100010;
inst_memory[120]=8'b10110000;
inst_memory[121]=8'b01011010;
inst_memory[122]=8'b11010010;
inst_memory[123]=8'b00000001;
inst_memory[124]=8'b00111101;
inst_memory[125]=8'b11010010;
inst_memory[126]=8'b00000001;
inst_memory[127]=8'b00000000;
inst_memory[128]=8'b11010010;
inst_memory[129]=8'b00000001;
inst_memory[130]=8'b01000011;
inst_memory[131]=8'b00110010;
inst_memory[132]=8'b11111011;
inst_memory[133]=8'b00110000;
inst_memory[134]=8'b11010010;
inst_memory[135]=8'b00000001;
inst_memory[136]=8'b01000011;
inst_memory[137]=8'b00110010;
inst_memory[138]=8'b11111100;
inst_memory[139]=8'b00110000;
inst_memory[140]=8'b10001011;
inst_memory[141]=8'b01111000;
inst_memory[142]=8'b11010010;
inst_memory[143]=8'b10011000;
inst_memory[144]=8'b00011011;
inst_memory[145]=8'b00000010;
inst_memory[146]=8'b00111011;
inst_memory[147]=8'b01110000;
inst_memory[148]=8'b00111100;
inst_memory[149]=8'b10000000;
inst_memory[150]=8'b10110000;
inst_memory[151]=8'b10011100;
inst_memory[152]=8'b00111011;
inst_memory[153]=8'b10000000;
inst_memory[154]=8'b00111100;
inst_memory[155]=8'b01110000;
inst_memory[156]=8'b11010101;
inst_memory[157]=8'b00000000;
inst_memory[158]=8'b11010110;
inst_memory[159]=8'b00000000;
inst_memory[160]=8'b00110001;
inst_memory[161]=8'b00000000;
inst_memory[162]=8'b11010010;
inst_memory[163]=8'b10110100;
inst_memory[164]=8'b00011011;
inst_memory[165]=8'b00000010;
inst_memory[166]=8'b00110101;
inst_memory[167]=8'b01011100;
inst_memory[168]=8'b11010111;
inst_memory[169]=8'b00000010;
inst_memory[170]=8'b11010010;
inst_memory[171]=8'b11111111;
inst_memory[172]=8'b00111011;
inst_memory[173]=8'b10110010;
inst_memory[174]=8'b11010010;
inst_memory[175]=8'b11000010;
inst_memory[176]=8'b00100001;
inst_memory[177]=8'b01110010;
inst_memory[178]=8'b10110000;
inst_memory[179]=8'b10100000;
inst_memory[180]=8'b11101100;
inst_memory[181]=8'b00110000;
inst_memory[182]=8'b11010010;
inst_memory[183]=8'b00000001;
inst_memory[184]=8'b00110011;
inst_memory[185]=8'b00110010;
inst_memory[186]=8'b11101011;
inst_memory[187]=8'b00110000;
inst_memory[188]=8'b11010010;
inst_memory[189]=8'b00000001;
inst_memory[190]=8'b00110011;
inst_memory[191]=8'b00110010;
inst_memory[192]=8'b10110100;
inst_memory[193]=8'b00000000;
inst_memory[194]=8'b11010010;
inst_memory[195]=8'b00000001;
inst_memory[196]=8'b00110110;
inst_memory[197]=8'b01100010;
inst_memory[198]=8'b10110000;
inst_memory[199]=8'b10100000;










		
	end
endmodule

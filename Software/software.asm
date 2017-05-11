.data
#real data
#v:	.word 300,  150,   666,   357,   220,   480,   276,  666	#OVERFLOW
#v array size 16 with 8 elements
#overflow(simple)(signed)
#v:	.word 2,44, 1,22,  5,26,  2,101, 1,92,  3,96,  2,20, 5,26
#overflow(unsigned second byte) doesnt allow neg numbers
v:	.word 1,44, 0,150, 2,154, 1,101, 0,220, 1,224, 1,20, 2,154
nCa:	.word 1	
nAl:	.word 2	
nSi:	.word 2			
nO:	.word 8
mCa:	.word 40
mAl:	.word 26	
mSi:	.word 28
mO:	.word 16		
.text
#main func
main:
la $a0, nCa
la $a1, mCa
lw $a0, 0($a0)
lw $a1, 0($a1)
jal mult
mov $s0,$v0
mov $s1,$v1
la $a0, nAl
la $a1, mAl
lw $a0, 0($a0)
lw $a1, 0($a1)
jal mult
add $s0,$v0,$s0
add $s1,$v1,$s1
la $a0, nSi
la $a1, mSi
lw $a0, 0($a0)
lw $a1, 0($a1)
jal mult
add $s0,$v0,$s0
add $s1,$v1,$s1
la $a0, nO
la $a1, mO
lw $a0, 0($a0)
lw $a1, 0($a1)
jal mult
add $s1,$v1,$s1		#+sig massa molar de CaAl2Si2O8
add $s0,$v0,$s0 	#-sig massa molar de CaAl2Si2O8
lc $a0, 2	#overflow negative
bof $flg, $a0, over
j overend
over:
addc $s1, $s1, 1
overend:
mov $flg, $0



lc $s2, 0
la $s3, v
mainloop:
sltc $a0, $s2, 8	#if(s2<8) nt=true else nt=false
beq $a0, $0, mainend	#erro por usar nt

lw $a2, 0($s3)	#vector at i value
lw $a1, 1($s3)	#vector at i value
sub $a2,$a2,$s1 	#mais significativo
sub $a1,$a1,$s0 	#menos significativo
add $a0,$a2,$a1

beq $0,$a0,mainend #igual
addc $s2,$s2,1
addc $s3,$s3,2	#nao ha alinhamento de memoria
j mainloop	
mainend:
addc $s2, $s2, 1		#posicao do plagioclasio(primeira posicao e 1)
slp			# we are out of here.

#mult func(a*b=c)
mult:
push $s0
push $s1
slt $s0, $a0, $a1 	#if(a0<a1) t0=true else t0=false
beq $s0, $0, multp2
mov $s0, $a0 #a0 lower
mov $s1, $a1
j multp3
multp2:			#a1 lower
mov $s0, $a1 #a0 lower
mov $s1, $a0
multp3: 		#always s0<s1
lc $v0, 0
lc $v1, 0
multloop:

mov $flg, $0

	# erro
	# sltc $nt, $s0, 0 #if(s0<0) nt=true else nt=false
	# not $nt, $nt
	# beq $nt, $zero, multend
	# end erro

	beq $s0, $zero, multend

add $v0, $v0, $s1
lc $a0, 2	#overflow negative
addc $s0, $s0, -1
bof $flg, $a0, multoverflow
j multloop
multend:
pop $s1
pop $s0
jr $ra
multoverflow:
addc $v1, $v1, 1
j multloop
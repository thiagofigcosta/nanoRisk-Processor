.data
v:	.word 300,150,666,357,220,480,276,666	#v array size 8
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
la $t0, nCa
la $t1, mCa
lw $a0, 0($t0)
lw $a1, 0($t1)
jal mult
addi $s0,$v0,0
la $t0, nAl
la $t1, mAl
lw $a0, 0($t0)
lw $a1, 0($t1)
jal mult
add $s0,$v0,$s0
la $t0, nSi
la $t1, mSi
lw $a0, 0($t0)
lw $a1, 0($t1)
jal mult
add $s0,$v0,$s0
la $t0, nO
la $t1, mO
lw $a0, 0($t0)
lw $a1, 0($t1)
jal mult
add $s0,$v0,$s0 	#massa molar de CaAl2Si2O8
li $t2, 8		#vector size
li $t1, 0
la $t3, v
mainloop:
slt $t0, $t1, $t2	#if(t1<t2) t0=true else t0=false
beq $t0, $zero, mainend
add $t4, $t1, $t1	#t1*2
add $t4, $t4, $t4	#t4*2
add $t4, $t3, $t4	#t4+base
lw $t4, 0($t4)		#vector at i value
sub $t4, $t4, $s0
addi $t1, $t1, 1
addi $s1, $t1,0		#posicao do plagioclasio(primeira posicao e 1)
beq $zero,$t4,mainend
j mainloop	
mainend:
li   $v0, 10		# system call for exit
syscall			# we are out of here.

#mult func(a*b=c)
mult:
slt $t0, $a0, $a1 	#if(a0<a1) t0=true else t0=false
beq $t0, $zero, multp2
addi $t0, $a0, 0	#a0 lower	
addi $t1, $a1,0 	
j multp3
multp2:			#a1 lower
addi $t0, $a1, 0			
addi $t1, $a0,0 
multp3: 		#t0<t1
li $t2, 0
li $v0, 0
multloop:
slt $t3, $t2, $t0	#if(t2<t0) t3=true else t3=false
beq $t3, $zero, multend
add $v0, $v0, $t1
addi $t2, $t2, 1
j multloop
multend:
jr $ra
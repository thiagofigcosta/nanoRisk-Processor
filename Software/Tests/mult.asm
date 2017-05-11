.data
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
main:
la $a0, nO
la $a1, mO
lw $a0, 0($a0)
lw $a1, 0($a1)
jal mult
mov $s0,$v0
mov $s1,$v1
slp


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
# erro
# sltc $nt, $s0, 0 #if(s0<0) nt=true else nt=false
# not $nt, $nt
# beq $nt, $zero, multend
# end erro

beq $s0, $zero, multend

add $v0, $v0, $s1
lc $a0, 1	#overflow positive
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
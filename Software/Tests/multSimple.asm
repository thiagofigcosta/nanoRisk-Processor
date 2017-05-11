.text
main:
lc $a0, 2
lc $a1, 2
jal mult
mov $s2,$v0
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
sltc $nt, $s0, 0 #if(s0<0) nt=true else nt=false
not $nt, $nt 	#if(s0<0) nt=0 else nt=1
beq $nt, $zero, multend
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
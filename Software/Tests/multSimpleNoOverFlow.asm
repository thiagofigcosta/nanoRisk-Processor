.text
main:
lc $a0, 2
lc $a1, 4
jal mult
mov $s2,$v0
slp

mult:
slt $s0, $a0, $a1
beq $s0, $0, multp2
mov $s0, $a0
mov $s1, $a1
j multp3

multp2:		
mov $s0, $a1
mov $s1, $a0

multp3: 		
lc $v0, 0
lc $v1, 0

multloop:
beq $s0, $zero, multend
add $v0, $v0, $s1
addc $s0, $s0, -1
j multloop

multend:
jr $ra
addi $a0, $0, 0x002C
addi $a1, $0, 0x0019
j Euclidean

Div:
add $t2, $a0, $0
sub $t4, $t2, $a1
blez $t4, Swap
sub $t2, $t2, $a1
Swap:
add $a0, $a1, $0
add $a1, $t2, $0
Euclidean:
bne $a0, $a1, Div
add $v0, $a0, $0
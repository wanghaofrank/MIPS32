addi $a2, $0, 12056
addi $a3, $0, 3425
j Euclidean
Div:
add $t2, $a2, $0
sub $t3, $t2, $a3
blez $t3, Swap
sub $t2, $t2, $a3
Swap:
add $a2, $a3, $0
add $a3, $t2, $0
j Euclidean
Euclidean:
bne $a2, $a3, Div
add $v0, $a2, $0
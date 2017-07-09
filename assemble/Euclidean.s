j ExceptionProcess
j InterruptProcess

add $s0, $0, $0
lui $s0, 0x4000
addi $s0, $s0, 0x0018

add $s1, $0, $0
lui $s1, 0x0000
addi $s1, $s1, 0x0002

add $a0, $0, $0
add $a1, $0, $0

# Timer
addi $s0, $s0, -4
sw $0, 0($s0)

addi $s0, $s0, -8
addi $t0, $0, 100
sw $t0, 0($s0)

addi $t0, $t0, -1
addi $s0, $s0, 4
sw $t0, 0($s0)

addi $t0, $t0, 3
addi $s0, $s0, 4
sw $t0, 0($s0)

add $s0, $s0, $8
add $v0, $0, $0
getNumber1:
lw $t0, 0($s0)
or $t1, $t0, $s1
beq $t1, $0, getNumber1
sub $s0, $s0, $4
lw $a0, 0($s0)
add $s0, $s0, $4

getNumber2:
lw $t0, 0($s0)
or $t1, $t0, $s1
beq $t1, $0, getNumber2
sub $s0, $s0, $4
lw $a1, 0($s0)
add $s0, $s0, $4
j Euclidean
Div:
add $t2, $a0, $0
ble $t2,$a1,Swap
sub $t2, $t2, $a1
Swap:
add $a0, $a1, $0
add $a1, $t2, $0
Euclidean:
bne $a0, $a1, Div
add $v0, $a0, $0

lui $s0, 0x4000
addi $s0, $s0, 0x000C

sw $v0, 0($s0) # LED 

ExceptionProcess:
nop

InterruptProcess:
add $s7, $0, $0
lui $s7, 0x1000
addi $s7, $s7, 0x0014
lw $t0, 0($s7)

andi $s6, $t0, 0x0F00
addi $t2, $0, 0x0100
beq $s6, $0, LabelA
beq $t2, $s6, LabelB
sll $t2, $t2, 1
beq $t2, $s6, LabelC
sll $t2, $t2, 1
beq $t2, $s6, LabelD
sll $t2, $t2, 1
beq $t2, $s6, LabelA
LabelA:
add $t3, $0, $0
and $t3, $a1, 0x00F0
srl $t3, $t3, 4
jal Decoder
or $t3, $t3, 0x0100
sw $t3, 0($s7)
j start # must be a register save the instruction before interruption happened.
LabelB:
add $t3, $0, $0
and $t3, $a1, 0x000F
srl $t3, $t3, 4
jal Decoder
or $t3, $t3, 0x0200
sw $t3, 0($s7)
j start
LabelC:
add $t3, $0, $0
and $t3, $a0, 0x00F0
srl $t3, $t3, 4
jal Decoder
or $t3, $t3, 0x0400
sw $t3, 0($s7)
j start
LabelD:
add $t3, $0, $0
and $t3, $a0, 0x000F
srl $t3, $t3, 4
jal Decoder
or $t3, $t3, 0x0800
sw $t3, 0($s7)
j start
Decoder:
addi $t0, $0, 0
beq $t3, $t0, L1
addi $t3, $0, 0x0002
jr $ra
L1:
addi $t0, $t0, 1
bne $t3, $t0, L2
addi $t3, $0, 0x009E
jr $ra
L2:
addi $t0, $t0, 1
bne $t3, $t0, L3
addi $t3, $0, 0x0024
jr $ra
L3:
addi $t0, $t0, 1
bne $t3, $t0, L4
addi $t3, $0, 0x000C
jr $ra
L4:
addi $t0, $t0, 1
bne $t3, $t0, L5
addi $t3, $0, 0x0098
jr $ra
L5:
addi $t0, $t0, 1
bne $t3, $t0, L6
addi $t3, $0, 0x0048
jr $ra
L6:
addi $t0, $t0, 1
bne $t3, $t0, L7
addi $t3, $0, 0x0040
jr $ra
L7:
addi $t0, $t0, 1
bne $t3, $t0, L8
addi $t3, $0, 0x001E
jr $ra
L8:
addi $t0, $t0, 1
bne $t3, $t0, L9
addi $t3, $0, 0x0000
jr $ra
L9:
addi $t0, $t0, 1
bne $t3, $t0, L10
addi $t3, $0, 0x0008
jr $ra
L10:
addi $t0, $t0, 1
bne $t3, $t0, L11
addi $t3, $0, 0x0010
jr $ra
L11:
addi $t0, $t0, 1
bne $t3, $t0, L12
addi $t3, $0, 0x00C0
jr $ra
L12:
addi $t0, $t0, 1
bne $t3, $t0, L13
addi $t3, $0, 0x0062
jr $ra
L13:
addi $t0, $t0, 1
bne $t3, $t0, L14
addi $t3, $0, 0x0084
jr $ra
L14:
addi $t0, $t0, 1
bne $t3, $t0, L15
addi $t3, $0, 0x0070
jr $ra
L15:
addi $t0, $t0, 1
addi $t3, $0, 0x0070
jr $ra









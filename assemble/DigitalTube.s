.data 0x10000014
.word 0

.text 0x00400000
addi $a1, $0, 0x00AF
addi $a0, $0, 0x0035

start:
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
j start
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

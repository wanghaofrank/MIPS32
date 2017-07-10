addi $a0, $a0, 0x0000
addi $a1, $a1, 0x00C0

addi $t5, $0, -7

add $s7, $0, $0
lui $s7, 0x1000
addi $s7, $s7, 0x0008
lw $t6, 0($s7)

and $t5, $t5, $t6
sw $t5, 0($s7)

addi $s7, $s7, 12

lw $t5, 0($s7)
andi $s6, $t5, 0x0F00

addi $t6, $0, 0x0100
beq $s6, $0, LabelA
beq $t6, $s6, LabelB
sll $t6, $t6, 1
beq $t6, $s6, LabelC
sll $t6, $t6, 1
beq $t6, $s6, LabelD
sll $t6, $t6, 1
beq $t6, $s6, LabelA

LabelA:
add $t7, $0, $0
andi $t7, $a1, 0x00F0
srl $t7, $t7, 4
jal Decoder
or $t7, $t7, 0x0100
sw $t7, 0($s7)
j Exit
LabelB:
add $t7, $0, $0
andi $t7, $a1, 0x000F
srl $t7, $t7, 4
jal Decoder
or $t7, $t7, 0x0200
sw $t7, 0($s7)
j Exit
LabelC:
add $t7, $0, $0
andi $t7, $a0, 0x00F0
srl $t7, $t7, 4
jal Decoder
or $t7, $t7, 0x0400
sw $t7, 0($s7)
j Exit
LabelD:
add $t7, $0, $0
andi $t7, $a0, 0x000F
srl $t7, $t7, 4
jal Decoder
or $t7, $t7, 0x0800
sw $t7, 0($s7)
j Exit
Decoder:
addi $t5, $0, 0
bne $t7, $t5, L1
addi $t7, $0, 0x0002
jr $ra
L1:
addi $t5, $t5, 1
bne $t7, $t5, L2
addi $t7, $0, 0x009E
jr $ra
L2:
addi $t5, $t5, 1
bne $t7, $t5, L3
addi $t7, $0, 0x0024
jr $ra
L3:
addi $t5, $t5, 1
bne $t7, $t5, L4
addi $t7, $0, 0x000C
jr $ra
L4:
addi $t5, $t5, 1
bne $t7, $t5, L5
addi $t7, $0, 0x0098
jr $ra
L5:
addi $t5, $t5, 1
bne $t7, $t5, L6
addi $t7, $0, 0x0048
jr $ra
L6:
addi $t5, $t5, 1
bne $t7, $t5, L7
addi $t7, $0, 0x0040
jr $ra
L7:
addi $t5, $t5, 1
bne $t7, $t5, L8
addi $t7, $0, 0x001E
jr $ra
L8:
addi $t5, $t5, 1
bne $t7, $t5, L9
addi $t7, $0, 0x0000
jr $ra
L9:
addi $t5, $t5, 1
bne $t7, $t5, L10
addi $t7, $0, 0x0008
jr $ra
L10:
addi $t5, $t5, 1
bne $t7, $t5, L11
addi $t7, $0, 0x0010
jr $ra
L11:
addi $t5, $t5, 1
bne $t7, $t5, L12
addi $t7, $0, 0x00C0
jr $ra
L12:
addi $t5, $t5, 1
bne $t7, $t5, L13
addi $t7, $0, 0x0062
jr $ra
L13:
addi $t5, $t5, 1
bne $t7, $t5, L14
addi $t7, $0, 0x0084
jr $ra
L14:
addi $t5, $t5, 1
bne $t7, $t5, L15
addi $t7, $0, 0x0070
jr $ra
L15:
addi $t5, $t5, 1
addi $t7, $0, 0x0070
jr $ra
Exit:
add $s7, $0, $0
lui $s7, 0x4000
addi $s7, $s7, 0x0008
lw $t6, 0($s7)
lui $t7, 0x0000
addi $t7, $t7, 0x0002
or $t6, $t7, $t6
sw $t6, 0($s7)
jr $k0

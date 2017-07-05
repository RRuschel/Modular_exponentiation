.data
N: .word 10 # number of test cases supplied; at least 10
A: .word 5,25,9,12345,54321,4,10,31,12,94 # parameter A in (A^B) mod P; add 5 or more test cases
B: .word 0,16,8,54321,10000,13,20,7,18,7 # parameter B in (A^B) mod P; add 5 or more test cases
P: .word 8,13,2,10000,65535,497,5,75,39,345 # parameter P in (A^B) mod P; add 5 or more test cases
C: .word 1,1,1,1,1,1,1,1,1,1 # results of test cases 

base: .asciiz "\n\nBase "
exp: .asciiz "\nExponent "
module: .asciiz "\nModule "
result: .asciiz "\nResult "

.globl main
.text
main:

la $t7, N
lw $t7, 0($t7) #Number of operations
la $s0, A
la $s1, B
la $s2, P
la $s3, C

main2:

lw $t3, 0($s0) #base
lw $t4, 0($s1) #exponent
lw $a2, 0($s2) #mod
lw $t5, 0($s3) #result

la $a0, base
li $v0, 4
syscall
add $a0, $t3, $zero
li $v0, 1
syscall

la $a0, exp
li $v0, 4
syscall
add $a0, $t4, $zero
li $v0, 1
syscall

la $a0, module
li $v0, 4
syscall
add $a0, $a2, $zero
li $v0, 1
syscall

looooooop:
beq $t4, $zero, label1
andi $t6, $t4, 0x00000001
beq $t6, $zero, faz_nada
add $a0, $t3, $zero
add $a1, $t5, $zero
jal ummu
add $t5, $v1, $zero

faz_nada:
add $a0, $t3, $zero
add $a1, $t3, $zero
srl $t4, $t4, 1
jal ummu
add $t3, $v1, $zero
j looooooop

label1:
addi $t7, $t7, -1
addi $s0, $s0, 4
addi $s1, $s1, 4
addi $s2, $s2, 4
sw $t5, 0($s3)
addi $s3, $s3, 4

#Print the messages
la $a0, result
li $v0, 4
syscall
add $a0, $t5, $zero
li $v0, 1
syscall

bne $t7, $zero, main2
li $v0, 10
syscall

ummu: #A0*A1 mod A2
add $v0, $zero, $zero
add $v1, $zero, $zero
addi $t2, $zero, 32

mloop:
add $t0, $zero, $zero
add $t1, $a1, $zero
srl $a1,$a1, 1
andi $t1,$t1, 0x00000001
beq $t1, $zero, noadd
add $v0, $v0, $a0
slt $t0, $v0, $a0

noadd:
add $t1, $v0, $zero
srl $v0,$v0, 1
andi $t1, $t1, 0x00000001
sll $t0, $t0, 31
add $v0, $v0, $t0
srl $v1,$v1, 1
sll $t1, $t1, 31
add $v1, $v1, $t1
addi $t2, $t2, -1
addi $s5, $s5, 1 #bne
bne $t2, $zero, mloop
repete: #Calculates the modulus
bltz $v1, fim
sub $v1, $v1, $a2
j repete

fim:
add $v1, $v1, $a2
jr $ra


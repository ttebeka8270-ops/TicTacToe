.data

title: .asciiz "MIPS Number Guessing Game\n"
prompt: .asciiz "Guess a number from 1 to 10: "
too_low: .asciiz "Too low!\n"
too_high: .asciiz "Too high!\n"
correct: .asciiz "Correct! You win!\n"
invalid: .asciiz "Invalid guess.\n"
lose: .asciiz "You are out of attempts!\n"
.text
.globl main


main:
    li $v0, 4
    la $a0, title
    syscall

    li $s0, 7          # Secret number
    li $s1, 0          # Number of attempts
    li $s2, 5          # Maximum attempts

guess_loop:
    bge $s1, $s2, out_of_attempts

    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    blt $t0, 1, invalid_guess
    bgt $t0, 10, invalid_guess

    addi $s1, $s1, 1

    beq $t0, $s0, correct_guess
    blt $t0, $s0, low_guess

    li $v0, 4
    la $a0, too_high
    syscall
    j guess_loop

low_guess:
    li $v0, 4
    la $a0, too_low
    syscall
    j guess_loop

invalid_guess:
    li $v0, 4
    la $a0, invalid
    syscall
    j guess_loop

correct_guess:
    li $v0, 4
    la $a0, correct
    syscall
    j exit_game

out_of_attempts:
    li $v0, 4
    la $a0, lose
    syscall

exit_game:
    li $v0, 10
    syscall


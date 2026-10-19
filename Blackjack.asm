.data

title: .asciiz "MIPS Blackjack\n"
prompt: .asciiz "Enter your card value from 1 to 10: "
player_msg: .asciiz "Your total is: "
dealer_msg: .asciiz "Dealer total is: "
win_msg: .asciiz "\nYou win!\n"
lose_msg: .asciiz "\nDealer wins!\n"
draw_msg: .asciiz "\nIt is a draw!\n"
invalid: .asciiz "Invalid card value.\n"

.text
.globl main
main:
    li $v0, 4
    la $a0, title
    syscall

    li $s0, 0          # Player total
    li $s1, 0          # Number of cards
    li $s2, 2          # Player gets 2 cards

card_loop:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    blt $t0, 1, invalid_card
    bgt $t0, 10, invalid_card

    add $s0, $s0, $t0
    addi $s1, $s1, 1
    blt $s1, $s2, card_loop

    li $v0, 4
    la $a0, player_msg
    syscall

    li $v0, 1
    move $a0, $s0
    syscall

    li $s3, 17          # Dealer total

    li $v0, 4
    la $a0, dealer_msg
    syscall

    li $v0, 1
    move $a0, $s3
    syscall

    bgt $s0, 21, player_lose
    bgt $s3, $s0, player_lose
    blt $s3, $s0, player_win

    li $v0, 4
    la $a0, draw_msg
    syscall
    j exit_game

player_win:
    li $v0, 4
    la $a0, win_msg
    syscall
    j exit_game

player_lose:
    li $v0, 4
    la $a0, lose_msg
    syscall
    j exit_game

invalid_card:
    li $v0, 4
    la $a0, invalid
    syscall
    j card_loop

exit_game:
    li $v0, 10
    syscall
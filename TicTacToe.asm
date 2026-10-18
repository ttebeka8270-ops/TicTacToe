.data
title: .asciiz "MIPS Tic-Tac-Toe\n"
board_line: .asciiz "   |   |   \n---+---+---\n"
board: .space 9          # Stores 9 board spaces
prompt: .asciiz "\nPlayer X, choose a position from 1 to 9: "
invalid: .asciiz "Invalid choice.\n"
newline: .asciiz "\n"
cell_sep: .asciiz " | "
row_line: .asciiz "---+---+---\n"
prompt_o: .asciiz "\nPlayer O, choose a position from 1 to 9: "
occupied: .asciiz "That position is already taken.\n"
x_wins: .asciiz "\nPlayer X wins!\n"
o_wins: .asciiz "\nPlayer O wins!\n"
draw_msg: .asciiz "\nThe game is a draw!\n"
wins: .byte 0,1,2, 3,4,5, 6,7,8, 0,3,6, 1,4,7, 2,5,8, 0,4,8, 2,4,6
.text
.globl main

main:
    # Display the game title
    li $v0, 4
    la $a0, title
    syscall

    # Clear the board
    jal init_board
    jal draw_grid
    li $s0, 0

game_loop:
    andi $t7, $s0, 1
    beq $t7, $zero, x_turn

    jal player_o_move
    j after_turn

x_turn:
    jal player_move

after_turn:
    jal draw_marks
    jal print_board
    jal check_winner

    bne $v0, $zero, game_over

    addi $s0, $s0, 1
    blt $s0, 9, game_loop

    li $v0, 4
    la $a0, draw_msg
    syscall

game_over:
    # End program for now
    li $v0, 10
    syscall


# ------------------------------------------------
# Procedure: init_board
# Fills all 9 board spaces with a blank space
# ------------------------------------------------
init_board:
    la $t0, board          # $t0 points to the board
    li $t1, 0              # Counter
    li $t2, 32             # ASCII space

clear_loop:
    beq $t1, 9, clear_done
    sb $t2, 0($t0)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j clear_loop

clear_done:
    jr $ra
# ------------------------------------------------
# Procedure: print_board
# Displays the Tic-Tac-Toe board
# ------------------------------------------------
print_board:
        la $t0, board
    li $t1, 0

row_loop:
    li $t2, 0

column_loop:
    lb $a0, 0($t0)

    li $v0, 11
    syscall

    addi $t0, $t0, 1
    addi $t1, $t1, 1
    addi $t2, $t2, 1

    bge $t2, 3, end_row

    li $v0, 4
    la $a0, cell_sep
    syscall

    j column_loop

end_row:
    li $v0, 4
    la $a0, newline
    syscall

    bge $t1, 9, board_done

    li $v0, 4
    la $a0, row_line
    syscall

    j row_loop

board_done:
    jr $ra
    # ------------------------------------------------
# Procedure: player_move
# Gets a position from 1 to 9 and stores X
# ------------------------------------------------
player_move:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    blt $t0, 1, invalid_move
    bgt $t0, 9, invalid_move

    addi $t0, $t0, -1
    la $t1, board
    add $t1, $t1, $t0
lb $t3, 0($t1)
bne $t3, 32, occupied_move
    li $t2, 88
    sb $t2, 0($t1)

    jr $ra

invalid_move:
    li $v0, 4
    la $a0, invalid
    syscall
    jr $ra
    # ------------------------------------------------
# Procedure: player_o_move
# Gets a position and stores O
# ------------------------------------------------
player_o_move:
    li $v0, 4
    la $a0, prompt_o
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    blt $t0, 1, invalid_o
    bgt $t0, 9, invalid_o

    addi $t0, $t0, -1
    la $t1, board
    add $t1, $t1, $t0

    lb $t3, 0($t1)
    bne $t3, 32, occupied_move

    li $t2, 79          # ASCII value for O
    sb $t2, 0($t1)
    jr $ra

invalid_o:
    li $v0, 4
    la $a0, invalid
    syscall
    jr $ra

occupied_move:
    li $v0, 4
    la $a0, occupied
    syscall
    jr $ra# ------------------------------------------------
# Procedure: draw_grid
# Draws the Tic-Tac-Toe grid on the Bitmap Display
# ------------------------------------------------
draw_grid:
    li $t0, 0x00FFFFFF       # White color
    li $t1, 10               # First vertical line
    li $t2, 0                # Y position
    li $t6, 32

vertical_one:
    mul $t3, $t2, $t6
    add $t3, $t3, $t1
    sll $t3, $t3, 2
    li $t4, 0x10008000
    add $t4, $t4, $t3
    sw $t0, 0($t4)

    addi $t2, $t2, 1
    blt $t2, 32, vertical_one

    li $t1, 20
    li $t2, 0

vertical_two:
    mul $t3, $t2, $t6
    add $t3, $t3, $t1
    sll $t3, $t3, 2
    li $t4, 0x10008000
    add $t4, $t4, $t3
    sw $t0, 0($t4)

    addi $t2, $t2, 1
    blt $t2, 32, vertical_two

    li $t1, 10
    li $t2, 0

horizontal_one:
    mul $t3, $t1, $t6
    add $t3, $t3, $t2
    sll $t3, $t3, 2
    li $t4, 0x10008000
    add $t4, $t4, $t3
    sw $t0, 0($t4)

    addi $t2, $t2, 1
    blt $t2, 32, horizontal_one

    li $t1, 20
    li $t2, 0

horizontal_two:
    mul $t3, $t1, $t6
    add $t3, $t3, $t2
    sll $t3, $t3, 2
    li $t4, 0x10008000
    add $t4, $t4, $t3
    sw $t0, 0($t4)

    addi $t2, $t2, 1
    blt $t2, 32, horizontal_two

    jr $ra

draw_marks:
    la $t0, board
    li $t1, 0
    li $t6, 32

marks_loop:
    bge $t1, 9, marks_done

    lb $t2, 0($t0)

    li $t3, 88
    beq $t2, $t3, draw_x

    li $t3, 79
    beq $t2, $t3, draw_o

    j next_mark

draw_x:
    li $t5, 0x00FF0000
    j calculate_position

draw_o:
    li $t5, 0x000000FF

calculate_position:
    move $t2, $t1
    li $t3, 3
    div $t2, $t3
    mflo $t4
    mfhi $t2

    mul $t2, $t2, 10
    addi $t2, $t2, 5

    mul $t4, $t4, 10
    addi $t4, $t4, 5

    li $t7, -1

draw_x_pixels:
    li $t8, -1

draw_y_pixels:
    add $t9, $t2, $t7
    add $t3, $t4, $t8
    mul $t3, $t3, $t6
    add $t3, $t3, $t9
    sll $t3, $t3, 2

    li $t9, 0x10008000
    add $t9, $t9, $t3
    sw $t5, 0($t9)

    addi $t8, $t8, 1
    blt $t8, 2, draw_y_pixels

    addi $t7, $t7, 1
    blt $t7, 2, draw_x_pixels

next_mark:
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j marks_loop

marks_done:
    jr $ra
    check_winner:
    li $v0, 0
    la $t0, wins
    la $t1, board
    li $t2, 0

check_line:
    bge $t2, 8, no_winner

    lb $t3, 0($t0)
    lb $t4, 1($t0)
    lb $t5, 2($t0)

    add $t6, $t1, $t3
    lb $t6, 0($t6)

    add $t7, $t1, $t4
    lb $t7, 0($t7)

    add $t8, $t1, $t5
    lb $t8, 0($t8)

    li $t9, 32
    beq $t6, $t9, next_line

    bne $t6, $t7, next_line
    bne $t6, $t8, next_line

    li $t9, 88
    beq $t6, $t9, x_winner

    li $t9, 79
    beq $t6, $t9, o_winner

next_line:
    addi $t0, $t0, 3
    addi $t2, $t2, 1
    j check_line

x_winner:
    li $v0, 4
    la $a0, x_wins
    syscall
    li $v0, 1
    jr $ra

o_winner:
    li $v0, 4
    la $a0, o_wins
    syscall
    li $v0, 1
    jr $ra

no_winner:
    jr $ra

###############################################################################
# TITLE: CharType		HWK #4
# AUTHOR: Ahmed Salah
# DATE: 3/2/2026
# DESCRIPTION: This program reads a line of characters then determines the type
# each character using a lookup table, followed by storing the results in a buffer
# and finally prints the corresponding character type numbers.
###############################################################################

.data 
	NL: .asciiz "\n"
	IN_BUFFER: 	 .space 80
	TYPE_BUFFER: .space 80
	PROMPT:		 .asciiz "Enter a new input line. \n"
	CHAR_TABLE:	.word 0x09, 6 # tab
			.word 0x0a, 6 # line feed
			.word 0x0d, 6 # carraige return
			.word ' ', 6
			.word '#', 5
			.word '$', 4
			.word '(', 4
			.word ')', 4
			.word '*', 3
			.word '+', 3
			.word ',', 4
			.word '-', 3
			.word '.', 4
			.word '/', 3
			.word '0', 1
			.word '1', 1
			.word '2', 1
			.word '3', 1
			.word '4', 1
			.word '5', 1
			.word '6', 1
			.word '7', 1
			.word '8', 1
			.word '9', 1
			.word ':', 4
			.word 'A', 2
			.word 'B', 2
			.word 'C', 2
			.word 'D', 2
			.word 'E', 2
			.word 'F', 2
			.word 'G', 2
			.word 'H', 2
			.word 'I', 2
			.word 'J', 2
			.word 'K', 2
			.word 'L', 2
			.word 'M', 2
			.word 'N', 2
			.word 'O', 2
			.word 'P', 2
			.word 'Q', 2
			.word 'R', 2
			.word 'S', 2
			.word 'T', 2
			.word 'U', 2
			.word 'V', 2
			.word 'W', 2
			.word 'X', 2
			.word 'Y', 2
			.word 'Z', 2
			.word 'a', 2
			.word 'b', 2
			.word 'c', 2
			.word 'd', 2
			.word 'e', 2
			.word 'f', 2
			.word 'g', 2
			.word 'h', 2
			.word 'i', 2
			.word 'j', 2
			.word 'k', 2
			.word 'l', 2
			.word 'm', 2
			.word 'n', 2
			.word 'o', 2
			.word 'p', 2
			.word 'q', 2
			.word 'r', 2
			.word 's', 2
			.word 't', 2
			.word 'u', 2
			.word 'v', 2
			.word 'w', 2
			.word 'x', 2
			.word 'y', 2
			.word 'z', 2
			.word 0x5c, -1 # '\' used as the end-of-table symbol
	
		
.text
.globl main
main:	
	# YOUR CODE HERE
main_loop:
	jal GET_USER_INPUT # GET_USER_INPUT();
	jal PROCESS_TYPES  # PROCESS_TYPES();
	jal PRINT_TYPES    # PRINT_TYPES();
	j main_loop 	   # while(1)

###############################################################################
# INPUT: IN_BUFFER
# OUTPUT: TYPE_BUFFER filled with char types
# MODIFIED: $t0, $t1, $t2, $t3, $t4, $a0 and $v0
###############################################################################
PROCESS_TYPES:
	# YOUR CODE HERE
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 0		# int i = 0;
PROCESS_LOOP:
    la $t1, IN_BUFFER
    addu $t1, $t1, $t0
    lb $t2, 0($t1)        	# IN_BUFFER[i]

    li $t3, '#'
    beq $t2, $t3, PROCESS_END   # while (IN_BUFFER[i] != '#')

    addi $sp, $sp, -4         # save i (push stack)
    sw $t0, 0($sp)            # save i

    move $a0, $t2             # argument = IN_BUFFER[i]
    jal GET_CHAR_CODE         # int type = GET_CHAR_CODE(IN_BUFFER[i]);

    lw $t0, 0($sp)            # restore i
    addi $sp, $sp, 4          # pop stack

    la $t4, TYPE_BUFFER
    addu $t4, $t4, $t0
    sb $v0, 0($t4)       	# TYPE_BUFFER[i] = type;

    addi $t0, $t0, 1    	# i++;
    j PROCESS_LOOP

PROCESS_END:

    la $t4, TYPE_BUFFER
    addu $t4, $t4, $t0
    li $t5, 5
    sb $t5, 0($t4)        	# TYPE_BUFFER[i] = 5;

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

###############################################################################
# INPUT: $a0
# OUTPUT: $v0
# MODIFIED: $t0, $t1, $t2, $t3
###############################################################################
GET_CHAR_CODE:
	# YOUR CODE HERE
	la $t0, CHAR_TABLE # int i = 0;
SEARCH_LOOP:
		lw $t1, 0($t0) # CHAR_TABLE[i].character
		lw $t2, 4($t0) # CHAR_TABLE[i].type
		
		li $t3, -1
		beq $t2, $t3, NOT_FOUND # return 0;
		
		beq $a0, $t1, FOUND # if( c == CHAR_TABLE[i].character)
		addi $t0, $t0, 8    # i++;
		j SEARCH_LOOP
FOUND:
	move $v0, $t2		    # return CHAR_TABLE[i].type;
	jr $ra
NOT_FOUND:
	li $v0, 0		    # return 0;
	jr $ra

###############################################################################
# INPUT: TYPE_BUFFER
# OUTPUT: printed char types
# MODIFIED: $t0, $t1, $t2, $t3, $t4, $a0, $v0
###############################################################################
PRINT_TYPES:
	# YOUR CODE HERE
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 0 	# int i = 0;
PRINT_LOOP:

    la $t1, TYPE_BUFFER
    addu $t1, $t1, $t0
    lb $t2, 0($t1)        # TYPE_BUFFER[i]

    li $t3, 5
    beq $t2, $t3, PRINT_LAST    # while (TYPE_BUFFER[i] != 5)

    li $t4, 6
    beq $t2, $t4, SKIP_PRINT    # if (TYPE_BUFFER[i] != 6)

    move $a0, $t2
    li $v0, 1
    syscall            # printf("%d", TYPE_BUFFER[i]);

SKIP_PRINT:
    addi $t0, $t0, 1    # i++;
    j PRINT_LOOP

PRINT_LAST:

    li $a0, 5
    li $v0, 1
    syscall            # printf("5");

    la $a0, NL
    li $v0, 4
    syscall            # printf("\n");

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

###############################################################################
# INPUT: No input
# OUTPUT: IN_BUFFER contains user input
# MODIFIED: $a0, $a1 and $v0
###############################################################################
GET_USER_INPUT:
	# YOUR CODE HERE
	la $a0, PROMPT		# $a0 = &PROMPT	
	li $v0, 4
	syscall			# printf(PROMPT);
	
	la $a0, IN_BUFFER 	# $a0 = &IN_BUFFER[0]
	li $a1, 80	  	# $a1 = 80;
	li $v0, 8
	syscall			# fgets(IN_BUFFER, 80, stdin);
	
	jr $ra			# return;
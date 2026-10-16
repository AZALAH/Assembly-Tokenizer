###############################################################################
# TITLE: 	HWK #6
# AUTHOR: Ahmed Salah	
# DATE: 4/6/2026 (updated 10/16/2026)	
# DESCRIPTION: This program builds upon HW5 by taking the tokenized input from TAB_TOKEN and processing it to build a Symbol Table. 
# It scans each token to determine if it is a label definition or a symbol reference, 
# stores each symbol along with its address and declaration status into the symbol table,
# and prints the results in a formatted table.
###############################################################################

.data 
	IN_BUFFER: 	.space 80
	TYPE_BUFFER:	.space 80
	TAB_TOKEN:	.space 240 	# 20 entries of 3 words each = 20 * 3 * 4 = 240
	TAB_SYMBOL:	.space 1600	# 100 entries of 4 words each = 100 * 4 * 4 = 1600

	PROMPT:		.asciiz "Enter a new input line. \n"
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

	PARSE_STATE_TABLE:
		Q0: 	.word FSA_ACT_1
			.word Q1  # T1
			.word Q1  # T2
			.word Q1  # T3
			.word Q1  # T4
			.word Q1  # T5
			.word Q1  # T6
			.word Q11 # T7
			
		Q1: 	.word FSA_ACT_2
			.word Q2  # T1
			.word Q5  # T2
			.word Q3  # T3
			.word Q3  # T4
			.word Q4  # T5
			.word Q0  # T6
			.word Q11 # T7

		Q2: 	.word FSA_ACT_1
			.word Q6  # T1
			.word Q7  # T2
			.word Q7  # T3
			.word Q7  # T4
			.word Q7  # T5
			.word Q7  # T6
			.word Q11 # T7

		Q3: 	.word FSA_ACT_4
			.word Q0  # T1
			.word Q0  # T2
			.word Q0  # T3
			.word Q0  # T4
			.word Q0  # T5
			.word Q0  # T6
			.word Q11 # T7

		Q4: 	.word FSA_ACT_4
			.word Q10 # T1
			.word Q10 # T2
			.word Q10 # T3
			.word Q10 # T4
			.word Q10 # T5
			.word Q10 # T6
			.word Q11 # T7

		Q5: 	.word FSA_ACT_1
			.word Q8  # T1
			.word Q8  # T2
			.word Q9  # T3
			.word Q9  # T4
			.word Q9  # T5
			.word Q9  # T6
			.word Q11 # T7

		Q6: 	.word FSA_ACT_3
			.word Q2  # T1
			.word Q2  # T2
			.word Q2  # T3
			.word Q2  # T4
			.word Q2  # T5
			.word Q2  # T6
			.word Q11 # T7

		Q7: 	.word FSA_ACT_4
			.word Q1  # T1
			.word Q1  # T2
			.word Q1  # T3
			.word Q1  # T4
			.word Q1  # T5
			.word Q1  # T6
			.word Q11 # T7

		Q8: 	.word FSA_ACT_3
			.word Q5  # T1
			.word Q5  # T2
			.word Q5  # T3
			.word Q5  # T4
			.word Q5  # T5
			.word Q5  # T6
			.word Q11 # T7

		Q9: 	.word FSA_ACT_4
			.word Q1  # T1
			.word Q1  # T2
			.word Q1  # T3
			.word Q1  # T4
			.word Q1  # T5
			.word Q1  # T6
			.word Q11 # T7

		Q10: 	.word FSA_ACT_RETURN
			.word Q10 # T1
			.word Q10 # T2
			.word Q10 # T3
			.word Q10 # T4
			.word Q10 # T5
			.word Q10 # T6
			.word Q11 # T7

		Q11: 	.word FSA_ACT_ERROR
			.word Q4 # T1
			.word Q4 # T2
			.word Q4 # T3
			.word Q4 # T4
			.word Q4 # T5
			.word Q4 # T6
			.word Q4 # T7 	
	TOKEN_HEADER:   .ascii  "      Token               Token Type  \n"	# 6 spaces before 'token', 
			.asciiz "-----------------     ----------------\n"	# 31 spaces until gap between 'Token' and 'Type'

	SYMBOL_HEADER: 	.ascii  "\n      Symbol          Address             Declaration\n"
			.asciiz "  --------------  ------------------  -------------------\n      "
	HEX_PREFIX:	.asciiz "0x"
	LONG_SPACE_1:	.asciiz "          "
	LONG_SPACE_2:	.asciiz "      "
	DUMMY_HEX:	.asciiz "0x01234567"
	NEWLINE:	.asciiz "\n"	
					
.text
MAIN:	
	# 0
	jal CLEAR_TAB_SYMBOL
	# YOUR CODE HERE: ALLOCATE and initialize struct symbol_overhead so;
	addi $sp, $sp, -8
	sw $zero, 4($sp)			# so.ts_index = 0
	li $t0, 0x400
	sw $t0, 0($sp)
	move $s0, $sp			# so.LOC = 0x400
_MAIN_LOOP:
	# 1
	jal GET_USER_INPUT		# GET_USER_INPUT();

	# 2
	jal PROCESS_INPUT		# PROCESS_INPUT();
	
	# 3
	jal PRINT_CHAR_TYPES		# PRINT_CHAR_TYPES();

	# 4 
	jal PROCESS_TOKENS		# PROCESS_TOKENS();
	
	# 5
	jal PRINT_TOKENS			# PRINT_TOKENS();
	
	# YOUR CODE HERE: CALL PROCESS_SYMBOLS
	move $a0, $s0
	jal PROCESS_SYMBOLS			# PROCESS_SYMBOLS(&so)
	# YOUR CODE HERE: CALL PRINT_SYMBOLS
	move $a0,$s0
	jal PRINT_SYMBOLS			# PRINT_SYMBOLS(&so)
	# YOUR CODE HERE: UPDATE LOC
	lw $t0, 0($s0)				# so.LOC
	addi $t0, $t0, 4				# so.LOC + 4
	sw $t0, 0($s0)				# so.LOC += 4
	# LOOP
	j _MAIN_LOOP
	# YOUR CODE HERE: DEALLOCATE symbol_overhead so
	addi $sp, $sp, 8
	jal EXIT_PROGRAM		# EXIT_PROGRAM();
###############################################################################
# INPUT: 	NA
# OUTPUT: TAB_SYMBOL IS CLEARED MEANING ALL ENTRIES ARE SET TO 0 NOW
# MODIFIED: TAB_SYMBOL
###############################################################################
CLEAR_TAB_SYMBOL:

	# YOUR CODE HERE
	li $t0, 0			# i = 0;
C_T_S_LOOP:
	bge $t0, 100, C_T_S_DONE		# while(i < 100)
		
	li $t1, 16
	mul $t2, $t0, $t1		#offset = i * 16
	
	la $t3, 	TAB_SYMBOL
	add $t4, $t3, $t2		# TAB_SYMBOL[i]
	
	sw $zero, 0($t4)			#TAB_SYMBOL[i].name[First 4 characters] = 0
	sw $zero, 4($t4)			#TAB_SYMBOL[i].name[Next 4 characters] = 0
	sw $zero, 8($t4)			# TAB_SYMBOL[i].addr = 0
	sw $zero, 12($t4)		# TAB_SYMBOL[i].status = 0
	
	addi $t0, $t0, 1			# i += 1
	j C_T_S_LOOP	
C_T_S_DONE:
 	jr $ra 				# return
###############################################################################
# INPUT: 	$a0 as "struct symbol_overhead* so"
# OUTPUT: TAB_SYMBOL BUT NOW FILLED WITH DECTECTED SYMBOLS
# MODIFIED: TAB_SYMBOL and so->ts_index
###############################################################################
PROCESS_SYMBOLS:	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 1		# 	int param_start = 1
	li $t1, 0		# 	int i = 0
	
	la $t2, TAB_TOKEN	
	li $t3, 12
	add $t4, $t2, $t3
	lb $t5, 0($t4)
	li $t6, ':'
	bne $t5, $t6, P_S_IF	# 	if(TAB_TOKEN[1],text[0] != ':')
	
	move $a1, $t2		# 	TAB_TOKEN[0].text
	li $a2, 1		
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $a0, 12($sp)
	jal ADD_SYMBOL_TO_TABLE	# 	add_symbol_to_table(so, TAB_TOKEN[0].text, 1)
	lw $a0, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 16
	li $t1, 3		# 	i = 3
	j P_S_LOOP
P_S_IF:
	li $t1, 1		# 	i = 1
P_S_LOOP:
	li $t3, 12
	mul $t4, $t1, $t3
	add $t5, $t2, $t4
	lb $t6, 0($t5)
	li $t7, '#'
	beq $t6, $t7, P_S_DONE	# 	if(TAB_TOKEN[i].text[0] == '#') return
	lw $t8, 8($t5)
	li $t9, 2
	bne $t8, $t9, P_S_COMMA	# 	if(TAB_TOKEN[i].type != 2
	beq $t0, 1, P_S_SYM_ADD	# 	if(param_start == 1)
	j P_S_ELSE
P_S_SYM_ADD:
	move $a1, $t5
	li $a2, 0
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $a0, 12($sp)
	jal ADD_SYMBOL_TO_TABLE	# 	add_symbol_to_table(so, TAB_TOKEN[i[].text, 0)
	lw $a0, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 16
	j P_S_CONTINUE
P_S_ELSE:
	li $t0, 0		# 	param_start = 0
	j P_S_CONTINUE
P_S_COMMA:
	li $t9, ','
	bne $t6, $t9, P_S_ELSE	# 	if(TAB_TOKEN[i].text[0] != ',')
	li $t0, 1		# 	param_start = 1
P_S_CONTINUE:
	addi $t1, $t1, 1		# 	i = i + 1
	j P_S_LOOP
P_S_DONE:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra			# return
###############################################################################
# INPUT: 	$a0 as "struct symbol_overhead* so"
#		$a1 as "char* text" for the token being made into a symbol
#		$a2 as "boolean type": definition (1), reference (0)
# OUTPUT: NOW SYMBOLS ARE BEING ADDED TO TAB_SYMBOL
# MODIFIED: TAb_SYMBOL, so->ts_index
###############################################################################
ADD_SYMBOL_TO_TABLE:
	# YOUR CODE HERE
	li $t0, 0			# int i = 0
A_S_TT_LOOP:
	bge $t0, 8, A_S_TT_DONE		# while(i < 8)
	
	lw $t1, 4($a0)
	li $t2, 16
	mul $t3, $t1, $t2
	la $t4, TAB_SYMBOL
	add $t5, $t4, $t3 		# TAB_SYMBOL[so->ts_index]
	
	add $t6, $a1, $t0
	lb $t7, 0($t6)			# text[i]
	
	add $t8, $t5,$t0
	sb $t7, 0($t8)			# TAB_SYMBOL[so->ts_index.name[i] = text[i]
	
	addi $t0, $t0, 1
	j A_S_TT_LOOP
A_S_TT_DONE:
	lw $t1, 4($a0)
	li $t2, 16
	mul $t3, $t1, $t2
	la $t4, TAB_SYMBOL
	add $t5, $t4, $t3		# TAB_SYMBOL[so->ts_index]
	
	lw $t9, 0($a0)
	sw $t9, 8($t5)			# TAB_SYMBOL[so->ts_index].addr = so->LOC
	sw $a2, 12($t5)			# TAB_SYMBOL[so->ts_index].status = type
	
	lw $t1, 4($a0)
	addi $t1, $t1, 1
	sw $t1, 4($a0)			# so->ts_index += 1
	jr $ra				# return
###############################################################################
# INPUT: 	$a0 as "struct symbol_overhead* so"
# OUTPUT:	NA
# MODIFIED:	$t0, $t1, $t2, $t3, $t4
###############################################################################
PRINT_SYMBOLS:

	# Print out the static text
	sub $sp, $sp, 4
	sw $a0, ($sp)			# PUSH ($a0)
	la $a0, SYMBOL_HEADER
	li $v0, 4
	syscall
	lw $a0, ($sp)
	add $sp, $sp, 4			# POP ($a0)
	
	
	li $t0, 0			# int i = 0;
	lw $t1, 4($a0)			# so->ts_index
	
_PRINT_SYM_LOOP:
	bge $t0, $t1, _PRINT_SYM_DONE
	
	# A) Print out the token name
	mul $t2, $t0, 16
	la $t3, TAB_SYMBOL
	add $t3, $t2, $t3

	sub $sp, $sp, 4
	sw $a0, ($sp)			# PUSH ($a0)
	li $t4, 0
_PRINT_SYM_NAME:
	bge $t4, 8, _PRINT_SYM_NAME_DONE
	add $t5, $t3, $t4
	lb $a0, ($t5)
	beq $a0, 0, _PRINT_SYM_NAME_DONE
	li $v0, 11
	syscall
	add $t4, $t4, 1
	j _PRINT_SYM_NAME
	
_PRINT_SYM_NAME_DONE:
	li $v0, 11
	li $a0, ' '
_PRINT_SYM_PAD_LOOP:
	bge $t4, 16, _PRINT_SYM_PAD_DONE
	syscall
	add $t4, $t4, 1
	j _PRINT_SYM_PAD_LOOP
	
_PRINT_SYM_PAD_DONE:					
	lw $a0, ($sp)
	add $sp, $sp, 4			# POP ($a0)
			

	# B) Print out the hex number... 
	lw $t4, 8($t3)
	sub $sp, $sp, 4
	sw $a0, ($sp)			# PUSH ($a0)
	sub $sp, $sp, 4
	sw $t0, ($sp)			# PUSH ($t0)
	sub $sp, $sp, 4
	sw $t1, ($sp)			# PUSH ($t1)
	sub $sp, $sp, 4
	sw $t2, ($sp)			# PUSH ($t2)
	sub $sp, $sp, 4
	sw $t3, ($sp)			# PUSH ($t3)
	sub $sp, $sp, 4
	sw $ra, ($sp)			# PUSH ($ra)
	move $a0, $t4
	jal PRINT_HEX
	la $a0, LONG_SPACE_1
	li $v0, 4
	syscall
	lw $ra, ($sp)
	add $sp, $sp, 4			# POP ($ra)
	lw $t3, ($sp)
	add $sp, $sp, 4			# POP ($t3)
	lw $t2, ($sp)
	add $sp, $sp, 4			# POP ($t2)
	lw $t1, ($sp)
	add $sp, $sp, 4			# POP ($t1)
	lw $t0, ($sp)
	add $sp, $sp, 4			# POP ($t0)
	lw $a0, ($sp)
	add $sp, $sp, 4			# POP ($a0)
	
	
	# C) Print out the type number...
	lw $t4, 12($t3)
	sub $sp, $sp, 4		
	sw $a0, ($sp)			# PUSH ($a0)
	move $a0, $t4
	li $v0, 1
	syscall
	lw $a0, ($sp)
	add $sp, $sp, 4			# POP ($a0)


	# End of line code
	sub $sp, $sp, 4
	sw $a0, ($sp)			# PUSH ($a0)
	li $v0, 4
	la $a0, NEWLINE
	syscall
	la $a0, LONG_SPACE_2
	syscall
	lw $a0, ($sp)
	add $sp, $sp, 4			# POP ($a0)
	
	
	# Update
	add $t0, $t0, 1			# i = i + 1;
	j _PRINT_SYM_LOOP


_PRINT_SYM_DONE:
	li $v0, 4
	la $a0, NEWLINE
	syscall
	jr $ra



###############################################################################
# INPUT: 	$a0 as the number to print in hex
# OUTPUT:	prints hexadecimal to the console now
# MODIFIED: $v0 and $a0 only
###############################################################################
PRINT_HEX:
	move $t0, $a0			# int value = input
	li $v0, 4
	la $a0, HEX_PREFIX
	syscall
	
	li $t1, 28			# int shift = 28
P_HX_LOOP:
	blt $t1, 0 PX_HX_DONE		# while(shift >= 0)
	
	srlv $t2, $t0, $t1		# value >> shift
	andi $t2, $t2, 0xF		# digit = value >> shift & 0xF
	
	li $t3, 10
	blt $t2, $t3, P_HX_DIGIT		# if(digit < 10)
	
	addi $t2, $t2, 55		# digit + 'A' - 10
	j P_HX_PRINT_CHAR
P_HX_DIGIT:
	addi $t2, $t2, 48		# digit + '0'
P_HX_PRINT_CHAR:
	li $v0, 11
	move $a0, $t2
	syscall
	
	addi $t1, $t1, -4		# shift -= 4
	j P_HX_LOOP
PX_HX_DONE:	
	jr $ra				# return
###############################################################################
# INPUT: 	NA
# OUTPUT:	NA
# MODIFIED:	$t0, $t1, $t2, $t3, $t4, $t5
###############################################################################
PRINT_TOKENS:
	la $a0, TOKEN_HEADER
	li $v0, 4
	syscall				# printf("%s", TOKEN_HEADER);
	
	li $t0, 0			# int tt_index = 0;
_PRINT_TOKENS_LOOP:

	li $t1, 0			# int chars_printed = 0;
	mul $t2, $t0, 12
	lb $t3, TAB_TOKEN($t2)		
	beq $t3, 0, _PRINT_TOKENS_DONE	# while (tab_token[0] != 0) {


	_PRINT_TOKENS_LSPACE:
	bge $t1, 6, _PRINT_SINGLE_TOKEN	# 	while (chars_printed < 5) {
	la $a0, ' '
	li $v0, 11
	syscall				# 		printf(" ");
	add $t1, $t1, 1			# 		chars_printed += 1;
	j _PRINT_TOKENS_LSPACE		# 	}
	
	
	_PRINT_SINGLE_TOKEN:
	li $t4, 0			# 	int token_chars_printed = 0;
	_PRINT_SINGLE_LOOP:
	bge $t4, 8, _PRINT_TYPE_LSPACE	# 	while (chars_printed < 8) {
	add $t5, $t2, $t4		
	lb $a0, TAB_TOKEN($t5)
	beq $a0, 0, _PRINT_TYPE_LSPACE	# 		if (tab_token[tt_index + token_chars_printed] == 0) break;
	li $v0, 11
	syscall				# 		printf("%c", tab_token[token_chars_printed]);
	add $t4, $t4, 1			# 		token_chars_printed += 1;
	add $t1, $t1, 1			# 		chars_printed += 1;
	j _PRINT_SINGLE_LOOP		# 	}

				
	_PRINT_TYPE_LSPACE:
	bge $t1, 31, _PRINT_TYPE	# 	while (chars_printed < 31) {
	la $a0, ' '
	li $v0, 11
	syscall				# 		printf(" ");
	add $t1, $t1, 1			# 		chars_printed += 1;
	j _PRINT_TYPE_LSPACE		# 	}
	
	
	_PRINT_TYPE:
	add $t2, $t2, 8	
	lw $a0, TAB_TOKEN($t2)		
	li $v0, 1
	syscall				# 	printf("%d", tab_token[8,9,10,11]);
	la $a0, NEWLINE
	li $v0, 4
	syscall				# 	printf("\n");
	
	
	add $t0, $t0, 1			# 	tt_index += 1;
	j _PRINT_TOKENS_LOOP		# }
	

_PRINT_TOKENS_DONE:
	jr $ra
###############################################################################
# INPUT: 	$a0 holds pointer to parse_variables structure
# OUTPUT:	NA
# MODIFIED:	$t0, $t1, $t2 and $t3
###############################################################################
FSA_ACT_1:
	# YOUR CODE HERE
	lw  $t0, 4($a0)		
	la $t1, IN_BUFFER
	add $t2, $t1, $t0		# 	pv->cur_char = IN_BUFFER[pv->char_index];
	lb $t3, 0($t2)
	sw $t3, 8($a0)
	
	la $t1, TYPE_BUFFER
	add $t2, $t1, $t0		#	pv->cur_type = TYPE_BUFFER[pv->char_index];
	lb $t3, 0($t2)
	sw $t3, 12($a0)
	
	addi $t0, $t0, 1			#	pv->char_index += 1;
	sw $t0, 4($a0)
	jr $ra				#	return;
###############################################################################
# INPUT: 	$a0 holds pointer to parse_variables structure
# OUTPUT:	NA
# MODIFIED:	$t0, $t1, $t2, $t3, $t4 and $t5
###############################################################################
FSA_ACT_2:
	# YOUR CODE HERE
	lw $t0, 16($a0)
	lw $t1, 8($a0)
	la $t2, TAB_TOKEN		#	TAB_TOKEN[pv->tt_index].text[0] = pv->cur_char;
	mul $t3, $t0, 12	
	add $t4, $t2, $t3
	sb $t1, 0($t4)
	
	li $t5, 7
	sw $t5, 20($a0)			#	pv->token_space = 7;
	jr $ra
###############################################################################
# INPUT: 	$a0 holds pointer to parse_variables structure
# OUTPUT:	NA
# MODIFIED:	$t0, $t1, $t2, $t3, $t4 and $t5
###############################################################################
FSA_ACT_3:
	# YOUR CODE HERE
	lw $t0, 16($a0)
	lw $t1, 8($a0)			
	lw $t2, 20($a0)			# 	offset = 8 - pv->token_space;
	
	la $t3, TAB_TOKEN
	mul $t4, $t0, 12
	add $t4, $t3, $t4
	li $t5, 8			#	TAB_TOKEN[pv->tt_index].text[offset] = pv->cur_char;
	sub $t5, $t5, $t2
	add $t4, $t4, $t5
	sb $t1, 0($t4)
	
	addi $t2, $t2, -1		#	pv->token_space -= 1;
	sw $t2, 20($a0)
	jr $ra
###############################################################################
# INPUT: 	$a0 holds pointer to parse_variables structure
# OUTPUT:	NA
# MODIFIED:	$t0, $t1, $t2, $t3 and $t4
###############################################################################
FSA_ACT_4:

	# YOUR CODE HERE
	lw $t0, 0($a0)
	la $t1, Q4
	beq $t0, $t1, IS_Q4		#	if(pv->stare == IS_Q4) 
	la $t1, Q7
	beq $t0, $t1, IS_Q7		#	else if(pv->state == IS_Q7)
	la $t1, Q9
	beq $t0, $t1, IS_Q9		#	else if(pv->state == Q9)
	lw $t4, 12($a0)			#	token_type = pv->cur_type;	
	j FINISH
IS_Q4:
	li $t4, 5			#	token_type = 5;
	j FINISH
IS_Q7:
	li $t4, 1			#	token_type = 1;
	j FINISH
IS_Q9:
	li $t4, 2			#	token_type = 2;
	j FINISH
FINISH:
	lw $t0, 16($a0)
	la $t1, TAB_TOKEN
	mul $t2, $t0, 12
	add $t3, $t1, $t2
	sw $t4, 8($t3)			#	TAB_TOKEN[pv->tt_index].type = token_type;
	addi $t0, $t0, 1			#	pv->tt_index += 1;
	sw $t0, 16($a0)
	li $t0, 8
	sw $t0, 20($a0)			# 	pv->token_space = 8;
	jr $ra				# 	return;
###############################################################################
# INPUT: 	$a0 holds pointer to parse_variables structure
# OUTPUT:	$v0 set 0
# MODIFIED:	NA
###############################################################################
FSA_ACT_RETURN:
	# YOUR CODE HERE
	li $v0, 0
	jr $ra			# 	return 0;		
###############################################################################
# INPUT: 	$a0 holds pointer to parse_variables structure
# OUTPUT:	$v0 set 1
# MODIFIED:	NA
###############################################################################
FSA_ACT_ERROR:
	# YOUR CODE HERE
	li $v0, 1
	jr $ra			# 	return 1;	
###############################################################################
# INPUT: 	NA
# OUTPUT:	NA
# MODIFIED:	$t0 and $t1
###############################################################################
CLEAR_TAB_TOKEN:
	# YOUR CODE HERE
	li $t0, 0
	la $t1, TAB_TOKEN
LOOP:
	beq $t0, 240, LOOP_DONE	#	for (int i = 0; i < 240; i++)
	sb $zero, 0($t1)		#	TAB_TOKEN[i] = 0;
	addi $t1, $t1, 1
	addi $t0, $t0, 1		#	i++
	j LOOP
LOOP_DONE:
	jr $ra			#	return 0;
###############################################################################
# INPUT: 	NA
# OUTPUT:	$v0 holds 0 if everything is OK, 1 otherwise
# MODIFIED:	$t0, $t1, $t2, $ra
###############################################################################
PROCESS_TOKENS:
	# YOUR CODE HERE
	addi $sp, $sp, -28
	sw $ra, 24($sp)
	jal CLEAR_TAB_TOKEN	#	CLEAR_TAB_TOKEN()
	sw $zero, 0($sp)		#	pv->state = 0;
	sw $zero, 4($sp)		#	pv->char_index = 0;
	sw $zero, 8($sp)		#	pv->cur_char = 0;
	sw $zero, 12($sp)	#	pv->cur_type = 0;
	sw $zero, 16($sp)	#	pv->tt_index = 0;
	sw $zero, 20($sp)	#	pv->token_space = 0;
	
	la $t0, Q0		#	pv->state = Q0
	sw $t0, 0($sp)
PROCESS_TOKEN_LOOP:
	lw $t0, 0($sp)
	lw $t1, 0($t0)
	move $a0, $sp
	jalr $t1
	beq $v0, 1, PROCESS_TOKEN_DONE		# 	if(v0 == 1) return
	beq $v0, 0, PROCESS_TOKEN_DONE		# 	if(v0 == 0) return
	lw $t0, 0($sp)
	lw $t2, 12($sp)
	sll $t2, $t2, 2				#	pv->cur_type * 4
	add $t0, $t0, $t2
	lw $t0, 0($t0)
	sw $t0, 0($sp)
	j PROCESS_TOKEN_LOOP
PROCESS_TOKEN_DONE:
	lw $ra, 24($sp)
	addi $sp, $sp, 28
	jr $ra
###############################################################################
# INPUT: 	NA
# OUTPUT:	NA
# MODIFIED:	$t0, $t1, $t2, $t3, $t4, $a0 and $v0
###############################################################################
PROCESS_INPUT:
	# YOUR CODE HERE (From the last homework assignment)
# YOUR CODE HERE
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 0		# 	int i = 0;
PROCESS_LOOP:
    la $t1, IN_BUFFER
    addu $t1, $t1, $t0
    lb $t2, 0($t1)              # 	IN_BUFFER[i]

    li $t3, '#'
    beq $t2, $t3, PROCESS_END  #		while (IN_BUFFER[i] != '#')
    li $t3, 0x0a
    beq $t2, $t3, PROCESS_FIX_END	#		a line without '#' ends at the newline
    beq $t2, $zero, PROCESS_FIX_END

    addi $sp, $sp, -4          #		save i (push stack)
    sw $t0, 0($sp)             # 	save i

    move $a0, $t2              # 	argument = IN_BUFFER[i]
    jal GET_CHAR_CODE          #		int type = GET_CHAR_CODE(IN_BUFFER[i]);

    lw $t0, 0($sp)             #		restore i
    addi $sp, $sp, 4           #		pop stack

    la $t4, TYPE_BUFFER
    addu $t4, $t4, $t0
    sb $v0, 0($t4)            #		TYPE_BUFFER[i] = type;

    addi $t0, $t0, 1    	     #		i++;
    j PROCESS_LOOP

PROCESS_FIX_END:
    li $t3, '#'
    sb $t3, 0($t1)            #		IN_BUFFER[i] = '#';
PROCESS_END:

    la $t4, TYPE_BUFFER
    addu $t4, $t4, $t0
    li $t5, 5
    sb $t5, 0($t4)        	#  	TYPE_BUFFER[i] = 5;
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
###############################################################################
# INPUT: 	$a0 as the input char
# OUTPUT:	$v0 as the output code
# MODIFIED:	$t0, $t1, $t2,  and $t3
###############################################################################
GET_CHAR_CODE:
	# YOUR CODE HERE (From the last homework assignment)
	la $t0, CHAR_TABLE 		# 	int i = 0;
SEARCH_LOOP:
		lw $t1, 0($t0) 		# 	CHAR_TABLE[i].character
		lw $t2, 4($t0)         	#	CHAR_TABLE[i].type
		
		li $t3, -1
		beq $t2, $t3, NOT_FOUND #	return 0;
		
		beq $a0, $t1, FOUND     #	if( c == CHAR_TABLE[i].character)
		addi $t0, $t0, 8        # 	i++;
		j SEARCH_LOOP
FOUND:
	move $v0, $t2		    	# 	return CHAR_TABLE[i].type;
	jr $ra
NOT_FOUND:
	li $v0, 0		    	# 	return 0;
	jr $ra
###############################################################################
# INPUT: 	NA
# OUTPUT:	NA
# MODIFIED:	$t0, $t1
###############################################################################
PRINT_CHAR_TYPES:
	li $t0, 0			# i = 0;

_PRINT_CT_LOOP:
	lb $t1, TYPE_BUFFER($t0)		# OUTPUT[i]
	beq $t1, 6, _PRINT_CT_ONE_SPACE
_PRINT_CT_ONE_NUM:
	li $v0, 1
	move $a0, $t1			
	syscall				# Print a single NUMBER
	j _PRINT_CT_POST_NUM_OR_SPACE
_PRINT_CT_ONE_SPACE:
	li $v0, 11
	li $a0, 32			# Print a ' ' character
	syscall
_PRINT_CT_POST_NUM_OR_SPACE:																
	add $t0, $t0, 1			# i += 1
	bne $t1, 5, _PRINT_CT_LOOP	# if (OUTPUT[i] != '#') GOTO LOOP 	

_PRINT_CT_LOOP_DONE:
	li $v0, 11
	li $a0, 10			# Print a '\n' character
	syscall

	jr $ra				# return
###############################################################################
# INPUT: 	NA
# OUTPUT: 	NA
# MODIFIED: 	$v0, $a0, $a1
###############################################################################
GET_USER_INPUT:
	li $v0, 4			# PRINT PROMPT
	la $a0, PROMPT	
	syscall
	
	li $v0, 8			# FGETS
	la $a0, IN_BUFFER
	li $a1, 80	
	syscall
	
	lb $t0, IN_BUFFER
	beq $t0, $zero, EXIT_PROGRAM	# no more input: exit
	jr $ra	
###############################################################################
# INPUT: 	NA
# OUTPUT: 	NA
# MODIFIED: 	$v0
###############################################################################
EXIT_PROGRAM:
	li $v0, 10			# HALT
	syscall	
	jr $ra
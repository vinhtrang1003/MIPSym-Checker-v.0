# Vinh Trang HW 8.3
	.data
space:	.asciiz " "
askrow:	.asciiz "Please enter row number: (-1 to exit) "
askcol:	.asciiz "Please enter column number: "
askval:	.asciiz "Please enter value number(1=r/3=w/5=R/7=W/0=remove): "
askvalid:	.asciiz "Is this valid? (1 to store into array / 0 cancel) "
legal:	.asciiz "legal position "
illegal:	.asciiz "illegal position "
r:	.asciiz "r "
R:	.asciiz "R "
w:	.asciiz "w "
W:	.asciiz "W "
color0m:	.asciiz "Color = 0 (red) \nMoves: "
color0j:	.asciiz "Color = 0 (red) \nJumps: "
color1m:	.asciiz "Color = 0 (white) \nMoves: "
color1j:	.asciiz "Color = 0 (white) \nJumps: "
total:	.asciiz "Total Tupples equal: "
slash:	.asciiz " | "
newln:	.asciiz "\n"
	.globl main
	.code
	
main:
	addi	$sp,$sp,-144	#allocate board to array
	mov		$s0,$sp
# while loop for board
	li	$t6,5			#let rcount = 5, r>=0, r--
	li	$t7,0			#let ccount = 0, c<6, c++
whileboard:
	li	$t0,0
	li	$t1,0
	
	# mul	$t0,$t6,6			# $t0 = r*6
	sll	$t0,$t6,2
	sll	$t1,$t6,1
	add	$t0,$t0,$t1
	# use sll instead
	add	$t0,$t0,$t7			#   " idx = $t0 + c
	sll	$t0,$t0,2			# offset = idx *4 bytes
	add	$sp,$sp,$t0		# "
	sw	$0,($sp)			# "
	
	mov	$sp,$s0
	
	addi	$t7,1	#c++
ccheck:
	blt	$t7,6,whileboard
	addi	$t6,-1
	li		$t7,0
rcheck:
	bge	$t6,0,whileboard
	
#Finish setup board to 0 now print board
	j	ploopr

Mainloop:
# Ask for row	
	la	$a0,askrow
	syscall	$print_string
	
	syscall	$read_int			#read row into $t6
	mov	$t6,$v0		
	
	beq	$t6,-1,tupples			#If user enter -1 move to HW8.3
	
# Ask for column	
	la	$a0,askcol
	syscall	$print_string
	
	syscall	$read_int			#read col into $t7
	mov	$t7,$v0			
# Ask for value	(1=red, 3=white, 5=redking, 7=whiteking)		
	la	$a0,askval
	syscall	$print_string
	
	syscall	$read_int			#read val into $t1
	mov	$t1,$v0			
	
	
	j	afunc					#Call assign function
endassign:

#	Print the board again	
	j	ploopr


# Now print out the values of the board

ploopr:
	li	$t6,5			#let rcount = 5, r>=0, r++
	li	$t7,0			#let ccount = 0, c<6, c++
ploopc:
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7		#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	add	$sp,$sp,$t0		# "
# put code Below for problem 5.4

	li	$t9,0
	add	$t9,$t6,$t7		# sum row and column
	andi	$t9,$t9,1	# And their sum with 1 to have 1 or 0, 1 = odd (white), 0 = even (black)
	beq	$t9,0,black		# Print black if $t9 = 0
	
	lw	$t8,($sp)
	beq	$t8,1,redpiece
	beq	$t8,3,whitepiece
	beq	$t8,5,redking
	beq	$t8,7,whiteking
	#otherwise empty white space
	li	$a0,32			# Else print white space
	syscall	$print_char
	mov		$sp,$s0
	li	$a0,32			# Make it look square rather than rectangle
	syscall	$print_char
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
black:
	li	$a0,219			# Else print black square
	syscall	$print_char
	li	$a0,219			# Make it look square rather than rectangle
	syscall	$print_char
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
redpiece:
	la	$a0,r		
	syscall	$print_string
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
whitepiece:
	la	$a0,w		
	syscall	$print_string
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
redking:
	la	$a0,R		
	syscall	$print_string
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
whiteking:
	la	$a0,W		
	syscall	$print_string
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck

#put code Above for problem 5.4	

pccheck:
	blt	$t7,6,ploopc
	addi	$t6,-1	#r--
	li		$t7,0
	
	la	$a0,newln
	syscall	$print_string
	
prcheck:
	bge	$t6,0,ploopc
	j	Mainloop
	
	
	
# Assign function:
afunc:						# $t6 = row variable, $t7 = column variable
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	add	$sp,$sp,$t0
	sw	$t1,($sp)
	
	mov		$sp,$s0
	
	j	endassign
	
# HW 8.3 start here#########################################

tupples:
	
	la	$a0,color0m
	syscall	$print_string
	
	la	$a0,newln
	syscall	$print_string
	
	li	$s5,0	#colorcode = 0
	
	addi	$sp,$sp,-384	# Allocate array [24][4]
	mov		$s1,$sp			# Save array pointer to $s1
	

	
	j	movemain

	
tupples1:	
	addi	$sp,$sp,384	# Dellocate array [24][4]
	la	$a0,color0j
	syscall	$print_string
	
	la	$a0,newln
	syscall	$print_string
	
	li	$s5,0	#colorcode = 0
	
	addi	$sp,$sp,-384	# Allocate array [24][4]
	mov		$s6,$sp			# Save array pointer to $s6

	
	j	jumpmain

	
tupples2:
	addi	$sp,$sp,384	# Dellocate array [24][4]
	
	la	$a0,color1m
	syscall	$print_string
	
	la	$a0,newln
	syscall	$print_string
	
	li	$s5,1	#colorcode = 1
	
	addi	$sp,$sp,-384	# Allocate array [24][4]
	mov		$s6,$sp			# Save array pointer to $s6

	
	j	movemain
tupples3:
	addi	$sp,$sp,384	# Dellocate array [24][4]	

	la	$a0,color1j
	syscall	$print_string
	
	la	$a0,newln
	syscall	$print_string
	
	li	$s5,1	#colorcode = 1
	
	addi	$sp,$sp,-384	# Allocate array [24][4]
	mov		$s6,$sp			# Save array pointer to $s6

	
	j	jumpmain
tupples4:
	addi	$sp,$sp,384	# Dellocate array [24][4]
	syscall	$exit
###############################################################	
# int getValidMoves(int *board, int *tupleList, int color)
movemain:
	li	$s7,0	#Total
	li	$t6,0	#row count
	li	$t7,0	#col count
aloop:
	li	$s2,-1
	li	$s3,-1
a2loop:
	
	# r1,c1,r2,c2 = t6,t7,t4,t5
	li	$t4,0	#store location r2 
	add	$t4,$t6,$s2	# r1 +- 1
	li	$t5,0	#store location c2 
	add	$t5,$t7,$s3	# r1 +- 1
	
	#checklegalmove
	j	islegalmove
endlegalmove:
	mov	$sp,$s1
	li	$t3,0
	mov	$t3,$v0			# move validmove to t3 then to tupple if t3=1
	beq	$t3,1,validtup
	
nextt:
	
	addi	$s3,2	#col2++ 2
a2ccheck:
	ble	$s3,1,a2loop
	addi	$s2,2	#row2++ 2
	li		$s3,-1
a2rcheck:
	ble	$s2,1,a2loop
	
	
	addi	$t7,1	#col++
accheck:
	blt	$t7,6,aloop
	addi	$t6,1	#row++
	li		$t7,0
archeck:
	blt	$t6,6,aloop
	j	break		# End of loop return number of tupples in break
	
validtup:
	mov		$sp,$s1			# pointer back to array
	li	$t2,0		# Calculate address of array
	sll	$t2,$s7,2	# total *4 = index
	sll	$t2,$t2,2	# index *4 = offset
	add	$t2,$t2,$s1	# address = base + offset
	sw	$t6,0($t2)
	sw	$t7,4($t2)
	sw	$t4,8($t2)
	sw	$t5,12($t2)
	addi	$s7,1
	beq	$s7,24,break
	j	nextt
	
break:
	la	$a0,total
	syscall	$print_string
	
	mov	$a0,$s7
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	j	printarray
	
printarray:
	li	$t3,0
parray:
	li	$t2,0		# Calculate address of array
	sll	$t2,$t3,2	# total *4 = index
	sll	$t2,$t2,2	# index *4 = offset
	add	$t2,$t2,$s1	# address = base + offset
	lw	$t6,0($t2)
	lw	$t7,4($t2)
	lw	$t4,8($t2)
	lw	$t5,12($t2)
	
	# Display r1,c1,r2,c2
	mov	$a0,$t6
	syscall	$print_int
	mov	$a0,$t7
	syscall	$print_int
	mov	$a0,$t4
	syscall	$print_int
	mov	$a0,$t5
	syscall	$print_int
	la	$a0,slash
	syscall	$print_string
	
	addi	$t3,1
	blt	$t3,$s7,parray
	
	la	$a0,newln
	syscall	$print_string
	
	beq	$s5,1,tupples3
	j	tupples1		# End printing jump to tupples1
	
# Legalmove function
islegalmove:
	
	#Check if the first piece is empty or not
	
	mov	$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	add	$sp,$sp,$t0
	lw	$t1,($sp)			# First piece value in $t1
	
	#Check first piece color
	
	
	beq	$t1,0,invalidmove
	beq	$t1,1,rmove
	beq	$t1,3,wmove
	beq	$t1,5,rkmove
	beq	$t1,7,wkmove
	
	
invalidmove:
	li	$v0,0			# Illegal out of board return 0
	j	endlegalmove

rmove:
	li	$s4,0			#Red piece color code 0
	li	$t0,0
	sub	$t0,$t6,$t4
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$s4,$s5,invalidmove
	bne	$t0,-1,invalidmove
	bne	$t1,1,invalidmove
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidmove
	
	li	$v0,1			# elseLegal return 1
	j	endlegalmove
	
wmove:
	li	$s4,1			#White piece color code 1
	li	$t0,0
	sub	$t0,$t6,$t4
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$s4,$s5,invalidmove
	bne	$t0,1,invalidmove
	bne	$t1,1,invalidmove
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidmove
	
	li	$v0,1			# elseLegal return 1
	j	endlegalmove
	
rkmove:
	li	$s4,0			#Red piece color code 0
	li	$t0,0
	sub	$t0,$t6,$t4
	abs	$t0,$t0
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$s4,$s5,invalidmove
	bne	$t0,1,invalidmove
	bne	$t1,1,invalidmove
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidmove
	
	li	$v0,1			# elseLegal return 1
	j	endlegalmove
	
wkmove:	
	li	$s4,1			#White piece color code 1
	li	$t0,0
	sub	$t0,$t6,$t4
	abs	$t0,$t0
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$s4,$s5,invalidmove
	bne	$t0,1,invalidmove
	bne	$t1,1,invalidmove
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidmove
	
	li	$v0,1			# elseLegal return 1
	j	endlegalmove
	
islegalposition:

	bgt	$t4,5,outofboard
	bgt	$t5,5,outofboard
	blt	$t4,0,outofboard
	blt	$t5,0,outofboard
	
	li	$t9,0
	add	$t9,$t4,$t5		# sum row and column
	andi	$t9,$t9,1	# And their sum with 1 to have 1 or 0, 1 = odd (white), 0 = even (black)
	beq	$t9,0,blacksquare		# black if $t9 = 0
	beq	$t9,1,whitesquare		# white if $t9 = 1
	
blacksquare:
	li	$v1,0			# Black square is not a legal position return 0
	jr $ra
	
whitesquare:			# White square can be a legal position if there is no piece on it
	mov		$sp,$s0
	li	$t0,0
	li	$t1,0
	mul	$t0,$t4,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t5			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	add	$sp,$sp,$t0
	lw	$t1,($sp)
	
	beq	$t1,0,whitelegal
	
	# whitesquare has piece on it return 0 illegal
	
	li	$v1,0
	jr	$ra
	
whitelegal:
	li	$v1,1			# white square is legal position return 1
	jr $ra
	
outofboard:
	li	$v1,0			# Illegal out of board return 0
	jr $ra
##########################################################
#int getValidJumps(int *board, int *tupleList, int color);	
jumpmain:
	li	$s7,0	#Total
	li	$t6,0	#row count
	li	$t7,0	#col count
aloopj:
	li	$s2,-2
	li	$s3,-2
a2loopj:
	
	# r1,c1,r2,c2 = t6,t7,t4,t5
	li	$t4,0	#store location r2 
	add	$t4,$t6,$s2	# r1 +- 2
	li	$t5,0	#store location c2 
	add	$t5,$t7,$s3	# r1 +- 2
	
	#checklegaljump

	j	islegaljump
endlegaljump:

	li	$t3,0
	mov	$t3,$v0			# move validjump to t3 then to tupple if t3=1
	beq	$t3,1,validtupj
	
nexttj:
	
	addi	$s3,4	#col2++ 4
a2ccheckj:
	ble	$s3,2,a2loopj
	addi	$s2,4	#row2++ 4
	li		$s3,-2
a2rcheckj:
	ble	$s2,2,a2loopj
	
	
	addi	$t7,1	#col++
accheckj:
	blt	$t7,6,aloopj
	addi	$t6,1	#row++
	li		$t7,0
archeckj:
	blt	$t6,6,aloopj
	j	breakj		# End of loop return number of tupples in break
	
validtupj:
	mov	$sp,$s6			# pointer back to array
	li	$t1,0		# Calculate address of array
	sll	$t1,$s7,2	# total *4 = index
	sll	$t1,$t1,2	# index *4 = offset
	add	$t1,$t1,$s6	# address = base + offset
	sw	$t6,0($t1)
	sw	$t7,4($t1)
	sw	$t4,8($t1)
	sw	$t5,12($t1)
	addi	$s7,1
	beq	$s7,24,breakj
	j	nexttj
	
breakj:
	la	$a0,total
	syscall	$print_string
	
	mov	$a0,$s7
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	j	printarrayj
	
printarrayj:
	li	$t3,0
parrayj:
	mov	$sp,$s6
	li	$t1,0		# Calculate address of array
	sll	$t1,$t3,2	# total *4 = index
	sll	$t1,$t1,2	# index *4 = offset
	add	$t1,$t1,$s6	# address = base + offset
	lw	$t6,0($t1)
	lw	$t7,4($t1)
	lw	$t4,8($t1)
	lw	$t5,12($t1)
	
	# Display r1,c1,r2,c2
	mov	$a0,$t6
	syscall	$print_int
	mov	$a0,$t7
	syscall	$print_int
	mov	$a0,$t4
	syscall	$print_int
	mov	$a0,$t5
	syscall	$print_int
	la	$a0,slash
	syscall	$print_string
	
	addi	$t3,1
	blt	$t3,$s7,parrayj
	
	la	$a0,newln
	syscall	$print_string
	beq	$s5,1,tupples4
	j	tupples2		# End printing jump to tupples1
	
# Legalmove function
islegaljump:
	
	#Check if the first piece is empty or not
	
	mov	$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	add	$sp,$sp,$t0
	lw	$t1,($sp)			# First piece value in $t1
	
	#Find midpoint piece										#need help...
	#li	$t2,0
	#li	$t3,0
	#li	$t8,2
	
	#add	$t2,$t6,$t4
	#add	$t3,$t7,$t5
	#div	$t2,$t2,$t8
	#div	$t3,$t3,$t8
	
	#mov		$sp,$s0
	#li	$t0,0
	#mul	$t0,$t2,6			# idx = $t0 = r*6+c
	#add	$t0,$t0,$t3			#   "
	#mul	$t0,$t0,4			# offset = idx *4 bytes
	#add	$sp,$sp,$t0
	#lw	$t9,($sp)			# Mid piece value in $t9
	
	beq	$t1,0,invalidjump
	beq	$t1,1,rjump
	beq	$t1,3,wjump
	beq	$t1,5,rkjump
	beq	$t1,7,wkjump
	

invalidjump:
	li	$v0,0			# Illegal out of board return 0
	mov	$sp,$s0
	j	endlegaljump	

rjump:
	li	$s4,0			#Red piece color code 0
	#beq	$t9,1,invalidjump								#Midpoint need help...
	#beq	$t9,5,invalidjump
	#beq	$t9,0,invalidjump
	bne	$s4,$s5,invalidjump
	
	li	$t0,0
	sub	$t0,$t6,$t4
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,-2,invalidjump
	bne	$t1,2,invalidjump
	
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalpositionj	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidjump
		  
	li	$v0,1			# elseLegal return 1
	mov	$sp,$s0
	j	endlegaljump
	
wjump:
	li	$s4,1			#White piece color code 1
	#beq	$t9,3,invalidjump	#Midpoint
	#beq	$t9,7,invalidjump
	#beq	$t9,0,invalidjump
	bne	$s4,$s5,invalidjump

	li	$t0,0
	sub	$t0,$t6,$t4
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,2,invalidjump
	bne	$t1,2,invalidjump

	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalpositionj	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidjump
	
	li	$v0,1			# elseLegal return 1
	mov	$sp,$s0
	j	endlegaljump
	
rkjump:
	li	$s4,0			#Red piece color code 0
	#beq	$t9,1,invalidjump	#Midpoint
	#beq	$t9,5,invalidjump
	#beq	$t9,0,invalidjump
	bne	$s4,$s5,invalidjump

	li	$t0,0
	sub	$t0,$t6,$t4
	abs	$t0,$t0
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,2,invalidjump
	bne	$t1,2,invalidjump
	
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalpositionj	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidjump
	
	li	$v0,1			# elseLegal return 1
	mov	$sp,$s0
	j	endlegaljump
	
wkjump:
	li	$s4,1				#White piece color code 1
	#beq	$t9,3,invalidjump	#Midpoint
	#beq	$t9,7,invalidjump
	#beq	$t9,0,invalidjump
	bne	$s4,$s5,invalidjump
	
	li	$t0,0
	sub	$t0,$t6,$t4
	abs	$t0,$t0
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,2,invalidjump
	bne	$t1,2,invalidjump
	
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalpositionj	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidjump
	
	li	$v0,1			# elseLegal return 1
	mov	$sp,$s0
	j	endlegaljump	
	

islegalpositionj:

	bgt	$t4,5,outofboardj
	bgt	$t5,5,outofboardj
	blt	$t4,0,outofboardj
	blt	$t5,0,outofboardj
	
	li	$t9,0
	add	$t9,$t4,$t5		# sum row and column
	andi	$t9,$t9,1	# And their sum with 1 to have 1 or 0, 1 = odd (white), 0 = even (black)
	beq	$t9,0,blacksquarej		# black if $t9 = 0
	beq	$t9,1,whitesquarej		# white if $t9 = 1
	
blacksquarej:
	li	$v1,0			# Black square is not a legal position return 0
	jr $ra
	
whitesquarej:	# White square can be a legal position if there is no piece on it
	mov		$sp,$s0
	li	$t0,0
	li	$t1,0
	mul	$t0,$t4,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t5			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	add	$sp,$sp,$t0
	lw	$t1,($sp)
	
	beq	$t1,0,whitelegalj
	
	# whitesquare has piece on it return 0 illegal
	
	li	$v1,0
	jr	$ra
	
whitelegalj:
	li	$v1,1			# white square is legal position return 1
	jr $ra
	
outofboardj:
	li	$v1,0			# Illegal out of board return 0
	jr $ra
	
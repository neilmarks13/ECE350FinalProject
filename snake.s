.text

start:
#make outer edge
	addi $r5, $r0, 65
	addi $r2, $r2, 8192
	addi $r3, $r0, 0
	addi $r4, $r0, 64
	addi $r10, $r0, 5
makeSides:
	vid $r1, $r0, 31744
	vid $r2, $r1, 31744
	vid $r3, $r0, 31744
	vid $r4, $r3, 31744
	sw $r10, 0($r1)
	sw $r10, 8192($r1)
	sw $r10, 0($r3)
	sw $r10, 64($r3)
	addi $r1, $r1, 1
	# addi $r2, $r2, -1
	addi $r3, $r3, 128
	# addi $r4, $r4, 128
	blt $r1, $r5, makeSides

startSnake: #initialize location of snake head 2x2 pixels
	addi $r1, $r0, 4128
	addi $r2, $r0, 5
	# addi $r3, $r0, 128
	# addi $r4, $r0, 129
	# addi $r5, $r0, 129
	# addi $r6, $r0, 130
	# addi $r7, $r0, 256
	# addi $r8, $r0, 257
	# addi $r9, $r0, 258

	sw $r2, 0($r1)

	addi $r21, $r0, 4128 #hold position of head to start but becomes postion of back
	
	# addi $r17, $r0, 0
firstApple:
	rand $r18
	lw $r17, 0($r18)
	bne $r17, $r0, firstApple

	addi $r10, $r0, 0
	addi $r11, $r0, 0

	addi $r20, $r0, 4 #register for moves
	addi $r19, $r0, 0 #counts moves while lengthening

	vid $r1, $r0, 32767
	# vid $r2, $r1, 32767
	# vid $r3, $r1, 32767
	# vid $r4, $r1, 32767
	# vid $r6, $r1, 32767
	# vid $r7, $r1, 32767
	# vid $r8, $r1, 32767
	# vid $r9, $r1, 32767

	vid $r18, $r0, 480
	# vid $r2, $r18, 480
	# vid $r3, $r18, 31744
	# vid $r4, $r18, 31744
	# vid $r5, $r18, 31744
	# vid $r6, $r18, 31744
	# vid $r7, $r18, 31744
	# vid $r8, $r18, 31744
	# vid $r9, $r18, 31744

	key $r10
	key $r10

hold:
	key $r10 #get keyboard entry
	#if the keyboard entry isn't still 0 then start game
	bne $r10, $r0, move
	j hold

move:
	key $r10 #get keyboard input
	sub $r12, $r0, $r10
	bne $r12, $r11, normal
	add $r10, $r11, $r0

	# sub $r11, $r5, $r10
normal:
	add $r11, $r10, $r0
	sw $r10, 0($r1) #save direction of travel at location

	add $r1, $r1, $r10 #update locations

	bne $r1, $r18, noApple

eatApple:
	rand $r18
	lw $r17, 0($r18)
	# lw $r16, 129($r18)
	bne $r17, $r0, eatApple
	# bne $r16, $r0, eatApple
	
	addi $r19, $r19, -3
	vid $r18, $r0, 480
	# vid $r2, $r18, 480
	# vid $r3, $r18, 31744
	# vid $r4, $r18, 31744

	j pass

noApple:
	lw $r13, 0($r1) #load anything at that location
	# lw $r14, 127($r1)

	bne $r13, $r0, byeApple #check if position is occupied; if so game over
	# bne $r14, $r0, byeApple #check if position is occupied; if so game over
	blt $r19, $r20, longer #see if snake needs to be make longer

back: #move the back
	lw $r10, 0($r21)

	sw $r0, 0($r21)

	vid $r21, $r0, 0
	# vid $r2, $r21, 0
	# vid $r3, $r21, 0
	# vid $r4, $r21, 0
	# vid $r5, $r21, 0
	# vid $r6, $r21, 0
	# vid $r7, $r21, 0
	# vid $r8, $r21, 0
	# vid $r9, $r21, 0
	
	add $r21, $r21, $r10

pass: #move the front
	#fill the hole
	# vid $r1, $r11, 32767

	vid $r1, $r0, 32767
	# vid $r2, $r1, 32767
	# vid $r3, $r1, 32767
	# vid $r4, $r1, 32767
	# vid $r6, $r1, 32767
	# vid $r7, $r1, 32767
	# vid $r8, $r1, 32767
	# vid $r9, $r1, 32767

	j move


longer:
	addi $r19, $r19, 1
	j pass

byeApple:
	vid $r18, $r0, 0
	# vid $r2, $r18, 0
	# vid $r3, $r18, 0
	# vid $r4, $r18, 0
	# vid $r5, $r18, 0
	# vid $r6, $r18, 0
	# vid $r7, $r18, 0
	# vid $r8, $r18, 0
	# vid $r9, $r18, 0

lose:
	lw $r10, 0($r21)
	# lw $r11, 129($r21)
	# or $r13, $r10, $r11

	bne $r10, $r2, contLose

	j startSnake

contLose:
	vid $r21, $r0, 0
	# vid $r2, $r21, 0
	# vid $r3, $r21, 0
	# vid $r4, $r21, 0
	# vid $r5, $r21, 0
	# vid $r6, $r21, 0
	# vid $r7, $r21, 0
	# vid $r8, $r21, 0
	# vid $r9, $r21, 0
	
	sw $r0, 0($r21)
	
	add $r21, $r21, $r10
	
	bne $r10, $r0, lose
	j startSnake
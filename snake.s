.text

start:
#make outer edge
	addi $r5, $r0, 128
	sll $r6, $r5, 7
	addi $r2, $r2, 16256
	addi $r3, $r2, 0
	addi $r4, $r2, 127
	addi $r10, $r0, 1
makeSides:
	vid $r1, $r0, 31744
	vid $r2, $r0, 31744
	vid $r3, $r0, 31744
	vid $r4, $r0, 31744
	sw $r10, 0($r1)
	sw $r10, 0($r2)
	sw $r10, 0($r3)
	sw $r10, 0($r4)
	addi $r1, $r1, 1
	addi $r2, $r2, 1
	addi $r3, $r3, 128
	addi $r4, $r4, 128
	blt $r1, $r5, makeSides

startSnake: #initialize location of snake head 2x2 pixels
	addi $r1, $r0, 8256
	addi $r2, $r0, 8257
	addi $r3, $r0, 8258
	addi $r4, $r0, 8384
	addi $r5, $r0, 8385
	addi $r6, $r0, 8386
	addi $r7, $r0, 8512
	addi $r8, $r0, 8513
	addi $r9, $r0, 8514

	addi $r21, $r0, 8256
	addi $r22, $r0, 8257
	addi $r23, $r0, 8258
	addi $r24, $r0, 8384
	addi $r25, $r0, 8385
	addi $r26, $r0, 8386
	addi $r27, $r0, 8512
	addi $r28, $r0, 8513
	addi $r29, $r0, 8514

	addi $r11, $r0, 127 #mask for lower 7 location bits; x location
	sll $r12, $r5, 7 #mask for upper 7 location bits; y location
	addi $r10, $r0, 0

	addi $r20, $r0, 4 #register for moves
	addi $r19, $r0, 0

	vid $r1, $r0, 32767
	vid $r2, $r0, 32767
	vid $r3, $r0, 32767
	vid $r4, $r0, 32767
	vid $r5, $r0, 0
	vid $r6, $r0, 32767
	vid $r7, $r0, 32767
	vid $r8, $r0, 32767
	vid $r9, $r0, 32767

hold:
	key $r10
	bne $r10, $r0, move
	j hold

move:
	key $r10 #get keyboard input
	# sll $r14, $r10, 14
	# add $r10, $r10, $r14
	vid $r5, $r0, 32767
	
	sw $r10, 0($r1) #save direction of travel at location
	#update locations
	add $r1, $r1, $r10
	lw $r13, 0($r1)
	add $r2, $r2, $r10
	add $r3, $r3, $r10
	add $r4, $r4, $r10
	add $r5, $r5, $r10
	add $r6, $r6, $r10
	add $r7, $r7, $r10
	add $r8, $r8, $r10
	add $r9, $r9, $r10

	#check if position is occupied; if so game over
	bne $r13, $r0, lose
	blt $r19, $r20, longer

back:
	lw $r10, 0($r21)
	

	vid $r21, $r0, 0
	vid $r22, $r0, 0
	vid $r23, $r0, 0
	vid $r24, $r0, 0
	vid $r25, $r0, 0
	vid $r26, $r0, 0
	vid $r27, $r0, 0
	vid $r28, $r0, 0
	vid $r29, $r0, 0
	
	sw $r0, 0($r21)
	
	add $r21, $r21, $r10
	add $r22, $r22, $r10
	add $r23, $r23, $r10
	add $r24, $r24, $r10
	add $r25, $r25, $r10
	add $r26, $r26, $r10
	add $r27, $r27, $r10
	add $r28, $r28, $r10
	add $r29, $r29, $r10

pass:
	vid $r1, $r0, 32767
	vid $r2, $r0, 32767
	vid $r3, $r0, 32767
	vid $r4, $r0, 32767
	vid $r5, $r0, 0
	vid $r6, $r0, 32767
	vid $r7, $r0, 32767
	vid $r8, $r0, 32767
	vid $r9, $r0, 32767

	j move

longer:
	addi $r19, $r19, 1
	j pass
lose:
	j lose
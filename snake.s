.text

start:
#make outer edge
	addi $r5, $r0, 128
	addi $r2, $r2, 16383
	addi $r3, $r0, 0
	addi $r4, $r0, 127
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
	addi $r2, $r2, -1
	addi $r3, $r3, -128
	addi $r4, $r4, 128
	blt $r1, $r5, makeSides

startSnake: #initialize location of snake head 2x2 pixels
	addi $r1, $r0, 8256
	addi $r2, $r0, 1
	addi $r3, $r0, 2
	addi $r4, $r0, 128
	addi $r5, $r0, 129
	addi $r6, $r0, 130
	addi $r7, $r0, 256
	addi $r8, $r0, 257
	addi $r9, $r0, 258

	addi $r21, $r0, 8256 #hold position of head to start but becomes postion of back
	
	addi $r17, $r0, 0
	addi $r18, $r0, 10191
	
	addi $r10, $r0, 0

	addi $r20, $r0, 2 #register for moves
	addi $r19, $r0, 0 #counts moves while lengthening

	vid $r1, $r0, 32767
	vid $r2, $r1, 32767
	vid $r3, $r1, 32767
	vid $r4, $r1, 32767
	vid $r5, $r1, 0
	vid $r6, $r1, 32767
	vid $r7, $r1, 32767
	vid $r8, $r1, 32767
	vid $r9, $r1, 32767

	vid $r18, $r0, 31744
	vid $r2, $r18, 480
	vid $r3, $r18, 31744
	vid $r4, $r18, 31744
	vid $r5, $r18, 31744
	vid $r6, $r18, 31744
	vid $r7, $r18, 31744
	vid $r8, $r18, 31744
	vid $r9, $r18, 31744

hold:
	key $r10 #get keyboard entry
	#if the keyboard entry isn't still 0 then start game
	bne $r10, $r0, move
	j hold

move:
	key $r10 #get keyboard input

	sub $r11, $r5, $r10

	sw $r10, 0($r1) #save direction of travel at location

	add $r1, $r1, $r10 #update locations

	bne $r1, $r18, noApple

eatApple:
	addi $r19, $r19, -1
	addi $r17, $r0, 1
	j pass

noApple:
	lw $r13, 0($r1) #load anything at that location
	lw $r14, 2($r1)
	lw $r15, 256($r1)

	bne $r13, $r0, lose #check if position is occupied; if so game over
	bne $r14, $r0, lose #check if position is occupied; if so game over
	bne $r15, $r0, lose #check if position is occupied; if so game over
	blt $r19, $r20, longer #see if snake needs to be make longer

back: #move the back
	lw $r10, 0($r21)

	sw $r0, 0($r21)

	bne $r17, $r0, newApple

	vid $r21, $r0, 0
	vid $r2, $r21, 0
	vid $r3, $r21, 0
	vid $r4, $r21, 0
	vid $r5, $r21, 0
	vid $r6, $r21, 0
	vid $r7, $r21, 0
	vid $r8, $r21, 0
	vid $r9, $r21, 0
	
	add $r21, $r21, $r10

pass: #move the front
	#fill the hole
	vid $r1, $r11, 32767

	vid $r1, $r0, 32767
	vid $r2, $r1, 32767
	vid $r3, $r1, 32767
	vid $r4, $r1, 32767
	vid $r5, $r1, 0
	vid $r6, $r1, 32767
	vid $r7, $r1, 32767
	vid $r8, $r1, 32767
	vid $r9, $r1, 32767

	j move

newApple:
	addi $r17, $r0, 0
	addi $r18, $r21, 0
	vid $r18, $r0, 31744
	vid $r2, $r18, 480
	vid $r3, $r18, 31744
	vid $r4, $r18, 31744
	vid $r5, $r18, 31744
	vid $r6, $r18, 31744
	vid $r7, $r18, 31744
	vid $r8, $r18, 31744
	vid $r9, $r18, 31744

	add $r21, $r21, $r10

	j pass

longer:
	addi $r19, $r19, 1
	j pass
lose:
	lw $r10, 0($r21)
	lw $r11, 2($r21)
	lw $r12, 256($r21)

	bne $r10, $r2, check2
	j startSnake

check2:
	bne $r11, $r2, check3
	j startSnake

check3:
	bne $r12, $r2, contLose
	j startSnake

contLose:
	vid $r21, $r0, 0
	vid $r2, $r21, 0
	vid $r3, $r21, 0
	vid $r4, $r21, 0
	vid $r5, $r21, 0
	vid $r6, $r21, 0
	vid $r7, $r21, 0
	vid $r8, $r21, 0
	vid $r9, $r21, 0
	
	sw $r0, 0($r21)
	
	add $r21, $r21, $r10
	
	bne $r10, $r0, lose
	j startSnake
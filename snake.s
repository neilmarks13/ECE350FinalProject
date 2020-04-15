.text

start:
#make outer edge
	addi $r5, $r0, 128
	sll $r6, $r5, 7
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
	
	addi $r10, $r0, 0

	addi $r20, $r0, 4 #register for moves
	addi $r19, $r0, 0 #counts moves while lengthening

	vid $r1, $r0, 32767
	vid $r2, $r1, 32767
	vid $r3, $r1, 32767
	vid $r4, $r1, 32767
	vid $r5, $r1, 31744
	vid $r6, $r1, 32767
	vid $r7, $r1, 32767
	vid $r8, $r1, 32767
	vid $r9, $r1, 32767

hold:
	key $r10 #get keyboard entry
	#if the keyboard entry isn't still 0 then start game
	bne $r10, $r0, move
	j hold

move:
	key $r10 #get keyboard input

	vid $r5, $r1, 32767 #fill in hole in head
	
	sw $r10, 0($r1) #save direction of travel at location
	
	add $r1, $r1, $r10 #update locations

	lw $r13, 0($r1) #load anything at that location
	lw $r14, 3($r1)
	lw $r15, 256($r1)

	bne $r13, $r0, lose #check if position is occupied; if so game over
	bne $r14, $r0, lose #check if position is occupied; if so game over
	bne $r15, $r0, lose #check if position is occupied; if so game over
	blt $r19, $r20, longer #see if snake needs to be make longer

back: #move the back
	lw $r10, 0($r21)
	
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

pass: #move the front
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

longer:
	addi $r19, $r19, 1
	j pass
lose:
	j lose
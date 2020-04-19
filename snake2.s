.text

start:
#make outer edges
	addi $r5, $r0, 34 #make 33 pixels on each side
	addi $r2, $r0, 4224 #start at the bottom left corner
	addi $r3, $r0, 0 #start in the top left corner
	addi $r4, $r0, 33 #start in the top right corner
	addi $r10, $r0, 1 #save a 1 in each side location
makeSides:
	#add the outer lines
	vid $r1, $r0, 32736
	vid $r2, $r1, 32736
	vid $r3, $r0, 32736
	vid $r4, $r3, 32736
	#save a 1 at these locations
	sw $r10, 0($r1)
	sw $r10, 4224($r1)
	sw $r10, 0($r3)
	sw $r10, 33($r3)
	#move to next spots
	addi $r1, $r1, 1
	addi $r3, $r3, 128
	#if not done yet keep making the sides
	blt $r1, $r5, makeSides


startSnake: #initialize location of snake head 2x2 pixels
	#double key resets the inputs and outputs
	key $r10
	key $r10
	#"Use"
	write $r0, $r0, 85
	write $r0, $r0, 371
	write $r0, $r0, 613
	#" A S D W 
	write $r0, $r0, 1089
	write $r0, $r0, 1619
	write $r0, $r0, 2116
	write $r0, $r0, 2647
	#" to move"
	write $r0, $r0, 3188
	write $r0, $r0, 3439
	write $r0, $r0, 3949
	write $r0, $r0, 4207
	write $r0, $r0, 4470
	write $r0, $r0, 4709
	#"Score:00"
	write $r0, $r0, 6227
	write $r0, $r0, 6499
	write $r0, $r0, 6767
	write $r0, $r0, 7026
	write $r0, $r0, 7269
	write $r0, $r0, 7482
	write $r0, $r0, 7728
	write $r0, $r0, 7984

	#start the 2x2 pixels head of the snake in the middle
	addi $r1, $r0, 2193 #top left of head
	addi $r2, $r0, 1 #top right of head
	addi $r3, $r0, 128 #bottom left of head
	addi $r4, $r0, 129 #bottom right of head

	sw $r2, 0($r1) #save a 1 in the initial location of the head

	add $r21, $r0, $r1 #hold position of head to start but becomes postion of back
	
	addi $r28, $r0, 0 #ones place of score
	addi $r27, $r0, 0 #tens place of score
	addi $r26, $r0, 9 #holds a 9 to compare when r28 gets to 10

firstApple:
	rand $r18 #new location of the apple
	lw $r17, 0($r18) #check to see if there is anything in this location
	bne $r17, $r0, firstApple #if there is something there re randomize

	

	addi $r20, $r0, 4 #register for moves
	addi $r19, $r0, 0 #counts moves while lengthening

	#print the initial head location all white
	vid $r1, $r0, 32767
	vid $r2, $r1, 32767
	vid $r3, $r1, 32767
	vid $r4, $r1, 32767

	#print the initial apple location green top red bottem
	vid $r18, $r0, 480
	vid $r2, $r18, 480
	vid $r3, $r18, 31744
	vid $r4, $r18, 31744
	
	addi $r10, $r0, 0 #initialize the register to 0 to hold the current move
	addi $r11, $r0, 0 #initialize the register to 0 to hold the previous move

hold:
	key $r10 #get keyboard entry
	#if the keyboard entry isn't still 0 then start game
	bne $r10, $r0, move
	j hold

move:
	key $r10 #get keyboard input for direction of move
	sub $r12, $r0, $r10 #r12 to the inverse of the move
	bne $r12, $r11, normal #cant move backwards so check for that
	add $r10, $r11, $r0 #if moving backwards then use previous direction instead

	
normal:
	add $r11, $r10, $r0 #update the previous move register

	sw $r10, 0($r1) #save direction of travel at location

	sub $r5, $r1, $r0 #save the previous location

	add $r1, $r1, $r10 #update to new location

	bne $r1, $r18, noApple #if not at the apple location

eatApple: #if at the apple location
	rand $r18 #randomize the new apple location
	lw $r17, 0($r18) #load what is at this location
	bne $r17, $r0, eatApple #if the location has something there get new location
	bne $r18, $r1, notSame #if the location is the same as the head location get new location
	j eatApple

notSame:
	addi $r28, $r28, 1 #add to ones place of score

	addi $r19, $r19, -3 #delay 3 moves before moving the back of the snake
	#update new apple
	vid $r18, $r0, 480
	vid $r2, $r18, 480
	vid $r3, $r18, 31744
	vid $r4, $r18, 31744

updateScore:
	blt $r26, $r28, overTen #if the ones place is 10 or more
	write $r0, $r27, 7728 #update score
	write $r0, $r28, 7984
	j pass

overTen:
	addi $r27, $r27, 1 #add one to the tens place
	addi $r28, $r0, 0 #set ones place to 0
	write $r0, $r27, 7728 #update score
	write $r0, $r28, 7984
	j pass

noApple:
	lw $r13, 0($r1) #load anything at top left head location
	lw $r14, 129($r1) #load anything at bottom right head location

	bne $r13, $r0, byeApple #check if position is occupied; if so game over
	bne $r14, $r0, byeApple #check if position is occupied; if so game over
	blt $r19, $r20, longer #see if snake needs to be make longer

back: #move the back
	lw $r10, 0($r21) #get the direction of movement at this location

	sw $r0, 0($r21) #clear the memory at the back location

	vid $r21, $r0, 0 #clear screen of back 2x2 piece
	vid $r2, $r21, 0
	vid $r3, $r21, 0
	vid $r4, $r21, 0
	
	add $r21, $r21, $r10 #move the back location to new back location

pass: #move the front
	#fill the eye hole
	vid $r0, $r5, 32767
	vid $r5, $r4, 32767
	#print the corners that are always white
	vid $r2, $r1, 32767
	vid $r3, $r1, 32767

	blt $r11, $r0, leftup #if moving left or up
rightdown:
	#put eye in bottom right corner
	vid $r4, $r1, 7679
	vid $r1, $r0, 32767
	add $r0, $r0, $r0
	add $r0, $r0, $r0
	j move
leftup: 
	#put eye in top left corner
	vid $r1, $r0, 7679
	vid $r4, $r1, 32767

	j move


longer:
	addi $r19, $r19, 1 #if the snake needs to be made longer go here instead of back
	j pass

byeApple: #when you lose
	#double key resets the writing and input
	key $r10
	key $r10
	#Score:__
	write $r0, $r0, 6227
	write $r0, $r0, 6499
	write $r0, $r0, 6767
	write $r0, $r0, 7026
	write $r0, $r0, 7269
	write $r0, $r0, 7482
	write $r0, $r27, 7728
	write $r0, $r28, 7984
	#Game over
	write $r0, $r0, 71
	write $r0, $r0, 353
	write $r0, $r0, 621
	write $r0, $r0, 869
	write $r0, $r0, 1391
	write $r0, $r0, 1654
	write $r0, $r0, 1893
	write $r0, $r0, 2162

	#clear the apple
	vid $r18, $r0, 0
	vid $r2, $r18, 0
	vid $r3, $r18, 0
	vid $r4, $r18, 0

lose:

	lw $r10, 0($r21) #load direction of travel at the back
	lw $r11, 129($r21) #load what is stored at the bottom right corner
	or $r13, $r10, $r11 #or both just to check if its a side location that only stored a 1
	#this or works bc when losing nothing is saved at the $r1 location of memory
	bne $r13, $r2, contLose #if at the side location then dont clear the pixels
	j startSnake #restart the game

contLose:
	#clear the back piece of the snake
	vid $r21, $r0, 0
	vid $r2, $r21, 0
	vid $r3, $r21, 0
	vid $r4, $r21, 0
	# vid $r5, $r21, 0
	# vid $r6, $r21, 0
	# vid $r7, $r21, 0
	# vid $r8, $r21, 0
	# vid $r9, $r21, 0
	
	sw $r1, 0($r21) #clear the memory at the location of the back
	
	add $r21, $r21, $r10 #move the back in the direction of travel
	
	bne $r10, $r0, lose #stop clearning when an empty space is reached

	j startSnake #restart the game
.text

# Generates an autostereogram inside of buffer
#
# Arguments:
#     autostereogram (unsigned char*)
#     depth_map (unsigned char*)
#     width
#     height
#     strip_size
calc_autostereogram:

        # Allocate 5 spaces for $s0-$s5
        # (add more if necessary)
        addiu $sp $sp -32
        sw $s0 0($sp)
        sw $s1 4($sp)
        sw $s2 8($sp)
        sw $s3 12($sp)
        sw $s4 16($sp)
        sw $s5 20($sp)
        sw $s6 24($sp)
	
	sw $ra 28($sp)
	
        # autostereogram
        lw $s0 32($sp)
        # depth_map
        lw $s1 36($sp)
        # width
        lw $s2 40($sp)
        # height
        lw $s3 44($sp)
        # strip_size
        lw $s4 48($sp)

        # YOUR CODE HERE #
	
	li 	$t1,0 # loop index for i
	li	$t4,0 # $t4 = j*width always
	
LoopM:	beq 	$t1,$s2,EndOfM # if i=M: end of loop M
	li 	$t2,0 # loop index for j

LoopN:	beq 	$t2,$s3,EndOfN # if j=N: end of loop N
	
	add	$t5,$t4,$t1 # $t5 = j*width + i
	add	$t8,$t5,$s0 # t8 holds the address of I(i,j) in memory
	
	slt 	$t3,$t1,$s4
	bne 	$t3,$0, Case1 # if i<S, case1
	
	j	Case2 # Else, case2
	
Case1:	move $s1,$t1
	move $s2,$t2
	move $s3,$t3
	move $s4,$t4
	move $s5,$t5
	move $s6,$t8

	jal 	lfsr_random
	
	move $t1,$s1
	move $t2,$s2
	move $t3,$s3
	move $t4,$s4
	move $t5,$s5
	move $t8,$s6
	
	lw $s1 4($sp)
        lw $s2 8($sp)
        lw $s3 12($sp)
        lw $s4 16($sp)
        lw $s5 20($sp)
        lw $s6 24($sp)
	
	move	$t9,$v0
	andi 	$t9,$t9,0xff # $t9 now holds random int in {0,1,...,255}
	sb 	$t9,0($t8) # store into I(i,j)

	j 	EndCases

Case2:	add	$t5,$t5,$s1 # $t5 how holds the address of (i,j) in depth map
	lb	$t6,0($t5) # $t6 = depth(i,j)
	add	$t6,$t6,$t1 # $t6 = i+depth(i,j)
	sub	$t6,$t6,$s4 # $t6 = i+depth(i,j)-S
	add	$t6,$t6,$t4 # $t6 = i+depth(i,j)-S + width*j
	add	$t6,$t6,$s0 # $t6 is address of I(i+depth(i,j)-S , j)
	
	lb	$t7,0($t6) # $t7 holds I(i+depth(i,j)-S , j)
	sb	$t7,0($t8) # I(i,j) = I(i+depth(i,j)-S , j)
	
EndCases:

	addi 	$t2,$t2,1 # j++
	add	$t4,$t4,$s2 # increments $t4 by width; remember $t4 = j*width
	j 	LoopN
	
EndOfN:	addi 	$t1,$t1,1 # i++
	li	$t4,0
	j 	LoopM
	
EndOfM: lw $s0 0($sp)
        lw $s1 4($sp)
        lw $s2 8($sp)
        lw $s3 12($sp)
        lw $s4 16($sp)
        lw $s5 20($sp)
        lw $s6 24($sp)
        lw $ra 28($sp)
        addiu $sp $sp 28
        jr $ra

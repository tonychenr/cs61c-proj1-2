.text

# Decodes a quadtree to the original matrix
#
# Arguments:
#     quadtree (qNode*)
#     matrix (void*)
#     matrix_width (int)
#
# Recall that quadtree representation uses the following format:
#     struct qNode {
#         int leaf;
#         int size;
#         int x;
#         int y;
#         int gray_value;
#         qNode *child_NW, *child_NE, *child_SE, *child_SW;
#     }




quad2matrix:

        # YOUR CODE HERE #
	
	lw 	$t2,0($a0) # $t2 = t1.leaf
	move	$t1,$a0
	bne 	$t2,$0, Store # if t1 is a leaf, store
	
	j	Recurse
	
Store:	lw 	$t3,8($t1) # t3 = t1.x
	lw 	$t4,12($t1) # t4 = t1.y
	lw 	$t5,4($t1) # t5 = t1.size
	lw	$t6,16($t1) # t6 = t1.gray_value
	addiu	$sp,$sp,-8
	sw	$s0,0($sp)
	sw	$s1,4($sp)
	
	move	$t8,$t4 # j = y
	
YLoop:	add	$s0,$t4,$t5 # s0=y+size
	beq	$t8,$s0, YEnd # if j = y+size, exit YLoop
	move	$t7,$t3 # i = x

XLoop:	add 	$s0,$t3,$t5 # s0 = x+size
	beq	$t7,$s0,XEnd # if i = x+size, exit XLoop
	
	multu	$t8, $a2
	mflo	$t9	#$t9 holds the result of j*width
	add	$s1,$t9,$t7 # s1 = j*width +i
	add	$s1,$s1,$a1 # s1 is address of matrix[i,j]
	sb	$t6, 0($s1) # matrix[i,j]=gray_value
	
	addiu	$t7,$t7,1 # i++
	j	XLoop
	
XEnd:	addiu	$t8,$t8,1 # j++
	j	YLoop
	
YEnd: 	lw	$s0,0($sp)
	lw	$s1,4($sp)
	addiu	$sp,$sp,8
	jr 	$ra

Recurse:
	
	addiu	$sp,$sp,-8
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	lw	$a0,20($a0) # the NW tree
	jal	quad2matrix
	
	lw	$a0, 0($sp)
	lw	$a0,24($a0) # NE Tree
	jal	quad2matrix
	
	lw	$a0, 0($sp)
	lw	$a0,28($a0) # SE Tree
	jal	quad2matrix
	
	lw	$a0, 0($sp)
	lw	$a0,32($a0) # SW Tree
	jal	quad2matrix
	
	lw	$ra, 4($sp)
	lw	$a0, 0($sp)
	addiu	$sp,$sp,8
	jr	$ra

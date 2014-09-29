.data

lfsr:
        .align 4
        .half
        0x1

.text

# Implements a 16-bit lfsr
#
# Arguments: None
lfsr_random:

        la $t0 lfsr
        lhu $v0 0($t0)
        

        # YOUR CODE HERE #
	
	
	
	li  	$t1, 0
	
	
Loop: 
	addi 	$t1,$t1,1
	
	srl	$t3,$v0,0
	srl	$t4,$v0,2
	srl 	$t5,$v0,3
	srl	$t6,$v0,5
	
	xor	$t2,$t3,$t4
	xor	$t2,$t2,$t5
	xor	$t2,$t2,$t6	# $t2 now holds ((reg >> 0) ^ (reg >> 2) ^ (reg >> 3) ^ (reg >> 5))
	
	srl	$t7,$v0,1
	sll	$t2,$t2,15
	or	$v0,$t7,$t2
	
	andi	$v0,$v0,0xFFFF
	bne 	$t1,16, Loop
	
	# $v0 how holds the lfsr
	
        la $t0 lfsr
        sh $v0 0($t0)        
        jr $ra

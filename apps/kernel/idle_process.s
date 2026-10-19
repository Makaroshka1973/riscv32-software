.text
.global init_idle_process
.global idle

init_idle_process:
	la t0,current_pcb
	lw t0,0(t0)
	la t1,idle
	sw t1,124(t0)
	ret	

#idle:
#	li a0,1
#	la a1,TEST_MSG
#	li a2,9
#	li a7,64
#	ecall
#	j idle


#.data
#TEST_MSG: .asciz "haii!!!!\n"

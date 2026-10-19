.text
.global k_write
.global mtimecmp_write
.global mtimecmp_add

k_write: # takes file at a0, buffer pointer at a1, length in a2
	li t0,1
	beq a0,t0,k_write_uart # if stdout
	li t0,2
	beq a0,t0,k_write_uart # if stderr
	li a0,-1
	j k_write_end # else error

	k_write_uart:
		addi sp,sp,-16
		sw ra,0(sp)

		mv a0,a1
		mv a1,a2		
		call uart_write

		lw ra,0(sp)
		addi sp,sp,16
		j k_write_end

	k_write_end:
		ret

k_read: # takes file at a0, buffer pointer at a1, length in a2
	beq a0,x0,k_read_keyboard # if stdin
	li a0,-1
	j k_read_end # else error

	k_read_keyboard:
		addi sp,sp,-16
		sw ra,0(sp) # save ra
		call keyboard_read # read data from keyboard
		lw ra,0(sp)
		addi sp,sp,16 # load ra

		addi a0,a0,-1 # makes driver's return standartized: -1 is error, 0 is ok
		j k_read_end

	k_read_end:
		ret

mtimecmp_write:
	li t0,0x1000020
	sw a0,0(t0)
	sw a1,4(t0)
	ret

mtimecmp_add:
	li t0,0x1000018
	lw t1,0(t0)
	lw t2,4(t0)
	add t3,t1,a0
	add t4,t2,a1
	sltu t5,t3,t1
	add t4,t4,t5
	li t0,0x1000020
	sw t3,0(t0)
	sw t4,4(t0)
	ret

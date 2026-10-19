.global uart_write

.text
uart_write: # takes buffer pointer in a1 and length in a2 
	la t0,BASE_MMIO_ADDR # load MMIO address
	mv t1,a0 # load buffer pointer
	mv t2,a1 # load length
	uart_write_loop:
		beq t2,x0,uart_write_end # if len equals 0, end 
		addi t2,t2,-1 # decrease len
		lb t3,0(t1) # load char
		sb t3,0(t0) # print char to uart
		addi t1,t1,1 # increase buffer pointer by 1
		j uart_write_loop
	uart_write_end:
		mv a2,a0
		ret

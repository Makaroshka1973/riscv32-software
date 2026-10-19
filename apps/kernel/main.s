.section .text
.global main
.global BASE_MMIO_ADDR

main:
	csrw mscratch,sp
	li a0,5000
	add a1,x0,x0
	call mtimecmp_add
	la t0,trap_handler
        csrw mtvec,t0
	la t0,idle
	csrw mepc,t0
        addi t0,x0,0x80
	csrrs x0,mstatus,t0
	csrrs x0,mie,t0
        addi t0,x0,-0x800
	csrrs x0,mie,t0

	call init_idle_process

	la a0,init
	call start_process

	li a0,1
	la a1,START_MSG
	li a2,19
	call k_write 

        mret

.align 2
trap_handler:
	# swap program's stack pointer and kernel's stack pointer
	csrrw sp,mscratch,sp

	# store some tmp registers and saved register to stack
	addi sp,sp,-16
	sw s0,0(sp)
	sw t1,4(sp)
	sw t2,8(sp)

	la s0,current_pcb
	lw s0,0(s0)

	# process's sp to t1, mepc to t2
	csrr t1,mscratch
	csrr t2,mepc
	
	# save context
	sw x1,0(s0)
	sw t1,4(s0) # sp
	sw x3,8(s0)
	sw x4,12(s0)
	sw x5,16(s0)
	sw x9,32(s0)
	sw x10,36(s0)
	sw x11,40(s0)
	sw x12,44(s0)
	sw x13,48(s0)
	sw x14,52(s0)
	sw x15,56(s0)
	sw x16,60(s0)
	sw x17,64(s0)
	sw x18,68(s0)
	sw x19,72(s0)
	sw x20,76(s0)
	sw x21,80(s0)
	sw x22,84(s0)
	sw x23,88(s0)
	sw x24,92(s0)
	sw x25,96(s0)
	sw x26,100(s0)
	sw x27,104(s0)
	sw x28,108(s0)
	sw x29,112(s0)
	sw x30,116(s0)
	sw x31,120(s0)
	sw t2,124(s0) # mepc
	# load process's s0, t1,t2
	lw t3,0(sp)
	lw t1,4(sp)
	lw t2,8(sp)
	addi sp,sp,16
	# save t1,t2, s0 to context
	sw t1,20(s0)
	sw t2,24(s0)
	sw t3,28(s0)

	# get trap cause, compare it
	csrr t0,mcause

	bgt t0,x0,trap_handler_soft_exception

	# trap is hardware interrupt
	li t1,0x80000007
	beq t0,t1,trap_handler_timer # trap is timer interrupt
	li t1,0x8000000b
	beq t0,t1,trap_handler_external # trap is external interrupt
	j trap_handler_return


	# trap is software exception
	trap_handler_soft_exception:
	li t1,8
	beq t0,t1,trap_handler_ecall	
	li t1,11
	beq t0,t1,trap_handler_ecall	

	trap_handler_return:
		csrw mscratch,sp

		# update current_pcb address
		la s0,current_pcb
		lw s0,0(s0)

		# load context
		lw x1,0(s0)
		lw x2,4(s0)
		lw x3,8(s0)
		lw x4,12(s0)
		lw x5,16(s0)
		lw x6,20(s0)
		lw x9,32(s0)
		lw x10,36(s0)
		lw x11,40(s0)
		lw x12,44(s0)
		lw x13,48(s0)
		lw x14,52(s0)
		lw x15,56(s0)
		lw x16,60(s0)
		lw x17,64(s0)
		lw x18,68(s0)
		lw x19,72(s0)
		lw x20,76(s0)
		lw x21,80(s0)
		lw x22,84(s0)
		lw x23,88(s0)
		lw x24,92(s0)
		lw x25,96(s0)
		lw x26,100(s0)
		lw x27,104(s0)
		lw x28,108(s0)
		lw x29,112(s0)
		lw x30,116(s0)
		lw x31,120(s0)
		# load mepc
		lw t2,124(s0)
		csrw mepc,t2
		# load t2, s0
		lw x7,24(s0)
		lw x8,28(s0)
		mret

	trap_handler_timer:
		call schedule
		addi a0,x0,1000
		add a1,x0,x0
		call mtimecmp_add
		j trap_handler_return

	trap_handler_external:
		call keyboard_interrupt
		j trap_handler_return

	trap_handler_ecall:
		lw t2,124(s0)
		addi t2,t2,4
		sw t2,124(s0)
		li t0,64
		beq a7,t0,trap_handler_ecall_write
		li t0,63
		beq a7,t0,trap_handler_ecall_read

		li a0,-1
		j trap_handler_ecall_end

		trap_handler_ecall_write:
			call k_write
			j trap_handler_ecall_code

		trap_handler_ecall_read:
			call k_read
			j trap_handler_ecall_end

		trap_handler_ecall_code:
		sw a0,36(s0) # place return code in a0

		trap_handler_ecall_end:
		j trap_handler_return
		

.data
START_MSG: .ascii "MakKernel Started!\n"
BASE_MMIO_ADDR: .word 0x1000000

.global __syscall3

.text

__syscall3: # takes 4 args, the last one is code for system call.
	mv a7,a3

	ecall
	ret

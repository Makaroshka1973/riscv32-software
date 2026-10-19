.global write
.global read

.text

write: # takes file(a0), buffer pointer(a1), length(a2), makes a syscall with code 64.
	li a7,64
	ecall
	ret

read: # takes file(a0), buffer pointer(a1), length(a2), makes a syscall with code 63.
	li a7,63
	ecall
	ret

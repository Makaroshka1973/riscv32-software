.global keyboard_read

.text
keyboard_read:
	la t0,BASE_MMIO_ADDR
	lw a0,0xc(t0) # get keyboard availablity status (0 - not avail, 1 - avail)
	lw a1,0x8(t0) # get keyboard data
	ret

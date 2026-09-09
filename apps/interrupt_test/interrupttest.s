.section .text
.global main

main:
    la t0, trap_handler
    csrw mtvec, t0

    la t0, context_save_area
    csrw mscratch, t0
    li t0, 0x11111111
    li t1, 0x22222222

    ecall

    li t2, 0x33333333
loop:
    j loop


.align 2
trap_handler:
    csrrw t0, mscratch, t0

    sw t1, 4(t0)

    csrr t1, mscratch
    sw t1, 0(t0)
    li t0, 0x9999              
    li t1, 0x8888              
    
    csrr t1, mepc
    addi t1, t1, 4
    csrw mepc, t1

    la t0, context_save_area
    lw t1, 0(t0)
    csrw mscratch, t1

    lw t1, 4(t0)               

    csrrw t0, mscratch, t0

    mret

.section .data
.align 4
context_save_area:
    .word 0
    .word 0


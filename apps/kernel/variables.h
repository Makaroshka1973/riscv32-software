#include <libc/stddef.h>
#include <process_types.h>

#define MAX_PROCESSES 32
#define STACK_SIZE 128

extern char __global_pointer$;

extern const uintptr_t BASE_MMIO_ADDR;
extern PCB *current_pcb;
extern PCB pcb_array[MAX_PROCESSES];
extern uint8_t stack[MAX_PROCESSES][STACK_SIZE];

extern queue_process_t process_queue;

#include <libc/stddef.h>
#include <process_types.h>
#include <funcs.h>
#include <variables.h>

queue_process_t process_queue;

PCB pcb_array[MAX_PROCESSES];
uint8_t stack[MAX_PROCESSES][STACK_SIZE];

PCB *current_pcb = &pcb_array[0];


void schedule() {
	if (current_pcb->state == PROCESS_RUNNING) {
		current_pcb->state = PROCESS_READY;
		enqueue_process(&process_queue, current_pcb);
	}

	current_pcb = dequeue_process(&process_queue);
	if (current_pcb == NULL) {
		current_pcb = &pcb_array[0];
		return;
	}

	current_pcb->state = PROCESS_RUNNING;

	return;
}


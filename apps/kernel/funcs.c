#include <libc/stddef.h>
#include <funcs.h>
#include <variables.h>
#include <scheduler.h>
#include <process_types.h>
#include <process_block.h>
#include <drivers/uart/uart_driver.h>
#include <drivers/keyboard/keyboard_driver.h>

ssize_t k_write(uint32_t file, char *buf, size_t len) {
	if (file == 1 || file == 2)
		return uart_write(buf, len);
	else
		return -1;
}

ssize_t k_read(uint32_t file, char *buf, size_t len) {
	if (file == 0) {
		keyboard_process_read(buf, len);
	}
	else
		return -1;

	return 0;
}

void enqueue_process(queue_process_t *q, PCB *p) {
	p->next = NULL;

	if (q->tail == NULL)
		q->head = p; // empty queue
	else
		q->tail->next = p;
	q->tail = p;

	return;
}

PCB *dequeue_process(queue_process_t *q) {
	if (q->head == NULL)
		return NULL; // empty queue

	PCB *p = q->head;
	q->head = p->next;

	if (q->head == NULL)
		q->tail = NULL; // removed last task

	p->next = NULL;
	return p;
}

ssize_t start_process (void *func) {
	int32_t process_idx = -1;
	for (int i = 1; i < MAX_PROCESSES; i++) {
		if (pcb_array[i].state == PROCESS_UNUSED || pcb_array[i].state == PROCESS_TERMINATED) {
			process_idx = i;
			break;
		}
	}
	if (process_idx == -1) return -1;

	pcb_array[process_idx].state = PROCESS_READY;
	pcb_array[process_idx].regs[1] = (uintptr_t)&stack[process_idx][STACK_SIZE];
	pcb_array[process_idx].regs[2] = (uintptr_t)&__global_pointer$;
	pcb_array[process_idx].regs[31] = (uintptr_t)func;

	enqueue_process(&process_queue, &pcb_array[process_idx]);

	return process_idx;
}

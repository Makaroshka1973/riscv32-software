#include <libc/stddef.h>
#include <variables.h>
#include <funcs.h>
#include <scheduler.h>
#include <process_types.h>
#include <process_block.h>

void block_current_process() {
	current_pcb->state = PROCESS_BLOCKED;
	schedule();
	return;
}

void unblock_process(PCB *p) {
	if (p != NULL) {
		p->state = PROCESS_READY;
		enqueue_process(&process_queue, p);
	}
	return;
}

void enqueue_ioreq(queue_ioreq_t *q, IORequest *r) {
	r->next = NULL;

	if (q->tail == NULL)
		q->head = r; // empty queue
	else
		q->tail->next = r;
	q->tail = r;

	return;
}

IORequest *dequeue_ioreq(queue_ioreq_t *q) {
	if (q->head == NULL)
		return NULL; // empty queue

	IORequest *r = q->head;
	q->head = r->next;

	if (q->head == NULL)
		q->tail = NULL; // removed last request

	r->next = NULL;
	return r;
}


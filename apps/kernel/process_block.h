#include <process_types.h>

#ifndef IOREQUEST_H
#define IOREQUEST_H
typedef struct IORequest IORequest;
struct IORequest {
	PCB *process;
	char *buffer;
	size_t length;
	size_t bytes_read;
	IORequest *next;
};
#endif

#ifndef QUEUE_IOREQ_H
#define QUEUE_IOREQ_H
typedef struct {
	IORequest *head;
	IORequest *tail;
} queue_ioreq_t;
#endif

#ifndef DEVICE_H
#define DEVICE_H
typedef struct {
	char buffer[64];
	size_t head;
	size_t tail;
	size_t len;
	queue_ioreq_t queue;
} device_t;
#endif

extern void block_current_process();
extern void unblock_process(PCB *p);

extern void enqueue_ioreq(queue_ioreq_t *q, IORequest *r);
extern IORequest *dequeue_ioreq(queue_ioreq_t *q);

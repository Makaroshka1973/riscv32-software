#include <libc/stddef.h>
#include <process_types.h>

extern ssize_t k_write(uint32_t file, char *buf, size_t len);

extern void enqueue_process(queue_process_t *q, PCB *p);
extern PCB *dequeue_process(queue_process_t *q);

ssize_t start_process (void *func);

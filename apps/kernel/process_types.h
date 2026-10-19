#include <libc/stddef.h>

#ifndef PROCESS_STATE_H
#define PROCESS_STATE_H
typedef enum {
	PROCESS_UNUSED = 0,
	PROCESS_READY,
	PROCESS_RUNNING,
	PROCESS_BLOCKED,
	PROCESS_TERMINATED
} process_state_t;
#endif

#ifndef PCB_H
#define PCB_H
typedef struct PCB PCB;

struct PCB {
	uint32_t regs[32];

	process_state_t state;
	uint32_t pid;

	PCB *next;
};
#endif

#ifndef QUEUE_PROCESS_H
#define QUEUE_PROCESS_H
typedef struct {
	PCB *head;
	PCB *tail;
} queue_process_t;
#endif

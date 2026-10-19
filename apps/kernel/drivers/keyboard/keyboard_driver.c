#include <libc/stddef.h>
#include <variables.h>
#include <funcs.h>
#include <process_types.h>
#include <process_block.h>

#define KEYBOARD_DATA_OFFSET 0x8
#define KEYBOARD_AVAIL_OFFSET 0xc

#define keyboard_data ((volatile char*)(BASE_MMIO_ADDR + KEYBOARD_DATA_OFFSET))
#define keyboard_avail ((volatile uint32_t*)(BASE_MMIO_ADDR + KEYBOARD_AVAIL_OFFSET))
#define MAX_REQUESTS 16

device_t keyboard_device;
IORequest keyboard_requests[MAX_REQUESTS];

void fulfill_requests() {
	while (keyboard_device.queue.head != NULL && keyboard_device.len > 0) {
		IORequest *req = keyboard_device.queue.head;

		while (req->bytes_read < req->length && keyboard_device.len > 0) {
			req->buffer[req->bytes_read] = keyboard_device.buffer[keyboard_device.tail];
			req->bytes_read++;

			keyboard_device.tail++;
			keyboard_device.len--;
		}
		if (req->bytes_read == req->length) {
			dequeue_ioreq(&keyboard_device.queue);
			unblock_process(req->process);
			req->process->regs[9] = req->bytes_read;
			req->length = 0;
		}
	}
}

ssize_t keyboard_process_read(char *buf, size_t len) {
	if (len == 0) return 0;

	int32_t req_idx = -1;
	for (int i = 0; i < MAX_REQUESTS; i++) {
		if (keyboard_requests[i].length == 0) {
			req_idx = i;
			break;
		}
	}
	if (req_idx == -1) return -1;

	IORequest *request = &keyboard_requests[req_idx];
	request->process = current_pcb;
	request->buffer = buf;
	request->length = len;
	request->bytes_read = 0;

	enqueue_ioreq(&keyboard_device.queue, request);

	fulfill_requests();

	if (request->bytes_read < request->length) {
		block_current_process();
	}
	return request->bytes_read;
}

void keyboard_interrupt() {
	while (*keyboard_avail) {
		if (keyboard_device.len < 64) {
			keyboard_device.buffer[keyboard_device.head] = *keyboard_data;
			*keyboard_data = 0;
			keyboard_device.head++;
			keyboard_device.len++;
		} else {
			*keyboard_data = 0;
		}
	}
	fulfill_requests();
}

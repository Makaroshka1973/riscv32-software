#include <libc/stddef.h>
#include <variables.h>

#define UART_DATA_OFFSET 0x0
#define UART_CLEAR_OFFSET 0x4

#define uart_data ((volatile char*)(BASE_MMIO_ADDR + UART_DATA_OFFSET))
#define uart_clear ((volatile uint32_t*)(BASE_MMIO_ADDR + UART_DATA_OFFSET))

ssize_t uart_write(char *buf, size_t len) {
	for (int i = 0; i < len; i++) {
		*uart_data = buf[i];
	}
	return len;
}

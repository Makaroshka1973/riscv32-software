#include <libc/stddef.h>
#include <variables.h>

#define MTIME_LOW_OFFSET 0x18
#define MTIME_HIGH_OFFSET 0x1c
#define MTIMECMP_OFFSET 0x20

#define mtime_low ((volatile uint32_t*)(BASE_MMIO_ADDR + MTIME_LOW_OFFSET))
#define mtime_high ((volatile uint32_t*)(BASE_MMIO_ADDR + MTIME_HIGH_OFFSET))
#define mtimecmp ((volatile uint64_t*)(BASE_MMIO_ADDR + MTIMECMP_OFFSET))

void mtimecmp_add(uint64_t adder) {
	// get mtime
	uint64_t high, low, high_after;
	do {
		high = *mtime_high;
		low = *mtime_low;
		high_after = *mtime_high;
	} while (high != high_after); // retry if high word changed
	
	*mtimecmp = (((uint64_t)high << 32) | low) + adder; // mtime + adder
	
	return;
}

void mtimecmp_write(uint64_t value) {
	*mtimecmp = value;
	return;
}

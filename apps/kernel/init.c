#include <libc/stddef.h>
#include <libc/stdio.h>

char buf[1];
char *ptr = buf;

void init () {
	write(1, "Inited!\n", 8);
	while (1) {
		read(0, ptr, 29);
		write(1, ptr, 29);
	}
}

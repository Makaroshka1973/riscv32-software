CC = riscv32-none-elf-gcc
CFLAGS = -march=rv32i -mabi=ilp32 -ffreestanding

all: crt0.o stubs.o

%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o

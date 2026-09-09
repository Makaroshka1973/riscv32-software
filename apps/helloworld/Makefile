PREFIX = riscv32-none-elf-
CC = $(PREFIX)gcc

SYSDIR = ../../sys
LINKER_SCRIPT = $(SYSDIR)/linker.ld
CRT = $(SYSDIR)/crt0.s

CFLAGS = -march=rv32i -mabi=ilp32 -nostartfiles -nostdlib
LDFLAGS = -T $(LINKER_SCRIPT)

TARGET = helloworld
SRC = $(TARGET).s
ELF = $(TARGET).out
BIN = $(TARGET).bin
RAW_BLOCKS = block0.raw block1.raw block2.raw block3.raw

all: $(RAW_BLOCKS)

$(ELF): $(SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) $(CRT) $< -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(RAW_BLOCKS): $(BIN)
	# Process Byte 0
	$(OBJCOPY) -I binary -O binary --interleave=4 --interleave-width=1 --byte=0 $(BIN) temp0.bin
	echo "v2.0 raw" > block0.raw
	hexdump -v -e '1/1 "%02x "' temp0.bin >> block0.raw
	
	# Process Byte 1
	$(OBJCOPY) -I binary -O binary --interleave=4 --interleave-width=1 --byte=1 $(BIN) temp1.bin
	echo "v2.0 raw" > block1.raw
	hexdump -v -e '1/1 "%02x "' temp1.bin >> block1.raw
	
	# Process Byte 2
	$(OBJCOPY) -I binary -O binary --interleave=4 --interleave-width=1 --byte=2 $(BIN) temp2.bin
	echo "v2.0 raw" > block2.raw
	hexdump -v -e '1/1 "%02x "' temp2.bin >> block2.raw
	
	# Process Byte 3
	$(OBJCOPY) -I binary -O binary --interleave=4 --interleave-width=1 --byte=3 $(BIN) temp3.bin
	echo "v2.0 raw" > block3.raw
	hexdump -v -e '1/1 "%02x "' temp3.bin >> block3.raw
	
	rm -f temp0.bin temp1.bin temp2.bin temp3.bin

clean:
	rm -f $(ELF) $(BIN) *.bin *.raw

.PHONY: all clean

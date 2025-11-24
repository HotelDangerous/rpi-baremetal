AARCH64 = aarch64-linux-gnu-

CXX = $(AARCH64)g++
AS  = $(AARCH64)gcc
LD  = $(AARCH64)ld
OBJCOPY = $(AARCH64)objcopy

CXXFLAGS = -ffreestanding -O2 -Wall -Wextra -nostdlib -fno-exceptions -fno-rtti
ASFLAGS  = -ffreestanding

all: kernel8.img

boot.o: boot.s
	$(AS) $(ASFLAGS) -c $< -o $@

kernel_main.o: kernel_main.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

kernel8.elf: boot.o kernel_main.o
	$(LD) -T link.ld boot.o kernel_main.o -o $@

kernel8.img: kernel8.elf
	$(OBJCOPY) kernel8.elf -O binary kernel8.img

clean:
	rm -f *.o *.elf *.img

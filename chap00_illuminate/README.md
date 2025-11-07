# Bare-Metal Raspberry Pi 3B+ — GPIO16 LED in ARM64 Assembly

This project demonstrates a minimal bare-metal program for the Raspberry Pi 3B+. It turns **GPIO16** on (solid ON) using **AArch64 (ARM64)** assembly, without Linux, without an operating system, and without any external libraries.

This README walks through the full process so that anyone with a Raspberry Pi 3B+ can reproduce it.

---

## Requirements

### Hardware
- Raspberry Pi 3B+
- 8 GB or 16 GB microSD card (recommended)
- USB microSD card reader
- LED (any color) and a 330 Ω resistor
- Jumper wires
- Breadboard (optional)

### Software (on your development machine)
You need the ARM64 cross toolchain.

**Arch Linux:**
```
sudo pacman -S aarch64-linux-gnu-binutils aarch64-linux-gnu-gcc
```

**Debian/Ubuntu:**
```
sudo apt install gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
```

This provides the tools:
- `aarch64-linux-gnu-as` (assembler)
- `aarch64-linux-gnu-ld` (linker)
- `aarch64-linux-gnu-objcopy` (ELF → raw binary)

---

## Wiring the LED to GPIO16

GPIO16 on the Raspberry Pi 3B+ is **physical pin 36**.

### Connect the LED:
- GPIO16 → resistor → LED anode (long leg)
- LED cathode (short leg) → any ground pin (e.g., pin 6)

This example turns the LED **solid ON**.

---

## ARM64 Assembly Code (`main.s`)

```asm
.section .text
.globl _start

_start:
    // Load GPIO base address for Raspberry Pi 3B+
    ldr x0, =0x3F200000

    // Configure GPIO16 as output (modify GPFSEL1 register)
    mov w1, #1
    lsl w1, w1, #18
    str w1, [x0, #4]

    // Set GPIO16 high (turn LED on)
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #28]

hang:
    b hang
```

---

## Building the Program

Run the following commands from the same directory as `main.s`:

```
aarch64-linux-gnu-as main.s -o main.o
aarch64-linux-gnu-ld main.o -Ttext=0x80000 -o main.elf
aarch64-linux-gnu-objcopy -O binary main.elf kernel8.img
```

You should now have:

```
kernel8.img
```

This is the raw binary the Raspberry Pi will execute at boot.

---

## Preparing the SD Card

We will create a bootable card that loads our bare-metal program instead of Linux.

### 1. Partition the SD card
Use a tool like `gparted` or `cfdisk`.

Create:
- **Partition 1:** FAT32 (recommended size: 256 MB to 512 MB)

### 2. Format the partition
```
sudo mkfs.vfat /dev/sdX1
```
Replace `sdX1` with your actual device.

### 3. Mount it
```
sudo mount /dev/sdX1 /mnt/boot
```

---

## Required Boot Files

The Raspberry Pi needs its boot firmware. Download from:

https://github.com/raspberrypi/firmware/tree/master/boot

You only need:
- `bootcode.bin`
- `start.elf`

Copy them into `/mnt/boot`.

---

## Create `config.txt`

Inside `/mnt/boot`, create a file named `config.txt`:

```
arm_64bit=1
kernel=kernel8.img
enable_uart=1
```

This instructs the Raspberry Pi to:
- use 64-bit mode
- load our bare-metal kernel named `kernel8.img`
- enable UART serial output (optional)

---

## Final SD Card Layout

Your SD card's `/mnt/boot` folder should contain:

```
bootcode.bin
start.elf
config.txt
kernel8.img
```

Unmount the card:

```
sudo umount /mnt/boot
```

Insert into your Raspberry Pi and power it on.

---

## Expected Behavior

When powered:
- The Pi’s ACT LED will blink once.
- The LED connected to GPIO16 will turn on and stay on.
- No Linux boots; your assembly code runs immediately.

---

## Troubleshooting

### 7 flashes of ACT LED (repeating)
This means the Raspberry Pi could not execute your kernel. Common causes:
- Incorrect file name (`kernel8.img` required)
- Incorrect architecture (must be ARM64)
- `config.txt` missing `arm_64bit=1`
- SD card formatting issues

### LED does not light
- Check wiring to GPIO16 (pin 36)
- Confirm resistor and LED orientation
- Ensure code is assembled for ARM64, not ARM32

---

## Rebuilding After Changes

After modifying `main.s`, re-run:

```
aarch64-linux-gnu-as main.s -o main.o
aarch64-linux-gnu-ld main.o -Ttext=0x80000 -o main.elf
aarch64-linux-gnu-objcopy -O binary main.elf kernel8.img
```

Then copy the new `kernel8.img` to the SD card.

---

## License
MIT


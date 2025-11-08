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

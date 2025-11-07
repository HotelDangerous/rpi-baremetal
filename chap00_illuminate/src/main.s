.section .text
.globl _start
_start:
    ldr x0, =0x3F200000      // GPIO base address

    // Set pin 16 as output
    mov w1, #1
    lsl w1, w1, #18
    str w1, [x0, #4]

    // Turn pin 16 ON (HIGH)
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #28]

hang:
    b hang


// blink.s — Raspberry Pi 3 B+ GPIO16 blink (AArch64)
.section .text
.globl _start

_start:
    ldr x19, =0x3F200000    // GPIO base address
    mov x20, #0x800000      // time delay (crude)
    mov w21, #16            // choosing pin number
    
    bl SetOutput            // set pin (w21) to output

blink:
    bl PinOn                // turn LED on
    bl Delay                // wait
    bl PinOff               // turn LED off
    bl Delay                // wait
b blink                     // repeat forever

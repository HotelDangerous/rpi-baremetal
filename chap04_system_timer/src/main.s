// blink.s — Raspberry Pi 3 B+ GPIO16 blink (AArch64)
.section .text
.globl _start

_start:
    ldr x19, =0x3F200000    // GPIO base address
    mov w20, #62500         // start delay (1/16 sec.)
    mov w21, #16            // choosing pin number
    ldr x22, =0x3F003004    // System Timer (lower 32) (CLO)
    ldr x23, =0x3F00300C    // System Time Compare 0 (C0)
    
    bl SetOutput            // set pin (w21) to output

blink:
    bl PinOn                // turn LED on
    bl Delay                // wait
    bl PinOff               // turn LED off
    bl Delay                // wait
    b blink                 // repeat forever

// blink.s — Raspberry Pi 3 B+ GPIO16 blink (AArch64)
.section .text
.globl _start

_start:
    ldr x0, =0x3F200000      // GPIO base address

    // Set pin 16 as output
    ldr w1, [x0, #4]         // read current GPFSEL1
    bic w1, w1, #(7 << 18)   // clear bits 20:18 (GPIO16)
    orr w1, w1, #(1 << 18)   // set 001 = output
    str w1, [x0, #4]

blink:
    bl PinOn                 // turn LED on
    bl Delay                 // wait
    bl PinOff                // turn LED off
    bl Delay                 // wait
    b blink                  // repeat forever

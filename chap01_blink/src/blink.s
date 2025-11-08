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

pin_on:
    // Turn pin 16 ON (HIGH)
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #28]   // GPSET0

    mov x2, #0x800000   // set delay time 
    
delay_on:
    subs x2, x2, #1
    bne delay_on

pin_off:
    // Turn pin 16 OFF (LOW)
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #40]   // GPCLR0

    mov x2, #0x800000   // set delay time

delay_off:
    subs x2, x2, #1
    bne delay_off

    b pin_on


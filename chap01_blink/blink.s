// blink.s — Raspberry Pi 3 B+ GPIO16 blink (AArch64)
.section .text
.globl _start

.equ GPIO_BASE, 0x3F200000
.equ GPFSEL1,  GPIO_BASE + 0x04
.equ GPSET0,   GPIO_BASE + 0x1C
.equ GPCLR0,   GPIO_BASE + 0x28

_start:
    // Set GPIO16 as output
    ldr x0, =GPFSEL1
    ldr w1, [x0]
    bic w1, w1, #(7 << 18)
    orr w1, w1, #(1 << 18)
    str w1, [x0]

loop:
    // LED on
    ldr x0, =GPSET0
    mov w1, #(1 << 16)
    str w1, [x0]

    mov x2, #0x200000
delay_on:
    subs x2, x2, #1
    b.ne delay_on

    // LED off
    ldr x0, =GPCLR0
    mov w1, #(1 << 16)
    str w1, [x0]

    mov x2, #0x200000
delay_off:
    subs x2, x2, #1
    b.ne delay_off

    b loop


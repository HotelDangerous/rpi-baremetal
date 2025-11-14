// blink.s — Raspberry Pi 3 B+ GPIO16 blink (AArch64)
.section .text
.globl _start

_start:
    // Set important values
    ldr x19, =0x3F200000    // GPIO base address
    mov w20, #62500         // start delay (1/16 sec.)
    mov w21, #16            // choosing pin number
    ldr x22, =0x3F003004    // System Timer (lower 32) (CLO)
    ldr x23, =0x3F00300C    // System Time Compare 0 (C0)
    
    bl SetOutput            // set pin (w21) to output

    // Load morse code pattern
    ldr x0, =pattern         // variable in assembly!
    ldr w24, [x0]            // w24 = 32-bit pattern
    mov w25, #0              // bit index = 0


// Morse code loop
morse_loop:
    // w0 = (1 << w25)
    mov w0, #1
    lsl w0, w0, w25

    // Test: (ex: 0010 && 1001 -> off)
    and w1, w24, w0
    cbnz w1, bit_is_one      // if bit != 0 → ON


// if Bit == 0, then turn pin off
bit_is_zero:
    bl PinOff
    bl Delay
    b next_bit

// if BIT == 1, then turn pin on
bit_is_one:
    bl PinOn
    bl Delay

// Get the next bit
next_bit:
    add w25, w25, #1
    cmp w25, #32
    b.lt morse_loop          // continue sequence

    // Restart after 32 bits
    mov w25, #0
    b morse_loop


// This puts the pattern in the .data section
.section .data
.align 2
pattern:
    .int 0b11111111101010100010001000101010

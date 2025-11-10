// Make functions available to other files
.globl PinOn
.globl PinOff
.globl Delay

// Turn pin 16 ON (HIGH)
PinOn:
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #28]       // GPSET0
    ret

// Turn pin 16 OFF (LOW)
PinOff:
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #40]       // GPCLR0
    ret

// Simple software delay
Delay:
    mov x2, #0x800000       // reload delay counter
    .loop:
        subs x2, x2, #1
        bne .loop
        ret

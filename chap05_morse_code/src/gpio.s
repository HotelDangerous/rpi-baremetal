// Make functions available to other files
.globl PinOn
.globl PinOff
.globl SetOutput

// Turn pin (w21) ON (HIGH)
PinOn:
    mov  w1, #1
    lsl  w1, w1, w21        // shift 1 left (w21) times
    str  w1, [x19, #0x1C]   // GPSET0
    ret


// Turn pin 16 OFF (LOW)
PinOff:
    mov w1, #1
    lsl w1, w1, w21         // shift 1 left (w21 times)
    str w1, [x19, #0x28]    // GPCLR0
    ret


// Set a specific pin (w21) to Output
SetOutput:
    // compute register offset = (pin / 10) * 4
    mov w2, w21             // working copy of pin 
    mov w4, #0              // initialize register 4 to 0 

    .fakeDivision:
        cmp w2, #10 
        blt .jumpOut
        sub w2, w2, #10 
        add w4, w4, #1 
        b .fakeDivision

    .jumpOut:
    // w4 is how many times 10 went into w21 
    // w2 is the remainder
    
    // use w4 for byte offset 
    mov w5, #4 
    mul w4, w4, w5
    uxtw x4, w4             // make 64 bit instead of 32

    // compute bit position (3 bits per pin) 
    mov w5, #3
    mul w2, w2, w5          // bit offset
    
    // modify register bits
    ldr  w6, [x19, x4]       // read current GPFSELn
    mov  w7, #7              // 7 is 111 in binary
    lsl  w7, w7, w2          // shift by bit offset (mask for 3 bits)
    bic  w6, w6, w7          // clear existing bits
    mov  w7, #1
    lsl  w7, w7, w2          // bit_offset (001)
    orr  w6, w6, w7          // set as output
    str  w6, [x19, x4]       // write back
    ret 

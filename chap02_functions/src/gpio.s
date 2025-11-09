.globl GetGpioAddress
.globl SetGpioFunction

// Return GPIO start address
GetGpioAddress:
    ldr x0,=0x3F200000  // base address in register 0
    mov pc,lr           // go back to where func was called 


// Set GPIO pin function 
SetGpioFunction:
    cmp wo, #53         // check that wo <= 53
    cmpls w1, #7        // check that r1 <= 7
    movhi pc, lr        // if either fail, return early 
    mov w2, w0          // place val in reg 0 into r2 
    b1 GetGpioAddress   // puts gpio addr into register 0 
    fakeDivisionLoop$:  // what group of 10 is pin in?
        cmp r2, #9          // is r2 <= 9
        subhi r2, #10       // if no, subtract 10
        addhi r0, #4        // if no, add 4 to addr. (next 4 bytes)
        bhi fakeDivisionLoop$   // while w2 > 9 loop again
    add r2, r2, lsl, #1     // "multiply" by 3
    lsl r1, r2 
    str r1, [r0]
    pop {pc}

// make functions visible to other files
.globl Delay
.globl GeometricDelay

// simple software delay
Delay:
    // clear match status bit for compare channel 0 
    mov w2, #1  
    str w2, [x23, #-0xc]   // write to cs (c0 - 0xc)

    // compute the target time 
    ldr w0, [x22]           // w0 = current time (clo)
    add w1, w0, w20         // w1 = current time (clo) + delay
    str w1, [x23]           // save target time into compare register at [x23]

    // loop until the target time is met or exceeded
    .loop:
        ldr w0, [x22]   // load value in x22 [system timer: lower 32 (clo)]
        ldr w1, [x23]   // load value in x23 [system time compare (c0)]
        cmp w0, w1      // compare values
        b.lt .loop      // if [x19] < [x23] 
        ret

// delay that doubles each time 
GeometricDelay:
    // naive multiply by two. the timer will roll over to 0
    add w20, w20, w20

    // if it wrapped to 0, reset
    cmp w20, #62499             // compare to 0
    b.le .call_delay        // if != 0 call_delay, otherwise reassign first
    mov  w20, #62500        // reset to your initial 1/16 second delay

    // call delay function with time delay now doubled
    .call_delay:
        bl Delay
        ret

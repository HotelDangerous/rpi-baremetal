// make functions visible to other files
.globl Delay
.globl GeometricDelay


// simple software delay
Delay:
    // clear match status bit for compare channel 0 
    mov w2, #1  
    str w2, [x23, #0xc]   // write to cs (c0 - 0xc)

    // compute the target time 
    ldr w0, [x22]           // w0 = current time (clo)
    add w1, w0, w20         // w1 = current time (clo) + delay
    str w1, [x23]           // save target time into compare register at [x23]

    // loop until the target time is met or exceeded
    .loop:
        ldr w0, [x22]   // load value in x22 [system timer: lower 32 (clo)]
        ldr w1, [x23]   // load value in x23 [system time compare (c0)]
        cmp w0, w1      // compare values
        b.lt .loop
    ret


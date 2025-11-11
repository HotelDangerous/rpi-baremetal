// Make functions visible to other files
.globl Delay

// Simple software delay
Delay:
    mov x0, x20         // load delay value
    .loop:
        subs x0, x0, #1
        bne .loop
        ret

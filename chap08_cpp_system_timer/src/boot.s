// boot.S — ARM64 bare-metal bootstrap for Raspberry Pi 3B+

.section .text
.global _start
_start:
    // Set stack pointer (use some safe area in RAM)
    ldr x0, =0x80000
    add x0, x0, #0x4000       // stack at 0x84000
    mov sp, x0

    // Call C++ kernel entry point
    bl kernel_main

// If kernel_main() returns, hang forever
1:  wfe
    b 1b

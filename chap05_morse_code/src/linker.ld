ENTRY(_start)

SECTIONS {
    . = 0x80000;             /* Pi 3 boot address */
    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) }
}


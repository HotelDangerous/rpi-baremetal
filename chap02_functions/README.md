# Bare-Metal Raspberry Pi 3B+ — Using Our First Functions (ARM64 Assembly)

This chapter builds on [Chapter 01 — Blink](../chap01_blink/README.md).  
Previously, we created a single assembly file that blinked an LED on **GPIO16** using simple branching logic.  
Here, we refactor that same functionality into **modular functions** — our first step toward structured, reusable code on bare metal.

---

## 🔧 Overview

We take the working blink code from the previous chapter and split it into **separate subroutines**:
- `PinOn` — turns the LED on  
- `PinOff` — turns the LED off  
- `Delay` — provides a crude timing delay  

These routines are placed in a new file, `functions.s`, and called from `main.s` using the **`bl` (branch with link)** instruction.  
This demonstrates how functions work in **AArch64 assembly**, where `bl` stores the return address in register **`x30`** (the link register), and each subroutine ends with **`ret`** to return control to the caller.

---

## 💡 Code Structure

### `main.s`
```asm
// main.s — calls our new subroutines
.section .text
.globl _start

_start:
    ldr x0, =0x3F200000      // GPIO base address

    // Set GPIO16 as output
    ldr w1, [x0, #4]
    bic w1, w1, #(7 << 18)
    orr w1, w1, #(1 << 18)
    str w1, [x0, #4]

blink:
    bl PinOn                 // turn LED ON
    bl Delay                 // wait
    bl PinOff                // turn LED OFF
    bl Delay                 // wait
    b blink
```

### `functions.s`
```asm
.globl PinOn
.globl PinOff
.globl Delay

PinOn:
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #28]        // GPSET0
    ret

PinOff:
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #40]        // GPCLR0
    ret

Delay:
    mov x2, #0x800000
.loop:
    subs x2, x2, #1
    bne .loop
    ret
```

---

## 🧠 What’s New in This Chapter

| Concept | Description |
|----------|--------------|
| **Subroutines** | Code is now organized into callable functions using `bl` (branch with link) and `ret`. |
| **Link Register (`x30`)** | The CPU stores the return address in `x30` automatically when `bl` is used. |
| **Code Reuse** | `PinOn`, `PinOff`, and `Delay` are self-contained, making future programs cleaner and easier to expand. |
| **Multiple Source Files** | Introduces splitting logic across multiple `.s` files and linking them together. |

---

## ⚙️ Behavior

When powered:
- The Raspberry Pi boots directly into your assembly program.
- The LED on **GPIO16** blinks **ON and OFF** repeatedly.
- Timing is controlled by the delay loop inside `Delay`.

---

## 🧩 File Summary

| File | Purpose |
|------|----------|
| `main.s` | Entry point — configures GPIO and calls the functions |
| `functions.s` | Contains reusable subroutines (`PinOn`, `PinOff`, `Delay`) |
| `kernel8.img` | Final binary output loaded by the Pi firmware |

---

## 🫩 Notes

- The behavior is identical to Chapter 01, but the structure is now modular.
- This chapter demonstrates how *function calls* and *returns* work in AArch64.
- This modular design prepares us for future chapters involving more complex components, like UART and timers.

---

## 🔧 Build Instructions

```bash
aarch64-linux-gnu-as -o main.o main.s
aarch64-linux-gnu-as -o functions.o functions.s
aarch64-linux-gnu-ld -Ttext=0x80000 -nostdlib -o kernel8.elf main.o functions.o
aarch64-linux-gnu-objcopy kernel8.elf -O binary kernel8.img
```

Copy `kernel8.img` to your SD card's boot partition, ensuring `config.txt` includes:
```
arm_64bit=1
kernel=kernel8.img
```


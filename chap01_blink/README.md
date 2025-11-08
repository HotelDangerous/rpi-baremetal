# Bare-Metal Raspberry Pi 3B+ — GPIO16 LED Blink (ARM64 Assembly)

This chapter builds on [Chapter 00 — Illuminate](../chap00_illuminate/README.md).  
Previously, we configured **GPIO16** to output and turn the LED **ON**.  
In this chapter, we add timing and control logic to make the LED **blink repeatedly**. Still in **bare-metal ARM64 assembly**, with no operating system.

---

## 🔧 Overview

The Raspberry Pi 3B+ executes our assembly code directly at power-on.  
We now alternate between writing to the **GPSET0** and **GPCLR0** registers, inserting a crude delay loop in between.

This results in a continuous on–off pattern visible on the LED connected to GPIO16.

---

## 💡 Code Explanation (`blink.s`)

```asm
// blink.s — Raspberry Pi 3 B+ GPIO16 blink (AArch64)
.section .text
.globl _start

_start:
    ldr x0, =0x3F200000      // GPIO base address

    // Set pin 16 as output
    ldr w1, [x0, #4]         // read current GPFSEL1
    bic w1, w1, #(7 << 18)   // clear bits 20:18 (GPIO16)
    orr w1, w1, #(1 << 18)   // set 001 = output
    str w1, [x0, #4]

pin_on:
    // Turn pin 16 ON (HIGH)
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #28]   // GPSET0

    mov x2, #0x800000   // set delay time 
delay_on:
    subs x2, x2, #1
    bne delay_on

pin_off:
    // Turn pin 16 OFF (LOW)
    mov w1, #1
    lsl w1, w1, #16
    str w1, [x0, #40]   // GPCLR0

    mov x2, #0x800000   // set delay time
delay_off:
    subs x2, x2, #1
    bne delay_off

    b pin_on
```

---

## 🧠 What’s New in This Chapter

| Concept | Description |
|----------|--------------|
| **Bit Clear (BIC)** | Clears the 3 bits in `GPFSEL1` that control GPIO16, before setting it as an output. This ensures we don’t overwrite unrelated bits. |
| **Bitwise OR (ORR)** | Sets the function bits to `001`, configuring the pin as an output. |
| **Delay Loop** | Uses a simple decrementing loop on register `x2` to waste cycles between ON and OFF states. The larger the value loaded into `x2`, the slower the blink. |
| **Infinite Loop** | After turning the LED off, execution branches back to `pin_on`, creating a continuous blink cycle. |

---

## ⚙️ Behavior

When powered:
- The Pi boots directly into your assembly program.
- The LED connected to GPIO16 repeatedly **blinks ON and OFF**.
- Timing depends on the chosen delay constant (`0x800000` in this case).

---

## 🧩 Notes

- No changes are needed to your SD card setup or build commands from Chapter 00.
- You can experiment with different delay values for faster or slower blinking.
- Real timing will vary with CPU clock speed — this is a *busy-wait*, not a precise timer.

---

## 📁 File Summary

| File | Purpose |
|------|----------|
| `blink.s` | Assembly source file for GPIO16 blink |
| `kernel8.img` | Binary output after assembly/linking |
| `config.txt` | Boot configuration file (same as Chapter 00) |

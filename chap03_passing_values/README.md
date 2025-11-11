# Bare-Metal Raspberry Pi 3B+ — Passing Arguments Between Functions (ARM64 Assembly)

This chapter builds on [Chapter 02 — Using Our First Functions](../chap02_functions/README.md).  
Previously, our subroutines didn’t receive data — they only redirected code.  
Now, we pass values through registers, following the **AArch64 ABI**, and start thinking carefully about *where* data lives and *what* survives between calls.

---

## 🔧 Overview

We now pass real arguments between functions:
- **x19** → GPIO base  
- **x20** → delay time  
- **w21** → pin number  

By storing these in **callee-saved registers**, each function can use them safely without reinitializing.

---

## 💡 Example

```asm
_start:
    ldr x19, =0x3F200000    // GPIO base
    mov x20, #0x800000      // delay
    mov w21, #16            // pin

    bl SetOutput            // set as output

blink:
    bl PinOn
    bl Delay
    bl PinOff
    bl Delay
    b blink
```

This structure gives us clean, reusable code that passes information explicitly.

---

## 🧠 The AArch64 ABI (Simplified)

| Register | Purpose | Who Keeps It |
|-----------|----------|--------------|
| x0–x7 | Arguments / Return values | Caller |
| x8–x18 | Scratch (temporary) | Caller |
| x19–x28 | Persistent (saved) | Callee |
| x29 | Frame pointer | Callee |
| x30 | Link register | Callee |

In our code, `x19–x21` hold important data permanently — respecting the ABI ensures those values stay valid across every function call.

---

## ⚙️ Why It Matters

This chapter is about **awareness**: knowing what each register does and who’s responsible for preserving it.  
Understanding and following the ABI keeps our code stable as it grows — a fundamental step toward building an RTOS.

---


# Chapter 07 — C++ Blink (Bare-Metal Raspberry Pi 3B+)

This chapter rewrites the classic “blink an LED” program in modern C++, running with no OS, no runtime, and no standard library. It builds on the previous C++ chapter by introducing:

- GPIO helper functions  
- proper GPIO bitfield masking  
- a standalone busy-wait delay  
- correct use of volatile  
- unsigned shift constants (`1u`, `7u`)  
- debugging a compiler optimization bug  

---

## GPIO Configuration in C++

Each GPIO pin is controlled by a 3-bit function field inside the GPFSEL registers.

To configure GPIO16 [18-20]:

```c++
int shift = (pin_num % 10) * 3; // (16 % 10) * 3 = 18
sel &= ~(7u << shift);   // clear the 3-bit field
sel |=  (1u << shift);   // set output mode (001)
```

Using `1u` and `7u` ensures the operation is done with **unsigned integers**, which avoids unexpected behavior with bit shifting.

---

## Setting Pins High and Low

The Pi has two separate write-only registers:

- GPSET0 → set pin HIGH  
- GPCLR0 → set pin LOW  

```c++
gpset0 = (1u << pin);   // HIGH
gpclr0 = (1u << pin);   // LOW
```

These registers **must be assigned**, not |= or &=, because they are write-only.

---

## Busy-Wait Delay and the Role of `volatile`

Initially, when I wrote this, the busy-wait loop was optimized away:

```c++
void busy_wait(uint32_t delay) {
    while (delay--) {}
}
```

The compiler saw a loop with no side effects and removed it.  
This caused the LED to appear constantly ON because the OFF delay was never executed.

### Fix: make the delay argument `volatile`

```c++
void busy_wait(volatile uint32_t delay) {
    while (delay--) {}
}
```

With `volatile`, the compiler must execute the loop exactly as written.

This is a key lesson in bare-metal programming:
**a delay loop with no hardware access may needs volatile; otherwise the optimizer may delete it.**

---

## Expected Behavior

- GPIO16 turns ON  
- waits using the busy-wait delay  
- GPIO16 turns OFF  
- waits again  
- repeats forever  

Adjusting `timeout` changes blink speed.

---

## Key Lessons Learned

- `volatile` is required for timing loops and MMIO registers  
- use `1u` and `7u` for correct unsigned bit shifting  
- GPSET0 and GPCLR0 are write-only and must be assigned  
- compiler optimizations *can* break naive delay loops  
- bitfield manipulation is central to GPIO control  

---

## Next Steps

Chapter 08 will introduce:

- splitting functions into separate `.cpp` files  
- building a small GPIO library  
- organizing a folder structure  
- continuing toward a modular bare-metal C++ kernel  

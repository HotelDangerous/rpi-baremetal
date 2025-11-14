# Bare-Metal Raspberry Pi 3B+ — Using the System Timer (ARM64 Assembly)

This chapter introduces our **first hardware device beyond GPIO**:  
the **BCM System Timer**. Instead of waiting with a software loop, we now
use the Pi's hardware timer to create precise delays.

This continues the discipline from previous chapters:  
following the **AArch64 ABI**, keeping important values in
**callee-saved registers**, and understanding how the CPU sees the
peripherals.

---

## 🔧 Overview

We now use the System Timer’s free-running counter (CLO) and one of its
compare registers (C0) to implement accurate delays.

Files introduced:
- `main.s` — initializes pointers to CLO and C0  
- `time.s` — implements the hardware-timer `Delay`  
- `gpio.s` — unchanged except for using the ABI-assigned registers  

Persistent registers we use:
- **x19** → GPIO base  
- **w20** → delay in microseconds  
- **w21** → pin  
- **x22** → address of CLO  
- **x23** → address of C0  

This follows the ABI rule that `x19–x28` are callee-saved and stable across calls.

---

## 🧠 GPU vs CPU Address Conversion

The BCM2835/2836/2837 manuals list **GPU bus addresses**, usually starting with `0x7E000000`.

The ARM core on the Raspberry Pi 3 uses a **different peripheral base**:

```
PeripheralBase = 0x3F000000
```

To convert:

```
ARM_address = Bus_address - 0x7E000000 + PeripheralBase
```

Example:
- Timer bus address: `0x7E003004`  
- ARM address: `0x3F003004`  

This is why CLO = `0x3F003004` and C0 = `0x3F00300C`.

---

## 💡 How the Hardware Delay Works

1. Clear the match bit in the Control/Status register.  
2. Read the current time from **CLO**.  
3. Add the desired delay to compute a target time.  
4. Write that target to **C0**.  
5. Loop until `CLO >= C0`.

This is our first use of a real hardware peripheral, and it forms the basis of
future features like **timer interrupts**, **scheduling**, and eventually an RTOS task system.

---

## ⚙️ Example Snippet

```asm
ldr w0, [x22]          // now = CLO
add w1, w0, w20        // target = now + delay
str w1, [x23]          // write target to C0
.loop:
    ldr w0, [x22]
    ldr w1, [x23]
    cmp w0, w1
    b.lt .loop
ret
```

---

## 🧭 Why This Chapter Matters

This is our first real interaction with a **timing device**, not just a loop.
We now have deterministic delays, understand how the timer is mapped into ARM
address space, and follow the ABI to keep registers organized as the program grows.

This sets the stage for:
- Timer interrupts  
- Preemptive scheduling  
- A future RTOS tick handler  

A foundational step toward building an operating system.

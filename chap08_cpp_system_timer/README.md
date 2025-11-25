# Chapter 08 — C++ System Timer (Bare-Metal Raspberry Pi 3B+)

In the previous chapter (C++ Blink), we built a simple LED blinker using a busy-wait loop inside the CPU. That version worked, but it relied on a crude timing method that was vulnerable to compiler optimizations and CPU-frequency changes.
This chapter introduces a real hardware timer, and begins the transition toward a modular, multi-file kernel.

This is the first chapter where your bare-metal C++ code begins to resemble a small operating system.

-------------------------------------------------------------

## Why Use the System Timer?

The Raspberry Pi exposes a free-running 32-bit counter located at:

0x3F003000 + 0x04  →  System Timer CLO (lower 32 bits)

This counter increments once per microsecond and never stops (until it wraps around after ~71 minutes).
By comparing time differences, we can implement accurate delays without busy-wait optimization issues.

This eliminates the need for 'volatile' delay loops and moves timing responsibility to dedicated hardware.

-------------------------------------------------------------

## What Changed in This Chapter?

### 1. A real system timer module

We created:
- timer.hpp
- timer.cpp

The module:
- reads the hardware counter via MMIO
- provides timer::now() (microseconds since boot)
- provides timer::delay(seconds) using accurate hardware timing
- hides internal helper functions using an unnamed namespace

This is your first real hardware driver.

---

### 2. Modular, multi-file C++ kernel

GPIO code now lives in:
- gpio.hpp
- gpio.cpp

Timer code is also isolated in its own pair of files.

kernel_main.cpp now uses clean high-level calls:

    gpio::set_output(16);
    gpio::pin_high(16);
    timer::delay(1);

This begins the separation of:
- hardware access
- kernel logic
- reusable drivers

This structure will scale into UART, framebuffer, and eventually your RTOS.

---

### 3. Proper MMIO register access

We now use a safe helper in an unnamed namespace:

    inline volatile uint32_t& reg(uintptr_t addr) {
        return *reinterpret_cast<volatile uint32_t*>(addr);
    }

This keeps MMIO implementation private, prevents name collisions, and makes the timer independent of GPIO.

---

### 4. Safe and correct delay logic

Instead of a decrement loop, we now use:

    uint32_t start = now();
    while ((now() - start) < usec) {}

This is:
- microsecond accurate
- wraparound-safe
- resistant to compiler optimizations

This is the standard pattern used in real embedded kernels.

-------------------------------------------------------------

## Comparison With Chapter 07

Concept                 | Chap07 (Blink)       | Chap08 (System Timer)
----------------------------------------------------------------------
Delay method            | CPU busy-wait loop    | Hardware timer
Risk of optimization    | High                  | None
Timing accuracy         | Crude                 | Microsecond-accurate
Modules                 | All in one file       | Split into gpio/ and timer/
MMIO access             | Local functions       | Independent reusable modules
Kernel structure        | Minimal               | Beginning of OS-like layout

-------------------------------------------------------------

## Expected Behavior

- GPIO16 still blinks
- Delays are now real-time accurate
- Changing optimization level or CPU load does not affect timing
- Code is cleaner, modular, and easier to scale

You're no longer relying on timing loops that “happen to work”.
You're now using real hardware timing, just like a real embedded OS.

-------------------------------------------------------------

## Key Lessons Learned

- Hardware timers are essential for reliable delays
- Unnamed namespaces provide proper internal linkage
- Drivers should live in separate .cpp modules
- MMIO access should be encapsulated
- Kernel logic becomes simpler as modules become smarter

You now have the foundation of a real hardware-abstraction layer.

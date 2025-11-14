# Raspberry Pi 3B+ Bare Metal Series
This repository documents my full journey into bare-metal Raspberry Pi development, progressing chapter-by-chapter from the simplest possible program to building a real RTOS.

Each chapter is fully self-contained, with its own source code, build system, and documentation so that others can follow along and grow their skills the same way.

## Chapters
### Chapter 00 – Minimal LED (GPIO16 ON)
Turns GPIO16 on using pure ARM64 assembly.
Source: chapters/chapter00_minimal_led/

### Chapter 01 – Blink Loop  
Introduces looping in ARM64 assembly.  
The LED toggles on and off using a simple CPU‑burning delay loop.  
Source: chapters/chap01_blink/

### Chapter 02 – First Functions  
Introduces `bl` (branch with link) and `ret`.  
Code is split into reusable functions: `PinOn`, `PinOff`, and `Delay`.  
No arguments passed yet — just control flow.  
Source: chapters/chap02_functions/

### Chapter 03 – Passing Arguments (ABI)  
Introduces the **AArch64 ABI** and how to pass data between functions.  
Registers gain specific roles:  
- `x19` = GPIO base  
- `w20` = delay  
- `w21` = pin  
Explains caller/callee‑saved registers.  
Source: chapters/chap03_passing_arguments/

### Chapter 04 – System Timer  
Integrates the **BCM System Timer**, the project’s first hardware device.  
Implements precise delays using:  
- CLO (`0x3F003004`)  
- C0 compare (`0x3F00300C`)  
Explains GPU→CPU address translation using:  
```
ARM_addr = Bus_addr - 0x7E000000 + PeripheralBase
```
Source: chapters/chap04_system_timer/

### Chapter 05 – Morse Code  
Introduces **variables in assembly** using the `.data` section.  
Blinks LED according to a 32‑bit bitfield pattern.  
Uses `cbnz` for efficient bit tests and branching.  
Mentions RWX linker warning as expected for bare‑metal (no MMU).  
Source: chapters/chap05_morse_code/

More chapters coming soon...



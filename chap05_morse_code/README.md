# Bare-Metal Raspberry Pi 3B+ — Morse Code Blinking (ARM64 Assembly)

In this chapter, we expand our bare‑metal toolkit by introducing **variables
in assembly**, using the **`cbnz` conditional branch**, and combining our
existing GPIO and System Timer functions to blink an LED in **Morse code**.

This is our first chapter that works with actual **data stored in memory**, not
just register‑based values.

---

## 🔧 Overview

We define a 32‑bit value called `pattern` in the `.data` section:

```asm
pattern:
    .int 0b11111111101010100010001000101010
```

Then we load it at runtime using:

```asm
ldr x0, =pattern     // load the address of the variable
ldr w24, [x0]        // load the 32-bit value stored there
```

This shows how to place **variables** in memory and access them cleanly in
AArch64.

We then step through each bit (0–31) and use it to decide whether the LED
should turn ON or OFF for that portion of the sequence.

---

## 🔁 Using `cbnz`

A new instruction introduced here is:

```asm
cbnz wX, label
```

Meaning:

> “Compare the register with zero.  
> If it is **NOT** zero, branch to `label`.”

This is perfect for bit testing:

```asm
and w1, w24, w0   // isolate a single bit
cbnz w1, bit_is_one
```

If the selected bit is 1 → LED ON.  
If the selected bit is 0 → LED OFF.

---

## ⏱️ System Timer + Morse Pattern

We reuse our working System Timer delay from chap04, using:

- **CLO** at `0x3F003004`
- **C0** at `0x3F00300C`

The LED blinks using:

- `PinOn`
- `PinOff`
- `Delay`

And a loop that walks through the 32 bits of the pattern.

This is our first time combining:

- GPIO output  
- System Timer delays  
- Data stored in memory  
- Bit testing  
- Conditional branching  

Together, they form the basis for more complex behaviors.

---

## ⚠️ About the RWX Warning

The linker may emit:

```
kernel8.elf has a LOAD segment with RWX permissions
```

This is *expected* in bare‑metal development.

Because we are executing directly from RAM without an MMU, the code, data, and
stack all live in the same physical region. Modern operating systems separate
these for security, but a bare‑metal kernel naturally has RWX sections.

No action is required.

---

## 🧭 Why This Chapter Matters

This chapter is small but meaningful. We now know how to:

- Define and access global variables in assembly  
- Step through individual bits of a 32‑bit value  
- Use `cbnz` for efficient conditional logic  
- Combine GPIO, timers, and data into a real program  
- Interpret arbitrary bit patterns as LED output sequences  

This is the first step toward **data‑driven behavior** in our OS project.

A small chapter — but a very important one.

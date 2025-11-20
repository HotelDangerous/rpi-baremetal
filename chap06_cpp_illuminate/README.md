# Raspberry Pi 3B+ Bare Metal – Chapter 06 (C++ Version)

This chapter rewrites the original ARM64 assembly version of **chap00** in modern **C++**, still running on bare metal with **no OS**, **no runtime**, and **no standard library**.

The program turns **GPIO16 ON** and hangs forever.  
Functionally, this is a very simple C++ bare-metal kernel. The syntax and types, however, may be a bit challenging.

---

## 🔧 What This Chapter Demonstrates
- Booting a custom C++ kernel on the Raspberry Pi  
- Using **memory-mapped I/O (MMIO)** in C++  
- Configuring GPIO using bit manipulation  
- Why bare-metal kernels do **not** use `main()`  
- Why hardware registers must be **volatile**  
- How `boot.s` jumps into `kernel_main()`

This marks the beginning of our **C++ bare-metal OS**.

---

## 📄 Files in This Chapter

### **boot.s**
Minimal ARM64 bootstrap:
- Sets stack pointer  
- Calls `kernel_main()`  
- Enters low-power idle loop if it returns  

### **kernel_main.cpp**
Our first C++ kernel:
- Configures GPIO16 as output  
- Sets GPIO16 HIGH  
- Loops forever  

### **link.ld**
Tells the linker:
- Load the kernel at **0x80000** (Pi firmware location)  
- Layout of `.text`, `.data`, `.bss` sections  
- Entry point `_start`

### **Makefile**
Automates:
- Building assembly  
- Building C++ (freestanding)  
- Linking  
- Producing the final **kernel8.img**

---

## 🧠 Key Concepts

### **1. Why kernel_main() instead of main()**
Bare-metal does not have:
- argc/argv  
- a C/C++ runtime  
- automatic stack setup  
- startup code  

We define:

```cpp
extern "C" void kernel_main();
```
and our assembly stub calls it directly.

---

### **2. What is MMIO ?**
Memory-Mapped I/O means hardware registers appear at fixed memory addresses. Example:

```cpp
reinterpret_cast<volatile uint32_t*> (0x3F20001C)
```
This is not RAM. It is the **GPIO SET register**.

### **3. Why `volatile`?**

Hardware registers:
- can change outside the program 
- must not be cached 
- must be written exactly as specified 
`volatile` ensures the compiler does not optimize them away.

### **4. Configure GPIO16**
Each GPIO pin is controlled by a 3-bit function field. GPIO 16 uses bits **20:18** of **GPFSEL1**.
- **000** -> Input pin
- **001** -> Output pin 
- Anything else is an alternative function. 

---

## 🚀 Expected Behavior

After copying **kernel8.img** to the SD card and booting:

- The Pi firmware loads your C++ kernel into memory  
- `boot.s` sets up the stack and calls `kernel_main()`  
- GPIO16 is configured as an output  
- GPIO16 is set HIGH  
- The CPU enters an infinite idle loop  

Our LED turns **solid ON** — your first C++ bare-metal kernel works!

---

## 📌 Notes

- `kernel8.img` is **required** for 64-bit boot on Raspberry Pi 3B+  
- This kernel uses **no heap**, **no interrupts**, **no constructors**, and **no standard library**  
- `reinterpret_cast` is correct and safe for MMIO register access  
- Everything else (timers, UART, framebuffer, interrupts) will come in later chapters.

---

## 🎉 Next Steps

Next up: **Chapter 01 (C++ Version)**  
We’ll implement a blinking LED using a CPU-burn delay loop, matching the assembly chapter but in clean C++.

Bare-metal C++ has officially begun.


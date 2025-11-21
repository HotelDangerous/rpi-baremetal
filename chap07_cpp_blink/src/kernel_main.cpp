#include <cstdint>

// global variables
const volatile uintptr_t gpio_base = 0x3f200000;
const volatile uint32_t timeout = 0xA00000; // ~1 billion

// function to reinterpret an integer as a pointer
inline volatile uint32_t &reg(uintptr_t address) {
  return *reinterpret_cast<volatile uint32_t *>(address);
}

// set pin as output
void set_input(volatile uint32_t &gpfsel, int pin_num) {
  int shift = (pin_num % 10) * 3;
  uint32_t sel = gpfsel;

  sel &= ~(7u << shift); // clear bits  (000)
  gpfsel = sel;
}

// set pin as output
void set_output(volatile uint32_t &gpfsel, int pin_num) {
  int shift = (pin_num % 10) * 3;
  uint32_t sel = gpfsel;

  sel &= ~(7u << shift); // clear bits  (000)
  sel |= (1u << shift);  // set output  (001)
  gpfsel = sel;
}

// pull pin high
void pin_high(volatile uint32_t &gpset, int pin_number) {
  gpset = (1u << pin_number);
}

// pull pin low
void pin_low(volatile uint32_t &gpclr, int pin_number) {
  gpclr = (1u << pin_number);
}

void busy_wait(volatile uint32_t delay) {
  while (delay--) {
    /* wasting time */
  }
}

extern "C" void kernel_main() {
  // memory mapped input / output (mmio)
  volatile uint32_t &gpfsel1 = reg(gpio_base + 0x04);
  volatile uint32_t &gpset0 = reg(gpio_base + 0x1c);
  volatile uint32_t &gpclr0 = reg(gpio_base + 0x28);

  // set pin 16 as output
  set_output(gpfsel1, 16);

  // infinite loop (blink)
  while (true) {
    pin_high(gpset0, 16);
    busy_wait(timeout);
    pin_low(gpclr0, 16);
    busy_wait(timeout);
  }
}

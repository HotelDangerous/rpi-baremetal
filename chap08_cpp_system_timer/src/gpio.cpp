#include "gpio.hpp"

namespace GPIO {

// function to reinterpret an integer as a pointer
volatile uint32_t &reg(uintptr_t address) {
  return *reinterpret_cast<volatile uint32_t *>(address);
}

// set pin as input
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

} // namespace GPIO

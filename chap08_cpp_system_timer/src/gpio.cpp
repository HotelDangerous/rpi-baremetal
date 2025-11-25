#include "gpio.hpp"

namespace gpio {

// Register address
volatile uint32_t &reg(uintptr_t address) {
  return *reinterpret_cast<volatile uint32_t *>(address);
}

// Set pin as input / output
void set_input(int pin_num) {
  int index = pin_num / 10; // integer division
  int shift = (pin_num % 10) * 3;

  volatile uint32_t &gpfsel = reg(GPIOBASE + (index * 4));
  volatile uint32_t sel = gpfsel;

  sel &= ~(7u << shift);
  gpfsel = sel;
}

void set_output(int pin_num) {
  int index = pin_num / 10; // integer division
  int shift = (pin_num % 10) * 3;

  // compute correct general purpose function selector
  volatile uint32_t &gpfsel = reg(GPIOBASE + (index * 4));
  volatile uint32_t &sel = gpfsel;

  // setting pin as output
  sel &= ~(7u << shift);
  sel |= (1u << shift);
  gpfsel = sel;
}

// Pull pin high / low
void pin_high(int pin_num) {
  volatile uint32_t &gpset = reg(GPIOBASE + 0x1C);
  gpset = (1u << pin_num);
}

void pin_low(int pin_num) {
  volatile uint32_t &gpclr = reg(GPIOBASE + 0x28);
  gpclr = (1u << pin_num);
}

} // namespace gpio

#ifndef GPIO_HPP
#define GPIO_HPP

#include <cstdint>

namespace GPIO {
// GPIOBASE: reference position for all hardware
constexpr volatile uintptr_t GPIOBASE = 0x3f200000;

// convert integer to reference to that memory address
volatile uint32_t &reg(uintptr_t address);

// set pin as output
void set_input(volatile uint32_t &gpfsel, int pin_num);

// set pin as output
void set_output(volatile uint32_t &gpfsel, int pin_num);

// pull pin high
void pin_high(volatile uint32_t &gpset, int pin_number);

// pull pin low
void pin_low(volatile uint32_t &gpclr, int pin_number);
} // namespace GPIO

#endif

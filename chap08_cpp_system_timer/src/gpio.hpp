#ifndef GPIO_HPP
#define GPIO_HPP

#include <cstdint>

namespace gpio {

// Reference point for hardware
const uintptr_t GPIOBASE = 0x3f200000;

// Register address
volatile uint32_t &reg(uintptr_t addres);

// Set pin as input / output
void set_input(int pin_num);
void set_output(int pin_num);

// Pull pin high / low
void pin_high(int pin_num);
void pin_low(int pin_num);

} // namespace gpio

#endif // GPIO_HPP

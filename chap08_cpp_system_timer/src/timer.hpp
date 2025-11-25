#ifndef TIMER_HPP
#define TIMER_HPP

#include <cstdint>

namespace timer {

// Return register address
volatile uint32_t& reg(uintptr_t address);

// Time functions
uint32_t now();
void delay(uint32_t seconds);

} // end namespace timer

#endif

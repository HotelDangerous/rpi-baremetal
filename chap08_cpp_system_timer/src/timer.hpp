#ifndef TIMER_HPP
#define TIMER_HPP

#include <cstdint>

namespace timer {

// Time functions
uint32_t now();
void delay(uint32_t seconds);

} // end namespace timer

#endif

#ifndef TIMER_HPP
#define TIMER_HPP

#include <cstdint>

namespace timer {
uint32_t now();
void delay(uint32_t seconds);
} // namespace timer

#endif

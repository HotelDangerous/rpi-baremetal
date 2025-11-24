#include "gpio.hpp"
#include <cstdint>

const uint32_t current_time = GPIO::reg(0x3F003004);

namespace timer {
// Get the current time (system counter time)
uint32_t now() { return current_time; }

// Delay using the system timer
void delay(uint32_t seconds) {
  uint32_t start = now(); // current time
  while (now() - start < seconds) {
    /* wait */
  }
  return;
}

} // namespace timer

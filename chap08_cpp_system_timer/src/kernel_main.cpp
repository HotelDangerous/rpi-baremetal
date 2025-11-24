#include <cstdint>

#include "gpio.hpp"
#include "timer.hpp"

// global variables
const volatile uint32_t timeout = 0xA00000; // ~1 billion

extern "C" void kernel_main() {
  // memory mapped input / output (mmio)
  volatile uint32_t &gpfsel1 = GPIO::reg(GPIO::GPIOBASE + 0x04);
  volatile uint32_t &gpset0 = GPIO::reg(GPIO::GPIOBASE + 0x1c);
  volatile uint32_t &gpclr0 = GPIO::reg(GPIO::GPIOBASE + 0x28);

  // set pin 16 as output
  GPIO::set_output(gpfsel1, 16);

  // infinite loop (blink)
  while (true) {
    GPIO::pin_high(gpset0, 16);
    timer::delay(10);
    GPIO::pin_low(gpclr0, 16);
    timer::delay(10);
  }
}

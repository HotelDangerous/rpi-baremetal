#include "timer.hpp"

namespace /* private */ {
constexpr uintptr_t TIMERBASE = 0x3F003000;
constexpr uintptr_t CL0OFFSET = 0x04;

// Return register address
volatile uint32_t& reg(uintptr_t address) {
    return *reinterpret_cast<volatile uint32_t*>(address);
}

} // end namespace


namespace timer {

// Time functions
// Returns time since boot in microseconds
uint32_t now() { return reg(TIMERBASE + CL0OFFSET); }

// Busy wait for given number of seconds
void delay(uint32_t seconds) {
    uint32_t stop = now() + (seconds * 1000000);    // now + (seconds -> microseconds)

    while(now() < stop) {
        /* busy loop */
    }
}

} // end namespace timer

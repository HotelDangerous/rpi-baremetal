#include "gpio.hpp"
#include "timer.hpp"

extern "C" void kernel_main() {
    
    // set pin 16 as an output pin
    gpio::set_output(16);

    while (true) { // forever loop 
        // blink on / off (1 second)
        gpio::pin_high(16);
        timer::delay(1);
        gpio::pin_low(16);
        timer::delay(1);

        // blink on / off (4 seconds)
        gpio::pin_high(16);
        timer::delay(4);
        gpio::pin_low(16);
        timer::delay(4);
    }
}

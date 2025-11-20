#include <cstdint>

// Define base address for GPIO hardware
constexpr uintptr_t GPIO_BASE = 0x3F200000;

// Helper function: treat memory address as a hardware address
inline volatile uint32_t &reg(uintptr_t addr) {
  return *reinterpret_cast<volatile uint32_t *>(addr);
}

extern "C" void kernel_main() {

  // Sets GPIO pin 16 to output mode
  volatile uint32_t &GPFSEL1 = reg(GPIO_BASE + 0x04);

  uint32_t sel = GPFSEL1;
  sel &= ~(7 << 18); // clear bits 20:18
  sel |= (1 << 18);  // set to output (20:18 == 001)
  GPFSEL1 = sel;

  // Set GPIO16 HIGH (turn on the light)
  volatile uint32_t &GPSET0 = reg(GPIO_BASE + 0x1C);
  GPSET0 = (1 << 16); // write 1 to bit 16 -> pin goes high

  // Hang: infinite loop
  while (true) {
  }
}

// SYNTAX:
// constexpr: This will be a constant at compile time not a variable
// uintptr_t: An unsigned integer type that is large enough to store a pointer
// uint32_t&: A reference to a 32-bit unsigned integer
// volatile:  This value can change outside of the program, don't optimize

// extern: "C" Do not apply C++ name mangling to this function
//         i.e. (dont change the name under the hood).
// reinterpret_cast<T*>: Convert an integer to a pointer to some type T
// volatile uint32_t*: Pointer to a hardware address

// VOCABULARY:
// GPFSEL1: GPIO function selector register 1:
//      (1) Controls pins 10-19;
//      (2) Each pin uses 3 bits to choose its function
//          (000)  Input
//          (001)  Output
//          (else) Alternate Function
// GPSET0: GPIO Pin Output Set Register 0 ("turn this pin on")
//      (1) Writing a 1 to bit N turns pin N HIGH
//      (2) Writing a 0 to bit N does nothing
//      (3) Write-only
//      (4) used for GPIO pins 0-31

// CRYPTIC LINES OF CODE:
// return *reinterpret_cast<volatile uint32_t*>(addr);
/* addr -> an unsigned integer large enough to hold a pointer
 * reinterpret_cast<volatile uint32_t> -> convert this integer into a pointer
 * that points to a unsigned 32-bit integer. Then the (*) dereferences that
 * pointer, giving the underlying address in memory uintptr_t -> uint32_t* ->
 * uint32_t&
 * */

// sel &= ~(7 << 18);
/* First recall that 7 in binary is equal to 111.
 *
 * (7 << 18) -> Shift the number 7 (111) left 18 times so that we have the bit
 * string: 00000000000111000000000000000000
 *
 * ~() -> inverts the bitstring so that we have
 * 11111111111000111111111111111111
 *
 * sel &= bit_string -> compute the & operation on all bits, for the bit strings
 * sel and whatever is on the R.H.S. of the &= function. In the case of this bit
 * string that just means leave all the bits the same, except bits [20:18] which
 * will be set to 0.
 * */

// sel |= (1 << 18);
/* This is very similar to the above case. The difference is two fold:
 *      1. No inversion ~()
 *      2. Computing the logical OR on each bit instead of the logical AND
 * Here we want bit 18 of sel to be 1, but we dont want to change any of the
 * other bits that are stored there
 * */

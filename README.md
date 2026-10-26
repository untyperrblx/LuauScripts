# Luau Scripts

Scripts and modules in Luau that I made for fun or when I felt bored

The current moduels can be found inside [`modules`](./modules/).

The older modules can be found in [`legacy`](./legacy/).

# Modules
### Current
The following modules are recently developed and completely functional for use.

- [Randlib](./modules/randlib.luau) - A custom pseudorandom number generator module inspired by Roblox's `Random` library
- [Base64](./modules/base64.luau) - A module that encodes/decodes data into [base 64](https://en.wikipedia.org/wiki/Base64)

### Legacy
The following modules are very outdated and/or deprecated.

- [Bit Encoder Test](./legacy/BitEncoderTest.luau) - A test archive for encoding data into a large set of bits
- [Fenv Mod](./legacy/FenvMod.luau) - A module for modifying Luau function environments (ability to change Luau "global" variables and libraries)
- [Hidden Tables](./legacy/HiddenTables.luau) - A module for protecting modifiable tables by implementing into `userdata`, but is now deprecated due to the use of the function `getrawmetatable()`
- [String Encoder](./legacy/StringEncoder.luau) - An old encryption tool which creates specific keys and offsets each character's byte within the data; keys are implemented inside the encoded result to easily decode back into the original data

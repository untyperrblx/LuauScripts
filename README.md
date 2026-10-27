# Luau Scripts

Scripts and modules in Luau that I made for fun or when I felt bored

The current modules can be found inside [`modules`](./modules/).

Modules specifically developed in [**_Lute_**](https://lute.lune.org) can be found inside [`lute`](./lute/)

The older modules can be found inside [`legacy`](./legacy/).

# Modules
### Current
The following modules are recently developed and completely functional for use.

- [Randlib](./modules/randlib.luau) - A custom pseudorandom number generator module inspired by Roblox's `Random` library
- [Base64](./modules/base64.luau) - A module that encodes/decodes data into [base 64](https://en.wikipedia.org/wiki/Base64)

### Lute
The following modules are developed specifically for [Lute](https://lute.lune.org).
You can only run these by downloading Lute with the following installation [instructions](https://lute.luau.org/guide/installation.html).

- TBD

### Legacy
The following modules are very outdated and/or deprecated.

- [Bit Encoder Test](./legacy/BitEncoderTest.luau) - A test archive for encoding data into a large set of bits
- [Fenv Mod](./legacy/FenvMod.luau) - A module for modifying Luau function environments (ability to change Luau "global" variables and libraries)
- [Hidden Tables](./legacy/HiddenTables.luau) - A module for protecting modifiable tables by implementing into `userdata`, but is now deprecated due to the use of the function `getrawmetatable()`
- [String Encoder](./legacy/StringEncoder.luau) - An old encryption tool which creates specific keys and offsets each character's byte within the data; keys are implemented inside the encoded result to easily decode back into the original data

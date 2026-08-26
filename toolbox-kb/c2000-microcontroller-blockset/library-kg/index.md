# Library Reuse Index

## Priority

1. Custom library blocks (highest priority)
2. Toolbox KB blocks

## Policy

- Always use custom library blocks when available.
- Never fall back to built-in primitives if the same block exists in a declared library.
- Only use built-in blocks when NO equivalent exists in any declared library after searching this index.
- Do not invent custom block names.
- If uncertain, inspect the relevant category page or ask the user.

## Libraries

- C2000 Microcontroller Blockset

Common blocks: [common.md](common.md) (30 of 594 blocks)

## Categories

- [Analog conversion](analog-conversion.md) — 66 blocks; ADC, DAC, comparators, and sigma-delta filter modules for analog signal acquisition and generation
- [System](system.md) — 54 blocks; System-level blocks: watchdog, profiler, and library utilities
- [Digital io](digital-io.md) — 52 blocks; GPIO digital input and output pin access
- [Serial communication](serial-communication.md) — 173 blocks; Serial communication peripherals: SCI/UART, SPI, I2C, and LIN interfaces
- [Interrupt scheduling](interrupt-scheduling.md) — 31 blocks; Hardware and software interrupt configuration, task scheduling, and event routing
- [Pwm timing](pwm-timing.md) — 71 blocks; PWM generation, input capture, quadrature decoding, and timer peripherals for actuation and measurement
- [Can communication](can-communication.md) — 59 blocks; CAN and CAN FD bus communication including message packing and unpacking
- [Cla coprocessor](cla-coprocessor.md) — 35 blocks; Control Law Accelerator coprocessor for offloading real-time math from the main CPU
- [Interprocessor](interprocessor.md) — 10 blocks; Inter-processor communication for dual-core C2000 devices
- [Network communication](network-communication.md) — 12 blocks; TCP and UDP network communication via on-chip Ethernet
- [Iqmath](iqmath.md) — 17 blocks; TI IQMath fixed-point arithmetic library for efficient control computations
- [Sensor drivers](sensor-drivers.md) — 7 blocks; Driver blocks for common external sensors connected via I2C or SPI
- [Memory register](memory-register.md) — 3 blocks; Direct memory and register access for DMA, shared memory, and custom peripheral interfacing
- [Data packing](data-packing.md) — 4 blocks; Byte-level data packing, unpacking, and protocol encoding/decoding for communication payloads

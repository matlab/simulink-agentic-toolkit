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

- SoC Blockset

Common blocks: [common.md](common.md) (11 of 112 blocks)

## Categories

- [Fpga connectivity](fpga-connectivity.md) — 6 blocks; AXI4-Stream and bus connectivity between FPGA and processor domains
- [Board io](board-io.md) — 5 blocks; Physical board I/O blocks for switches, buttons, LEDs, and GPIO pins
- [Test infrastructure](test-infrastructure.md) — 6 blocks; Testbench source and sink blocks for verifying hardware interfaces in simulation
- [Processor io](processor-io.md) — 24 blocks; Processor-side read/write blocks for accessing hardware peripherals and network
- [Memory interfaces](memory-interfaces.md) — 8 blocks; Shared memory, DMA, registers, and interrupt channels between FPGA and processor
- [Uncategorized](uncategorized.md) — 40 blocks; blocks not yet assigned to a category
- [Io data](io-data.md) — 8 blocks; I/O data injection and capture for testbench-driven SoC verification
- [Peripherals](peripherals.md) — 7 blocks; Peripheral device interface models for ADC, audio, video, PWM, and digital I/O
- [Interprocess](interprocess.md) — 3 blocks; Shared data channels for communication between processor tasks at different rates
- [Task scheduling](task-scheduling.md) — 5 blocks; Task management, scheduling, triggering, and interrupt-driven execution

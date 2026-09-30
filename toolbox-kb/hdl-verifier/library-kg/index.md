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

- HDL Verifier

Common blocks: [common.md](common.md) (8 of 8 blocks)

## Categories

- [Signal logging](signal-logging.md) — 3 blocks; Capture HDL signal activity to file
- [Hdl cosimulation](hdl-cosimulation.md) — 3 blocks; Cosimulate Simulink with an external HDL simulator
- [Dpi c verification](dpi-c-verification.md) — 2 blocks; SystemVerilog DPI-C / UVM testbench components

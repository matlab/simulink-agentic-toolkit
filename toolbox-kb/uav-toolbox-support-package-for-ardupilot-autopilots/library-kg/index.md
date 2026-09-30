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

- UAV Toolbox Support Package for ArduPilot Autopilots

Common blocks: [common.md](common.md) (12 of 12 blocks)

## Categories

- [Controller interface](controller-interface.md) — 10 blocks; Read vehicle state and issue setpoints when authoring custom ArduPilot controllers
- [Peripherals](peripherals.md) — 1 blocks; Access ArduPilot hardware peripherals
- [Utility](utility.md) — 1 blocks; Timing and helper blocks

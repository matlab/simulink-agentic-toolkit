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

- AUTOSAR Blockset

Common blocks: [common.md](common.md) (8 of 28 blocks)

## Categories

- [Application routing](application-routing.md) — 2 blocks; Inter-runnable communication and event-driven data exchange between AUTOSAR software components
- [Diagnostics](diagnostics.md) — 7 blocks; Diagnostic Event Manager (DEM) services for fault monitoring, debouncing, and reporting
- [Function inhibition](function-inhibition.md) — 2 blocks; Function Inhibition Manager (FIM) for controlled degradation and safety interlocks
- [Nvram](nvram.md) — 3 blocks; Non-volatile RAM (NvM) services for persistent data storage across power cycles
- [Interpolation](interpolation.md) — 7 blocks; AUTOSAR fixed-point interpolation and lookup routines for calibration data
- [Math functions](math-functions.md) — 6 blocks; AUTOSAR Math Function Library (MFL) building blocks for signal generation
- [Signal management](signal-management.md) — 1 blocks; Signal quality, invalidation, and communication status handling

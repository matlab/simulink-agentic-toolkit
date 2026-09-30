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

- Simulink Fault Analyzer

Common blocks: [common.md](common.md) (4 of 5 blocks)

## Categories

- [Fault data ports](fault-data-ports.md) — 1 blocks; Ports that feed external data or parameters used to drive fault behavior
- [Fault signal ports](fault-signal-ports.md) — 4 blocks; Ports that route the modeled signal into and out of a fault subsystem's injection logic

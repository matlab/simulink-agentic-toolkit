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

- Instrument Control Toolbox

Common blocks: [common.md](common.md) (5 of 10 blocks)

## Categories

- [Instrument io](instrument-io.md) — 3 blocks; Direct instrument query and command via SCPI/VISA
- [Serial comm](serial-comm.md) — 3 blocks; Serial port communication with instruments and devices
- [Network comm](network-comm.md) — 4 blocks; Network-based data exchange over TCP/IP and UDP

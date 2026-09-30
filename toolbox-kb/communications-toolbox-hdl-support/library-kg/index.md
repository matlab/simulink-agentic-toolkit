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

- Communications Toolbox HDL Support

Common blocks: [common.md](common.md) (24 of 25 blocks)

## Categories

- [Comm filters](comm-filters.md) — 3 blocks; Pulse-shaping and conditioning filters for HDL links
- [Comm sinks](comm-sinks.md) — 3 blocks; Visualization and measurement of received signals
- [Comm sources](comm-sources.md) — 1 blocks; Sequence and test sources
- [Error correction](error-correction.md) — 6 blocks; HDL-optimized forward error correction and error detection
- [Interleaving](interleaving.md) — 4 blocks; Interleavers/deinterleavers that spread burst errors
- [Modulation](modulation.md) — 8 blocks; Baseband digital modulators and demodulators

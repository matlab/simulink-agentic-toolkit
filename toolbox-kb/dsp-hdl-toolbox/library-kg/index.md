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

- DSP HDL Toolbox

Common blocks: [common.md](common.md) (17 of 18 blocks)

## Categories

- [Filtering](filtering.md) — 10 blocks; HDL-optimized streaming filters and rate-change filters
- [Math functions](math-functions.md) — 1 blocks; HDL-optimized math on streaming samples
- [Signal operations](signal-operations.md) — 5 blocks; HDL-optimized resampling and sample-rate operations
- [Transforms](transforms.md) — 2 blocks; HDL-optimized FFT/IFFT transforms

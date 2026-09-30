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

- Simulink Test

Common blocks: [common.md](common.md) (5 of 11 blocks)

## Categories

- [Observers](observers.md) — 2 blocks; Non-intrusive monitoring and verification of a system under test through a separate observer model.
- [Activity visualization](activity-visualization.md) — 1 blocks; Visualize the order and timing of messages, events, function calls, and state transitions during simulation.
- [Test harness internals](test-harness-internals.md) — 8 blocks; Primitive elements that implement the Test Sequence and Test Assessment blocks; not normally placed on their own.

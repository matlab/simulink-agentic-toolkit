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

- UAV Toolbox

Common blocks: [common.md](common.md) (25 of 32 blocks)

## Categories

- [Guidance algorithms](guidance-algorithms.md) — 11 blocks; Path following, trajectory generation, and obstacle avoidance
- [Mavlink](mavlink.md) — 2 blocks
- [Scenario sensors](scenario-sensors.md) — 7 blocks; Scenario-based sensor models (GPS, INS, barometer)
- [Simulation 3d](simulation-3d.md) — 10 blocks; Photorealistic 3D scene, cameras, and sensors
- [Utilities](utilities.md) — 2 blocks; Coordinate transforms and animation helpers

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

- DO-178C/DO-331 Primitive Library

Common blocks: [common.md](common.md) (14 of 138 blocks)

## Categories

- [Discrete operations](discrete-operations.md) — 6 blocks; Delays, integrators, and difference operators for sampled systems
- [Discontinuities](discontinuities.md) — 6 blocks; Saturation, dead zones, relays, and signal limiting
- [Logic and comparison](logic-and-comparison.md) — 18 blocks; Boolean logic, relational comparisons, bit operations, and edge detection
- [Math operations](math-operations.md) — 21 blocks; Arithmetic, algebraic, and trigonometric computations
- [Documentation](documentation.md) — 2 blocks; Model documentation and metadata blocks
- [Signal attributes](signal-attributes.md) — 12 blocks; Data type conversion, rate transitions, and signal property management
- [User defined functions](user-defined-functions.md) — 4 blocks; MATLAB Function, C Caller, and expression blocks
- [Stateflow](stateflow.md) — 2 blocks; Stateflow charts and embedded Simulink functions
- [Lookup tables](lookup-tables.md) — 6 blocks; Breakpoint-based interpolation and table lookup
- [Ports and subsystems](ports-and-subsystems.md) — 42 blocks; Subsystem interfaces, iterators, conditional execution ports
- [Signal routing](signal-routing.md) — 15 blocks; Buses, muxing, switching, data stores, and signal routing
- [Sources and sinks](sources-and-sinks.md) — 4 blocks; Constants, inputs, outputs, grounds, and terminators

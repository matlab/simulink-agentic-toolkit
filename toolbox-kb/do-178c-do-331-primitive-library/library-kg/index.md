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

Common blocks: [common.md](common.md) (30 of 113 blocks)

## Categories

- [Discrete](discrete.md) — 6 blocks; Discrete-time delays and integration
- [Discontinuities](discontinuities.md) — 6 blocks; Dead zone, relay, and saturation nonlinearities
- [Logic bit](logic-bit.md) — 18 blocks; Logical, relational, and bit operations
- [Lookup tables](lookup-tables.md) — 6 blocks; N-D lookup tables and prelookup interpolation
- [Math](math.md) — 21 blocks; Arithmetic and elementwise math functions
- [Simulink model wide utilities](simulink-model-wide-utilities.md) — 2 blocks
- [Ports subsystems](ports-subsystems.md) — 19 blocks; Ports, subsystems, and control-flow containers
- [Signal attributes](signal-attributes.md) — 10 blocks; Type, rate, and attribute handling
- [Signal routing](signal-routing.md) — 15 blocks; Buses, mux/demux, switches, and data stores
- [Sinks](sinks.md) — 1 blocks; Signal sinks
- [Sources](sources.md) — 3 blocks; Constant and ground sources
- [String](string.md) — 1 blocks; String handling
- [User defined](user-defined.md) — 3 blocks; Custom C, MATLAB, and expression blocks
- [Stateflow](stateflow.md) — 2 blocks; State-machine and flow-chart logic

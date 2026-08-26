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

- Electrical

Common blocks: [common.md](common.md) (23 of 436 blocks)

## Categories

- [Spice components](spice-components.md) — 36 blocks; SPICE-compatible components and dependent sources for netlist import
- [Control blocks](control-blocks.md) — 95 blocks; Controllers for machines, converters, and power systems including exciters and governors
- [Mathematical transforms](mathematical-transforms.md) — 14 blocks; Clarke, Park, and sequence transforms for AC machine and power system control
- [Measurements and observers](measurements-and-observers.md) — 13 blocks; Power, RMS, THD, PLL measurements and state observers
- [Pulse width modulation](pulse-width-modulation.md) — 17 blocks; PWM generators, gate signal generators, and thyristor pulse generators
- [Passive components](passive-components.md) — 54 blocks; Resistors, capacitors, inductors, transformers, cables, and loads
- [Semiconductors and converters](semiconductors-and-converters.md) — 52 blocks; Diodes, transistors, power converters, and switching devices
- [Connectors and references](connectors-and-references.md) — 15 blocks; Electrical references, busbars, connectors, and phase management
- [Electromechanical machines](electromechanical-machines.md) — 63 blocks; Electric motors, generators, actuators, and machine subcomponents
- [Integrated circuits](integrated-circuits.md) — 21 blocks; Op-amps, logic gates, flip-flops, comparators, and IC building blocks
- [Sensors and transducers](sensors-and-transducers.md) — 24 blocks; Current, voltage, power, temperature, and motion sensors
- [Sources](sources.md) — 16 blocks; Voltage and current sources, batteries, fuel cells, and supply rails
- [Switches and breakers](switches-and-breakers.md) — 13 blocks; Circuit breakers, relays, switches, and fuses for protection and switching
- [Utilities](utilities.md) — 3 blocks; Environment settings and fault injection for simulation configuration

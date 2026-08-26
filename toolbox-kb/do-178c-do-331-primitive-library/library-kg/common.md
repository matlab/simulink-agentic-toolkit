---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 14
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Clamp a signal between fixed upper and lower bounds — use to enforce actuator limits, protect downstream logic from out-of-range values, or implement safety envelopes | Saturation | DO-178C/DO-331 Primitive Library |
| Accumulate a signal over discrete time steps with optional reset and saturation — use for PID integral action, position from velocity, or energy accumulation in certified controllers | Discrete-Time Integrator | DO-178C/DO-331 Primitive Library |
| Delay a signal by exactly one sample period — use for implementing Z-transform transfer functions, state feedback, or breaking algebraic loops in discrete systems | Unit Delay | DO-178C/DO-331 Primitive Library |
| Perform AND, OR, NOT, NAND, NOR, or XOR on Boolean signals — use for combining conditions, implementing enable logic, or voting schemes in certified avionics | Logical Operator | DO-178C/DO-331 Primitive Library |
| Compare two signals using ==, ~=, <, >, <=, >= — use for threshold comparisons, guard conditions, or generating Boolean control signals from continuous quantities | Relational Operator | DO-178C/DO-331 Primitive Library |
| Interpolate output from a single breakpoint-value pair table — use for calibration curves, sensor linearization, or scheduled gains in certified airborne software | 1-D Lookup Table | DO-178C/DO-331 Primitive Library |
| Sum two or more signals element-wise — use for combining feedforward and feedback paths, error computation, or signal aggregation | Add | DO-178C/DO-331 Primitive Library |
| Multiply a signal by a constant factor — use for unit conversion, controller gains, scaling factors, or applying physical constants in certified algorithms | Gain | DO-178C/DO-331 Primitive Library |
| Bundle multiple signals into a single bus — use to group related signals into a structured interface for cleaner routing and subsystem boundaries | Bus Creator | DO-178C/DO-331 Primitive Library |
| Extract selected elements from a bus signal — use to access specific fields from a structured data bus at subsystem inputs or processing stages | Bus Selector | DO-178C/DO-331 Primitive Library |
| Split a vector signal into individual scalar or sub-vector outputs — use to separate multiplexed channels for individual processing or routing | Demux | DO-178C/DO-331 Primitive Library |
| Combine multiple scalar or vector signals into a single vector — use to aggregate parallel channels into one signal line for compact routing or array processing | Mux | DO-178C/DO-331 Primitive Library |
| Select between two data inputs based on a Boolean or threshold condition — use for if-then-else logic, failover selection, or conditional signal routing | Switch | DO-178C/DO-331 Primitive Library |
| Output a constant value — use for fixed parameters, calibration values, Boolean flags, or reference setpoints in certified control algorithms | Constant | DO-178C/DO-331 Primitive Library |

---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 30
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Hold the input for one sample period (z^-1) — use to introduce a one-step delay or break an algebraic loop. | Unit Delay | DO-178C/DO-331 Primitive Library |
| Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. | Gain | DO-178C/DO-331 Primitive Library |
| Multiply inputs elementwise or as matrices — use for scaling, modulation, or products of signals. | Product | DO-178C/DO-331 Primitive Library |
| Add or subtract inputs per the sign list — use to combine signals, form errors, or accumulate. | Sum | DO-178C/DO-331 Primitive Library |
| Group blocks into a hierarchical container — use to organize a model into reusable, readable units. | Subsystem | DO-178C/DO-331 Primitive Library |
| Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. | Data Type Conversion | DO-178C/DO-331 Primitive Library |
| Pass one of two inputs based on a control threshold — use for conditional signal selection. | Switch | DO-178C/DO-331 Primitive Library |
| Output a constant value — use for fixed parameters, thresholds, or test inputs. | Constant | DO-178C/DO-331 Primitive Library |
| Run authored MATLAB code as a block — use for custom algorithms not easily built from blocks. | MATLAB Function | DO-178C/DO-331 Primitive Library |
| Output zero for inputs within a dead zone. Offset input signals by either the Start or End value when outside of the dead zone. | Dead Zone Dynamic | DO-178C/DO-331 Primitive Library |
| Bound the range of the second input by using the first input (upper limit) and the third input (lower limit). | Saturation Dynamic | DO-178C/DO-331 Primitive Library |
| If the input is above the threshold, the output is zero, otherwise the output equals the input. | Wrap To Zero | DO-178C/DO-331 Primitive Library |
| Output zero while the input is within a dead band, then pass the offset beyond it — use to model backlash or ignore small signals. | Dead Zone | DO-178C/DO-331 Primitive Library |
| Switch the output between two values with hysteresis around on/off thresholds — use for bang-bang control or thermostat-like logic. | Relay | DO-178C/DO-331 Primitive Library |
| Decrease the Real World Value of Signal by 1.0 Overflows will always wrap. | Decrement Real World | DO-178C/DO-331 Primitive Library |
| Increase the Real World Value of Signal by 1.0 Overflows will always wrap. | Increment Real World | DO-178C/DO-331 Primitive Library |
| Output the current input value minus the previous input value. | Difference | DO-178C/DO-331 Primitive Library |
| Delay a signal by a configurable number of sample steps — use to align timing or model transport delay in discrete systems. | Delay | DO-178C/DO-331 Primitive Library |
| Accumulate a signal over time in discrete steps, with optional limits and reset — use for discrete integration in controllers and estimators. | Discrete-Time Integrator | DO-178C/DO-331 Primitive Library |
| Perform the specified bitwise operation on the inputs. The output data type should represent zero exactly. | Bitwise Operator | DO-178C/DO-331 Primitive Library |
| Clear ith bit of the stored integer to 0. Scaling is ignored. | Bit Clear | DO-178C/DO-331 Primitive Library |
| Set ith bit of the stored integer to 1. Scaling is ignored. | Bit Set | DO-178C/DO-331 Primitive Library |
| Determine how a signal compares to a constant. | Compare To Constant | DO-178C/DO-331 Primitive Library |
| Determine how a signal compares to zero. | Compare To Zero | DO-178C/DO-331 Primitive Library |
| Map one input to an output by interpolating breakpoint-value pairs — use for calibration curves and nonlinear functions. | 1-D Lookup Table | DO-178C/DO-331 Primitive Library |
| Interpolate an output from two inputs over a gridded table — use for two-variable maps such as gain schedules. | 2-D Lookup Table | DO-178C/DO-331 Primitive Library |
| Interpolate an output from three inputs over a gridded table — use for three-variable characterization maps. | 3-D Lookup Table | DO-178C/DO-331 Primitive Library |
| Interpolate table values using the index/fraction from a Prelookup block — use for efficient multi-table lookups that share breakpoints. | Interpolation Using Prelookup | DO-178C/DO-331 Primitive Library |
| Compute the index and fraction of an input within a breakpoint set — use ahead of Interpolation Using Prelookup to share breakpoint search. | Prelookup | DO-178C/DO-331 Primitive Library |
| Output the max or min of all past inputs u. The output is reset to the initial condition when the Reset input signal R is TRUE. This reset action is vectorized and supports scalar expansion. | MinMax Running Resettable | DO-178C/DO-331 Primitive Library |

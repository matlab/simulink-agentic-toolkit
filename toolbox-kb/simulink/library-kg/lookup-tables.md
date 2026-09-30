---
type: Simulink Block Category
title: Lookup tables
description: Lookup tables, prelookup, and interpolation
tags: [lookup, table, prelookup, interpolation, cosine, sine]
status: stable
source: custom_library
library_root: Simulink
category_path: Lookup tables
block_count: 18
---

# Lookup tables

Use these blocks for lookup tables.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 1-D Lookup Table | simulink/Lookup Tables/1-D Lookup Table | R2023a+ | Map an input to an output by interpolating a table of breakpoint-value pairs — use for nonlinear functions or calibration curves. |
| 2-D Lookup Table | simulink/Lookup Tables/2-D Lookup Table | R2023a+ | Interpolate an output from a 2-D table indexed by two inputs — use for surface maps such as engine or gain schedules. |
| Direct Lookup Table (n-D) | simulink/Lookup Tables/Direct Lookup Table (n-D) | R2023a+ | Return stored table elements directly by integer index with no interpolation — use for indexed selection of vectors/matrices. |
| Interpolation Using Prelookup | simulink/Lookup Tables/Interpolation Using Prelookup | R2023a+ | Interpolate table values using precomputed index/fraction from Prelookup — use for efficient multi-table lookup sharing breakpoints. |
| Lookup Table Dynamic | simulink/Lookup Tables/Lookup Table Dynamic | R2023a+ | Approximate a one-dimensional function using a selected lookup method. |
| Prelookup | simulink/Lookup Tables/Prelookup | R2023a+ | Compute the index and fraction of an input within a breakpoint set — use ahead of an Interpolation block for efficient lookup. |
| n-D Lookup Table | simulink/Lookup Tables/n-D Lookup Table | R2023a+ | Interpolate an output from an n-dimensional breakpoint table — use for multi-input calibration maps. |
| 3-D Lookup Table | simulink/Quick Insert/Lookup Tables/3-D Lookup Table | R2023a+ | Interpolate an output from a 3-D breakpoint table indexed by three inputs — use for three-input maps. |
| Cosine Lookup | simulink/Quick Insert/Lookup Tables/Cosine Lookup | R2023a+ | Approximate cosine using a lookup table — use for efficient cos evaluation on fixed-point/embedded targets. |
| Exponential Lookup | simulink/Quick Insert/Lookup Tables/Exponential Lookup | R2023a+ | Approximate the exponential using a lookup table — use for efficient exp evaluation. |
| Index Search | simulink/Quick Insert/Lookup Tables/Index Search | R2023a+ | Find the breakpoint interval index for an input — use as a standalone prelookup index search. |
| Lookup with Akima spline Interpolation | simulink/Quick Insert/Lookup Tables/Lookup with Akima spline Interpolation | R2023a+ | Table lookup using Akima spline interpolation — use for smooth interpolation without overshoot. |
| Lookup with Linear Lagrange Interpolation | simulink/Quick Insert/Lookup Tables/Lookup with Linear Lagrange Interpolation | R2023a+ | Table lookup using linear Lagrange interpolation — use for straightforward linear table interpolation. |
| Lookup with Linear Point-slope Interpolation | simulink/Quick Insert/Lookup Tables/Lookup with Linear Point-slope Interpolation | R2023a+ | Table lookup using linear point-slope interpolation — use for efficient linear interpolation on embedded targets. |
| SinCos Lookup | simulink/Quick Insert/Lookup Tables/SinCos Lookup | R2023a+ | Approximate sine and cosine together using a lookup table — use for efficient combined trig on embedded targets. |
| Sine Lookup | simulink/Quick Insert/Lookup Tables/Sine Lookup | R2023a+ | Approximate sine using a lookup table — use for efficient sin evaluation on fixed-point/embedded targets. |
| Chirp Signal | simulink/Sources/Chirp Signal | R2023a+ | Output a linear chirp signal (sine wave whose frequency varies linearly with time). |
| Repeating
Sequence | simulink/Sources/Repeating
Sequence | R2023a+ | Output a repeating sequence of numbers specified in a table of time-value pairs. Values of time should be monotonically increasing. |

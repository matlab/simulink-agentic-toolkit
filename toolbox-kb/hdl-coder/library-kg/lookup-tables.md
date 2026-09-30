---
type: Simulink Block Category
title: Lookup tables
description: Lookup tables and prelookup
tags: [lookup, table, prelookup, interpolation, breakpoint]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Lookup tables
block_count: 8
---

# Lookup tables

Use these blocks for lookup tables.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Resettable Synchronous Subsystem | hdlsllib/HDL Subsystems/Resettable Synchronous Subsystem | R2023a+ | A subsystem block template containing a reset port, state control, inport, and outport block. |
| 1-D Lookup Table | hdlsllib/Lookup Tables/1-D Lookup Table | R2023a+ | Map an input to an output by interpolating a table of breakpoint-value pairs — use to implement nonlinear functions or calibration curves. |
| 2-D Lookup Table | hdlsllib/Lookup Tables/2-D Lookup Table | R2023a+ | Interpolate an output from a 2-D table indexed by two inputs — use for surface maps such as engine or gain schedules. |
| Direct Lookup Table (n-D) | hdlsllib/Lookup Tables/Direct Lookup Table (n-D) | R2023a+ | Return stored table elements directly by integer index with no interpolation — use for indexed selection of vectors/matrices. |
| Prelookup | hdlsllib/Lookup Tables/Prelookup | R2023a+ | Compute the index and fraction of an input within a breakpoint set — use ahead of an Interpolation block for efficient table lookup. |
| Sine HDL Optimized | hdlsllib/Lookup Tables/Sine HDL Optimized | R2023a+ | Generate sine/cosine using an HDL-efficient lookup implementation — use for tone generation targeting hardware. |
| n-D Lookup Table | hdlsllib/Lookup Tables/n-D Lookup Table | R2023a+ | Interpolate an output from an n-dimensional breakpoint table — use for multi-input calibration maps. |
| Cosine HDL Optimized | hdlsllib/Lookup Tables/Cosine HDL Optimized | R2023a+ | Sine and Cosine HDL optimized block using quarter wave symmetry, and HDL friendly settings. |

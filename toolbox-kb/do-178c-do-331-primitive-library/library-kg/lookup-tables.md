---
type: Simulink Block Category
title: Lookup tables
description: N-D lookup tables and prelookup interpolation (6 blocks)
tags: [toolbox-kb, do-178c-do-331-primitive-library, lookup, prelookup, interpolation]
status: stable
sources:
  - resource: matlab:do178Lib
source: toolbox_kb
managed_by: satk
library: DO-178C/DO-331 Primitive Library
kb_folder: do-178c-do-331-primitive-library
category: lookup-tables
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:17Z" }
---

# Lookup tables

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 1-D Lookup Table | do178Lib/Simulink/Lookup Tables/1-D Lookup Table | R2023a+ | Map one input to an output by interpolating breakpoint-value pairs — use for calibration curves and nonlinear functions. |
| 2-D Lookup Table | do178Lib/Simulink/Lookup Tables/2-D Lookup Table | R2023a+ | Interpolate an output from two inputs over a gridded table — use for two-variable maps such as gain schedules. |
| 3-D Lookup Table | do178Lib/Simulink/Lookup Tables/3-D Lookup Table | R2023a+ | Interpolate an output from three inputs over a gridded table — use for three-variable characterization maps. |
| Interpolation Using Prelookup | do178Lib/Simulink/Lookup Tables/Interpolation Using Prelookup | R2023a+ | Interpolate table values using the index/fraction from a Prelookup block — use for efficient multi-table lookups that share breakpoints. |
| Prelookup | do178Lib/Simulink/Lookup Tables/Prelookup | R2023a+ | Compute the index and fraction of an input within a breakpoint set — use ahead of Interpolation Using Prelookup to share breakpoint search. |
| n-D Lookup Table | do178Lib/Simulink/Lookup Tables/n-D Lookup Table | R2023a+ | Interpolate an output from N inputs over an N-dimensional table — use for multi-variable calibration maps. |

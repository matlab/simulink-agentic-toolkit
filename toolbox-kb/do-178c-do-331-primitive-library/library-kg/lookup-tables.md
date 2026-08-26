---
type: Simulink Block Category
title: Lookup tables
description: Breakpoint-based interpolation and table lookup
tags: [lookup, interpolation, prelookup, breakpoint, table]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Lookup tables
block_count: 6
---

# Lookup tables

Use these blocks for lookup tables.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 1-D Lookup Table | do178Lib/Simulink/Lookup Tables/1-D Lookup Table | R2023a+ | Interpolate output from a single breakpoint-value pair table — use for calibration curves, sensor linearization, or scheduled gains in certified airborne software |
| 2-D Lookup Table | do178Lib/Simulink/Lookup Tables/2-D Lookup Table | R2023a+ | Interpolate output from a two-dimensional breakpoint grid — use for engine maps, aerodynamic coefficients, or performance tables requiring DO-178C traceability |
| 3-D Lookup Table | do178Lib/Simulink/Lookup Tables/3-D Lookup Table | R2023a+ | Interpolate output from a three-dimensional breakpoint grid — use for complex parameter schedules indexed by three operating conditions |
| Interpolation Using Prelookup | do178Lib/Simulink/Lookup Tables/Interpolation Using Prelookup | R2023a+ | Perform table interpolation using precomputed index and fraction from a Prelookup block — use to share index computation across multiple tables for efficiency |
| Prelookup | do178Lib/Simulink/Lookup Tables/Prelookup | R2023a+ | Compute breakpoint index and interpolation fraction for a given input — pair with Interpolation Using Prelookup to share search results across multiple tables |
| n-D Lookup Table | do178Lib/Simulink/Lookup Tables/n-D Lookup Table | R2023a+ | Interpolate output from an N-dimensional breakpoint grid — use when more than three independent variables index a calibration table |

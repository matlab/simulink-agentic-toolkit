---
type: Simulink Block Category
title: Lookup tables
description: Table-based interpolation and function approximation blocks for calibration and data mapping
tags: [interpolation, breakpoint, calibration, table, prelookup]
status: stable
source: mathworks_toolbox
library_root: Simulink
category_path: Lookup tables
block_count: 14
---

# Lookup tables

Use these blocks for lookup tables.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Cosine | simulink/Lookup Tables/Cosine | R2023a+ | Use when computing cosine via lookup table for efficient fixed-point trigonometric evaluation |
| Sine | simulink/Lookup Tables/Sine | R2023a+ | Use when computing sine via lookup table for efficient fixed-point trigonometric evaluation |
| Block Support Table | simulink/Model-Wide Utilities/Block Support Table | R2023a+ |  |
| 1-D Lookup Table | simulink/Lookup Tables/1-D Lookup Table | R2023a+ | Use when mapping a single input to an output using breakpoint data and interpolation for calibration curves |
| 2-D Lookup Table | simulink/Lookup Tables/2-D Lookup Table | R2023a+ | Use when mapping two inputs to an output using a two-dimensional data grid |
| Direct Lookup Table (n-D) | simulink/Lookup Tables/Direct Lookup Table (n-D) | R2023a+ | Use when indexing directly into an n-dimensional table without interpolation |
| Interpolation Using Prelookup | simulink/Lookup Tables/Interpolation Using Prelookup | R2023a+ | Use when performing table interpolation using precomputed index and fraction from a Prelookup block |
| Lookup Table Dynamic | simulink/Lookup Tables/Lookup Table Dynamic | R2023a+ | Use when table breakpoints and values change during simulation based on input signals |
| Prelookup | simulink/Lookup Tables/Prelookup | R2023a+ | Use when precomputing breakpoint index and interpolation fraction to share across multiple lookup tables |
| n-D Lookup Table | simulink/Lookup Tables/n-D Lookup Table | R2023a+ | Use when mapping multiple inputs to an output using an n-dimensional data grid for general calibration |
| 3-D Lookup Table | simulink/Quick Insert/Lookup Tables/3-D Lookup Table | R2023a+ | Use when mapping three inputs to an output using a three-dimensional data grid |
| Lookup with Akima spline Interpolation | simulink/Quick Insert/Lookup Tables/Lookup with Akima spline Interpolation | R2023a+ |  |
| Lookup with Linear Lagrange Interpolation | simulink/Quick Insert/Lookup Tables/Lookup with Linear Lagrange Interpolation | R2023a+ |  |
| Lookup with Linear Point-slope Interpolation | simulink/Quick Insert/Lookup Tables/Lookup with Linear Point-slope Interpolation | R2023a+ |  |

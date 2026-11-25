---
type: Simulink Block Category
title: Interpolation
description: AUTOSAR fixed-point interpolation and lookup routines for calibration data (6 blocks)
tags: [toolbox-kb, autosar-blockset, interpolation, lookup, curve, map, prelookup]
status: stable
sources:
  - resource: matlab:autosarlibiflifx
source: toolbox_kb
managed_by: satk
library: AUTOSAR Blockset
kb_folder: autosar-blockset
category: interpolation
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:12Z" }
---

# Interpolation

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Curve | autosarlibiflifx/Curve | R2023a+ | Look up a 1-D calibration curve (breakpoints + values) — use for simple characteristic lines like sensor transfer functions or temperature-dependent parameters |
| Curve Using Prelookup | autosarlibiflifx/Curve Using Prelookup | R2023a+ | Interpolate a 1-D curve using pre-computed index and fraction — use when multiple curves share the same axis breakpoints and you want to compute the prelookup only once |
| Map | autosarlibiflifx/Map | R2023a+ | Look up a 2-D calibration map (two breakpoint axes + table values) — use for characteristic maps such as base fuel injection or ignition timing vs. speed and load |
| Map Using Prelookup | autosarlibiflifx/Map Using Prelookup | R2023a+ | Interpolate a 2-D map using pre-computed index and fraction inputs — use when multiple maps share axes and you want to reuse a single prelookup computation for efficiency |
| Prelookup | autosarlibiflifx/Prelookup | R2023a+ | Compute index and fraction from breakpoint data for downstream interpolation blocks — use to share one axis search across multiple Curve/Map Using Prelookup blocks |
| Single Point Interpolation | autosarlibiflifx/Single Point Interpolation | R2023a+ | Interpolate a single output value from a calibration axis without prelookup — use for simple 1-D calibration tables where AUTOSAR fixed-point compliance is required |

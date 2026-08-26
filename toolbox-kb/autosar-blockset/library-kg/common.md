---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 8
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Receive asynchronous events from other AUTOSAR software components — use for inter-runnable triggered communication where data arrives on-demand rather than periodically | Event Receive | AUTOSAR Blockset |
| Send asynchronous events to other AUTOSAR software components — use to trigger runnables or notify subscribers of state changes | Event Send | AUTOSAR Blockset |
| Report a pass or fail result for a diagnostic event to the DEM — use inside monitor runnables to set fault detected/not-detected based on measured signals | DiagnosticMonitorCaller | AUTOSAR Blockset |
| Read or write a persistent data block through the NvM service — use to store adaptation values, DTCs, or learned parameters that must survive power cycles | NvMServiceCaller | AUTOSAR Blockset |
| Look up a 1-D calibration curve (breakpoints + values) — use for simple characteristic lines like sensor transfer functions or temperature-dependent parameters | Curve | AUTOSAR Blockset |
| Look up a 2-D calibration map (two breakpoint axes + table values) — use for characteristic maps such as base fuel injection or ignition timing vs. speed and load | Map | AUTOSAR Blockset |
| Compute index and fraction from breakpoint data for downstream interpolation blocks — use to share one axis search across multiple Curve/Map Using Prelookup blocks | Prelookup | AUTOSAR Blockset |
| Mark a signal as invalid to indicate communication failure or data unavailability — use in sender-receiver interfaces to propagate signal quality status to receiving components | Signal Invalidation | AUTOSAR Blockset |

---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 21
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
| Query whether a specific diagnostic event is available in the DEM — use as a guard before calling diagnostic monitor or info services to avoid runtime errors | DiagnosticEventAvailableCaller | AUTOSAR Blockset |
| Retrieve status information about a diagnostic event from the DEM — use to read fault status (tested, confirmed, pending) for downstream decision logic | DiagnosticInfoCaller | AUTOSAR Blockset |
| Control operation cycle state in the DEM (start, restart, end) — use to signal driving cycle boundaries that gate when diagnostic debouncing qualifies faults | DiagnosticOperationCycleCaller | AUTOSAR Blockset |
| Inject a diagnostic event status into the DEM for testing — use to simulate fault conditions during MIL/SIL validation without triggering real diagnostic monitors | Dem Status Inject | AUTOSAR Blockset |
| Override the reported status of a diagnostic event in the DEM — use to suppress or force fault states during calibration or integration testing | Dem Status Override | AUTOSAR Blockset |
| Check whether a control function is currently permitted by the FIM — use before executing safety-relevant actuator commands to respect inhibition conditions | Control Function Available Caller | AUTOSAR Blockset |
| Request inhibition or release of a function through the FIM — use to disable degraded features when prerequisite diagnostic events indicate a fault | Function Inhibition Caller | AUTOSAR Blockset |
| Interpolate a 1-D curve using pre-computed index and fraction — use when multiple curves share the same axis breakpoints and you want to compute the prelookup only once | Curve Using Prelookup | AUTOSAR Blockset |
| Interpolate a 2-D map using pre-computed index and fraction inputs — use when multiple maps share axes and you want to reuse a single prelookup computation for efficiency | Map Using Prelookup | AUTOSAR Blockset |
| Interpolate a single output value from a calibration axis without prelookup — use for simple 1-D calibration tables where AUTOSAR fixed-point compliance is required | Single Point Interpolation | AUTOSAR Blockset |
| Generate a ramp signal with configurable slope and initial value — use for rate-limited transitions in actuator commands or soft-start/soft-stop profiles in AUTOSAR MFL functions | Ramp | AUTOSAR Blockset |
| Perform administrative NvM operations (set block protection, invalidate, erase) — use for service routines that manage NVRAM block lifecycle beyond normal read/write | NvMAdminCaller | AUTOSAR Blockset |
| Provide a complete NvM service interface as a single component — use when modeling persistent storage logic that reads/writes calibration or adaptation data across ignition cycles | NVRAM Service Component | AUTOSAR Blockset |

---
type: Simulink Block Category
title: Diagnostics
description: Diagnostic Event Manager (DEM) services for fault monitoring, debouncing, and reporting
tags: [diagnostic, dem, fault, monitor, dtc]
status: stable
source: mathworks_toolbox
library_root: AUTOSAR Blockset
category_path: Diagnostics
block_count: 7
---

# Diagnostics

Use these blocks for diagnostics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dem Status Inject | autosarlibdem/Dem Status Inject | R2023a+ | Inject a diagnostic event status into the DEM for testing — use to simulate fault conditions during MIL/SIL validation without triggering real diagnostic monitors |
| Dem Status Override | autosarlibdem/Dem Status Override | R2023a+ | Override the reported status of a diagnostic event in the DEM — use to suppress or force fault states during calibration or integration testing |
| Diagnostic Service Component | autosarlibdem/Diagnostic Service Component | R2023a+ | Provide a complete DEM service interface as a single component — use when modeling a diagnostic manager that processes multiple fault events and reports status to the DCM |
| DiagnosticEventAvailableCaller | autosarlibdem/DiagnosticEventAvailableCaller | R2023a+ | Query whether a specific diagnostic event is available in the DEM — use as a guard before calling diagnostic monitor or info services to avoid runtime errors |
| DiagnosticInfoCaller | autosarlibdem/DiagnosticInfoCaller | R2023a+ | Retrieve status information about a diagnostic event from the DEM — use to read fault status (tested, confirmed, pending) for downstream decision logic |
| DiagnosticMonitorCaller | autosarlibdem/DiagnosticMonitorCaller | R2023a+ | Report a pass or fail result for a diagnostic event to the DEM — use inside monitor runnables to set fault detected/not-detected based on measured signals |
| DiagnosticOperationCycleCaller | autosarlibdem/DiagnosticOperationCycleCaller | R2023a+ | Control operation cycle state in the DEM (start, restart, end) — use to signal driving cycle boundaries that gate when diagnostic debouncing qualifies faults |

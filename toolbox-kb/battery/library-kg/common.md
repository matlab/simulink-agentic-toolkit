---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 13
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Equalize cell voltages in a series-connected pack by dissipating excess energy through bleed resistors — use to implement BMS balancing logic that reduces cell-to-cell SOC variation during charging | Passive Cell Balancing | Battery |
| Implement constant-current constant-voltage charging protocol — use to generate charge current commands that transition from CC to CV phase at the voltage setpoint for safe Li-ion charging | Battery CC-CV | Battery |
| Estimate the maximum available charge and discharge power over a prediction horizon — use for power management in hybrid/electric powertrains to enforce safe operating limits on motor torque requests | Battery Power Estimator | Battery |
| Estimate cell-level state of charge using an extended Kalman filter with an equivalent circuit model — use as the standard model-based SOC estimation algorithm for BMS applications | SOC Estimator (Kalman Filter) | Battery |
| Monitor pack current against overcurrent and short-circuit thresholds with time-based qualification — use to trigger contactor opening or current derating when sustained overcurrent is detected | Battery Current Monitoring | Battery |
| Monitor cell temperatures against over-temperature and under-temperature thresholds — use to trigger thermal protection actions like derating, heating, or emergency shutdown | Battery Temperature Monitoring | Battery |
| Monitor cell voltages against overvoltage and undervoltage thresholds — use to trigger charging cutoff, load disconnect, or cell balancing when limits are approached | Battery Voltage Monitoring | Battery |
| Control coolant flow rate and pump speed to regulate battery temperature — use to implement thermal management logic that maintains optimal cell temperature during charging and driving | Battery Coolant Control | Battery |
| Model a battery cell or module as a Simscape physical component with equivalent circuit dynamics — use for system-level electrical simulation with current, voltage, and thermal ports | Battery | Battery |
| Model a battery cell using table-based parameterization of OCV, resistance, and time constants vs. SOC and temperature — use when cell characterization data is available from HPPC or EIS testing | Battery (Table-Based) | Battery |
| Model a battery using a configurable equivalent circuit (R, RC, or multi-RC) in Simscape — use for detailed electrical dynamics simulation including transient voltage response under pulsed loads | Battery Equivalent Circuit | Battery |
| Model a battery charger as a controlled current/voltage source in Simscape — use to simulate charging profiles (CC-CV, pulse, multi-stage) applied to physical battery models | Charger | Battery |
| Model a battery test cycler that applies charge/discharge profiles in Simscape — use to simulate standard test procedures (capacity tests, HPPC, drive cycles) on physical battery models | Cycler | Battery |

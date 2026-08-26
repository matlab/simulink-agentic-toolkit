---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 14
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Use when accumulating a signal over continuous time to model dynamics such as position from velocity | Integrator | Simulink |
| Use when modeling linear continuous-time dynamics specified by numerator and denominator polynomial coefficients | Transfer Fcn | Simulink |
| Use when clamping a signal between upper and lower bounds to model actuator limits or constraints | Saturation | Simulink |
| Use when accumulating a signal over discrete time steps with optional reset and saturation | Discrete-Time Integrator | Simulink |
| Use when delaying a signal by exactly one sample period to implement z^-1 operations in discrete control | Unit Delay | Simulink |
| Use when performing Boolean AND, OR, NOT, NAND, NOR, XOR, or NXOR operations on logical signals | Logical Operator | Simulink |
| Use when comparing two signals with operators like equal, not-equal, greater-than, or less-than | Relational Operator | Simulink |
| Use when mapping a single input to an output using breakpoint data and interpolation for calibration curves | 1-D Lookup Table | Simulink |
| Use when computing the absolute value of a signal to remove sign information or measure magnitude | Abs | Simulink |
| Use when multiplying a signal by a constant scalar, vector, or matrix to apply scaling or unit conversion | Gain | Simulink |
| Use when multiplying or dividing two or more signals element-wise or performing matrix multiplication | Product | Simulink |
| Use when adding or subtracting multiple signals with configurable sign list to form error or combined outputs | Sum | Simulink |
| Use when explicitly converting a signal from one data type to another such as double to integer or fixed-point | Data Type Conversion | Simulink |
| Use when writing custom algorithms in MATLAB language that support code generation and run within Simulink | MATLAB Function | Simulink |

---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 30
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Combine multiple signals into a bus — use to bundle related signals for routing. | Bus
Creator | Simulink |
| Extract selected signals from a bus — use to access individual bus members. | Bus
Selector | Simulink |
| Output a constant value — use for fixed parameters, thresholds, or test inputs. | Constant | Simulink |
| Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. | Data Type Conversion | Simulink |
| Split a vector signal into separate scalar or subvector outputs — use to break out combined signals. | Demux | Simulink |
| Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. | Gain | Simulink |
| Integrate a continuous-time signal (1/s) with optional limits and reset — use for continuous dynamics. | Integrator | Simulink |
| Combine separate signals into a single vector — use to bundle signals for compact routing. | Mux | Simulink |
| Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. | Product | Simulink |
| Plot signals against time during simulation — use to view waveforms. | Scope | Simulink |
| Group blocks into a hierarchical subsystem — use to encapsulate and reuse logic. | Subsystem | Simulink |
| Add or subtract inputs — use for summing signals and forming error terms. | Sum | Simulink |
| Pass one of two inputs based on a control condition — use for conditional signal selection. | Switch | Simulink |
| Integrate a continuous-time signal (1/s) with optional limits and reset — use for continuous dynamics. | Integrator | Simulink |
| Delay a signal by one sample period — use to introduce one-step state or break algebraic loops. | Unit Delay | Simulink |
| Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. | Gain | Simulink |
| Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. | Product | Simulink |
| Add or subtract inputs — use for summing signals and forming error terms. | Sum | Simulink |
| Group blocks into a hierarchical subsystem — use to encapsulate and reuse logic. | Subsystem | Simulink |
| Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. | Data Type Conversion | Simulink |
| Combine multiple signals into a bus — use to bundle related signals for routing. | Bus
Creator | Simulink |
| Extract selected signals from a bus — use to access individual bus members. | Bus
Selector | Simulink |
| Split a vector signal into separate scalar or subvector outputs — use to break out combined signals. | Demux | Simulink |
| Combine separate signals into a single vector — use to bundle signals for compact routing. | Mux | Simulink |
| Pass one of two inputs based on a control condition — use for conditional signal selection. | Switch | Simulink |
| Plot signals against time during simulation — use to view waveforms. | Scope | Simulink |
| Output a constant value — use for fixed parameters, thresholds, or test inputs. | Constant | Simulink |
| Run custom MATLAB code as a block — use for algorithms not easily built from blocks. | MATLAB Function | Simulink |
| Discrete-time State-Space Realization | Fixed-Point State-Space | Simulink |
| A Direct Form II realization of the specified transfer function is used. Only single input multiple output transfer functions are supported. The data types and scalings of the output, the coefficients, and any temporary variables are automatically selected. The automatic choices will be acceptable in many situations. In situations where the automatic choices give unacceptable results, manual layout of the filter is necessary. For manual layout, it is suggested that the blocks under this mask be used as a starting point. Note 1: The full denominator should have a leading coefficient of +1.0, but this leading coefficient should be excluded when entering the parameter. For example, if the denominator is den = 1 -1.7 0.72 just enter den(2:end) = -1.7 0.72 Note 2: The numerator must be the same size as the full denominator. | Transfer Fcn Direct Form II | Simulink |

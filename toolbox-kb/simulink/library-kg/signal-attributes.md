---
type: Simulink Block Category
title: Signal attributes
description: Data type, rate, unit, and attribute handling
tags: [data type, rate transition, unit, signal, probe, cast]
status: stable
source: custom_library
library_root: Simulink
category_path: Signal attributes
block_count: 31
---

# Signal attributes

Use these blocks for signal attributes.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Data Type Conversion | simulink/Commonly
Used Blocks/Data Type Conversion | R2023a+ | Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. |
| Check  Dynamic Range | simulink/Model Verification/Check  Dynamic Range | R2023a+ | Assert that one signal always lies between two other signals. The first input is the upper-bound signal; the second input, the lower-bound; the third input, the test signal. |
| Check Dynamic  Lower Bound | simulink/Model Verification/Check Dynamic  Lower Bound | R2023a+ | Assert that one signal is always less than another signal. The first input is the lower-bound signal. The second input is the test signal. |
| Check Dynamic  Upper Bound | simulink/Model Verification/Check Dynamic  Upper Bound | R2023a+ | Assert that one signal is always greater than another signal. The first input is the upper-bound signal. The second input is the test signal. |
| Cast | simulink/Quick Insert/Signal Attributes/Cast | R2023a+ | Convert a signal to a specified data type — use to set type and scaling explicitly. |
| Cast To Boolean | simulink/Quick Insert/Signal Attributes/Cast To Boolean | R2023a+ | Convert the input to the boolean data type — use to force a logical-typed signal. |
| Cast To Double | simulink/Quick Insert/Signal Attributes/Cast To Double | R2023a+ | Convert the input to the double data type — use to promote a signal to double precision. |
| Cast To Single | simulink/Quick Insert/Signal Attributes/Cast To Single | R2023a+ | Convert the input to the single data type — use to reduce a signal to single precision. |
| Probe Complexity | simulink/Quick Insert/Signal Attributes/Probe Complexity | R2023a+ | Report whether a signal is real or complex at runtime — use to inspect signal complexity. |
| Probe Dimension | simulink/Quick Insert/Signal Attributes/Probe Dimension | R2023a+ | Report the dimensions of a signal at runtime — use to inspect signal size. |
| Probe Sample Time | simulink/Quick Insert/Signal Attributes/Probe Sample Time | R2023a+ | Report the sample time of a signal at runtime — use to inspect signal rate. |
| Probe Width | simulink/Quick Insert/Signal Attributes/Probe Width | R2023a+ | Report the width (number of elements) of a signal at runtime — use to inspect signal width. |
| Signal Copy | simulink/Quick Insert/Signal Attributes/Signal Copy | R2023a+ | Pass a signal through as an explicit copy — use to force a distinct signal buffer/attributes. |
| To Nonvirtual Bus | simulink/Quick Insert/Signal Attributes/To Nonvirtual Bus | R2023a+ | Convert a virtual bus to a nonvirtual bus — use when a contiguous bus structure is required. |
| To Virtual Bus | simulink/Quick Insert/Signal Attributes/To Virtual Bus | R2023a+ | Convert a nonvirtual bus to a virtual bus — use to reduce a bus to a routing-only grouping. |
| Bus to Vector | simulink/Signal Attributes/Bus to Vector | R2023a+ | Convert a bus of scalars into a single vector — use when downstream blocks need a vector instead of a bus. |
| Data Type Conversion Inherited | simulink/Signal Attributes/Data Type Conversion Inherited | R2023a+ | Convert a signal to the data type inherited from a reference input — use to match another signal's type. |
| Data Type Duplicate | simulink/Signal Attributes/Data Type Duplicate | R2023a+ | Force connected signals to share the same data type — use to enforce type consistency. |
| Data Type Propagation | simulink/Signal Attributes/Data Type Propagation | R2023a+ | Propagate a reference signal's data type to another — use to drive types from a template signal. |
| Data Type Scaling Strip | simulink/Signal Attributes/Data Type Scaling Strip | R2023a+ | Remove fixed-point scaling, keeping the stored integer — use to strip scaling for raw-value processing. |
| Data Type Conversion | simulink/Signal Attributes/Data Type Conversion | R2023a+ | Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. |
| IC | simulink/Signal Attributes/IC | R2023a+ | Set the initial condition of a signal for the first time step — use to seed a signal's starting value. |
| Probe | simulink/Signal Attributes/Probe | R2023a+ | Report signal attributes such as width, sample time, and complexity at runtime — use to inspect signal properties. |
| Rate Transition | simulink/Signal Attributes/Rate Transition | R2023a+ | Transfer data safely between blocks running at different sample rates — use to handle multirate boundaries. |
| Signal Conversion | simulink/Signal Attributes/Signal Conversion | R2023a+ | Convert signal storage (contiguous copy, virtual/nonvirtual bus) — use to satisfy downstream signal requirements. |
| Signal Specification | simulink/Signal Attributes/Signal Specification | R2023a+ | Assert or specify a signal's attributes (dimensions, type, sample time) — use to enforce an interface contract. |
| Unit Conversion | simulink/Signal Attributes/Unit Conversion | R2023a+ | Convert a signal between physical units — use to reconcile unit mismatches between components. |
| Weighted Sample Time | simulink/Signal Attributes/Weighted Sample Time | R2023a+ | Output the sample time scaled by a weight — use in discretization math that needs Ts. |
| Width | simulink/Signal Attributes/Width | R2023a+ | Output the width (number of elements) of the input signal — use to read signal size at runtime. |
| Data Type Propagation Examples | simulink/Signal Attributes/Data Type Propagation Examples | R2023a+ | Opens a model containing data type propagation examples. |
| Ramp | simulink/Sources/Ramp | R2023a+ | Output a ramp signal starting at the specified time. |

# Simulink Block Support Constraints — Index

SLCI supports a subset of Simulink blocks for code inspection. For each
supported block, SLCI enforces constraints on data types/ports, block
parameters, and structural usage. These constraints ensure that every block in
the model produces generated code that can be traced one-to-one back to the
model element. Blocks not in the supported set, or blocks violating these
constraints, cannot be verified.


---

## Reference Files

| File | Category | Blocks |
|-----|--------|------|
| [block_constraints_universal.md](block_constraints_universal.md) | Universal Constraints | Constraints applying to all blocks (data type, complexity, dimensionality, naming, frame-based, storage class, constant output, init/terminate) |
| [block_constraints_discrete.md](block_constraints_discrete.md) | Discrete | Discrete-Time Integrator, Delay/Resettable Delay, Discrete Derivative, Discrete FIR Filter, Discrete Filter, Discrete Transfer Fcn, Rate Limiter, Rate Transition, Unit Delay, Weighted Sample Time Math |
| [block_constraints_math_operations.md](block_constraints_math_operations.md) | Math Operations | Abs, Bias, Dot Product, Gain, Math Function, MinMax, Polynomial, Product, Rounding Function, Sqrt, Sum/Add/Subtract, Unary Minus, Unit Conversion |
| [block_constraints_ports_subsystems.md](block_constraints_ports_subsystems.md) | Ports and Subsystems | Action Port, Enable Port, Event Listener, For Each, For Iterator, Function-Call Generator, Function-Call Split, Function Caller, If, Initialize Function, Model, Model Info, Simulink Function, State Reader, State Writer, Subsystems, Switch Case, Terminate Function, Trigger Port, While Iterator |
| [block_constraints_signal_routing.md](block_constraints_signal_routing.md) | Signal Routing | Bus Assignment, Bus Creator, Bus Selector, Demux, From, Goto, Ground, Merge, Multiport Switch, Mux, Signal Conversion, Switch |
| [block_constraints_sources_sinks.md](block_constraints_sources_sinks.md) | Sources and Sinks | Constant, Inport, Outport, Probe, Terminator, Width |
| [block_constraints_data_operations.md](block_constraints_data_operations.md) | Data Operations | Assignment, Data Store Memory, Data Store Read, Data Store Write, Data Type Conversion, Data Type Duplicate, Data Type Propagation, IC, Reshape, Selector, Signal Specification |
| [block_constraints_logic_bits.md](block_constraints_logic_bits.md) | Logic and Bit Operations | Bitwise Operator, Combinatorial Logic, Extract Bits, Logical Operator, Relational Operator |
| [block_constraints_tables_functions.md](block_constraints_tables_functions.md) | Lookup Tables and Functions | C Caller, Interpolation Using Prelookup, 1-D/2-D/n-D Lookup Table, Prelookup, S-Function |
| [block_constraints_discontinuities.md](block_constraints_discontinuities.md) | Discontinuities | Dead Zone, Relay, Saturation |
| [block_constraints_string.md](block_constraints_string.md) | String Operations | ASCII to String, Compose String, String Compare, String Concatenate, String Constant, String Length, To String |
| [block_constraints_misc.md](block_constraints_misc.md) | Miscellaneous | DocBlock, Shift Arithmetic, Sign, Trigonometric Function, Vector Concatenate/Matrix Concatenate |

---

## FATAL Constraints Summary

Most block constraints are **Nonfatal**. The following are **FATAL** (inspection terminates immediately):

| Block | Constraint | Severity |
|---|---|---|
| Enable Port | Not supported at root level of model | FATAL |
| Inport | `VarSizeSig` must be `No` | FATAL |
| Inport | `BusOutputAsStruct` must be `on` for bus objects | FATAL |
| Model | Model reference must not be in protected mode | FATAL |
| Outport | `VarSizeSig` must be `No` | FATAL |
| Signal Specification | `VarSizeSig` must be `No` | FATAL |
| Trigger Port | Must not be at root level when `TriggerType` is rising/falling/either | FATAL |

---

## Common Patterns Across Block Constraints

Several constraint patterns recur across many blocks:

1. **Integer rounding mode (`RndMeth`) must be `Zero` or `Floor`** - Applies to:
   Abs, Data Type Conversion, Discrete Derivative, Discrete FIR Filter,
   Discrete Filter, Discrete Transfer Fcn, Gain, Interpolation Using Prelookup,
   Math Function, MinMax, Multiport Switch, Prelookup, Product, Saturation,
   Shift Arithmetic, Switch, Weighted Sample Time Math

2. **Input and output ports must have the same data type** - Applies to:
   Abs, Bias, Dot Product, Gain, Lookup Tables, Math Function, MinMax,
   Polynomial, Product, Saturation, Sqrt, Sum/Add/Subtract, Unit Conversion

3. **Parameter must not be empty, nonfinite, complex, or use range
   selection/variable indexing on MATLAB structures** - Applies to:
   Bias, Constant, Data Store Memory, Dead Zone, Gain, IC, Lookup Tables,
   Rate Transition, Relay, Saturation, Subsystems (mask parameters),
   Unit Delay

4. **int64/uint64 parameter type must match input signal type** - Applies to:
   Bias, Delay, Gain, Switch (threshold), Unit Delay

5. **Configuration parameter `TargetLang` must be set to `C`** - Applies to:
   ASCII to String, Compose String, String Compare, String Concatenate,
   String Constant, String Length, To String

6. **Block ports must not be of bus data type** - Applies to:
   IC, Interpolation Using Prelookup, Prelookup, Reshape

**Note:** Supported blocks (including mask blocks) are available in the block
library `slcilib`. Open it by entering `slcilib` in the MATLAB Command Window.
Parameters in the `slcilib` library are preconfigured for code inspection.

----

Copyright 2026 The MathWorks, Inc.

----

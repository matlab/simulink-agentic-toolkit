---
type: Simulink Block Category
title: Logic bit
description: Logical, relational, and bit operations
tags: [logic, relational, bit, and, or, compare]
status: stable
source: custom_library
library_root: Simulink
category_path: Logic bit
block_count: 97
---

# Logic bit

Use these blocks for logic bit.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Logical
Operator | simulink/Commonly
Used Blocks/Logical
Operator | R2023a+ | Apply a logical operation (AND, OR, NOT, XOR, …) to boolean inputs — use for combining conditions. |
| Relational
Operator | simulink/Commonly
Used Blocks/Relational
Operator | R2023a+ | Compare two inputs (>, <, ==, …) and output a boolean — use for threshold and comparison logic. |
| Bit to Integer Converter | simulink/Logic and Bit Operations/Bit to Integer Converter | R2023a+ | Map a vector of bits to a corresponding vector of integer values. M defines how many bits are mapped for each output integer. The input length must be an integer multiple of M. |
| Bitwise Operator | simulink/Logic and Bit Operations/Bitwise Operator | R2023a+ | Perform the specified bitwise operation on the inputs. The output data type should represent zero exactly. |
| Combinatorial  Logic | simulink/Logic and Bit Operations/Combinatorial  Logic | R2023a+ | Map inputs to outputs via a truth table — use to implement combinational logic from a lookup of bit patterns. |
| Float Extract Bits | simulink/Logic and Bit Operations/Float Extract Bits | R2023a+ | Extract the sign, exponent, or mantissa bits of a floating-point number — use for low-level float inspection. |
| Integer to Bit Converter | simulink/Logic and Bit Operations/Integer to Bit Converter | R2023a+ | Map a vector of integer-values inputs to a vector of bits. Block inputs must be integer values in the range [-2^(M-1), 2^(M-1)-1] when they are treated as signed and [0, 2^M-1] when they are treated as unsigned. For fixed-point inputs, the stored integer value is used. |
| Logical Operator | simulink/Logic and Bit Operations/Logical Operator | R2023a+ | Apply a logical operation (AND, OR, NOT, XOR, …) to boolean inputs — use for combining conditions. |
| Relational Operator | simulink/Logic and Bit Operations/Relational Operator | R2023a+ | Compare two inputs (>, <, ==, …) and output a boolean — use for threshold and comparison logic. |
| Shift Arithmetic | simulink/Logic and Bit Operations/Shift Arithmetic | R2023a+ | Arithmetic/logical shift of bits or the binary point — use for scaling by powers of two or bit shifts. |
| Bit Clear | simulink/Logic and Bit Operations/Bit Clear | R2023a+ | Clear ith bit of the stored integer to 0. Scaling is ignored. |
| Bit Set | simulink/Logic and Bit Operations/Bit Set | R2023a+ | Set ith bit of the stored integer to 1. Scaling is ignored. |
| Compare To Constant | simulink/Logic and Bit Operations/Compare To Constant | R2023a+ | Determine how a signal compares to a constant. |
| Compare To Zero | simulink/Logic and Bit Operations/Compare To Zero | R2023a+ | Determine how a signal compares to zero. |
| Detect Change | simulink/Logic and Bit Operations/Detect Change | R2023a+ | If the input does not equal its previous value, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the previous input U/z. |
| Detect Decrease | simulink/Logic and Bit Operations/Detect Decrease | R2023a+ | If the input is strictly less than its previous value, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the previous input U/z. |
| Detect Fall Negative | simulink/Logic and Bit Operations/Detect Fall Negative | R2023a+ | If the input is strictly negative and its previous value was nonnegative, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z < 0). |
| Detect Fall Nonpositive | simulink/Logic and Bit Operations/Detect Fall Nonpositive | R2023a+ | If the input is nonpositive and its previous value was strictly positive, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z <= 0). |
| Detect Increase | simulink/Logic and Bit Operations/Detect Increase | R2023a+ | If the input is strictly greater than its previous value, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the previous input U/z. |
| Detect Rise Nonnegative | simulink/Logic and Bit Operations/Detect Rise Nonnegative | R2023a+ | If the input is nonnegative and its previous value was strictly negative, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z >= 0). |
| Detect Rise Positive | simulink/Logic and Bit Operations/Detect Rise Positive | R2023a+ | If the input is strictly positive and its previous value was nonpositive, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z > 0). |
| Extract Bits | simulink/Logic and Bit Operations/Extract Bits | R2023a+ | Output selection of contiguous bits from input signal. Use the "Bits to extract" parameter to select the bits to output. |
| Interval Test | simulink/Logic and Bit Operations/Interval Test | R2023a+ | If the input is in the interval between the lower limit and the upper limit, then the output is TRUE, otherwise it is FALSE. |
| Interval Test Dynamic | simulink/Logic and Bit Operations/Interval Test Dynamic | R2023a+ | If the input is in the interval between the lower limit and the upper limit, then the output is TRUE, otherwise it is FALSE. |
| Cosine | simulink/Lookup Tables/Cosine | R2023a+ | Implement sine and cosine functions in fixed point using a lookup table approach that exploits quarter wave symmetry. The output fraction length equals the output word length minus 2. The most efficient implementation is obtained when the number of data points is (2^n)+1 where n is an integer. |
| Sine | simulink/Lookup Tables/Sine | R2023a+ | Implement sine and cosine functions in fixed point using a lookup table approach that exploits quarter wave symmetry. The output fraction length equals the output word length minus 2. The most efficient implementation is obtained when the number of data points is (2^n)+1 where n is an integer. |
| Message Polling Subsystem | simulink/Messages & Events/Message Polling Subsystem | R2023a+ | A subsystem block template containing a trigger port and outport block. |
| Message Triggered Subsystem | simulink/Messages & Events/Message Triggered Subsystem | R2023a+ | A subsystem block template containing a trigger port and outport block. |
| Check  Dynamic Gap | simulink/Model Verification/Check  Dynamic Gap | R2023a+ | Assert that the input signal 'u' is always less than the lower bound 'min' or greater than the upper bound 'max'. The first input is the upper-bound of the gap; the second input, the lower-bound; the third input, the test signal. |
| Check  Static Gap | simulink/Model Verification/Check  Static Gap | R2023a+ | Assert that the input signal is less than (or optionally equal to) a static lower bound or greater than (or optionally equal to) a static upper bound. |
| Check  Static Range | simulink/Model Verification/Check  Static Range | R2023a+ | Assert that the input signal lies between a static lower and upper bound or optionally equals either bound. |
| Check Input  Resolution | simulink/Model Verification/Check Input  Resolution | R2023a+ | Assert that the input signal has a specified resolution. If the resolution is a scalar, the input signal must be a multiple of the resolution within a 10e-3 tolerance. If the resolution is a vector, the input signal must equal an element of the resolution vector. |
| Check Static  Lower Bound | simulink/Model Verification/Check Static  Lower Bound | R2023a+ | Assert that the input signal is greater than (or optionally equal to) a static lower bound. |
| Check Static  Upper Bound | simulink/Model Verification/Check Static  Upper Bound | R2023a+ | Assert that the input signal is less than (or optionally equal to) a static upper bound. |
| Block Support Table | simulink/Model-Wide Utilities/Block Support Table | R2023a+ | Double-clicking the block will launch the Simulink Block Data Type Support Table. |
| DocBlock | simulink/Model-Wide Utilities/DocBlock | R2023a+ | Use this block to save long descriptive text with the model. Double-clicking the block will open an editor. |
| Model Info | simulink/Model-Wide Utilities/Model Info | R2023a+ | This block allows revision control information to be displayed within the model. |
| Timed-Based Linearization | simulink/Model-Wide Utilities/Timed-Based Linearization | R2023a+ | Generate linear models in the base workspace at specific times. |
| Trigger-Based Linearization | simulink/Model-Wide Utilities/Trigger-Based Linearization | R2023a+ | Generates linear models in the base workspace when triggered. |
| Atomic Subsystem | simulink/Ports &
Subsystems/Atomic Subsystem | R2023a+ | A subsystem block template containing an inport and outport block. |
| CodeReuseSubsystem | simulink/Ports &
Subsystems/CodeReuseSubsystem | R2023a+ | A subsystem block template containing an inport and outport block. |
| Enabled
Subsystem | simulink/Ports &
Subsystems/Enabled
Subsystem | R2023a+ | A subsystem block template containing an enable port, inport and outport block. |
| Enabled and
Triggered Subsystem | simulink/Ports &
Subsystems/Enabled and
Triggered Subsystem | R2023a+ | A subsystem block template containing an enable port, trigger port, inport and outport block. |
| For Each
Subsystem | simulink/Ports &
Subsystems/For Each
Subsystem | R2023a+ | A subsystem block template containing a for each, inport and outport block. |
| For Iterator
Subsystem | simulink/Ports &
Subsystems/For Iterator
Subsystem | R2023a+ | A subsystem block template containing a for iterator, inport and outport block. |
| Function-Call
Subsystem | simulink/Ports &
Subsystems/Function-Call
Subsystem | R2023a+ | A subsystem block template containing a function-call trigger port, inport and outport block. |
| If Action
Subsystem | simulink/Ports &
Subsystems/If Action
Subsystem | R2023a+ | A subsystem block template containing an action port, inport and outport block. |
| Resettable
Subsystem | simulink/Ports &
Subsystems/Resettable
Subsystem | R2023a+ | A subsystem block template containing a reset port, inport and outport block. |
| Subsystem Examples | simulink/Ports &
Subsystems/Subsystem Examples | R2023a+ | These are examples of how to use the different types of subsystems. |
| Switch Case Action
Subsystem | simulink/Ports &
Subsystems/Switch Case Action
Subsystem | R2023a+ | A subsystem block template containing an action port, inport and outport block. |
| Triggered
Subsystem | simulink/Ports &
Subsystems/Triggered
Subsystem | R2023a+ | A subsystem block template containing a trigger port, inport and outport block. |
| Variant Assembly Subsystem | simulink/Ports &
Subsystems/Variant Assembly Subsystem | R2023a+ | A Variant Subsystem template in Variant Assembly mode. |
| Variant Model | simulink/Ports &
Subsystems/Variant Model | R2023a+ | A Variant Subsystem template containing Model blocks as variant choices. |
| Variant Subsystem | simulink/Ports &
Subsystems/Variant Subsystem | R2023a+ | A Variant Subsystem template containing Subsystem blocks as variant choices. |
| While Iterator
Subsystem | simulink/Ports &
Subsystems/While Iterator
Subsystem | R2023a+ | A subsystem block template containing a while iterator, inport and outport block. |
| AND | simulink/Quick Insert/Logic and Bit Operations/AND | R2023a+ | Logical AND of the inputs — use to require all conditions to be true. |
| Bitwise AND | simulink/Quick Insert/Logic and Bit Operations/Bitwise AND | R2023a+ | Bitwise AND of integer inputs (with optional mask) — use for bit masking. |
| Bitwise NAND | simulink/Quick Insert/Logic and Bit Operations/Bitwise NAND | R2023a+ | Bitwise NAND of integer inputs — use for inverted bit masking. |
| Bitwise NOR | simulink/Quick Insert/Logic and Bit Operations/Bitwise NOR | R2023a+ | Bitwise NOR of integer inputs — use for inverted bit combination. |
| Bitwise NOT | simulink/Quick Insert/Logic and Bit Operations/Bitwise NOT | R2023a+ | Bitwise complement of an integer input — use to invert all bits. |
| Bitwise OR | simulink/Quick Insert/Logic and Bit Operations/Bitwise OR | R2023a+ | Bitwise OR of integer inputs — use for setting/combining bits. |
| Bitwise XOR | simulink/Quick Insert/Logic and Bit Operations/Bitwise XOR | R2023a+ | Bitwise exclusive-OR of integer inputs — use for toggling bits or parity. |
| Equal | simulink/Quick Insert/Logic and Bit Operations/Equal | R2023a+ | Output true when inputs are equal — use for equality comparison. |
| GT | simulink/Quick Insert/Logic and Bit Operations/GT | R2023a+ | Output true when the first input is greater than the second — use for greater-than comparison. |
| GTE | simulink/Quick Insert/Logic and Bit Operations/GTE | R2023a+ | Output true when the first input is greater than or equal to the second — use for greater-or-equal comparison. |
| GreaterThan | simulink/Quick Insert/Logic and Bit Operations/GreaterThan | R2023a+ | Output true when the first input is greater than the second — use for greater-than comparison. |
| GreaterThanOrEqual | simulink/Quick Insert/Logic and Bit Operations/GreaterThanOrEqual | R2023a+ | Output true when the first input is greater than or equal to the second — use for greater-or-equal comparison. |
| IsFinite | simulink/Quick Insert/Logic and Bit Operations/IsFinite | R2023a+ | Output true when the input is finite (not Inf or NaN) — use to validate numeric signals. |
| IsInf | simulink/Quick Insert/Logic and Bit Operations/IsInf | R2023a+ | Output true when the input is infinite — use to detect overflow/divide-by-zero results. |
| IsNaN | simulink/Quick Insert/Logic and Bit Operations/IsNaN | R2023a+ | Output true when the input is NaN — use to detect invalid numeric results. |
| IsNegative | simulink/Quick Insert/Logic and Bit Operations/IsNegative | R2023a+ | Output true when the input is negative — use for sign testing. |
| IsNonNegative | simulink/Quick Insert/Logic and Bit Operations/IsNonNegative | R2023a+ | Output true when the input is zero or positive — use for sign testing. |
| IsNonPositive | simulink/Quick Insert/Logic and Bit Operations/IsNonPositive | R2023a+ | Output true when the input is zero or negative — use for sign testing. |
| IsNonZero | simulink/Quick Insert/Logic and Bit Operations/IsNonZero | R2023a+ | Output true when the input is not zero — use to detect nonzero values. |
| IsPositive | simulink/Quick Insert/Logic and Bit Operations/IsPositive | R2023a+ | Output true when the input is positive — use for sign testing. |
| IsZero | simulink/Quick Insert/Logic and Bit Operations/IsZero | R2023a+ | Output true when the input equals zero — use to detect zero values. |
| LT | simulink/Quick Insert/Logic and Bit Operations/LT | R2023a+ | Output true when the first input is less than the second — use for less-than comparison. |
| LTE | simulink/Quick Insert/Logic and Bit Operations/LTE | R2023a+ | Output true when the first input is less than or equal to the second — use for less-or-equal comparison. |
| Less Than | simulink/Quick Insert/Logic and Bit Operations/Less Than | R2023a+ | Output true when the first input is less than the second — use for less-than comparison. |
| LessThanOrEqual | simulink/Quick Insert/Logic and Bit Operations/LessThanOrEqual | R2023a+ | Output true when the first input is less than or equal to the second — use for less-or-equal comparison. |
| NAND | simulink/Quick Insert/Logic and Bit Operations/NAND | R2023a+ | Logical NAND of the inputs — use for negated-AND logic. |
| NOR | simulink/Quick Insert/Logic and Bit Operations/NOR | R2023a+ | Logical NOR of the inputs — use for negated-OR logic. |
| NOT | simulink/Quick Insert/Logic and Bit Operations/NOT | R2023a+ | Logical negation of the input — use to invert a boolean. |
| NXOR | simulink/Quick Insert/Logic and Bit Operations/NXOR | R2023a+ | Logical exclusive-NOR of the inputs — use to test equality of booleans. |
| NotEqual | simulink/Quick Insert/Logic and Bit Operations/NotEqual | R2023a+ | Output true when inputs are not equal — use for inequality comparison. |
| OR | simulink/Quick Insert/Logic and Bit Operations/OR | R2023a+ | Logical OR of the inputs — use to require any condition to be true. |
| XOR | simulink/Quick Insert/Logic and Bit Operations/XOR | R2023a+ | Logical exclusive-OR of the inputs — use to detect differing booleans. |
| Manual
Variant Sink | simulink/Signal
Routing/Manual
Variant Sink | R2023a+ | The Manual Variant Sink provides variation on the sink (destination) of a signal. Blocks connected to the output ports define variant choices and one output port is active during simulation. Blocks connected to the inactive ports will be removed from the simulation. Double-clicking the block icon selects the active choice which is shown with a line connecting the input to output. |
| Manual
Variant Source | simulink/Signal
Routing/Manual
Variant Source | R2023a+ | The Manual Variant Source provides variation on the source of a signal. Blocks connected to the input ports define variant choices and one input port is active during simulation. Blocks connected to the inactive ports will be removed from the simulation. Double-clicking the block icon selects the active choice which is shown with a line connecting the input to output. |
| Counter
Free-Running | simulink/Sources/Counter
Free-Running | R2023a+ | This block is a free-running counter that overflows back to zero after it has reached the maximum value possible for the specified number of bits. The counter is always initialized to zero. The output is normally an unsigned integer with the specified number of bits. |
| Counter
Limited | simulink/Sources/Counter
Limited | R2023a+ | This block is a counter that wraps back to zero after it has output the specified upper limit. The counter is always initialized to zero. The output is normally an unsigned integer of 8, 16, or 32 bits. The smallest number of bits needed to represent the upper limit is used. |
| Signal Editor | simulink/Sources/Signal Editor | R2023a+ | Display, create, edit, and switch interchangeable scenarios. |
| Initialize Function | simulink/User-Defined Functions/Initialize Function | R2023a+ | A subsystem block template containing an event-listener block set to 'Initialize' Event, a constant block and a state writer block. |
| Reinitialize Function | simulink/User-Defined Functions/Reinitialize Function | R2023a+ | A subsystem block template containing an event-listener block set to 'Reinitialize' Event with the 'Event name' parameter set to 'reinit', a constant block and a state writer block. |
| Reset Function | simulink/User-Defined Functions/Reset Function | R2023a+ | A subsystem block template containing an event-listener block set to 'Reset' Event with the 'Event name' parameter set to 'reset', a constant block and a state writer block. |
| Simulink Function | simulink/User-Defined Functions/Simulink Function | R2023a+ | A subsystem block template configured as a Simulink Function containing a function-call trigger port, input and output argument blocks. |
| Terminate Function | simulink/User-Defined Functions/Terminate Function | R2023a+ | A subsystem block template containing an event-listener block set to 'Terminate' Event, a state reader and terminator blocks. |

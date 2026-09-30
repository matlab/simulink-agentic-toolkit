---
type: Simulink Block Category
title: Signal management
description: Buffering, indexing, and attribute handling
tags: [signal management, buffer, unbuffer, flip, selector, overwrite, data type, clock]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Signal management
block_count: 23
---

# Signal management

Use these blocks for signal management.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Overwrite Values | dspmtrx3/Overwrite Values | R2023a+ | Overwrite selected elements of a signal with new values — use to patch specific samples or regions. |
| Buffer | dspbuff3/Buffer | R2023a+ | Collect scalar samples into frames with optional overlap — use to convert sample-based to frame-based processing. |
| Delay Line | dspbuff3/Delay Line | R2023a+ | Shift out delay line contents and store input data into start of delay line. |
| N-Ratio Buffer | dspbuff3/N-Ratio Buffer | R2026a+ | Buffer samples into frames using an N:M rate ratio — use for rate-changing framing. |
| N-Ratio Unbuffer | dspbuff3/N-Ratio Unbuffer | R2026a+ | Convert frames back to samples using an N:M rate ratio — use for rate-changing unframing. |
| Queue | dspbuff3/Queue | R2023a+ | Implements a queue, or "First In, First Out" (FIFO) register. |
| Stack | dspbuff3/Stack | R2023a+ | Implements a stack, or "Last In, First Out" (LIFO) register. |
| Unbuffer | dspbuff3/Unbuffer | R2023a+ | Convert frames back into a scalar sample stream — use to move from frame-based to sample-based processing. |
| Flip | dspindex/Flip | R2023a+ | Reverse the order of elements along a dimension — use to flip a vector/matrix or reverse time within a frame. |
| Multiport Selector | dspindex/Multiport Selector | R2023a+ | Output specified rows or columns to one or more output ports. The number of output ports is determined by the number of index vectors, each specified as a separate vector entry in a cell array. Indices are 1-based and need not be unique. |
| Overwrite Values | dspindex/Overwrite Values | R2023a+ | Overwrite selected elements of a signal with new values — use to patch specific samples or regions. |
| Selector | dspindex/Selector | R2023a+ | Select a subset of elements from a signal by index — use to extract specific channels or samples. |
| Variable Selector | dspindex/Variable Selector | R2023a+ | Selects and/or reorders the rows or columns of the input according to a specified vector of indices (the indices need not be unique). The 'Selector mode' parameter determines whether the block uses the same indices for every input ('Fixed'), or uses different indices for every input ('Variable'). When set to 'Variable', you provide the vector of indices through an input port. When the indices are of Boolean data type the block performs logical indexing. |
| Data Type  Conversion | dspsigattribs/Data Type  Conversion | R2023a+ | Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. |
| Inherit Complexity | dspsigattribs/Inherit Complexity | R2023a+ | Copy data from the Data input with the complexity of the reference signal. If the data is real and the reference is complex, an all zero imaginary part is created. If the data is complex and the reference is real, the imaginary part of the input is removed. |
| Check Signal Attributes | dspsigattribs/Check Signal Attributes | R2023a+ | Generate an error when the input signal does or does not match selected attributes exactly. |
| Counter | dspswit3/Counter | R2023a+ | Count up or down through a specified range of numbers. If you set the 'Count event' parameter to 'Free running', the block counts at a constant time interval. Otherwise, the block increments or decrements the counter each time a trigger event occurs at the Inc/Dec input port. |
| Multiphase Clock | dspswit3/Multiphase Clock | R2023a+ | Generate multiple phase-shifted clock/enable signals — use to sequence multirate or multiphase logic. |
| Edge Detector | dspswit3/Edge Detector | R2023a+ | Output a unity amplitude pulse for one sample period in response to a transition from zero to a nonzero value. |
| Event-Count Comparator | dspswit3/Event-Count Comparator | R2023a+ | Output is true if the number of nonzero inputs over time equals or exceeds the 'Event threshold' during the enable interval. A nonzero input on the interval port (Int) enables the block to begin counting and resets the output. Inputs must be discrete-time scalars. |
| N-Sample Switch | dspswit3/N-Sample Switch | R2023a+ | Output N samples from the top port. Thereafter, output samples from the bottom port. |
| Sample and Hold | dspsigops/Sample and Hold | R2023a+ | Sample and hold the input signal. If Latch (buffer) input is selected, then this block produces the value of the input from the previous time step. |
| Multiphase Clock | dspsrcs4/Multiphase Clock | R2023a+ | Generate multiple phase-shifted clock/enable signals — use to sequence multirate or multiphase logic. |

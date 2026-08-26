---
type: Simulink Block Category
title: Physical signal sources
description: Physical signal generators, terminators, and periodic estimators
tags: [constant, step, sine wave, ramp, source]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Physical signal sources
block_count: 11
---

# Physical signal sources

Use these blocks for physical signal sources.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| PS Terminator | fl_lib/Physical Signals/Sinks/PS Terminator | R2023a+ | Use to terminate an unused physical signal output port to avoid unconnected-line warnings |
| PS Constant | fl_lib/Physical Signals/Sources/PS Constant | R2023a+ | Use when generating a constant-valued physical signal as an input to other Simscape blocks |
| PS Counter | fl_lib/Physical Signals/Sources/PS Counter | R2023a+ | Use when generating an incrementing integer physical signal for counting events or cycles |
| PS Ramp | fl_lib/Physical Signals/Sources/PS Ramp | R2023a+ | Use when generating a linearly increasing physical signal starting at a specified time |
| PS Random Number | fl_lib/Physical Signals/Sources/PS Random Number | R2023a+ | Use when generating a normally distributed random physical signal for noise injection |
| PS Repeating Sequence | fl_lib/Physical Signals/Sources/PS Repeating Sequence | R2023a+ | Use when generating a periodic physical signal defined by time-value pairs |
| PS Sine Wave | fl_lib/Physical Signals/Sources/PS Sine Wave | R2023a+ | Use when generating a sinusoidal physical signal at a specified amplitude and frequency |
| PS Step | fl_lib/Physical Signals/Sources/PS Step | R2023a+ | Use when generating a step change in a physical signal at a specified time for transient excitation |
| PS Uniform Random Number | fl_lib/Physical Signals/Sources/PS Uniform Random Number | R2023a+ | Use when generating a uniformly distributed random physical signal within specified bounds |
| PS Signal Specification | fl_lib/Physical Signals/Utilities/PS Signal Specification | R2023a+ | Use when explicitly specifying the size and initial value of a physical signal at a connection point |
| External Angular Velocity Source (AB) | fl_lib/Rotational/Sources/External Angular Velocity Source (AB) | R2023a+ |  |

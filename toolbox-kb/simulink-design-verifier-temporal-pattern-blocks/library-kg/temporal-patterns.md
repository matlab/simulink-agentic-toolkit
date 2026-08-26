---
type: Simulink Block Category
title: Temporal patterns
description: Temporal pattern blocks for formal verification of time-based properties
tags: [temporal, verification, assertion, pattern, time]
status: stable
source: mathworks_toolbox
library_root: Simulink Design Verifier Temporal Pattern Blocks
category_path: Temporal patterns
block_count: 6
---

# Temporal patterns

Use these blocks for temporal patterns.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| atleast_n | sldvpatternlib/atleast_n | R2023a+ | Assert that a condition holds for at least N consecutive time steps — use for specifying minimum duration requirements in temporal verification |
| atmost_n | sldvpatternlib/atmost_n | R2023a+ | Assert that a condition holds for at most N consecutive time steps — use for specifying maximum duration constraints in temporal verification |
| check_at_n | sldvpatternlib/check_at_n | R2023a+ | Check whether a condition holds at exactly the Nth time step — use for verifying properties at specific points in a simulation timeline |
| p_until_q | sldvpatternlib/p_until_q | R2023a+ | Assert that condition P remains true until condition Q becomes true — use for specifying precedence or ordering requirements between events |
| time_elapse | sldvpatternlib/time_elapse | R2023a+ | Measure elapsed time in simulation steps — use for creating time-based triggers or delays in temporal property specifications |
| within_n | sldvpatternlib/within_n | R2023a+ | Assert that a condition becomes true within N time steps — use for specifying bounded response time requirements in temporal verification |

---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 3
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Assert that a condition holds for at least N consecutive time steps — use for specifying minimum duration requirements in temporal verification | atleast_n | Simulink Design Verifier Temporal Pattern Blocks |
| Assert that condition P remains true until condition Q becomes true — use for specifying precedence or ordering requirements between events | p_until_q | Simulink Design Verifier Temporal Pattern Blocks |
| Assert that a condition becomes true within N time steps — use for specifying bounded response time requirements in temporal verification | within_n | Simulink Design Verifier Temporal Pattern Blocks |

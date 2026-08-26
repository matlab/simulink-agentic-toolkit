---
type: Simulink Block Category
title: Temporal operators
description: Temporal logic operators for time-based properties
tags: [temporal, detector, extender, within, time]
status: stable
source: mathworks_toolbox
library_root: Simulink Design Verifier
category_path: Temporal operators
block_count: 3
---

# Temporal operators

Use these blocks for temporal operators.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Detector | sldvlib/Temporal Operators/Detector | R2023a+ | Detect when a Boolean condition has been true for N consecutive steps — use for building temporal assertions that require sustained conditions |
| Extender | sldvlib/Temporal Operators/Extender | R2023a+ | Extend a Boolean pulse by N time steps — use for holding a trigger active longer when building temporal verification logic |
| Within Implies | sldvlib/Temporal Operators/Within Implies | R2023a+ | Assert that if P occurs, then Q must follow within N steps — use for bounded response time verification in safety-critical temporal properties |

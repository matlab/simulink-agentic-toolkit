---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 4
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Constrain input ranges for formal verification — use for defining valid operating conditions that the design verifier assumes hold during analysis | Assumption | Simulink Design Verifier |
| Specify a property to be formally proven — use for defining safety or correctness assertions that must hold under all valid input conditions | Proof Objective | Simulink Design Verifier |
| Specify a coverage target for test generation — use for directing automatic test generation to achieve specific signal conditions or code paths | Test Objective | Simulink Design Verifier |
| Container for verification logic excluded from code generation — use for grouping assertions and proof objectives without affecting production code | Verification Subsystem | Simulink Design Verifier |

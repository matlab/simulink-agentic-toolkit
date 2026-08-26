---
type: Simulink Block Category
title: Objectives constraints
description: Formal verification objectives and input constraints
tags: [proof, assumption, objective, constraint, test]
status: stable
source: mathworks_toolbox
library_root: Simulink Design Verifier
category_path: Objectives constraints
block_count: 4
---

# Objectives constraints

Use these blocks for objectives constraints.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Assumption | sldvlib/Objectives and Constraints/Assumption | R2023a+ | Constrain input ranges for formal verification — use for defining valid operating conditions that the design verifier assumes hold during analysis |
| Proof Objective | sldvlib/Objectives and Constraints/Proof Objective | R2023a+ | Specify a property to be formally proven — use for defining safety or correctness assertions that must hold under all valid input conditions |
| Test Condition | sldvlib/Objectives and Constraints/Test Condition | R2023a+ | Constrain signals during test generation — use for guiding automatic test vector generation to focus on specific operating regions |
| Test Objective | sldvlib/Objectives and Constraints/Test Objective | R2023a+ | Specify a coverage target for test generation — use for directing automatic test generation to achieve specific signal conditions or code paths |

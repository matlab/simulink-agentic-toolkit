---
type: Simulink Block Category
title: Objectives constraints
description: Formal verification objectives and input constraints (4 blocks)
tags: [toolbox-kb, simulink-design-verifier, proof, assumption, objective, constraint, test]
status: stable
sources:
  - resource: matlab:sldvlib
source: toolbox_kb
managed_by: satk
library: Simulink Design Verifier
kb_folder: simulink-design-verifier
category: objectives-constraints
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:31Z" }
---

# Objectives constraints

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Assumption | sldvlib/Objectives and Constraints/Assumption | R2023a+ | Constrain input ranges for formal verification — use for defining valid operating conditions that the design verifier assumes hold during analysis |
| Proof Objective | sldvlib/Objectives and Constraints/Proof Objective | R2023a+ | Specify a property to be formally proven — use for defining safety or correctness assertions that must hold under all valid input conditions |
| Test Condition | sldvlib/Objectives and Constraints/Test Condition | R2023a+ | Constrain signals during test generation — use for guiding automatic test vector generation to focus on specific operating regions |
| Test Objective | sldvlib/Objectives and Constraints/Test Objective | R2023a+ | Specify a coverage target for test generation — use for directing automatic test generation to achieve specific signal conditions or code paths |

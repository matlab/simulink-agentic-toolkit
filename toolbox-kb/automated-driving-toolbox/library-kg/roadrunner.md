---
type: Simulink Block Category
title: Roadrunner
description: RoadRunner scenario co-simulation interface (3 blocks)
tags: [toolbox-kb, automated-driving-toolbox, roadrunner]
status: stable
sources:
  - resource: matlab:roadrunnerscenario
source: toolbox_kb
managed_by: satk
library: Automated Driving Toolbox
kb_folder: automated-driving-toolbox
category: roadrunner
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:14Z" }
---

# Roadrunner

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| RoadRunner Scenario | roadrunnerscenario/RoadRunner Scenario | R2023a+ | Interface block that co-simulates the model with a RoadRunner scenario — use to drive Simulink from RoadRunner actors. |
| RoadRunner Scenario Reader | roadrunnerscenario/RoadRunner Scenario Reader | R2023a+ | Read actor and state data from a RoadRunner scenario into the model — use to consume RoadRunner data in Simulink. |
| RoadRunner Scenario Writer | roadrunnerscenario/RoadRunner Scenario Writer | R2023a+ | Write actor and state data from the model back to a RoadRunner scenario — use to publish Simulink results into RoadRunner. |

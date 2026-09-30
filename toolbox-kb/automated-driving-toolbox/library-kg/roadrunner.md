---
type: Simulink Block Category
title: Roadrunner
description: RoadRunner scenario co-simulation interface
tags: [roadrunner]
status: stable
source: custom_library
library_root: Automated Driving Toolbox
category_path: Roadrunner
block_count: 3
---

# Roadrunner

Use these blocks for roadrunner.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| RoadRunner Scenario | roadrunnerscenario/RoadRunner Scenario | R2023a+ | Interface block that co-simulates the model with a RoadRunner scenario — use to drive Simulink from RoadRunner actors. |
| RoadRunner Scenario Reader | roadrunnerscenario/RoadRunner Scenario Reader | R2023a+ | Read actor and state data from a RoadRunner scenario into the model — use to consume RoadRunner data in Simulink. |
| RoadRunner Scenario Writer | roadrunnerscenario/RoadRunner Scenario Writer | R2023a+ | Write actor and state data from the model back to a RoadRunner scenario — use to publish Simulink results into RoadRunner. |

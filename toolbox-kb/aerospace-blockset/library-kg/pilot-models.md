---
type: Simulink Block Category
title: Pilot models
description: Human pilot transfer function models (3 blocks)
tags: [toolbox-kb, aerospace-blockset, pilot, crossover, handling qualities, neuromuscular]
status: stable
sources:
  - resource: matlab:aerolibpilot
source: toolbox_kb
managed_by: satk
library: Aerospace Blockset
kb_folder: aerospace-blockset
category: pilot-models
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Pilot models

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Crossover Pilot Model | aerolibpilot/Crossover Pilot Model | R2023a+ | Model human pilot as a crossover transfer function that adapts gain and lead to achieve desired crossover frequency — use for handling qualities analysis |
| Precision Pilot Model | aerolibpilot/Precision Pilot Model | R2023a+ | Model human pilot with neuromuscular dynamics and remnant noise for precision tracking tasks — higher fidelity than crossover model |
| Tustin Pilot Model | aerolibpilot/Tustin Pilot Model | R2023a+ | Model human pilot using Tustin's simplified transfer function (gain, lead, lag, delay) — use for classical pilot-in-the-loop stability analysis |

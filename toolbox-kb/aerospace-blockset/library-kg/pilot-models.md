---
type: Simulink Block Category
title: Pilot models
description: Human pilot transfer function models
tags: [pilot, crossover, handling qualities, neuromuscular]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Pilot models
block_count: 3
---

# Pilot models

Use these blocks for pilot models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Crossover Pilot Model | aerolibpilot/Crossover Pilot Model | R2023a+ | Model human pilot as a crossover transfer function that adapts gain and lead to achieve desired crossover frequency — use for handling qualities analysis |
| Precision Pilot Model | aerolibpilot/Precision Pilot Model | R2023a+ | Model human pilot with neuromuscular dynamics and remnant noise for precision tracking tasks — higher fidelity than crossover model |
| Tustin Pilot Model | aerolibpilot/Tustin Pilot Model | R2023a+ | Model human pilot using Tustin's simplified transfer function (gain, lead, lag, delay) — use for classical pilot-in-the-loop stability analysis |

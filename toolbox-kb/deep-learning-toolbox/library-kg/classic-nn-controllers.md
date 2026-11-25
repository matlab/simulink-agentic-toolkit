---
type: Simulink Block Category
title: Classic nn controllers
description: Classic neural network controllers for adaptive and predictive control (3 blocks)
tags: [toolbox-kb, deep-learning-toolbox, controller, narma, predictive, adaptive, model]
status: stable
sources:
  - resource: matlab:neural
source: toolbox_kb
managed_by: satk
library: Deep Learning Toolbox
kb_folder: deep-learning-toolbox
category: classic-nn-controllers
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:18Z" }
---

# Classic nn controllers

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Model Reference Controller | neural/Control Systems/Model Reference Controller | R2023a+ | Implement a model reference adaptive controller using a neural network — use for adaptive control where the plant model is approximated by a trained network |
| NARMA-L2 Controller | neural/Control Systems/NARMA-L2 Controller | R2023a+ | Implement a NARMA-L2 (feedback linearization) neural network controller — use for nonlinear plant control where the network inverts the plant dynamics |
| NN Predictive Controller | neural/Control Systems/NN Predictive Controller | R2023a+ | Implement a neural network predictive controller using receding-horizon optimization — use for model-predictive control where the plant model is a trained network |

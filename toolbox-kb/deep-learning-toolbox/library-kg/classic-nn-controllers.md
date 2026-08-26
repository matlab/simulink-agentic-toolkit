---
type: Simulink Block Category
title: Classic nn controllers
description: Classic neural network controllers for adaptive and predictive control
tags: [controller, narma, predictive, adaptive, model]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Classic nn controllers
block_count: 3
---

# Classic nn controllers

Use these blocks for classic nn controllers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Model Reference Controller | neural/Control Systems/Model Reference Controller | R2023a+ | Implement a model reference adaptive controller using a neural network — use for adaptive control where the plant model is approximated by a trained network |
| NARMA-L2 Controller | neural/Control Systems/NARMA-L2 Controller | R2023a+ | Implement a NARMA-L2 (feedback linearization) neural network controller — use for nonlinear plant control where the network inverts the plant dynamics |
| NN Predictive Controller | neural/Control Systems/NN Predictive Controller | R2023a+ | Implement a neural network predictive controller using receding-horizon optimization — use for model-predictive control where the plant model is a trained network |

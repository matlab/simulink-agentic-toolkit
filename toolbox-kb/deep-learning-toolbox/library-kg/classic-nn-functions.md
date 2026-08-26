---
type: Simulink Block Category
title: Classic nn functions
description: Transfer functions, weight functions, and net input functions for classic networks
tags: [tansig, logsig, purelin, dotprod, transfer]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Classic nn functions
block_count: 22
---

# Classic nn functions

Use these blocks for classic nn functions.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| compet | neural/Transfer Functions/compet | R2023a+ | Competitive transfer function that outputs 1 for the neuron with the largest input — use in competitive learning and self-organizing map networks |
| elliot2sig | neural/Transfer Functions/elliot2sig | R2023a+ | Apply Elliot symmetric sigmoid (fast approximation to tanh) — use when sigmoid-like activation is needed with lower computational cost than standard tanh |
| elliotsig | neural/Transfer Functions/elliotsig | R2023a+ | Apply Elliot sigmoid (fast approximation to logistic sigmoid) — use for computationally efficient sigmoid activation in resource-constrained deployments |
| hardlim | neural/Transfer Functions/hardlim | R2023a+ | Hard-limit transfer function (outputs 0 or 1) — use for binary threshold activation in perceptrons or pattern classification networks |
| hardlims | neural/Transfer Functions/hardlims | R2023a+ | Symmetric hard-limit transfer function (outputs -1 or 1) — use for bipolar threshold activation in symmetric perceptron networks |
| logsig | neural/Transfer Functions/logsig | R2023a+ | Log-sigmoid transfer function mapping inputs to 0-1 range — use as the classic sigmoid activation for binary outputs in legacy neural network architectures |
| netinv | neural/Transfer Functions/netinv | R2023a+ | Inverse transfer function (1/x) — use in radial basis or specialized network architectures requiring reciprocal activation |
| poslin | neural/Transfer Functions/poslin | R2023a+ | Positive linear transfer function (equivalent to ReLU) — use as rectified linear activation in classic Neural Network Toolbox architectures |
| purelin | neural/Transfer Functions/purelin | R2023a+ | Linear transfer function (identity) — use for output layers in regression networks where no nonlinear squashing is desired |
| radbas | neural/Transfer Functions/radbas | R2023a+ | Radial basis transfer function (Gaussian) — use as the activation in radial basis function network hidden layers for function approximation |
| radbasn | neural/Transfer Functions/radbasn | R2023a+ | Normalized radial basis transfer function — use in normalized RBF networks where basis function outputs are divided by their sum |
| satlin | neural/Transfer Functions/satlin | R2023a+ | Saturating linear transfer function (clipped to 0-1) — use when linear response is needed within bounds and saturation outside |
| satlins | neural/Transfer Functions/satlins | R2023a+ | Symmetric saturating linear transfer function (clipped to -1 to 1) — use for bounded linear activation with symmetric saturation limits |
| softmax | neural/Transfer Functions/softmax | R2023a+ | Softmax transfer function producing probability distribution — use as the output activation for multi-class classification in classic NN Toolbox networks |
| tansig | neural/Transfer Functions/tansig | R2023a+ | Hyperbolic tangent sigmoid transfer function — use as the standard bipolar sigmoid activation in classic feedforward and recurrent networks |
| tribas | neural/Transfer Functions/tribas | R2023a+ | Triangular basis transfer function — use in specialized interpolation or local-response networks as a piecewise-linear basis function |
| dist | neural/Weight Functions/dist | R2023a+ | Euclidean distance weight function — use in radial basis and competitive networks to compute distance between input vectors and weight vectors |
| dotprod | neural/Weight Functions/dotprod | R2023a+ | Dot product weight function — use as the standard weight application method in feedforward layers computing weighted sums of inputs |
| negdist | neural/Weight Functions/negdist | R2023a+ | Negative Euclidean distance weight function — use in competitive layers where closer vectors should produce larger (less negative) net inputs |
| normprod | neural/Weight Functions/normprod | R2023a+ | Normalized dot product weight function — use when weight application should be invariant to input vector magnitude |
| netprod | neural/Net Input Functions/netprod | R2023a+ | Product net input function — use in pi-sigma or product-unit networks where net input is the product rather than sum of weighted inputs |
| netsum | neural/Net Input Functions/netsum | R2023a+ | Summation net input function — use as the standard net input computation that sums all weighted inputs plus bias in feedforward networks |

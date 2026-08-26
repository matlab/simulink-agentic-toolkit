---
type: Simulink Block Category
title: Gain scheduling
description: Gain-scheduled controllers and matrix interpolation
tags: [gain schedule, controller, interpolate, LPV, state-space]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Gain scheduling
block_count: 16
---

# Gain scheduling

Use these blocks for gain scheduling.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 1D Controller Blend: u=(1-L).K1.y+L.K2.y | aerolibschedule/1D Controller Blend: u=(1-L).K1.y+L.K2.y | R2023a+ | Blend two controller outputs using a single scheduling variable — use for smooth controller transition during flight envelope changes |
| 1D Controller [A(v),B(v),C(v),D(v)] | aerolibschedule/1D Controller [A(v),B(v),C(v),D(v)] | R2023a+ | Implement a gain-scheduled state-space controller interpolated over one scheduling variable — standard approach for LPV controller deployment |
| 1D Observer Form [A(v),B(v),C(v),F(v),H(v)] | aerolibschedule/1D Observer Form [A(v),B(v),C(v),F(v),H(v)] | R2023a+ | Implement a gain-scheduled observer-form controller over one scheduling variable — use when the controller includes a state estimator |
| 1D Self-Conditioned [A(v),B(v),C(v),D(v)] | aerolibschedule/1D Self-Conditioned [A(v),B(v),C(v),D(v)] | R2023a+ | Implement a self-conditioned gain-scheduled controller over one variable — prevents integrator wind-up during controller transitions |
| 2D Controller Blend | aerolibschedule/2D Controller Blend | R2023a+ | Blend controller outputs using two scheduling variables — use for multi-parameter operating envelope transitions |
| 2D Controller [A(v),B(v),C(v),D(v)] | aerolibschedule/2D Controller [A(v),B(v),C(v),D(v)] | R2023a+ | Implement a gain-scheduled state-space controller interpolated over two scheduling variables |
| 2D Observer Form [A(v),B(v),C(v),F(v),H(v)] | aerolibschedule/2D Observer Form [A(v),B(v),C(v),F(v),H(v)] | R2023a+ | Implement a gain-scheduled observer-form controller over two scheduling variables |
| 2D Self-Conditioned [A(v),B(v),C(v),D(v)] | aerolibschedule/2D Self-Conditioned [A(v),B(v),C(v),D(v)] | R2023a+ | Implement a self-conditioned gain-scheduled controller over two scheduling variables |
| 3D Controller [A(v),B(v),C(v),D(v)] | aerolibschedule/3D Controller [A(v),B(v),C(v),D(v)] | R2023a+ | Implement a gain-scheduled state-space controller interpolated over three scheduling variables |
| 3D Observer Form [A(v),B(v),C(v),F(v),H(v)] | aerolibschedule/3D Observer Form [A(v),B(v),C(v),F(v),H(v)] | R2023a+ | Implement a gain-scheduled observer-form controller over three scheduling variables |
| 3D Self-Conditioned [A(v),B(v),C(v),D(v)] | aerolibschedule/3D Self-Conditioned [A(v),B(v),C(v),D(v)] | R2023a+ | Implement a self-conditioned gain-scheduled controller over three scheduling variables |
| Gain Scheduled Lead-Lag | aerolibschedule/Gain Scheduled Lead-Lag | R2023a+ | Implement a gain-scheduled lead-lag compensator whose time constants vary with a scheduling variable — common in flight control augmentation |
| Interpolate Matrix(x,y,z)  | aerolibschedule/Interpolate Matrix(x,y,z)  | R2023a+ | Interpolate a matrix of gains over three scheduling variables — use for deploying 3D gain tables in controllers |
| Self-Conditioned [A,B,C,D] | aerolibschedule/Self-Conditioned [A,B,C,D] | R2023a+ | Implement a self-conditioned state-space controller that prevents integrator wind-up when switching between manual and automatic modes |
| Interpolate Matrix(x)  | aerolibschedule/Interpolate Matrix(x)  | R2023a+ | Interpolate a matrix of gains over one scheduling variable — use for 1D gain-table lookup in scheduled controllers |
| Interpolate Matrix(x,y)  | aerolibschedule/Interpolate Matrix(x,y)  | R2023a+ | Interpolate a matrix of gains over two scheduling variables — use for 2D gain-table lookup in scheduled controllers |

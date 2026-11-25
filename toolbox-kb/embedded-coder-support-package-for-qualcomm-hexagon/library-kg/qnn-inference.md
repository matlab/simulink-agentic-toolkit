---
type: Simulink Block Category
title: Qnn inference
description: Run deep-learning inference on Qualcomm AI Engine Direct (QNN) backends (5 blocks)
tags: [toolbox-kb, embedded-coder-support-package-for-qualcomm-hexagon, qnn, predict, inference, backend]
status: stable
sources:
  - resource: matlab:mwqnnlib
source: toolbox_kb
managed_by: satk
library: Embedded Coder Support Package for Qualcomm Hexagon
kb_folder: embedded-coder-support-package-for-qualcomm-hexagon
category: qnn-inference
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:21Z" }
---

# Qnn inference

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| QNN CPU Predict | mwqnnlib/QNN CPU Predict | R2025b+ | Run inference of a QNN deep-learning model on the CPU backend — use as a portable fallback when NPU/GPU/DSP acceleration is unavailable. |
| QNN DSP Predict | mwqnnlib/QNN DSP Predict | R2026a+ | Run inference of a QNN deep-learning model on the Hexagon DSP (v66) backend — use for efficient signal-processing-style inference. |
| QNN GPU Predict | mwqnnlib/QNN GPU Predict | R2026a+ | Run inference of a QNN deep-learning model on the GPU backend — use for parallel workloads that map well to the GPU. |
| QNN HTP Predict | mwqnnlib/QNN HTP Predict | R2025b+ | Run inference of a QNN deep-learning model on the Hexagon HTP (NPU) backend — the preferred, highest-performance backend for on-device neural network execution; accepts a compiled .so or QNN context .bin. |
| QNN LPAI Predict | mwqnnlib/QNN LPAI Predict | R2025b+ | Run inference of a QNN deep-learning model on the LPAI (low-power AI) backend from a QNN context binary — use for always-on, low-power inference. |

---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 6
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Run inference of a QNN deep-learning model on the CPU backend — use as a portable fallback when NPU/GPU/DSP acceleration is unavailable. | QNN CPU Predict | Embedded Coder Support Package for Qualcomm Hexagon |
| Run inference of a QNN deep-learning model on the Hexagon DSP (v66) backend — use for efficient signal-processing-style inference. | QNN DSP Predict | Embedded Coder Support Package for Qualcomm Hexagon |
| Run inference of a QNN deep-learning model on the GPU backend — use for parallel workloads that map well to the GPU. | QNN GPU Predict | Embedded Coder Support Package for Qualcomm Hexagon |
| Run inference of a QNN deep-learning model on the Hexagon HTP (NPU) backend — the preferred, highest-performance backend for on-device neural network execution; accepts a compiled .so or QNN context .bin. | QNN HTP Predict | Embedded Coder Support Package for Qualcomm Hexagon |
| Run inference of a QNN deep-learning model on the LPAI (low-power AI) backend from a QNN context binary — use for always-on, low-power inference. | QNN LPAI Predict | Embedded Coder Support Package for Qualcomm Hexagon |
| Hexagon Utilities Blocks | Hexagon | Embedded Coder Support Package for Qualcomm Hexagon |

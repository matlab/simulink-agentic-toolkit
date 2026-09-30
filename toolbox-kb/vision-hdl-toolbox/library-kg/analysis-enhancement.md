---
type: Simulink Block Category
title: Analysis enhancement
description: HDL-optimized feature detection and image enhancement on a pixel stream
tags: [analysis, enhancement, corner, edge detector]
status: stable
source: custom_library
library_root: Vision HDL Toolbox
category_path: Analysis enhancement
block_count: 3
---

# Analysis enhancement

Use these blocks for analysis enhancement.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Corner Detector | visionhdlanalysis/Corner Detector | R2023a+ | HDL-optimized corner detector on a pixel stream — use for hardware feature/interest-point detection (Harris/FAST-style). |
| Edge Detector | visionhdlanalysis/Edge Detector | R2023a+ | HDL-optimized edge detector on a pixel stream — use for hardware edge extraction (Sobel/Prewitt/Roberts). |
| Median Filter | visionhdlanalysis/Median Filter | R2023a+ | HDL-optimized median filter on a pixel stream — use for hardware impulse-noise (salt-and-pepper) removal that preserves edges. |

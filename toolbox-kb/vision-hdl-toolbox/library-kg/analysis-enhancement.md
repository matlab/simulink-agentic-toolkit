---
type: Simulink Block Category
title: Analysis enhancement
description: HDL-optimized feature detection and image enhancement on a pixel stream (3 blocks)
tags: [toolbox-kb, vision-hdl-toolbox, analysis, enhancement, corner, edge detector]
status: stable
sources:
  - resource: matlab:visionhdlanalysis
source: toolbox_kb
managed_by: satk
library: Vision HDL Toolbox
kb_folder: vision-hdl-toolbox
category: analysis-enhancement
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:34Z" }
---

# Analysis enhancement

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Corner Detector | visionhdlanalysis/Corner Detector | R2023a+ | HDL-optimized corner detector on a pixel stream — use for hardware feature/interest-point detection (Harris/FAST-style). |
| Edge Detector | visionhdlanalysis/Edge Detector | R2023a+ | HDL-optimized edge detector on a pixel stream — use for hardware edge extraction (Sobel/Prewitt/Roberts). |
| Median Filter | visionhdlanalysis/Median Filter | R2023a+ | HDL-optimized median filter on a pixel stream — use for hardware impulse-noise (salt-and-pepper) removal that preserves edges. |

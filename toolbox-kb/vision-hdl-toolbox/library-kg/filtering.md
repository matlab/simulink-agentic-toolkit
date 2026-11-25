---
type: Simulink Block Category
title: Filtering
description: HDL-optimized spatial filters on a pixel stream (3 blocks)
tags: [toolbox-kb, vision-hdl-toolbox, filtering, bilateral, image filter, median]
status: stable
sources:
  - resource: matlab:visionhdlfilter
source: toolbox_kb
managed_by: satk
library: Vision HDL Toolbox
kb_folder: vision-hdl-toolbox
category: filtering
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:34Z" }
---

# Filtering

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bilateral Filter | visionhdlfilter/Bilateral Filter | R2023a+ | HDL-optimized edge-preserving bilateral filter on a pixel stream — use for hardware noise reduction that keeps edges sharp. |
| Image Filter | visionhdlfilter/Image Filter | R2023a+ | HDL-optimized general 2-D FIR image filter with a user kernel on a pixel stream — use for hardware convolution such as blur, sharpen, or emboss. |
| Median Filter | visionhdlfilter/Median Filter | R2023a+ | HDL-optimized median filter on a pixel stream — use for hardware impulse-noise (salt-and-pepper) removal that preserves edges. |

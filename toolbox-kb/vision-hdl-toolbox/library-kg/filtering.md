---
type: Simulink Block Category
title: Filtering
description: HDL-optimized spatial filters on a pixel stream
tags: [filtering, bilateral, image filter, median]
status: stable
source: custom_library
library_root: Vision HDL Toolbox
category_path: Filtering
block_count: 3
---

# Filtering

Use these blocks for filtering.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bilateral Filter | visionhdlfilter/Bilateral Filter | R2023a+ | HDL-optimized edge-preserving bilateral filter on a pixel stream — use for hardware noise reduction that keeps edges sharp. |
| Image Filter | visionhdlfilter/Image Filter | R2023a+ | HDL-optimized general 2-D FIR image filter with a user kernel on a pixel stream — use for hardware convolution such as blur, sharpen, or emboss. |
| Median Filter | visionhdlfilter/Median Filter | R2023a+ | HDL-optimized median filter on a pixel stream — use for hardware impulse-noise (salt-and-pepper) removal that preserves edges. |

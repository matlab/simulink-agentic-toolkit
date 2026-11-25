---
type: Simulink Block Category
title: Morphology
description: HDL-optimized morphological operations on a pixel stream (8 blocks)
tags: [toolbox-kb, vision-hdl-toolbox, morphological, closing, dilation, erosion, opening, grayscale]
status: stable
sources:
  - resource: matlab:visionhdlmorphops
source: toolbox_kb
managed_by: satk
library: Vision HDL Toolbox
kb_folder: vision-hdl-toolbox
category: morphology
block_count: 8
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:34Z" }
---

# Morphology

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Closing | visionhdlmorphops/Closing | R2023a+ | HDL-optimized binary morphological closing on a pixel stream — use to fill small holes and gaps in hardware. |
| Dilation | visionhdlmorphops/Dilation | R2023a+ | HDL-optimized binary morphological dilation on a pixel stream — use to grow foreground regions in hardware. |
| Erosion | visionhdlmorphops/Erosion | R2023a+ | HDL-optimized binary morphological erosion on a pixel stream — use to shrink foreground regions and remove speckle in hardware. |
| Grayscale Closing | visionhdlmorphops/Grayscale Closing | R2023a+ | HDL-optimized grayscale morphological closing on a pixel stream — use to remove small dark features while preserving intensity. |
| Grayscale Dilation | visionhdlmorphops/Grayscale Dilation | R2023a+ | HDL-optimized grayscale morphological dilation on a pixel stream — use to expand bright regions in hardware. |
| Grayscale Erosion | visionhdlmorphops/Grayscale Erosion | R2023a+ | HDL-optimized grayscale morphological erosion on a pixel stream — use to shrink bright regions in hardware. |
| Grayscale Opening | visionhdlmorphops/Grayscale Opening | R2023a+ | HDL-optimized grayscale morphological opening on a pixel stream — use to remove small bright features while preserving intensity. |
| Opening | visionhdlmorphops/Opening | R2023a+ | HDL-optimized binary morphological opening on a pixel stream — use to remove small bright specks in hardware. |

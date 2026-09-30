---
type: Simulink Block Category
title: Conversions
description: HDL-optimized color, gamma, and format conversions
tags: [conversions, chroma, color space, demosaic, gamma, lookup table]
status: stable
source: custom_library
library_root: Vision HDL Toolbox
category_path: Conversions
block_count: 5
---

# Conversions

Use these blocks for conversions.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Chroma Resampler | visionhdlconversions/Chroma Resampler | R2023a+ | HDL-optimized chroma resampler that converts between chroma-subsampling formats (4:4:4/4:2:2/4:2:0) — use in hardware video pipelines. |
| Color Space Converter | visionhdlconversions/Color Space Converter | R2023a+ | HDL-optimized color space conversion (e.g., RGB↔YCbCr) on a pixel stream — use in hardware video pipelines. |
| Demosaic Interpolator | visionhdlconversions/Demosaic Interpolator | R2023a+ | HDL-optimized demosaic that reconstructs full RGB from a Bayer sensor pattern — use as the first stage of a hardware camera pipeline. |
| Gamma Corrector | visionhdlconversions/Gamma Corrector | R2023a+ | HDL-optimized gamma correction on a pixel stream — use for hardware tone/gamma adjustment. |
| Lookup Table | visionhdlconversions/Lookup Table | R2023a+ | HDL-optimized per-pixel lookup table — use for hardware intensity remapping and point operations on a pixel stream. |

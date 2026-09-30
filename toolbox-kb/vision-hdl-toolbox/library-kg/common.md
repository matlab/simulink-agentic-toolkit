---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 29
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| HDL-optimized edge detector on a pixel stream — use for hardware edge extraction (Sobel/Prewitt/Roberts). | Edge Detector | Vision HDL Toolbox |
| HDL-optimized color space conversion (e.g., RGB↔YCbCr) on a pixel stream — use in hardware video pipelines. | Color Space Converter | Vision HDL Toolbox |
| HDL-optimized demosaic that reconstructs full RGB from a Bayer sensor pattern — use as the first stage of a hardware camera pipeline. | Demosaic Interpolator | Vision HDL Toolbox |
| HDL-optimized general 2-D FIR image filter with a user kernel on a pixel stream — use for hardware convolution such as blur, sharpen, or emboss. | Image Filter | Vision HDL Toolbox |
| Buffer lines of a pixel stream to form pixel neighborhoods — use as the building block for hardware kernel/window operations. | Line Buffer | Vision HDL Toolbox |
| Select individual signals (hStart, vStart, valid, hEnd, vEnd) from the pixel-control bus — use to access streaming control flags. | Pixel Control Bus Selector | Vision HDL Toolbox |
| Extract one or more rectangular regions of interest from a pixel stream — use to process only part of a frame in hardware. | ROI Selector | Vision HDL Toolbox |
| HDL-optimized corner detector on a pixel stream — use for hardware feature/interest-point detection (Harris/FAST-style). | Corner Detector | Vision HDL Toolbox |
| HDL-optimized median filter on a pixel stream — use for hardware impulse-noise (salt-and-pepper) removal that preserves edges. | Median Filter | Vision HDL Toolbox |
| HDL-optimized chroma resampler that converts between chroma-subsampling formats (4:4:4/4:2:2/4:2:0) — use in hardware video pipelines. | Chroma Resampler | Vision HDL Toolbox |
| HDL-optimized gamma correction on a pixel stream — use for hardware tone/gamma adjustment. | Gamma Corrector | Vision HDL Toolbox |
| HDL-optimized per-pixel lookup table — use for hardware intensity remapping and point operations on a pixel stream. | Lookup Table | Vision HDL Toolbox |
| Informational block linking to Vision HDL Toolbox example models — not used in production designs. | Examples | Vision HDL Toolbox |
| HDL-optimized edge-preserving bilateral filter on a pixel stream — use for hardware noise reduction that keeps edges sharp. | Bilateral Filter | Vision HDL Toolbox |
| HDL-optimized median filter on a pixel stream — use for hardware impulse-noise (salt-and-pepper) removal that preserves edges. | Median Filter | Vision HDL Toolbox |
| HDL-optimized bird's-eye (inverse-perspective) transform on a pixel stream — use to generate a top-down view in hardware. | Birds-Eye View | Vision HDL Toolbox |
| HDL-optimized image resizer (scaling) on a pixel stream — use for hardware up/downscaling of video. | Image Resizer | Vision HDL Toolbox |
| HDL-optimized binary morphological closing on a pixel stream — use to fill small holes and gaps in hardware. | Closing | Vision HDL Toolbox |
| HDL-optimized binary morphological dilation on a pixel stream — use to grow foreground regions in hardware. | Dilation | Vision HDL Toolbox |
| HDL-optimized binary morphological erosion on a pixel stream — use to shrink foreground regions and remove speckle in hardware. | Erosion | Vision HDL Toolbox |
| HDL-optimized grayscale morphological closing on a pixel stream — use to remove small dark features while preserving intensity. | Grayscale Closing | Vision HDL Toolbox |
| HDL-optimized grayscale morphological dilation on a pixel stream — use to expand bright regions in hardware. | Grayscale Dilation | Vision HDL Toolbox |
| HDL-optimized image histogram on a pixel stream — use for hardware intensity-distribution analysis and equalization. | Histogram | Vision HDL Toolbox |
| HDL-optimized running image statistics (mean/variance) on a pixel stream — use for hardware exposure control and frame analysis. | Image Statistics | Vision HDL Toolbox |
| Creates a pixelcontrol bus. The block has 5 input ports: hStart - First pixel in a horizontal line of a frame hEnd - Last pixel in a horizontal line of a frame vStart - First pixel in the first (top) line of a frame vEnd - Last pixel in the last (bottom) line of a frame valid - Valid pixel indicator | Pixel Control Bus Creator | Vision HDL Toolbox |
| Buffer bursts of pixels into a contiguous stream | Pixel Stream FIFO | Vision HDL Toolbox |
| Track the horizontal and vertical pixel coordinates within a video frame — use to locate the current pixel in a hardware stream. | HV Counter | Vision HDL Toolbox |
| Measure the timing of a pixel-control stream (active/blanking region and frame size) — use to validate video timing in hardware. | Measure Timing | Vision HDL Toolbox |
| Align two pixel streams so their control signals coincide — use to synchronize streams before combining them in hardware. | Pixel Stream Aligner | Vision HDL Toolbox |

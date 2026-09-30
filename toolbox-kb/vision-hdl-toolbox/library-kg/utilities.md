---
type: Simulink Block Category
title: Utilities
description: Pixel-stream control, buffering, and timing helpers
tags: [utilities, line buffer, counter, control bus, aligner, roi, timing]
status: stable
source: custom_library
library_root: Vision HDL Toolbox
category_path: Utilities
block_count: 8
---

# Utilities

Use these blocks for utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| HV Counter | visionhdlutilities/HV Counter | R2023a+ | Track the horizontal and vertical pixel coordinates within a video frame — use to locate the current pixel in a hardware stream. |
| Line Buffer | visionhdlutilities/Line Buffer | R2023a+ | Buffer lines of a pixel stream to form pixel neighborhoods — use as the building block for hardware kernel/window operations. |
| Measure Timing | visionhdlutilities/Measure Timing | R2023a+ | Measure the timing of a pixel-control stream (active/blanking region and frame size) — use to validate video timing in hardware. |
| Pixel Control Bus Selector | visionhdlutilities/Pixel Control Bus Selector | R2023a+ | Select individual signals (hStart, vStart, valid, hEnd, vEnd) from the pixel-control bus — use to access streaming control flags. |
| Pixel Stream Aligner | visionhdlutilities/Pixel Stream Aligner | R2023a+ | Align two pixel streams so their control signals coincide — use to synchronize streams before combining them in hardware. |
| ROI Selector | visionhdlutilities/ROI Selector | R2023a+ | Extract one or more rectangular regions of interest from a pixel stream — use to process only part of a frame in hardware. |
| Pixel Control Bus Creator | visionhdlutilities/Pixel Control Bus Creator | R2023a+ | Creates a pixelcontrol bus. The block has 5 input ports: hStart - First pixel in a horizontal line of a frame hEnd - Last pixel in a horizontal line of a frame vStart - First pixel in the first (top) line of a frame vEnd - Last pixel in the last (bottom) line of a frame valid - Valid pixel indicator |
| Pixel Stream FIFO | visionhdlutilities/Pixel Stream FIFO | R2023a+ | Buffer bursts of pixels into a contiguous stream |

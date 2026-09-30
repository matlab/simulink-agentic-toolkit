---
type: Simulink Block Category
title: Comm filters
description: Pulse-shaping, DC removal, and filter libraries
tags: [comm filters, dc blocker, filter designs, multirate filters]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Comm filters
block_count: 9
---

# Comm filters

Use these blocks for comm filters.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DC Blocker | commfilt2/DC Blocker | R2023a+ | Remove the DC (zero-frequency) component of a signal with a high-pass filter — use to eliminate DC offset before demodulation. |
| Ideal Rectangular Pulse Filter | commfilt2/Ideal Rectangular Pulse Filter | R2023a+ | Upsample the input signal using ideal rectangular pulses. |
| Integrate and Dump | commfilt2/Integrate and Dump | R2023a+ | Integrate over the number of samples in the integration period and reset at the end of the integration. Offset samples are ignored during the first integration period. |
| Filter Designs Library Link | commfilt2/Filter Designs Library Link | R2023a+ | Link to the library of prebuilt communications filter designs — use to browse and insert standard comm filters. |
| Multirate Filters Library Link | commfilt2/Multirate Filters Library Link | R2023a+ | Link to the library of prebuilt multirate filter designs — use to browse and insert interpolation/decimation filters. |
| Raised Cosine Receive Filter | commfilt2/Raised Cosine Receive Filter | R2023a+ | Filter the input, and, if selected, downsample, using a normal or square root raised cosine FIR filter. |
| Raised Cosine Transmit Filter | commfilt2/Raised Cosine Transmit Filter | R2023a+ | Upsample and filter the input signal using a normal or square root raised cosine FIR filter. |
| Windowed Integrator | commfilt2/Windowed Integrator | R2023a+ | Integrate a discrete input signal over the sliding window of size equal to the integration period. |
| DC Blocker | commrfcorlib/DC Blocker | R2023a+ | Remove the DC (zero-frequency) component of a signal with a high-pass filter — use to eliminate DC offset before demodulation. |

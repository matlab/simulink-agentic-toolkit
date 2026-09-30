---
type: Simulink Block Category
title: Sources
description: Signal, noise, and network input sources
tags: [sources, constant, noise, nco, random, file reader, udp receive, multimedia, enable]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Sources
block_count: 12
---

# Sources

Use these blocks for sources.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| N-Sample Enable | dspswit3/N-Sample Enable | R2023a+ | Emit an enable that becomes true after N samples — use to trigger logic after a startup delay. |
| NCO | dspsigops/NCO | R2023a+ | Numerically controlled oscillator generating sine/cosine from a phase accumulator — use as a tunable carrier or tone source. |
| Binary File Reader | dspsrcs4/Binary File Reader | R2023a+ | Read samples from a raw binary file as a source — use to play back recorded data. |
| Chirp | dspsrcs4/Chirp | R2023a+ | Linear, Logarithmic, and Quadratic modes generate a swept-frequency cosine with instantaneous frequency values specified by the frequency and time parameters. The Swept cosine mode generates a swept-frequency cosine with a linear instantaneous output frequency that may differ from the one specified by the frequency and time parameters. |
| Colored Noise | dspsrcs4/Colored Noise | R2023a+ | Generate colored noise (pink, brown, …) with a specified spectral slope — use as a test stimulus. |
| Constant | dspsrcs4/Constant | R2023a+ | Output a constant value — use for fixed parameters, thresholds, or test inputs. |
| From Multimedia File | dspsrcs4/From Multimedia File | R2023a+ | Read audio and/or video from a media file as a source — use to feed recorded media into a processing chain. |
| N-Sample Enable | dspsrcs4/N-Sample Enable | R2023a+ | Emit an enable that becomes true after N samples — use to trigger logic after a startup delay. |
| NCO | dspsrcs4/NCO | R2023a+ | Numerically controlled oscillator generating sine/cosine from a phase accumulator — use as a tunable carrier or tone source. |
| Random Source | dspsrcs4/Random Source | R2023a+ | Generate random samples (uniform or Gaussian) with set statistics — use as a noise or test source. |
| Sine Wave | dspsrcs4/Sine Wave | R2023a+ | Output samples of a sinusoid. To generate more than one sinusoid simultaneously, enter a vector of values for the Amplitude, Frequency, and Phase offset parameters. |
| UDP Receive | dspsrcs4/UDP Receive | R2023a+ | Receive signal data over UDP from the network — use to stream data in from another application. |

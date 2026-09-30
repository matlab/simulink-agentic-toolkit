---
type: Simulink Block Category
title: Effects dynamics
description: Audio effects and dynamic range control
tags: [effect, dynamic range, reverb, compressor]
status: stable
source: custom_library
library_root: Audio Toolbox
category_path: Effects dynamics
block_count: 4
---

# Effects dynamics

Use these blocks for effects dynamics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Compressor | audiodynamicrange/Compressor | R2023a+ | Perform dynamic range compression independently across each input channel. |
| Expander | audiodynamicrange/Expander | R2023a+ | Perform dynamic range expansion independently across each input channel. |
| Limiter | audiodynamicrange/Limiter | R2023a+ | Perform limiting independently across each input channel. |
| Reverberator | audioeffects/Reverberator | R2023a+ | Add artificial reverberation to mono or stereo audio signal. The output is always a stereo signal. |

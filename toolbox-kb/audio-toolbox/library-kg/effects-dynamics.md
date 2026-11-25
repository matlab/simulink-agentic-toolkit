---
type: Simulink Block Category
title: Effects dynamics
description: Audio effects and dynamic range control (4 blocks)
tags: [toolbox-kb, audio-toolbox, effect, dynamic range, reverb, compressor]
status: draft
sources:
  - resource: matlab:audiodynamicrange
source: toolbox_kb
managed_by: satk
library: Audio Toolbox
kb_folder: audio-toolbox
category: effects-dynamics
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Effects dynamics

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Compressor | audiodynamicrange/Compressor | R2023a+ | Perform dynamic range compression independently across each input channel. |
| Expander | audiodynamicrange/Expander | R2023a+ | Perform dynamic range expansion independently across each input channel. |
| Limiter | audiodynamicrange/Limiter | R2023a+ | Perform limiting independently across each input channel. |
| Reverberator | audioeffects/Reverberator | R2023a+ | Add artificial reverberation to mono or stereo audio signal. The output is always a stereo signal. |

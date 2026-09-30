---
type: Simulink Block Category
title: Sources
description: Generate or read audio signals
tags: [source, oscillator, noise, from multimedia, wavetable]
status: stable
source: custom_library
library_root: Audio Toolbox
category_path: Sources
block_count: 7
---

# Sources

Use these blocks for sources.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Noise Gate | audiodynamicrange/Noise Gate | R2023a+ | Perform noise gating independently across each input channel. |
| Audio Device Reader | audiosources/Audio Device Reader | R2023a+ | Record audio stream from your computer's audio device. |
| Audio Oscillator | audiosources/Audio Oscillator | R2023a+ | Generate a tunable periodic waveform (sine/square/sawtooth) with adjustable frequency and amplitude — use as a real-time tone or test-signal source. |
| Colored Noise | audiosources/Colored Noise | R2023a+ | Generate colored noise (pink, brown, etc.) with a specified spectral slope — use as a test stimulus or dithering source. |
| From Multimedia File | audiosources/From Multimedia File | R2023a+ | Read audio (and optionally video) from a media file as a source — use to feed recorded audio into a processing chain. |
| MIDI Controls | audiosources/MIDI Controls | R2023a+ | Output values from controls on a MIDI control surface. Use a vector of control numbers to output values for multiple controls. Use the MATLAB midiid command to discover MIDI device names or MIDI device control numbers. |
| Wavetable Synthesizer | audiosources/Wavetable Synthesizer | R2023a+ | Synthesize audio by looping a stored wavetable at a controllable rate — use for efficient tone or instrument generation. |

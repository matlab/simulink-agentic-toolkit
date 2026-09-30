---
type: Simulink Block Category
title: Features
description: Extract audio features for analysis and machine learning
tags: [feature, cepstral, delta, mfcc]
status: stable
source: custom_library
library_root: Audio Toolbox
category_path: Features
block_count: 5
---

# Features

Use these blocks for features.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Audio Delta | audiofeatures/Audio Delta | R2023a+ | Compute delta and delta-delta coefficients (time derivatives of audio features) — use to add temporal dynamics to feature vectors for speech/audio ML. |
| Cepstral Coefficients | audiofeatures/Cepstral Coefficients | R2023a+ | Extract cepstral coefficients (MFCC/GTCC) from audio frames — use as compact spectral features for speech recognition and audio classification. |
| Auditory Spectrogram | audiofeatures/Auditory Spectrogram | R2023a+ | Extract mel, Bark, or ERB spectrogram from audio. |
| MFCC | audiofeatures/MFCC | R2023a+ | Extract mel-frequency cepstral coefficients from audio. |
| Mel Spectrogram | audiofeatures/Mel Spectrogram | R2023a+ | Extract mel spectrogram from audio. |

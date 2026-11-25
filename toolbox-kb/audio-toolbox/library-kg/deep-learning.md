---
type: Simulink Block Category
title: Deep learning
description: Neural-network audio processing blocks (13 blocks)
tags: [toolbox-kb, audio-toolbox, deep learning, crepe, vggish, yamnet]
status: draft
sources:
  - resource: matlab:audioai
source: toolbox_kb
managed_by: satk
library: Audio Toolbox
kb_folder: audio-toolbox
category: deep-learning
block_count: 13
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Deep learning

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| CREPE Postprocess | audioai/CREPE Postprocess | R2023a+ | Convert the raw output of the CREPE pitch network into a pitch (F0) estimate with confidence — use after CREPE inference to get usable pitch values. |
| CREPE | audioai/CREPE | R2023a+ | CREPE deep pitch estimation neural network. |
| CREPE Preprocess | audioai/CREPE Preprocess | R2023a+ | Preprocess audio for CREPE deep pitch estimation. |
| Deep Pitch Estimator | audioai/Deep Pitch Estimator | R2023a+ | Estimate pitch with CREPE deep learning neural network. |
| OpenL3 | audioai/OpenL3 | R2023a+ | OpenL3 embeddings extraction network. |
| OpenL3 Embeddings | audioai/OpenL3 Embeddings | R2023a+ | Extract OpenL3 embeddings. |
| OpenL3 Preprocess | audioai/OpenL3 Preprocess | R2023a+ | Preprocess audio for OpenL3 embeddings extraction. |
| Sound Classifier | audioai/Sound Classifier | R2023a+ | Classify sounds in input audio signal. |
| VGGish | audioai/VGGish | R2023a+ | VGGish embeddings extraction network. |
| VGGish Embeddings | audioai/VGGish Embeddings | R2023a+ | Extract VGGish embeddings. |
| VGGish Preprocess | audioai/VGGish Preprocess | R2023a+ | Preprocess audio for VGGish embeddings extraction. |
| YAMNet | audioai/YAMNet | R2023a+ | YAMNet sound classification network. |
| YAMNet Preprocess | audioai/YAMNet Preprocess | R2023a+ | Preprocess audio for YAMNet classifier. |

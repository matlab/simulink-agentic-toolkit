---
type: Simulink Block Category
title: Audio
description: Blocks for Audio (2 blocks)
tags: [toolbox-kb, simulink-coder-support-package-for-bbc-micro-bit]
status: draft
sources:
  - resource: matlab:microbitaudiolib
source: toolbox_kb
managed_by: satk
library: Simulink Coder Support Package for BBC micro:bit
kb_folder: simulink-coder-support-package-for-bbc-micro-bit
category: audio
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:30Z" }
---

# Audio

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Note Generator | microbitaudiolib/Note Generator | R2023a+ | Generates a musical note at specified scale. The scale can be selected as 'High' 'Mid' or 'Low' and the Note can be selected from A to G#. The block outputs the frequency of the particular note chosen. |
| Play Note | microbitaudiolib/Play Note | R2023a+ | Plays a musical note or a variable frequecy signal on the specified pin. Use the Pin parameter to select the pin on which the sound needs to be produced. Connect a speaker on the specified pin to hear the audio. The block accepts frequency as the input. A Note Generator block can be connected to this block to generate various notes. |

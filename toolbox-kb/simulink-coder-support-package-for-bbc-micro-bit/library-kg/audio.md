---
type: Simulink Block Category
title: Audio
description: Blocks for audio.
status: draft
source: custom_library
library_root: Simulink Coder Support Package for BBC micro:bit
category_path: Audio
block_count: 2
---

# Audio

Use these blocks for audio.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Note Generator | microbitaudiolib/Note Generator | R2023a+ | Generates a musical note at specified scale. The scale can be selected as 'High' 'Mid' or 'Low' and the Note can be selected from A to G#. The block outputs the frequency of the particular note chosen. |
| Play Note | microbitaudiolib/Play Note | R2023a+ | Plays a musical note or a variable frequecy signal on the specified pin. Use the Pin parameter to select the pin on which the sound needs to be produced. Connect a speaker on the specified pin to hear the audio. The block accepts frequency as the input. A Note Generator block can be connected to this block to generate various notes. |

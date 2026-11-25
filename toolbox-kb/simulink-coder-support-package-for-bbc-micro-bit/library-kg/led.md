---
type: Simulink Block Category
title: Led
description: "5x5 LED matrix output (17 blocks)"
tags: [toolbox-kb, simulink-coder-support-package-for-bbc-micro-bit, led matrix, led]
status: draft
sources:
  - resource: matlab:microbitledlib
source: toolbox_kb
managed_by: satk
library: Simulink Coder Support Package for BBC micro:bit
kb_folder: simulink-coder-support-package-for-bbc-micro-bit
category: led
block_count: 17
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:30Z" }
---

# Led

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 5x5 LED Matrix | microbitledlib/5x5 LED Matrix | R2023a+ | Outputs a 5x5 LED image on the Micro:bit board based on the 5x5 matrix specified at the input port. |
| Scroll down | microbitledlib/Image scrolling/Scroll down | R2023a+ | Take an input of min 5x5 matrix, shift it by one down every timestep and output a 5x5 matrix. |
| Scroll left | microbitledlib/Image scrolling/Scroll left | R2023a+ | Take an input of min 5x5 matrix, shift it by one to the left every timestep and output a 5x5 matrix. |
| Scroll right  | microbitledlib/Image scrolling/Scroll right  | R2023a+ | Take an input of min 5x5 matrix, shift it by one to the right every timestep and output a 5x5 matrix. |
| Scroll up | microbitledlib/Image scrolling/Scroll up | R2023a+ | Take an input of min 5x5 matrix, shift it by one up every timestep and output a 5x5 matrix. |
| Blink | microbitledlib/LED Brightness Effect/Blink | R2023a+ | Output brightness (int) that alternate between zero brightness (0) and maximum brightness (10). |
| Fade in | microbitledlib/LED Brightness Effect/Fade in | R2023a+ | Output a repeated sequence of brightness that goes from minimum brightness (0) to maximum brightness (10). |
| Fade out | microbitledlib/LED Brightness Effect/Fade out | R2023a+ | Output a repeated brightness that starts from maximum brightness (10) down to zero brightness (0). |
| Flicker | microbitledlib/LED Brightness Effect/Flicker | R2023a+ | Output brightness (int) that changes randomly according to the step size parameter. |
| Pulse | microbitledlib/LED Brightness Effect/Pulse | R2023a+ | Output brightness (int) that repeatedly fades in and then fades out. |
| Four on Dice | microbitledlib/LED Images/Four on Dice | R2023a+ | Output a 5x5 Matrix |
| One on Dice | microbitledlib/LED Images/One on Dice | R2023a+ | Output a 5x5 Matrix |
| Three on Dice | microbitledlib/LED Images/Three on Dice | R2023a+ | Output a 5x5 Matrix |
| Two on Dice | microbitledlib/LED Images/Two on Dice | R2023a+ | Output a 5x5 Matrix |
| LED Matrix output | microbitledlib/LED Matrix output | R2023a+ | Drive the full 5×5 LED display from a matrix input — use to show custom patterns or animations. |
| LED Text Scroll | microbitledlib/LED Text Scroll | R2023a+ | Scroll the input text on the 5x5 LED matrix. The Scroll speed represents the speed at which the characters move on the display. The slowest speed is 1 and the fastest is 10. The block accepts characters from A to Z, numbers from 0 to 9, and spaces in the input. If any other character is specified in the input, a minus sign is displayed. |
| Text Message | microbitledlib/Text Message | R2023a+ | Outputs the string specified by the Message parameter. |

---
type: Simulink Block Category
title: Model verification
description: Assertion blocks for linear analysis requirements (6 blocks)
tags: [toolbox-kb, simulink-control-design, check, assert, margin, characteristics, verify]
status: stable
sources:
  - resource: matlab:slctrlblks
source: toolbox_kb
managed_by: satk
library: Simulink Control Design
kb_folder: simulink-control-design
category: model-verification
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:30Z" }
---

# Model verification

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Check Bode  Characteristics | slctrlblks/Model Verification/Check Bode  Characteristics | R2023a+ | Assert Bode characteristics meet requirements — use for verification that frequency response stays within bounds |
| Check Gain and Phase Margins | slctrlblks/Model Verification/Check Gain and Phase Margins | R2023a+ | Assert stability margins meet requirements — use for verification that gain and phase margins exceed thresholds |
| Check Linear Step Response Characteristics | slctrlblks/Model Verification/Check Linear Step Response Characteristics | R2023a+ | Assert step response meets requirements — use for verification of rise time, overshoot, and settling specs |
| Check Nichols Characteristics | slctrlblks/Model Verification/Check Nichols Characteristics | R2023a+ | Assert Nichols chart meets requirements — use for verification that open-loop response avoids exclusion regions |
| Check Pole-Zero Characteristics | slctrlblks/Model Verification/Check Pole-Zero Characteristics | R2023a+ | Assert pole-zero locations meet requirements — use for verification that poles stay in a specified region |
| Check Singular Value Characteristics | slctrlblks/Model Verification/Check Singular Value Characteristics | R2023a+ | Assert singular values meet requirements — use for verification that MIMO gain bounds are satisfied |

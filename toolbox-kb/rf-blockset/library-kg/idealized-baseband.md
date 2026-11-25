---
type: Simulink Block Category
title: Idealized baseband
description: "System-level idealized baseband RF blocks with gain, noise, and nonlinearity (10 blocks)"
tags: [toolbox-kb, rf-blockset, idealized baseband]
status: draft
sources:
  - resource: matlab:simrfV2elements
source: toolbox_kb
managed_by: satk
library: RF Blockset
kb_folder: rf-blockset
category: idealized-baseband
block_count: 10
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Idealized baseband

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Amplifier | simrfV2elements/Amplifier | R2023a+ | Idealized baseband amplifier with gain, noise figure, and nonlinearity — use for system-level RF gain stages without full circuit detail. |
| Filter | simrfV2elements/Filter | R2023a+ | Idealized baseband filter (lowpass, highpass, bandpass) — use to shape the spectrum of a baseband RF signal at system level. |
| Mixer | simrfV2elements/Mixer | R2023a+ | Idealized baseband mixer that frequency-translates a signal — use to model up- or down-conversion in an RF chain. |
| Power Amplifier | simrfV2elements/Power Amplifier | R2023a+ | Idealized baseband power amplifier with nonlinearity and memory effects — use to model PA distortion (AM/AM, AM/PM) at system level. |
| Amplifier | rfmathmodels2/Amplifier | R2023a+ | Idealized baseband amplifier with gain, noise figure, and nonlinearity — use for system-level RF gain stages without full circuit detail. |
| Filter | rfmathmodels2/Filter | R2023a+ | Idealized baseband filter (lowpass, highpass, bandpass) — use to shape the spectrum of a baseband RF signal at system level. |
| Mixer | rfmathmodels2/Mixer | R2023a+ | Idealized baseband mixer that frequency-translates a signal — use to model up- or down-conversion in an RF chain. |
| Power Amplifier | rfmathmodels2/Power Amplifier | R2023a+ | Idealized baseband power amplifier with nonlinearity and memory effects — use to model PA distortion (AM/AM, AM/PM) at system level. |
| Sparameters | rfmathmodels2/Sparameters | R2023a+ | Model a component from its S-parameter data in idealized baseband — use to insert measured or simulated frequency-domain behavior into an RF chain. |
| RF Budget | rfmathmodels2/RF Budget | R2025a+ | Compute RF budget results for A chain of 2-port elements. |

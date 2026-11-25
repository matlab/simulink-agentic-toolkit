---
type: Simulink Block Category
title: Localization
description: "Position estimation from TOA, TDOA, and bistatic measurements (7 blocks)"
tags: [toolbox-kb, phased-array-system-toolbox, localization, TOA, TDOA, position, bistatic, emitter]
status: stable
sources:
  - resource: matlab:phasedloclib
source: toolbox_kb
managed_by: satk
library: Phased Array System Toolbox
kb_folder: phased-array-system-toolbox
category: localization
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Localization

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bistatic Position Estimator | phasedloclib/Bistatic Position Estimator | R2025a+ | Estimate target position from bistatic range measurements using multiple transmitter-receiver pairs |
| Range-Angle Position Estimator | phasedloclib/Range-Angle Position Estimator | R2025a+ | Estimate target position from joint range and angle measurements |
| TDOA Estimator | phasedloclib/TDOA Estimator | R2024b+ | Estimate time difference of arrival between sensor pairs from received signals |
| TDOA Position Estimator | phasedloclib/TDOA Position Estimator | R2024b+ | Estimate emitter position from time difference of arrival measurements at multiple sensors |
| TOA Estimator | phasedloclib/TOA Estimator | R2024a+ | Estimate time of arrival of a signal at each sensor |
| TOA Position Estimator | phasedloclib/TOA Position Estimator | R2024b+ | Estimate emitter position from time of arrival measurements at multiple sensors |
| TSOA Position Estimator | phasedloclib/TSOA Position Estimator | R2025a+ | Estimate emitter position from time sum of arrival measurements in a bistatic configuration |

---
type: Simulink Block Category
title: Mathematical transforms
description: Clarke, Park, and sequence transforms for AC machine and power system control
tags: [clarke, park, transform, dq, sequence]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Mathematical transforms
block_count: 14
---

# Mathematical transforms

Use these blocks for mathematical transforms.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Clarke Transform | ee_sl_lib/Mathematical Transforms/Clarke Transform | R2023a+ | Transform three-phase abc quantities to stationary alpha-beta frame — use as the first stage in field-oriented control or space vector modulation |
| Clarke to Park Angle Transform | ee_sl_lib/Mathematical Transforms/Clarke to Park Angle Transform | R2023a+ | Compute the angle transformation from Clarke to Park frame — use for deriving rotor position from alpha-beta quantities in sensorless control |
| Coordinate Transform (Five-Phase) | ee_sl_lib/Mathematical Transforms/Coordinate Transform (Five-Phase) | R2023a+ | Transform five-phase quantities to orthogonal rotating frames — use for control of five-phase machines with decoupled d-q and harmonic subspaces |
| Decoupled Transform (Six-Phase, Dual-Star) | ee_sl_lib/Mathematical Transforms/Decoupled Transform (Six-Phase, Dual-Star) | R2023a+ | Transform dual-star six-phase quantities to decoupled subspaces — use for independent control of dual three-phase winding sets |
| Decoupled Transform (Six-Phase, Symmetrical) | ee_sl_lib/Mathematical Transforms/Decoupled Transform (Six-Phase, Symmetrical) | R2023a+ | Transform symmetrical six-phase quantities to decoupled orthogonal subspaces — use for control of six-phase machines with 60-degree displacement |
| Inverse Clarke Transform | ee_sl_lib/Mathematical Transforms/Inverse Clarke Transform | R2023a+ | Transform stationary alpha-beta quantities back to three-phase abc — use to generate phase voltage references from alpha-beta controller outputs |
| Inverse Park Transform | ee_sl_lib/Mathematical Transforms/Inverse Park Transform | R2023a+ | Transform rotating dq quantities back to stationary alpha-beta frame — use to convert controller outputs to stationary frame for modulation |
| Inverse Coordinate Transform (Five-Phase) | ee_sl_lib/Mathematical Transforms/Inverse Coordinate Transform (Five-Phase) | R2023a+ | Transform orthogonal frames back to five-phase quantities — use to generate phase references for five-phase machine drives |
| Inverse Decoupled Transform (Six-Phase, Dual-Star) | ee_sl_lib/Mathematical Transforms/Inverse Decoupled Transform (Six-Phase, Dual-Star) | R2023a+ | Transform decoupled subspaces back to dual-star six-phase quantities — use to generate voltage references for dual three-phase inverters |
| Inverse Decoupled Transform  (Six-Phase, Symmetrical) | ee_sl_lib/Mathematical Transforms/Inverse Decoupled Transform  (Six-Phase, Symmetrical) | R2023a+ | Transform decoupled subspaces back to symmetrical six-phase quantities — use to generate phase references for six-phase drives |
| Inverse Symmetrical-Components Transform | ee_sl_lib/Mathematical Transforms/Inverse Symmetrical-Components Transform | R2023a+ | Convert sequence components back to three-phase abc quantities — use for unbalance compensation or injecting specific sequence currents |
| Park Transform | ee_sl_lib/Mathematical Transforms/Park Transform | R2023a+ | Transform stationary alpha-beta quantities to synchronously rotating dq frame — use for decoupled torque and flux control in AC machine drives |
| Park to Clarke Angle Transform | ee_sl_lib/Mathematical Transforms/Park to Clarke Angle Transform | R2023a+ | Compute the angle relationship between Park and Clarke frames — use for coordinate system conversions in sensorless or encoder-based control |
| Symmetrical-Components Transform | ee_sl_lib/Mathematical Transforms/Symmetrical-Components Transform | R2023a+ | Decompose three-phase quantities into positive, negative, and zero sequence components — use for fault analysis, unbalance detection, or sequence-based protection |

---
type: Simulink Block Category
title: Control references
description: Torque/current/speed reference generators and feed-forward blocks that produce commands for FOC and vector control loops
tags: [reference, control reference, feed forward, MTPA, torque estimator, commutation]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Control references
block_count: 17
---

# Control references

Use these blocks for control references.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ACIM Control Reference | mcblib/Controls/Control Reference/ACIM Control Reference | R2023a+ | Compute id/iq current references for an induction motor from a torque or speed command — use as the outer setpoint block inside an ACIM field-oriented control loop |
| ACIM Feed Forward Control | mcblib/Controls/Control Reference/ACIM Feed Forward Control | R2023a+ | Add decoupling voltage feed-forward terms for an induction motor FOC loop — use to cancel cross-coupling between d and q axes and improve current-loop bandwidth |
| ACIM Slip Speed Estimator | mcblib/Controls/Control Reference/ACIM Slip Speed Estimator | R2023a+ | Estimate rotor slip frequency from stator current references and rotor time constant — use in indirect field-oriented control of induction motors to orient the reference frame |
| ACIM Torque Estimator | mcblib/Controls/Control Reference/ACIM Torque Estimator | R2023a+ | Estimate electromagnetic torque of an induction motor from d/q currents and magnetizing inductance — use for torque monitoring, feedback, or diagnostics without a torque sensor |
| DQ Limiter | mcblib/Controls/Control Reference/DQ Limiter | R2023a+ | Saturate d and q current or voltage vectors while preserving their angle — use to enforce inverter voltage limits or maximum current envelopes without distorting the commanded direction |
| LUT based ACIM Control Reference | mcblib/Controls/Control Reference/LUT based ACIM Control Reference | R2026a+ | Look up id/iq current references for an induction motor from precomputed tables indexed by torque and speed — use when torque linearity across the operating envelope matters more than analytical simplicity |
| LUT based PMSM Control Reference | mcblib/Controls/Control Reference/LUT based PMSM Control Reference | R2023a+ | Look up id/iq current references for a PMSM from precomputed torque/speed tables — use for MTPA and field-weakening operation of interior PMSMs where closed-form solutions are inaccurate |
| LUT based SynRM Control Reference | mcblib/Controls/Control Reference/LUT based SynRM Control Reference | R2024a+ | Look up id/iq current references for a synchronous reluctance motor from precomputed tables — use to achieve optimal torque-per-ampere operation across the full SynRM operating map |
| MTPA Control Reference | mcblib/Controls/Control Reference/MTPA Control Reference | R2023a+ | Compute maximum torque per ampere (MTPA) d/q current references analytically from motor parameters — use for interior PMSMs to minimize copper losses at a given torque command |
| PMSM FeedForward Control | mcblib/Controls/Control Reference/PMSM FeedForward Control | R2023a+ | Add decoupling voltage feed-forward terms for PMSM FOC — use to cancel back-EMF and cross-axis coupling and improve current-loop transient response |
| PMSM Torque Estimator | mcblib/Controls/Control Reference/PMSM Torque Estimator | R2023a+ | Estimate PMSM electromagnetic torque from measured d/q currents and machine parameters — use for torque feedback, monitoring, or verification without a torque sensor |
| Position Generator | mcblib/Controls/Control Reference/Position Generator | R2023a+ | Generate a synthetic electrical position ramp from a speed reference — use for open-loop rotor position during I-F startup or when a real sensor is unavailable |
| SRM Commutation | mcblib/Controls/Control Reference/SRM Commutation | R2023a+ | Sequence phase excitation for a switched reluctance motor based on rotor position — use as the electrical commutation logic for SRM drives |
| Six Step Commutation | mcblib/Controls/Control Reference/Six Step Commutation | R2023a+ | Drive a BLDC motor in six-step (trapezoidal) commutation based on Hall sensor states — use for simple, robust BLDC control without full field-oriented control |
| SynRM FeedForward Control | mcblib/Controls/Control Reference/SynRM FeedForward Control | R2024a+ | Add voltage feed-forward decoupling for a synchronous reluctance motor FOC loop — use to compensate cross-axis coupling and improve dynamic response |
| SynRM Torque Estimator | mcblib/Controls/Control Reference/SynRM Torque Estimator | R2024a+ | Estimate synchronous reluctance motor torque from d/q currents and saturated inductance data — use for torque feedback or monitoring in SynRM drives |
| Vector Control Reference | mcblib/Controls/Control Reference/Vector Control Reference | R2023a+ | Generate d/q current references for a generic three-phase vector-controlled machine — use as the outer-loop reference block when detailed motor-type-specific logic is not required |

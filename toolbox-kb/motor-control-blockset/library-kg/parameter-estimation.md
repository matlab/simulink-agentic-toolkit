---
type: Simulink Block Category
title: Parameter estimation
description: Blocks that identify motor electrical and mechanical parameters (Rs, Ld, Lq, Rr, inertia, friction) from measured data
tags: [estimator, parameter identification, Rs, Ld, Lq, inertia, commissioning]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Parameter estimation
block_count: 10
---

# Parameter estimation

Use these blocks for parameter estimation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Id0 Estimator | mcblib/Parameter Estimation/ACIM Parameter Estimation/Id0 Estimator | R2023a+ | Identify the zero-current bias of the d-axis in an induction motor during commissioning — use as one step of the ACIM parameter identification workflow |
| Mechanical Parameter Estimator | mcblib/Parameter Estimation/ACIM Parameter Estimation/Mechanical Parameter Estimator | R2023a+ | Identify motor inertia and viscous friction from a spin-down or acceleration test — use to obtain mechanical plant parameters for speed-loop tuning |
| Parameter Estimation Configurator | mcblib/Parameter Estimation/ACIM Parameter Estimation/Parameter Estimation Configurator | R2023a+ | Sequence and configure the motor parameter identification tests (signal injection, dwell times, ramps) — use as the top-level orchestrator of the commissioning workflow |
| Rr L Estimator | mcblib/Parameter Estimation/ACIM Parameter Estimation/Rr L Estimator | R2023a+ | Estimate the rotor resistance and rotor inductance of an induction motor from injected test signals — use during ACIM commissioning to obtain rotor-side equivalent-circuit values |
| Rs Estimator | mcblib/Parameter Estimation/ACIM Parameter Estimation/Rs Estimator | R2023a+ | Estimate stator resistance by injecting a DC current and measuring the resulting voltage — use during commissioning of PMSM, induction, or SynRM drives |
| Ld Estimator | mcblib/Parameter Estimation/PMSM Parameter Estimation/Ld Estimator | R2023a+ | Estimate the d-axis inductance of a PMSM from high-frequency current injection — use during commissioning to obtain the inductance needed for accurate current-loop tuning and MTPA lookups |
| Lq Estimator | mcblib/Parameter Estimation/PMSM Parameter Estimation/Lq Estimator | R2023a+ | Estimate the q-axis inductance of a PMSM from high-frequency current injection — use during commissioning to characterize saliency and populate MTPA tables |
| Mechanical Parameter Estimator | mcblib/Parameter Estimation/PMSM Parameter Estimation/Mechanical Parameter Estimator | R2023a+ | Identify motor inertia and viscous friction from a spin-down or acceleration test — use to obtain mechanical plant parameters for speed-loop tuning |
| Parameter Estimation Configurator | mcblib/Parameter Estimation/PMSM Parameter Estimation/Parameter Estimation Configurator | R2023a+ | Sequence and configure the motor parameter identification tests (signal injection, dwell times, ramps) — use as the top-level orchestrator of the commissioning workflow |
| Rs Estimator | mcblib/Parameter Estimation/PMSM Parameter Estimation/Rs Estimator | R2023a+ | Estimate stator resistance by injecting a DC current and measuring the resulting voltage — use during commissioning of PMSM, induction, or SynRM drives |

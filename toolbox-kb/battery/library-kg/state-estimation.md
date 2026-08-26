---
type: Simulink Block Category
title: State estimation
description: State of charge, energy, health, and capacity estimation algorithms
tags: [soc, soe, soh, estimator, kalman]
status: stable
source: mathworks_toolbox
library_root: Battery
category_path: State estimation
block_count: 22
---

# State estimation

Use these blocks for state estimation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Battery Capacity Estimator (Kalman Filter) | batt_sl_lib/Estimators/Battery Capacity Estimator (Kalman Filter) | R2023a+ | Estimate total battery capacity online using a Kalman filter — use to track capacity fade over the battery lifetime for accurate SOC scaling and end-of-life prediction |
| Battery Capacity Estimator (Least Squares) | batt_sl_lib/Estimators/Battery Capacity Estimator (Least Squares) | R2023a+ | Estimate total battery capacity online using recursive least squares — use when a computationally lighter alternative to Kalman filtering is needed for capacity tracking |
| Battery Capacity Estimator (Least Squares, Variable Weights) | batt_sl_lib/Estimators/Battery Capacity Estimator (Least Squares, Variable Weights) | R2023a+ | Estimate battery capacity using weighted recursive least squares — use when measurement quality varies and recent data should be weighted more heavily for faster adaptation |
| Battery Power Estimator | batt_sl_lib/Estimators/Battery Power Estimator | R2024b+ | Estimate the maximum available charge and discharge power over a prediction horizon — use for power management in hybrid/electric powertrains to enforce safe operating limits on motor torque requests |
| Cell Delta SOC Estimator (Kalman Filter) | batt_sl_lib/Estimators/Cell Delta SOC Estimator (Kalman Filter) | R2023a+ | Estimate SOC differences between individual cells using a Kalman filter — use to monitor cell imbalance in a pack and trigger balancing when delta SOC exceeds thresholds |
| Cell Delta SOC Estimator (Kalman Filter, Variable Resistance) | batt_sl_lib/Estimators/Cell Delta SOC Estimator (Kalman Filter, Variable Resistance) | R2023a+ | Estimate cell SOC differences with online resistance adaptation — use when cell aging causes resistance divergence that biases fixed-model delta SOC estimates |
| Pack Bar SOC Estimator (Adaptive Kalman Filter) | batt_sl_lib/Estimators/Pack Bar SOC Estimator (Adaptive Kalman Filter) | R2023a+ | Estimate average pack-level SOC using an adaptive Kalman filter that tunes noise covariances online — use for robust pack SOC display that adapts to changing sensor noise or model uncertainty |
| Pack Bar SOC Estimator (Kalman Filter) | batt_sl_lib/Estimators/Pack Bar SOC Estimator (Kalman Filter) | R2023a+ | Estimate average pack-level SOC using a standard Kalman filter — use as the primary gauge algorithm for displaying remaining energy in a battery pack |
| SOC Estimator (Adaptive Kalman Filter) | batt_sl_lib/Estimators/SOC Estimator (Adaptive Kalman Filter) | R2023a+ | Estimate cell-level state of charge using an adaptive Kalman filter — use when operating conditions change significantly and fixed filter tuning produces drift |
| SOC Estimator (Adaptive Kalman Filter, Variable Capacity) | batt_sl_lib/Estimators/SOC Estimator (Adaptive Kalman Filter, Variable Capacity) | R2023a+ | Estimate SOC with adaptive Kalman filtering and online capacity tracking — use for aged batteries where nominal capacity no longer reflects actual usable energy |
| SOC Estimator (Coulomb Counting) | batt_sl_lib/Estimators/SOC Estimator (Coulomb Counting) | R2023a+ | Estimate SOC by integrating measured current over time — use as a simple baseline estimator or as a complement to model-based methods for short-term SOC tracking |
| SOC Estimator (Coulomb Counting, Variable Capacity) | batt_sl_lib/Estimators/SOC Estimator (Coulomb Counting, Variable Capacity) | R2023a+ | Estimate SOC via coulomb counting with time-varying capacity — use when capacity fade is significant and a fixed Ah reference would cause cumulative SOC error |
| SOC Estimator (Kalman Filter) | batt_sl_lib/Estimators/SOC Estimator (Kalman Filter) | R2023a+ | Estimate cell-level state of charge using an extended Kalman filter with an equivalent circuit model — use as the standard model-based SOC estimation algorithm for BMS applications |
| SOC Estimator (Kalman Filter, Variable Capacity) | batt_sl_lib/Estimators/SOC Estimator (Kalman Filter, Variable Capacity) | R2023a+ | Estimate SOC using a Kalman filter with online capacity parameter — use to maintain accurate SOC estimates as the battery ages and total capacity decreases |
| SOE Estimator (Adaptive Kalman Filter) | batt_sl_lib/Estimators/SOE Estimator (Adaptive Kalman Filter) | R2023a+ | Estimate state of energy using an adaptive Kalman filter — use when energy-based range prediction is needed and operating conditions vary widely |
| SOE Estimator (Energy Counting) | batt_sl_lib/Estimators/SOE Estimator (Energy Counting) | R2023a+ | Estimate state of energy by integrating power over time — use as a simple energy accounting method for applications where voltage variation is small |
| SOE Estimator (Kalman Filter) | batt_sl_lib/Estimators/SOE Estimator (Kalman Filter) | R2023a+ | Estimate state of energy using a Kalman filter — use for model-based remaining energy prediction that accounts for voltage-dependent available energy |
| SOE Estimator (Adaptive Kalman Filter, Variable Energy Capacity) | batt_sl_lib/Estimators/SOE Estimator (Adaptive Kalman Filter, Variable Energy Capacity) | R2023a+ | Estimate SOE with adaptive filtering and online energy capacity tracking — use for aged packs where total energy capacity has degraded from nominal |
| SOE Estimator (Energy Counting, Variable Energy Capacity) | batt_sl_lib/Estimators/SOE Estimator (Energy Counting, Variable Energy Capacity) | R2023a+ | Estimate SOE via energy integration with time-varying energy capacity — use when simple energy counting is sufficient but capacity fade must be accounted for |
| SOE Estimator (Kalman Filter, Variable Energy Capacity) | batt_sl_lib/Estimators/SOE Estimator (Kalman Filter, Variable Energy Capacity) | R2023a+ | Estimate SOE using a Kalman filter with online energy capacity tracking — use for accurate remaining range estimation in aged batteries |
| SOH Estimator | batt_sl_lib/Estimators/SOH Estimator | R2023a+ | Estimate state of health based on internal resistance growth — use to track battery degradation over lifetime and predict maintenance or replacement timing |
| SOH Estimator (Capacity-Based) | batt_sl_lib/Estimators/SOH Estimator (Capacity-Based) | R2023b+ | Estimate state of health based on capacity fade relative to nominal — use to quantify usable capacity loss for warranty tracking or second-life battery grading |

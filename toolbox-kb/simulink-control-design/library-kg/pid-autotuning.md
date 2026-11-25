---
type: Simulink Block Category
title: Pid autotuning
description: Online PID tuning and gain scheduling (7 blocks)
tags: [toolbox-kb, simulink-control-design, pid, autotuner, gain-schedule, vrft, tuning]
status: stable
sources:
  - resource: matlab:slctrl_autotuning
source: toolbox_kb
managed_by: satk
library: Simulink Control Design
kb_folder: simulink-control-design
category: pid-autotuning
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:30Z" }
---

# Pid autotuning

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Change Operating Points | slctrl_autotuning/Change Operating Points | R2023b+ | Switch between operating points during autotuning — use for scheduling gain tuning at multiple equilibria |
| Closed-Loop PID Autotuner | slctrl_autotuning/Closed-Loop PID Autotuner | R2023b+ | Tune PID gains online without opening the loop — use for safe in-service PID tuning with minimal process disruption |
| Gain-Scheduled PID Autotuner | slctrl_autotuning/Gain-Scheduled PID Autotuner | R2024a+ | Tune PID gains at multiple operating points automatically — use for building gain schedules from online experiments |
| Open-Loop PID Autotuner | slctrl_autotuning/Open-Loop PID Autotuner | R2023b+ | Tune PID gains using an open-loop experiment — use for accurate frequency-response-based PID tuning when the loop can be opened |
| PID Gain Scheduler | slctrl_autotuning/PID Gain Scheduler | R2023b+ | Interpolate PID gains across operating conditions — use for implementing gain-scheduled PID controllers from stored gain tables |
| PID Gains Store and Update | slctrl_autotuning/PID Gains Store and Update | R2023b+ | Store and apply tuned PID gains — use for saving autotuner results and deploying them to the controller |
| Virtual Reference Feedback Tuning | slctrl_autotuning/Virtual Reference Feedback Tuning | R2025a+ | Tune controller from closed-loop data without plant identification — use for data-driven controller design from routine operation data |

---
type: Simulink Block Category
title: Arm cortex a
description: Deployment blocks for ARM Cortex-A application processors running Linux or VxWorks
tags: [arm, cortex-a, linux, vxworks, task]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder Support Package for ARM Cortex-A Processors
category_path: Arm cortex a
block_count: 4
---

# Arm cortex a

Use these blocks for arm cortex a.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Linux Task | arm_cortex_a_lib/Linux Task | R2023a+ | Execute a subsystem as a Linux process task on an ARM Cortex-A processor — use to deploy algorithms as real-time Linux tasks on application processors |
| VxWorks Task | arm_cortex_a_lib/VxWorks Task | R2023a+ | Execute a subsystem as a VxWorks task on an ARM Cortex-A processor — use when deploying to Cortex-A boards running VxWorks RTOS |
| UDP Receive | arm_cortex_a_lib/UDP Receive | R2023a+ | Receive UDP datagrams on the ARM Cortex-A target — use for host-target communication over Ethernet during deployment |
| UDP Send | arm_cortex_a_lib/UDP Send | R2023a+ | Send UDP datagrams from the ARM Cortex-A target — use for telemetry or parameter exchange with a host PC |

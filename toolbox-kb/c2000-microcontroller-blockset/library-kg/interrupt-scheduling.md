---
type: Simulink Block Category
title: Interrupt scheduling
description: Hardware and software interrupt configuration, task scheduling, and event routing
tags: [interrupt, isr, task, event, trigger]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Interrupt scheduling
block_count: 30
---

# Interrupt scheduling

Use these blocks for interrupt scheduling.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Software Interrupt Trigger | c2802xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2803xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2805xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2806xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c280xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c281xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2833xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2834xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c280013xlib/Software Interrupt Trigger | R2023b+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c280015xlib/Software Interrupt Trigger | R2023b+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c28002xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c28003xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c28004xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2807xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2837xDlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2837xSlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c2838xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Hardware Interrupt | c2838x_M4_lib/Hardware Interrupt | R2023a+ | Configure a hardware interrupt service routine on the target processor — use to execute high-priority code triggered by peripheral events or external signals |
| Software Interrupt Trigger | f28M35x_C28x_lib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Hardware Interrupt | f28M35x_M3_lib/Hardware Interrupt | R2023a+ | Configure a hardware interrupt service routine on the target processor — use to execute high-priority code triggered by peripheral events or external signals |
| Software Interrupt Trigger | f28M36x_C28x_lib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Hardware Interrupt | f28M36x_M3_lib/Hardware Interrupt | R2023a+ | Configure a hardware interrupt service routine on the target processor — use to execute high-priority code triggered by peripheral events or external signals |
| Software Interrupt Trigger | c28P55xlib/Software Interrupt Trigger | R2024b+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Software Interrupt Trigger | c28P65xlib/Software Interrupt Trigger | R2024a+ | Trigger a software interrupt to preempt lower-priority tasks — use to implement priority-based scheduling where a high-priority computation must run immediately |
| Hardware Interrupt | c29H85xlib/Hardware Interrupt | R2025a+ | Configure a hardware interrupt service routine on the target processor — use to execute high-priority code triggered by peripheral events or external signals |
| C28x Hardware Interrupt | c2000lib/Scheduling/C28x Hardware Interrupt | R2023a+ | Configure a hardware interrupt service routine triggered by a peripheral event — use to run time-critical code in response to ADC completion, ePWM events, or external pin interrupts |
| Event Source | c2000lib/Scheduling/Event Source | R2024a+ | Select a hardware event (ePWM, ADC EOC, timer) as an interrupt trigger source — use to link peripheral completion events to interrupt service routines |
| Hardware Interrupt | c2000lib/Scheduling/Hardware Interrupt | R2023a+ | Configure a hardware interrupt service routine on the target processor — use to execute high-priority code triggered by peripheral events or external signals |
| Idle Task | c2000lib/Scheduling/Idle Task | R2023a+ | Define code that executes in the idle (background) loop when no interrupts are active — use for low-priority housekeeping, communication polling, or diagnostic routines |
| Task Manager | c2000lib/Scheduling/Task Manager | R2023a+ | Configure multi-rate task scheduling with priority assignment — use to manage multiple control loops running at different rates on the same C2000 processor |

---
type: Simulink Block Category
title: Scheduling
description: Interrupts, tasks, watchdog, and scheduling
tags: [interrupt, task, watchdog, event, idle, scheduling]
status: stable
source: custom_library
library_root: C2000 Microcontroller Blockset
category_path: Scheduling
block_count: 52
---

# Scheduling

Use these blocks for scheduling.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Software Interrupt Trigger | c2802xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2802xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2803xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2803xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c280xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c280xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c281xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Timer | c281xlib/Timer | R2023a+ | Initialize general purpose Event Manager timer. Enables one to define timer period, compare value and interrupt request for various events. |
| Watchdog | c281xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2833xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2833xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2834xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2834xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2805xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2805xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2806xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2806xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c280013xlib/Software Interrupt Trigger | R2023b+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c280013xlib/Watchdog | R2023b+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c280015xlib/Software Interrupt Trigger | R2023b+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c280015xlib/Watchdog | R2023b+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c28002xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c28002xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c28003xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c28003xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c28004xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c28004xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2807xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2807xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2837xDlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2837xDlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2837xSlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2837xSlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c2838xlib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c2838xlib/Watchdog | R2023a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Hardware Interrupt | c2838x_M4_lib/Hardware Interrupt | R2023a+ | Map a hardware interrupt to a triggered subsystem — use for event-driven ISR handling. |
| Software Interrupt Trigger | f28M35x_C28x_lib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Hardware Interrupt | f28M35x_M3_lib/Hardware Interrupt | R2023a+ | Map a hardware interrupt to a triggered subsystem — use for event-driven ISR handling. |
| Software Interrupt Trigger | f28M36x_C28x_lib/Software Interrupt Trigger | R2023a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Hardware Interrupt | f28M36x_M3_lib/Hardware Interrupt | R2023a+ | Map a hardware interrupt to a triggered subsystem — use for event-driven ISR handling. |
| Software Interrupt Trigger | c28P55xlib/Software Interrupt Trigger | R2024b+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c28P55xlib/Watchdog | R2024b+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Software Interrupt Trigger | c28P65xlib/Software Interrupt Trigger | R2024a+ | Trigger a software interrupt in the generated code — use to schedule a task via an ISR. |
| Watchdog | c28P65xlib/Watchdog | R2024a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Watchdog | c29H85xlib/Watchdog | R2025a+ | Configure and service the watchdog timer — use to reset the MCU if software hangs. |
| Hardware Interrupt | c29H85xlib/Hardware Interrupt | R2025a+ | Map a hardware interrupt to a triggered subsystem — use for event-driven ISR handling. |
| CLA Task Manager | c2000lib/Scheduling/CLA Task Manager | R2023a+ | Schedule and manage CLA coprocessor tasks — use to coordinate CLA task execution. |
| Event Source | c2000lib/Scheduling/Event Source | R2024a+ | Define an event that triggers a task — use to link peripheral events to scheduled execution. |
| Hardware Interrupt | c2000lib/Scheduling/Hardware Interrupt | R2023a+ | Map a hardware interrupt to a triggered subsystem — use for event-driven ISR handling. |
| Idle Task | c2000lib/Scheduling/Idle Task | R2023a+ | Run low-priority code when no other task is active — use for background processing. |
| Software Trigger CPU<->CLA | c2000lib/Scheduling/Software Trigger CPU<->CLA | R2023a+ | Trigger a CLA task from the CPU or signal back — use to coordinate CPU/CLA execution. |
| Task Manager | c2000lib/Scheduling/Task Manager | R2023a+ | Configure and schedule model tasks on the target — use to define task rates and priorities. |

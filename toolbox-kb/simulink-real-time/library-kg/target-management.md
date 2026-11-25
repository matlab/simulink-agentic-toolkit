---
type: Simulink Block Category
title: Target management
description: Blocks for Target management (3 blocks)
tags: [toolbox-kb, simulink-real-time]
status: draft
sources:
  - resource: matlab:slrealtimetgmanagement
source: toolbox_kb
managed_by: satk
library: Simulink Real-Time
kb_folder: simulink-real-time
category: target-management
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:32Z" }
---

# Target management

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Persistent Variable Read | slrealtimetgmanagement/Persistent Variable Read | R2023a+ | Read the specified persistent variable from the target computer when loading the real-time application. If the specified variable does not exist, the block outputs the value specified by the 'Default value' parameter. The data type and dimensions of the block output port are set by the 'Default value' parameter. |
| Persistent Variable Write | slrealtimetgmanagement/Persistent Variable Write | R2023a+ | Write the variable with the specified name to the target computer |
| Overload Options | slrealtimetgmanagement/Overload Options | R2024a+ | Configure CPU overload options for the rate identified through the TID port. Connect the TID port to any signal in the desired rate. This block will output the current overload count for the identified task. |
